import 'dart:async';
import 'package:appwrite/appwrite.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fixit/core/config/app_environment_provider.dart';
import '../../../../core/config/appwrite_provider.dart';
import '../../../../shared/models/user_model.dart';
import '../../data/appwrite_admin_repository.dart';
import '../../domain/models/admin_models.dart';
import '../../../marketplace/domain/models/service_issue_model.dart';
import '../../../guides/domain/models/guide_model.dart';

// Repository Provider
final adminRepositoryProvider = Provider<AppwriteAdminRepository>((ref) {
  final db = ref.watch(appwriteDatabasesProvider);
  final functions = ref.watch(appwriteFunctionsProvider);
  final storage = ref.watch(appwriteStorageProvider);
  final env = ref.watch(appEnvironmentProvider);
  return AppwriteAdminRepository(
    databases: db, 
    functions: functions,
    storage: storage,
    databaseId: env.appwriteDatabaseId,
  );
});

// Dashboard Statistics (Real-time)
final adminDashboardStatsProvider = StreamProvider<AdminStats>((ref) {
  final repo = ref.watch(adminRepositoryProvider);
  final realtime = ref.watch(appwriteRealtimeProvider);
  final env = ref.watch(appEnvironmentProvider);
  
  final controller = StreamController<AdminStats>();
  
  // 1. Initial Fetch
  repo.getDashboardStats().then((stats) => controller.add(stats)).catchError((e) => controller.addError(e));
  
  // 2. Listen to Real-time events
  final subscription = realtime.subscribe([
    'databases.${env.appwriteDatabaseId}.collections.users.documents',
    'databases.${env.appwriteDatabaseId}.collections.bookings.documents',
    'databases.${env.appwriteDatabaseId}.collections.technician_applications.documents',
  ]);
  
  subscription.stream.listen((event) async {
    // Re-fetch when any relevant document changes
    try {
      final stats = await repo.getDashboardStats();
      if (!controller.isClosed) controller.add(stats);

      // Tự động làm mới danh sách hồ sơ nếu có thay đổi từ Appwrite
      if (event.channels.any((c) => c.contains('technician_applications'))) {
        ref.invalidate(adminApplicationsProvider);
      }
    } catch (e) {
      if (!controller.isClosed) controller.addError(e);
    }
  });
  
  ref.onDispose(() {
    subscription.close();
    controller.close();
  });
  
  return controller.stream;
});

// Services List (Legacy - will be replaced by AsyncNotifier)
final allServicesFutureProvider = FutureProvider<List<ServiceCategory>>((ref) {
  return ref.watch(adminRepositoryProvider).getAllServices();
});

/// Quản lý danh sách Dịch vụ (Categories)
class ServicesNotifier extends AsyncNotifier<List<ServiceCategory>> {
  @override
  Future<List<ServiceCategory>> build() async {
    return ref.watch(adminRepositoryProvider).getAllServices();
  }

  Future<void> createService(Map<String, dynamic> data, {bool isPopular = false}) async {
    state = const AsyncValue.loading();
    try {
      await ref.read(adminRepositoryProvider).createService(data, isPopular: isPopular);
      state = AsyncValue.data(await ref.read(adminRepositoryProvider).getAllServices());
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> toggleStatus(String serviceId, bool currentStatus, {bool isPopular = false}) async {
    state = const AsyncValue.loading();
    try {
      await ref.read(adminRepositoryProvider).updateServiceStatus(serviceId, !currentStatus, isPopular: isPopular);
      state = AsyncValue.data(await ref.read(adminRepositoryProvider).getAllServices());
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> updateService(String serviceId, Map<String, dynamic> data, {bool isPopular = false}) async {
    state = const AsyncValue.loading();
    try {
      await ref.read(adminRepositoryProvider).updateService(serviceId, data, isPopular: isPopular);
      state = AsyncValue.data(await ref.read(adminRepositoryProvider).getAllServices());
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> deleteService(String serviceId, {bool isPopular = false}) async {
    state = const AsyncValue.loading();
    try {
      await ref.read(adminRepositoryProvider).deleteService(serviceId, isPopular: isPopular);
      ref.invalidate(adminDashboardStatsProvider);
      state = AsyncValue.data(await ref.read(adminRepositoryProvider).getAllServices());
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> reorderServices(List<ServiceCategory> reorderedList) async {
    // 1. Cập nhật state UI ngay lập tức (Optimistic UI)
    final oldState = state.valueOrNull ?? [];
    final idsInReordered = reorderedList.map((e) => e.id).toSet();
    
    // Tạo danh sách mới: giữ nguyên các mục không liên quan, 
    // và chèn các mục đã sắp xếp lại vào đúng những vị trí mà chúng từng chiếm giữ.
    final newState = <ServiceCategory>[];
    int reorderedIdx = 0;
    
    for (final item in oldState) {
      if (idsInReordered.contains(item.id)) {
        newState.add(reorderedList[reorderedIdx++]);
      } else {
        newState.add(item);
      }
    }
    
    state = AsyncValue.data(newState);

    try {
      // 2. Chuẩn bị danh sách cần update lên server (kèm index mới)
      final itemsToUpdate = <ServiceCategory>[];
      for (int i = 0; i < reorderedList.length; i++) {
        itemsToUpdate.add(reorderedList[i].copyWith(index: i));
      }

      await ref.read(adminRepositoryProvider).updateServiceOrder(itemsToUpdate);
      
      // 3. Fetch lại để đảm bảo đồng bộ
      state = AsyncValue.data(await ref.read(adminRepositoryProvider).getAllServices());
    } catch (e, st) {
      // Rollback nếu lỗi
      state = AsyncValue.data(oldState);
      state = AsyncValue.error(e, st);
    }
  }
}

final adminServicesProvider = AsyncNotifierProvider<ServicesNotifier, List<ServiceCategory>>(ServicesNotifier.new);

// --- SEARCH & FILTER PROVIDERS FOR SERVICES ---

final serviceSearchQueryProvider = StateProvider<String>((ref) => '');
final servicePopularFilterProvider = StateProvider<bool?>((ref) => true); // Default to Popular (true)
final expandedServiceIdProvider = StateProvider<String?>((ref) => null);

final filteredAdminServicesProvider = Provider<AsyncValue<List<ServiceCategory>>>((ref) {
  final servicesAsync = ref.watch(adminServicesProvider);
  final query = ref.watch(serviceSearchQueryProvider).toLowerCase();
  final isPopularFilter = ref.watch(servicePopularFilterProvider);

  return servicesAsync.whenData((services) {
    return services.where((service) {
      final matchesQuery = service.title.toLowerCase().contains(query);
      
      // Nếu filter là "Popular", chỉ hiện các parent
      // Nếu filter là "Regular", chỉ hiện các con (phẳng)
      // Nếu "All", hiện cả hai (nhưng UI sẽ xử lý lồng nhau)
      final matchesPopular = isPopularFilter == null || service.isPopular == isPopularFilter;

      return matchesQuery && matchesPopular;
    }).toList();
  });
});

// --- CONTROLLERS (Dùng AsyncNotifier để xử lý Logic & UI State) ---

/// Quản lý danh sách Người dùng
class UsersNotifier extends AsyncNotifier<List<AppUser>> {
  @override
  Future<List<AppUser>> build() async {
    return ref.watch(adminRepositoryProvider).getAllUsers();
  }

  Future<void> toggleUserStatus(String userId, bool currentStatus) async {
    state = const AsyncValue.loading();
    try {
      await ref.read(adminRepositoryProvider).updateUserStatus(userId, !currentStatus);
      state = AsyncValue.data(await ref.read(adminRepositoryProvider).getAllUsers());
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> deleteUser(String userId, String email) async {
    state = const AsyncValue.loading();
    try {
      await ref.read(adminRepositoryProvider).deleteUser(userId, email);
      state = AsyncValue.data(await ref.read(adminRepositoryProvider).getAllUsers());
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final adminUsersProvider = AsyncNotifierProvider<UsersNotifier, List<AppUser>>(UsersNotifier.new);

// --- SEARCH & FILTER PROVIDERS ---

final userSearchQueryProvider = StateProvider<String>((ref) => '');
final userRoleFilterProvider = StateProvider<UserRole?>((ref) => null);

final filteredAdminUsersProvider = Provider<AsyncValue<List<AppUser>>>((ref) {
  final usersAsync = ref.watch(adminUsersProvider);
  final query = ref.watch(userSearchQueryProvider).toLowerCase();
  final roleFilter = ref.watch(userRoleFilterProvider);

  return usersAsync.whenData((users) {
    return users.where((user) {
      final matchesQuery = user.name.toLowerCase().contains(query) || 
                          user.email.toLowerCase().contains(query);
      
      // Chuyển đổi String role sang UserRole enum để so sánh
      UserRole userEnumRole = UserRole.values.firstWhere(
        (r) => r.name == user.role,
        orElse: () => UserRole.none,
      );

      final matchesRole = roleFilter == null || userEnumRole == roleFilter;

      return matchesQuery && matchesRole;
    }).toList();
  });
});

/// Quản lý danh sách Hồ sơ chờ duyệt
class ApplicationsNotifier extends AsyncNotifier<List<TechApplication>> {
  @override
  Future<List<TechApplication>> build() async {
    return ref.watch(adminRepositoryProvider).getPendingApplications();
  }

  Future<void> updateStatus(String appId, String status) async {
    state = const AsyncValue.loading();
    try {
      await ref.read(adminRepositoryProvider).updateApplicationStatus(appId, status);
      // Khi duyệt xong thợ, cần cập nhật lại Dashboard (Số lượng pending apps giảm)
      ref.invalidate(adminDashboardStatsProvider);
      state = AsyncValue.data(await ref.read(adminRepositoryProvider).getPendingApplications());
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final adminApplicationsProvider = AsyncNotifierProvider<ApplicationsNotifier, List<TechApplication>>(ApplicationsNotifier.new);

/// Quản lý danh sách Đơn hàng (Jobs)
class AdminBookingsNotifier extends AsyncNotifier<List<BookingRecord>> {
  @override
  Future<List<BookingRecord>> build() async {
    return ref.watch(adminRepositoryProvider).getAllBookings();
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => ref.read(adminRepositoryProvider).getAllBookings());
  }
}

final adminBookingsProvider = AsyncNotifierProvider<AdminBookingsNotifier, List<BookingRecord>>(AdminBookingsNotifier.new);

// Để tương thích ngược với code UI cũ (nếu có)
final pendingApplicationsProvider = FutureProvider<List<TechApplication>>((ref) {
  return ref.watch(adminApplicationsProvider.future);
});

final recentApplicationsProvider = FutureProvider<List<TechApplication>>((ref) {
  return ref.watch(adminApplicationsProvider.future);
});

/// Quản lý danh sách Issues của một Service cụ thể
class AdminIssuesNotifier extends FamilyAsyncNotifier<List<ServiceIssueModel>, String> {
  @override
  Future<List<ServiceIssueModel>> build(String arg) async {
    return ref.watch(adminRepositoryProvider).getIssuesByService(arg);
  }

  Future<void> createIssue(Map<String, dynamic> data) async {
    state = const AsyncValue.loading();
    try {
      await ref.read(adminRepositoryProvider).createIssue(data);
      state = AsyncValue.data(await ref.read(adminRepositoryProvider).getIssuesByService(arg));
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> updateIssue(String issueId, Map<String, dynamic> data) async {
    state = const AsyncValue.loading();
    try {
      await ref.read(adminRepositoryProvider).updateIssue(issueId, data);
      state = AsyncValue.data(await ref.read(adminRepositoryProvider).getIssuesByService(arg));
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> deleteIssue(String issueId) async {
    state = const AsyncValue.loading();
    try {
      await ref.read(adminRepositoryProvider).deleteIssue(issueId);
      state = AsyncValue.data(await ref.read(adminRepositoryProvider).getIssuesByService(arg));
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final adminIssuesProvider = AsyncNotifierProviderFamily<AdminIssuesNotifier, List<ServiceIssueModel>, String>(AdminIssuesNotifier.new);

/// Quản lý Hướng dẫn (Guide) của một Issue cụ thể
class AdminGuideNotifier extends FamilyAsyncNotifier<GuideModel?, String> {
  @override
  Future<GuideModel?> build(String arg) async {
    return ref.watch(adminRepositoryProvider).getGuideByIssue(arg);
  }

  Future<void> createGuide(Map<String, dynamic> data) async {
    state = const AsyncValue.loading();
    try {
      await ref.read(adminRepositoryProvider).createGuide(data);
      state = AsyncValue.data(await ref.read(adminRepositoryProvider).getGuideByIssue(arg));
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> updateGuide(String guideId, Map<String, dynamic> data) async {
    state = const AsyncValue.loading();
    try {
      await ref.read(adminRepositoryProvider).updateGuide(guideId, data);
      state = AsyncValue.data(await ref.read(adminRepositoryProvider).getGuideByIssue(arg));
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final adminGuideProvider = AsyncNotifierProviderFamily<AdminGuideNotifier, GuideModel?, String>(AdminGuideNotifier.new);

/// Quản lý danh sách các bước (Steps) của một Guide
class AdminStepsNotifier extends FamilyAsyncNotifier<List<Map<String, dynamic>>, String> {
  @override
  Future<List<Map<String, dynamic>>> build(String arg) async {
    return ref.watch(adminRepositoryProvider).getStepsByGuide(arg);
  }

  Future<void> createStep(Map<String, dynamic> data) async {
    state = const AsyncValue.loading();
    try {
      await ref.read(adminRepositoryProvider).createStep(data);
      state = AsyncValue.data(await ref.read(adminRepositoryProvider).getStepsByGuide(arg));
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> updateStep(String stepId, Map<String, dynamic> data) async {
    state = const AsyncValue.loading();
    try {
      await ref.read(adminRepositoryProvider).updateStep(stepId, data);
      state = AsyncValue.data(await ref.read(adminRepositoryProvider).getStepsByGuide(arg));
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> deleteStep(String stepId) async {
    state = const AsyncValue.loading();
    try {
      await ref.read(adminRepositoryProvider).deleteStep(stepId);
      state = AsyncValue.data(await ref.read(adminRepositoryProvider).getStepsByGuide(arg));
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final adminStepsProvider = AsyncNotifierProviderFamily<AdminStepsNotifier, List<Map<String, dynamic>>, String>(AdminStepsNotifier.new);

/// Quản lý danh sách Banners
class AdminBannersNotifier extends AsyncNotifier<List<Map<String, dynamic>>> {
  @override
  Future<List<Map<String, dynamic>>> build() async {
    return ref.watch(adminRepositoryProvider).getBanners();
  }

  Future<void> createBanner(Map<String, dynamic> data) async {
    state = const AsyncValue.loading();
    try {
      await ref.read(adminRepositoryProvider).createBanner(data);
      state = AsyncValue.data(await ref.read(adminRepositoryProvider).getBanners());
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> updateBanner(String id, Map<String, dynamic> data) async {
    state = const AsyncValue.loading();
    try {
      await ref.read(adminRepositoryProvider).updateBanner(id, data);
      state = AsyncValue.data(await ref.read(adminRepositoryProvider).getBanners());
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> deleteBanner(String id) async {
    state = const AsyncValue.loading();
    try {
      await ref.read(adminRepositoryProvider).deleteBanner(id);
      state = AsyncValue.data(await ref.read(adminRepositoryProvider).getBanners());
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final adminBannersProvider = AsyncNotifierProvider<AdminBannersNotifier, List<Map<String, dynamic>>>(AdminBannersNotifier.new);

/// Quản lý Cấu hình Hệ thống (App Config)
class AdminConfigNotifier extends AsyncNotifier<Map<String, dynamic>?> {
  @override
  Future<Map<String, dynamic>?> build() async {
    return ref.watch(adminRepositoryProvider).getAppConfig();
  }

  Future<void> updateConfig(String id, Map<String, dynamic> data) async {
    state = const AsyncValue.loading();
    try {
      await ref.read(adminRepositoryProvider).updateAppConfig(id, data);
      state = AsyncValue.data(await ref.read(adminRepositoryProvider).getAppConfig());
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final adminConfigProvider = AsyncNotifierProvider<AdminConfigNotifier, Map<String, dynamic>?>(AdminConfigNotifier.new);

/// Quản lý Trung tâm Thông báo (Broadcast)
class AdminBroadcastNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> sendBroadcast({
    required String title,
    required String message,
    required String targetRole,
  }) async {
    state = const AsyncValue.loading();
    try {
      await ref.read(adminRepositoryProvider).sendBroadcastNotification(
        title: title,
        message: message,
        targetRole: targetRole,
      );
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final adminBroadcastProvider = AsyncNotifierProvider<AdminBroadcastNotifier, void>(AdminBroadcastNotifier.new);

/// Quản lý Sản phẩm (Linh kiện)
class AdminProductsNotifier extends AsyncNotifier<List<Map<String, dynamic>>> {
  @override
  Future<List<Map<String, dynamic>>> build() async {
    return ref.watch(adminRepositoryProvider).getProducts();
  }

  Future<void> createProduct(Map<String, dynamic> data) async {
    state = const AsyncValue.loading();
    try {
      await ref.read(adminRepositoryProvider).createProduct(data);
      state = AsyncValue.data(await ref.read(adminRepositoryProvider).getProducts());
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> updateProduct(String id, Map<String, dynamic> data) async {
    state = const AsyncValue.loading();
    try {
      await ref.read(adminRepositoryProvider).updateProduct(id, data);
      state = AsyncValue.data(await ref.read(adminRepositoryProvider).getProducts());
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> deleteProduct(String id) async {
    state = const AsyncValue.loading();
    try {
      await ref.read(adminRepositoryProvider).deleteProduct(id);
      state = AsyncValue.data(await ref.read(adminRepositoryProvider).getProducts());
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final adminProductsProvider = AsyncNotifierProvider<AdminProductsNotifier, List<Map<String, dynamic>>>(AdminProductsNotifier.new);

/// Quản lý Giao dịch (Tài chính)
class AdminTransactionsNotifier extends AsyncNotifier<List<Map<String, dynamic>>> {
  @override
  Future<List<Map<String, dynamic>>> build() async {
    return ref.watch(adminRepositoryProvider).getTransactions();
  }

  Future<void> updateStatus(String id, String status) async {
    state = const AsyncValue.loading();
    try {
      await ref.read(adminRepositoryProvider).updateTransactionStatus(id, status);
      state = AsyncValue.data(await ref.read(adminRepositoryProvider).getTransactions());
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> seedSampleData() async {
    state = const AsyncValue.loading();
    try {
      final repo = ref.read(adminRepositoryProvider);
      // Theo cấu trúc thường gặp và lỗi bạn gặp, có thể collection dùng các trường bắt buộc khác
      // Tôi sẽ thử gửi dữ liệu tối giản nhất khớp với TransactionModel
      final samples = [
        {
          'walletId': 'system_main',
          'amount': 500000,
          'type': 'payment',
          'status': 'success',
          'createdAt': DateTime.now().toIso8601String(),
        },
      ];

      for (var data in samples) {
        await repo.createTransaction(data);
      }
      state = AsyncValue.data(await repo.getTransactions());
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final adminTransactionsProvider = AsyncNotifierProvider<AdminTransactionsNotifier, List<Map<String, dynamic>>>(AdminTransactionsNotifier.new);

/// Quản lý Đánh giá (Reviews)
class AdminReviewsNotifier extends AsyncNotifier<List<Map<String, dynamic>>> {
  @override
  Future<List<Map<String, dynamic>>> build() async {
    return ref.watch(adminRepositoryProvider).getReviews();
  }

  Future<void> deleteReview(String id) async {
    state = const AsyncValue.loading();
    try {
      await ref.read(adminRepositoryProvider).deleteReview(id);
      state = AsyncValue.data(await ref.read(adminRepositoryProvider).getReviews());
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final adminReviewsProvider = AsyncNotifierProvider<AdminReviewsNotifier, List<Map<String, dynamic>>>(AdminReviewsNotifier.new);

/// QUẢN LÝ STORAGE (Upload ảnh)
class AdminStorageNotifier extends AutoDisposeAsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<String?> uploadImage(XFile image, String bucketId) async {
    try {
      final bytes = await image.readAsBytes();
      final file = InputFile.fromBytes(
        bytes: bytes,
        filename: image.name,
      );
      
      return await ref.read(adminRepositoryProvider).uploadFile(bucketId, file);
    } catch (e) {
      print('❌ Storage Upload Error: $e');
      return null;
    }
  }
}

final adminStorageProvider = AutoDisposeAsyncNotifierProvider<AdminStorageNotifier, void>(AdminStorageNotifier.new);

/// QUẢN LÝ COUPONS
class AdminCouponsNotifier extends AsyncNotifier<List<CouponModel>> {
  @override
  Future<List<CouponModel>> build() async => ref.watch(adminRepositoryProvider).getCoupons();

  Future<void> addCoupon(Map<String, dynamic> data) async {
    state = const AsyncValue.loading();
    await ref.read(adminRepositoryProvider).createCoupon(data);
    state = AsyncValue.data(await ref.read(adminRepositoryProvider).getCoupons());
  }
}

final adminCouponsProvider = AsyncNotifierProvider<AdminCouponsNotifier, List<CouponModel>>(AdminCouponsNotifier.new);

/// NHẬT KÝ HOẠT ĐỘNG
final auditLogsProvider = FutureProvider<List<AuditLogModel>>((ref) {
  return ref.watch(adminRepositoryProvider).getAuditLogs();
});

final auditSearchQueryProvider = StateProvider<String>((ref) => '');

final filteredAuditLogsProvider = Provider<AsyncValue<List<AuditLogModel>>>((ref) {
  final logsAsync = ref.watch(auditLogsProvider);
  final query = ref.watch(auditSearchQueryProvider).toLowerCase();

  return logsAsync.whenData((logs) {
    if (query.isEmpty) return logs;
    return logs.where((log) {
      return log.adminName.toLowerCase().contains(query) || 
             log.action.toLowerCase().contains(query) || 
             log.target.toLowerCase().contains(query);
    }).toList();
  });
});

/// BẢN ĐỒ THỢ TRỰC TUYẾN
final onlineTechsProvider = FutureProvider<List<Map<String, dynamic>>>((ref) {
  return ref.watch(adminRepositoryProvider).getOnlineTechnicians();
});

/// LỊCH SỬ THÔNG BÁO
final broadcastHistoryProvider = FutureProvider<List<Map<String, dynamic>>>((ref) {
  return ref.watch(adminRepositoryProvider).getNotificationHistory();
});

/// ĐỘI NGŨ QUẢN TRỊ (ROLES)
final adminStaffProvider = FutureProvider<List<AppUser>>((ref) {
  return ref.watch(adminRepositoryProvider).getAdminStaff();
});

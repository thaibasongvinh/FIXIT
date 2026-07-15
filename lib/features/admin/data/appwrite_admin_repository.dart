import 'package:appwrite/appwrite.dart';
import 'package:appwrite/enums.dart';
import 'package:fixit/core/constants/app_constants.dart';
import 'package:fixit/features/marketplace/domain/models/service_issue_model.dart';
import 'package:fixit/features/guides/domain/models/guide_model.dart';
import 'package:flutter/cupertino.dart';
import '../domain/models/admin_models.dart';

class AdminStats {
  final int totalUsers;
  final int activeJobs;
  final double revenue;
  final int pendingApprovals;
  final Map<String, double> weeklyRevenue;
  final Map<String, int> jobDistribution;

  AdminStats({
    required this.totalUsers,
    required this.activeJobs,
    required this.revenue,
    required this.pendingApprovals,
    required this.weeklyRevenue,
    required this.jobDistribution,
  });
}

class AppwriteAdminRepository {
  final Databases _databases;
  final Functions _functions;
  final Storage _storage;
  final String _databaseId;

  AppwriteAdminRepository({
    required Databases databases,
    required Functions functions,
    required Storage storage,
    String? databaseId,
  })  : _databases = databases,
        _functions = functions,
        _storage = storage,
        _databaseId = databaseId ?? AppwriteConstants.databaseId;

  /// Thống kê Dashboard
  Future<AdminStats> getDashboardStats() async {
    final users = await _databases.listDocuments(databaseId: _databaseId, collectionId: AppwriteConstants.usersCollectionId);
    final apps = await _databases.listDocuments(databaseId: _databaseId, collectionId: AppwriteConstants.technicianApplicationsCollectionId, queries: [Query.equal('status', 'pending')]);
    final bookings = await _databases.listDocuments(databaseId: _databaseId, collectionId: AppwriteConstants.bookingsCollectionId);

    double totalRevenue = 0;
    int activeCount = 0;
    Map<String, double> weeklyRevenue = {};
    Map<String, int> jobDistribution = {};
    
    // Khởi tạo 7 ngày gần nhất với giá trị 0
    final now = DateTime.now();
    for (int i = 6; i >= 0; i--) {
      final date = now.subtract(Duration(days: i));
      final key = "${date.day}/${date.month}";
      weeklyRevenue[key] = 0;
    }

    for (var doc in bookings.documents) {
      final status = doc.data['status'];
      final price = (doc.data['totalPrice'] ?? 0).toDouble();
      final createdAtStr = doc.data['createdAt'];
      final serviceTitle = doc.data['serviceTitle'] ?? 'Other';
      
      // Thống kê phân bổ
      jobDistribution[serviceTitle] = (jobDistribution[serviceTitle] ?? 0) + 1;

      if (status == 'ongoing' || status == 'pending') activeCount++;
      if (status == 'completed') {
        totalRevenue += price;

        // Thống kê vào chart
        if (createdAtStr != null) {
          final createdAt = DateTime.parse(createdAtStr);
          final key = "${createdAt.day}/${createdAt.month}";
          if (weeklyRevenue.containsKey(key)) {
            weeklyRevenue[key] = (weeklyRevenue[key] ?? 0) + price;
          }
        }
      }
    }

    return AdminStats(
      totalUsers: users.total,
      activeJobs: activeCount,
      revenue: totalRevenue,
      pendingApprovals: apps.total,
      weeklyRevenue: weeklyRevenue,
      jobDistribution: jobDistribution,
    );
  }

  /// Quản lý Users
  Future<List<AppUser>> getAllUsers() async {
    final result = await _databases.listDocuments(
      databaseId: _databaseId,
      collectionId: AppwriteConstants.usersCollectionId,
      queries: [Query.orderDesc('createdAt')],
    );
    return result.documents.map((e) => AppUser.fromMap(e.toMap())).toList();
  }

  Future<void> updateUserStatus(String userId, bool isActive) async {
    await _databases.updateDocument(
      databaseId: _databaseId,
      collectionId: AppwriteConstants.usersCollectionId,
      documentId: userId,
      data: {'isActive': isActive},
    );
    await logDetailedAction(
      action: 'Update User Status',
      target: userId,
      before: !isActive ? 'Active' : 'Inactive',
      after: isActive ? 'Active' : 'Inactive',
    );
  }

  Future<void> deleteUser(String userId, String email) async {
    try {
      // 1. Gọi Appwrite Function sử dụng email
      final execution = await _functions.createExecution(
        functionId: 'admin-delete-user', 
        body: '{"userId": "$userId", "email": "$email"}',
        path: '/',
        method: ExecutionMethod.pOST,
      );

      // Kiểm tra xem Function có chạy thành công không
      if (execution.status != ExecutionStatus.completed) {
        throw Exception('Function execution failed with status: ${execution.status.name}. Error: ${execution.responseBody}');
      }
      
      final responseData = execution.responseBody;
      // Nếu trong nội dung trả về có chữ "success" thì coi như đã xong
      if (responseData.contains('"status":"error"') && !responseData.contains('"status":"success"')) {
        throw Exception('Function returned error: $responseData');
      }

      print('Appwrite Admin: Auth deletion success: $responseData');
    } catch (e) {
      print('Appwrite Admin: Critical Error deleting user from Auth: $e');
      // Nếu bạn muốn dừng việc xóa DB khi Auth lỗi, hãy rethrow lỗi ở đây:
      throw Exception('Không thể xóa tài khoản hệ thống (Auth). Vui lòng kiểm tra quyền API Key hoặc logs của Function. Chi tiết: $e');
    }

    // 2. XÓA LIÊN KẾT (CASCADING DELETE)
    // Liệt kê các bảng cần quét sạch dữ liệu liên quan đến userId này
    final linkedCollections = [
      'technicians',
      'technician_applications',
      'bookings',
      'wallets',
      'reviews',
      'chat_rooms',
      'favorites',
      'notifications',
      'user_settings'
    ];

    for (var colId in linkedCollections) {
      try {
        // Tìm các documents có userId này (hoặc id chính là userId đối với bảng technicians/wallets)
        if (colId == 'technicians' || colId == 'wallets') {
          // Xóa trực tiếp bằng ID
          await _databases.deleteDocument(databaseId: _databaseId, collectionId: colId, documentId: userId);
        } else {
          // Tìm và xóa hàng loạt
          final result = await _databases.listDocuments(
            databaseId: _databaseId,
            collectionId: colId,
            queries: [Query.equal('userId', userId)],
          );
          for (var doc in result.documents) {
            await _databases.deleteDocument(databaseId: _databaseId, collectionId: colId, documentId: doc.$id);
          }
        }
      } catch (e) {
        print('Appwrite Admin: Minor Error deleting from linked collection $colId: $e');
        // Không quăng lỗi ở đây để tiếp tục xóa các bảng khác
      }
    }

    // 3. Xóa bản ghi User cuối cùng
    await _databases.deleteDocument(
      databaseId: _databaseId,
      collectionId: AppwriteConstants.usersCollectionId,
      documentId: userId,
    );
    await logAction('Deleted User (Full Clean)', email);
  }

  /// Quản lý Services
  Future<List<ServiceCategory>> getAllServices() async {
    // 1. Lấy danh sách từ collection services thường (Sắp xếp theo index)
    final regularResult = await _databases.listDocuments(
      databaseId: _databaseId,
      collectionId: AppwriteConstants.servicesCollectionId,
      queries: [Query.limit(100), Query.orderAsc('index')],
    );
    final regular = regularResult.documents.map((e) => ServiceCategory.fromMap(e.toMap())).toList();

    // 2. Lấy danh sách từ collection popular_services (Sắp xếp theo index)
    final popularResult = await _databases.listDocuments(
      databaseId: _databaseId,
      collectionId: AppwriteConstants.popularServicesCollectionId,
      queries: [Query.limit(100), Query.orderAsc('index')],
    );
    final popular = popularResult.documents.map((e) {
      final map = e.toMap();
      return ServiceCategory.fromMap(map);
    }).toList();

    return [...popular, ...regular];
  }

  Future<void> updateServiceOrder(List<ServiceCategory> services) async {
    for (var service in services) {
      await _databases.updateDocument(
        databaseId: _databaseId,
        collectionId: service.isPopular 
            ? AppwriteConstants.popularServicesCollectionId 
            : AppwriteConstants.servicesCollectionId,
        documentId: service.id,
        data: {'index': service.index},
      );
    }
  }



  Future<void> deleteService(String serviceId, {bool isPopular = false}) async {
    if (isPopular) {
      // 1. Tìm tất cả các Regular Services con
      final subServices = await _databases.listDocuments(
        databaseId: _databaseId,
        collectionId: AppwriteConstants.servicesCollectionId,
        queries: [Query.equal('parentId', serviceId)],
      );

      for (var subDoc in subServices.documents) {
        await deleteService(subDoc.$id, isPopular: false);
      }

      // 2. Xóa chính Popular Service
      await _databases.deleteDocument(
        databaseId: _databaseId,
        collectionId: AppwriteConstants.popularServicesCollectionId,
        documentId: serviceId,
      );
    } else {
      // Logic xóa Regular Service và con của nó (Issues, Guides, Steps, Products)
      // 1. Tìm và xóa các Service Issues con
      final issues = await _databases.listDocuments(
        databaseId: _databaseId,
        collectionId: AppwriteConstants.serviceIssuesCollectionId,
        queries: [Query.equal('serviceId', serviceId)],
      );

      for (var issueDoc in issues.documents) {
        final issueId = issueDoc.$id;

        // 2. Tìm và xóa các Guides con của Issue
        final guides = await _databases.listDocuments(
          databaseId: _databaseId,
          collectionId: AppwriteConstants.guidesCollectionId,
          queries: [Query.equal('issueId', issueId)],
        );

        for (var guideDoc in guides.documents) {
          final guideId = guideDoc.$id;

          // 3. Tìm và xóa các Steps con của Guide
          final steps = await _databases.listDocuments(
            databaseId: _databaseId,
            collectionId: AppwriteConstants.guideStepsCollectionId,
            queries: [Query.equal('guideId', guideId)],
          );

          for (var stepDoc in steps.documents) {
            await _databases.deleteDocument(
              databaseId: _databaseId,
              collectionId: AppwriteConstants.guideStepsCollectionId,
              documentId: stepDoc.$id,
            );
          }

          // Xóa Guide
          await _databases.deleteDocument(
            databaseId: _databaseId,
            collectionId: AppwriteConstants.guidesCollectionId,
            documentId: guideId,
          );
        }

        // 4. Cập nhật các Products liên quan (xóa issueId khỏi relatedIssueIds)
        final products = await _databases.listDocuments(
          databaseId: _databaseId,
          collectionId: AppwriteConstants.productsCollectionId,
          queries: [Query.contains('relatedIssueIds', issueId)],
        );

        for (var productDoc in products.documents) {
          final List<dynamic> currentIds = productDoc.data['relatedIssueIds'] ?? [];
          currentIds.remove(issueId);
          await _databases.updateDocument(
            databaseId: _databaseId,
            collectionId: AppwriteConstants.productsCollectionId,
            documentId: productDoc.$id,
            data: {'relatedIssueIds': currentIds},
          );
        }

        // 5. Xóa chính Service Issue
        await _databases.deleteDocument(
          databaseId: _databaseId,
          collectionId: AppwriteConstants.serviceIssuesCollectionId,
          documentId: issueId,
        );
      }

      // 6. Xóa chính Regular Service
      await _databases.deleteDocument(
        databaseId: _databaseId,
        collectionId: AppwriteConstants.servicesCollectionId,
        documentId: serviceId,
      );
    }
  }

  Future<void> createService(Map<String, dynamic> data, {bool isPopular = false}) async {
    await _databases.createDocument(
      databaseId: _databaseId,
      collectionId: isPopular ? AppwriteConstants.popularServicesCollectionId : AppwriteConstants.servicesCollectionId,
      documentId: ID.unique(),
      data: {
        ...data,
        'isActive': true,
      },
    );
  }

  Future<void> updateServiceStatus(String serviceId, bool isActive, {bool isPopular = false}) async {
    await _databases.updateDocument(
      databaseId: _databaseId,
      collectionId: isPopular ? AppwriteConstants.popularServicesCollectionId : AppwriteConstants.servicesCollectionId,
      documentId: serviceId,
      data: {'isActive': isActive},
    );
    await logDetailedAction(
      action: 'Update Service Status',
      target: serviceId,
      before: !isActive ? 'Active' : 'Inactive',
      after: isActive ? 'Active' : 'Inactive',
    );
  }

  Future<void> updateService(String serviceId, Map<String, dynamic> data, {bool isPopular = false}) async {
    await _databases.updateDocument(
      databaseId: _databaseId,
      collectionId: isPopular ? AppwriteConstants.popularServicesCollectionId : AppwriteConstants.servicesCollectionId,
      documentId: serviceId,
      data: data, // Loại bỏ việc tự động thêm updatedAt
    );
  }

  /// Quản lý Service Issues
  Future<List<ServiceIssueModel>> getIssuesByService(String serviceId) async {
    final result = await _databases.listDocuments(
      databaseId: _databaseId,
      collectionId: AppwriteConstants.serviceIssuesCollectionId,
      queries: [Query.equal('serviceId', serviceId)],
    );
    return result.documents.map((e) => ServiceIssueModel.fromAppwrite(e.data, e.$id)).toList();
  }

  Future<void> createIssue(Map<String, dynamic> data) async {
    await _databases.createDocument(
      databaseId: _databaseId,
      collectionId: AppwriteConstants.serviceIssuesCollectionId,
      documentId: ID.unique(),
      data: data,
    );
  }

  Future<void> updateIssue(String issueId, Map<String, dynamic> data) async {
    await _databases.updateDocument(
      databaseId: _databaseId,
      collectionId: AppwriteConstants.serviceIssuesCollectionId,
      documentId: issueId,
      data: data,
    );
  }

  Future<void> deleteIssue(String issueId) async {
    // 1. Tìm và xóa các Guides liên quan
    final guides = await _databases.listDocuments(
      databaseId: _databaseId,
      collectionId: AppwriteConstants.guidesCollectionId,
      queries: [Query.equal('issueId', issueId)],
    );

    for (var guideDoc in guides.documents) {
      // 2. Xóa các Steps của Guide
      final steps = await _databases.listDocuments(
        databaseId: _databaseId,
        collectionId: AppwriteConstants.guideStepsCollectionId,
        queries: [Query.equal('guideId', guideDoc.$id)],
      );
      for (var step in steps.documents) {
        await _databases.deleteDocument(databaseId: _databaseId, collectionId: AppwriteConstants.guideStepsCollectionId, documentId: step.$id);
      }
      await _databases.deleteDocument(databaseId: _databaseId, collectionId: AppwriteConstants.guidesCollectionId, documentId: guideDoc.$id);
    }

    // 3. Xóa chính Issue
    await _databases.deleteDocument(
      databaseId: _databaseId,
      collectionId: AppwriteConstants.serviceIssuesCollectionId,
      documentId: issueId,
    );
  }

  /// Quản lý Service Guides & Steps
  Future<GuideModel?> getGuideByIssue(String issueId) async {
    final result = await _databases.listDocuments(
      databaseId: _databaseId,
      collectionId: AppwriteConstants.guidesCollectionId,
      queries: [Query.equal('issueId', issueId), Query.limit(1)],
    );
    if (result.documents.isEmpty) return null;
    return GuideModel.fromAppwrite(result.documents.first);
  }

  Future<void> createGuide(Map<String, dynamic> data) async {
    await _databases.createDocument(
      databaseId: _databaseId,
      collectionId: AppwriteConstants.guidesCollectionId,
      documentId: ID.unique(),
      data: {
        ...data,
        'isOnlineOnly': false, // Bổ sung thuộc tính bắt buộc theo lỗi báo về
        'views': 0,
        'bookmarks': 0,
        'rating': 5.0,
      },
    );
  }

  Future<void> updateGuide(String guideId, Map<String, dynamic> data) async {
    await _databases.updateDocument(
      databaseId: _databaseId,
      collectionId: AppwriteConstants.guidesCollectionId,
      documentId: guideId,
      data: data,
    );
  }

  Future<List<Map<String, dynamic>>> getStepsByGuide(String guideId) async {
    final result = await _databases.listDocuments(
      databaseId: _databaseId,
      collectionId: AppwriteConstants.guideStepsCollectionId,
      queries: [Query.equal('guideId', guideId), Query.orderAsc('stepNumber')],
    );
    return result.documents.map((e) => e.toMap()).toList(); // Sử dụng toMap() để lấy đầy đủ $id
  }

  Future<void> createStep(Map<String, dynamic> data) async {
    await _databases.createDocument(
      databaseId: _databaseId,
      collectionId: AppwriteConstants.guideStepsCollectionId,
      documentId: ID.unique(),
      data: data,
    );
  }

  Future<void> updateStep(String stepId, Map<String, dynamic> data) async {
    await _databases.updateDocument(
      databaseId: _databaseId,
      collectionId: AppwriteConstants.guideStepsCollectionId,
      documentId: stepId,
      data: data,
    );
  }

  Future<void> deleteStep(String stepId) async {
    await _databases.deleteDocument(
      databaseId: _databaseId,
      collectionId: AppwriteConstants.guideStepsCollectionId,
      documentId: stepId,
    );
  }

  /// Quản lý Hồ sơ thợ (Applications)
  Future<List<TechApplication>> getPendingApplications() async {
    final result = await _databases.listDocuments(
      databaseId: _databaseId,
      collectionId: AppwriteConstants.technicianApplicationsCollectionId,
      queries: [Query.equal('status', 'pending'), Query.orderDesc('createdAt')],
    );
    return result.documents.map((e) => TechApplication.fromMap(e.toMap())).toList();
  }

  Future<TechApplication> getApplicationById(String id) async {
    final doc = await _databases.getDocument(
      databaseId: _databaseId,
      collectionId: AppwriteConstants.technicianApplicationsCollectionId,
      documentId: id,
    );
    return TechApplication.fromMap(doc.toMap());
  }

  Future<void> updateApplicationStatus(String docId, String status) async {
    // 1. Cập nhật trạng thái hồ sơ
    final appDoc = await _databases.updateDocument(
      databaseId: _databaseId,
      collectionId: AppwriteConstants.technicianApplicationsCollectionId,
      documentId: docId,
      data: {
        'status': status, 
        'verifiedStatus': status == 'approved' ? 'verified' : (status == 'rejected' ? 'rejected' : 'unverified'),
        'updatedAt': DateTime.now().toIso8601String()
      },
    );

    final userId = appDoc.data['userId'];
    if (userId == null) return;

    final now = DateTime.now().toIso8601String();

    // 2. Gửi thông báo cho người dùng dựa trên userId liên kết
    try {
      final isApproved = status == 'approved';
      await _databases.createDocument(
        databaseId: _databaseId,
        collectionId: AppwriteConstants.notificationsCollectionId,
        documentId: ID.unique(),
        data: {
          'userId': userId,
          'title': isApproved ? '🎉 Chúc mừng! Hồ sơ đã được duyệt' : '⚠️ Thông báo hồ sơ thợ',
          'body': isApproved 
              ? 'Hồ sơ thợ của bạn đã được phê duyệt thành công. Bây giờ bạn đã có thể bắt đầu nhận khách hàng và kiếm thu nhập!' 
              : 'Rất tiếc, hồ sơ của bạn chưa đáp ứng đủ điều kiện tại thời điểm này. Vui lòng kiểm tra lại thông tin và thử lại sau.',
          'type': 'application_status',
          'relatedId': docId,
          'isRead': false,
          'createdAt': now,
        },
        permissions: [
          Permission.read(Role.user(userId)),
          Permission.update(Role.user(userId)),
          Permission.delete(Role.user(userId)),
        ],
      );
      debugPrint('AdminRepo: Automated notification sent to userId: $userId');
    } catch (e) {
      debugPrint('AdminRepo: Error sending notification: $e');
    }

    // 3. Nếu duyệt (approved), cập nhật role của User thành 'technician' và verifiedStatus
    if (status == 'approved') {
      await _databases.updateDocument(
        databaseId: _databaseId,
        collectionId: AppwriteConstants.usersCollectionId,
        documentId: userId,
        data: {
          'role': 'technician',
          'verifiedStatus': 'verified', // Cập nhật để Router cho phép vào App
        },
      );
      
      // 4. Cập nhật trạng thái xác thực trong hồ sơ thợ chính thức
      try {
        await _databases.updateDocument(
          databaseId: _databaseId,
          collectionId: AppwriteConstants.techniciansCollectionId,
          documentId: userId,
          data: {'verifiedStatus': 'verified'},
        );
      } catch (e) {
        debugPrint('AdminRepo: Error updating tech verifiedStatus: $e');
      }
    } else if (status == 'rejected') {
      try {
        // Cập nhật trạng thái trong User gốc
        await _databases.updateDocument(
          databaseId: _databaseId,
          collectionId: AppwriteConstants.usersCollectionId,
          documentId: userId,
          data: {'verifiedStatus': 'rejected'},
        );

        await _databases.updateDocument(
          databaseId: _databaseId,
          collectionId: AppwriteConstants.techniciansCollectionId,
          documentId: userId,
          data: {'verifiedStatus': 'rejected'},
        );
      } catch (_) {}
    }
  }

  /// Quản lý Bookings (Jobs)
  Future<List<BookingRecord>> getAllBookings() async {
    final result = await _databases.listDocuments(
      databaseId: _databaseId,
      collectionId: AppwriteConstants.bookingsCollectionId,
      queries: [Query.orderDesc('createdAt')],
    );
    return result.documents.map((e) => BookingRecord.fromMap(e.toMap())).toList();
  }

  /// Gửi thông báo toàn hệ thống
  Future<void> sendBroadcastNotification({
    required String title,
    required String message,
    required String targetRole, // 'all', 'customer', 'technician'
    String? type,
  }) async {
    await _databases.createDocument(
      databaseId: _databaseId,
      collectionId: 'notifications', 
      documentId: ID.unique(),
      data: {
        'title': title,
        'message': message,
        'type': type ?? 'broadcast',
        'createdAt': DateTime.now().toIso8601String(),
        'targetRole': targetRole
      },
    );
  }

  /// Quản lý Banners
  Future<List<Map<String, dynamic>>> getBanners() async {
    final result = await _databases.listDocuments(
      databaseId: _databaseId,
      collectionId: AppwriteConstants.bannersCollectionId,
    );
    // Trả về e.data kèm theo $id để đảm bảo lấy đúng các cột tự định nghĩa
    return result.documents.map((e) => {
      ...e.data,
      '\$id': e.$id,
    }).toList();
  }

  Future<void> createBanner(Map<String, dynamic> data) async {
    await _databases.createDocument(
      databaseId: _databaseId,
      collectionId: AppwriteConstants.bannersCollectionId,
      documentId: ID.unique(),
      data: data,
    );
  }

  Future<void> updateBanner(String id, Map<String, dynamic> data) async {
    await _databases.updateDocument(
      databaseId: _databaseId,
      collectionId: AppwriteConstants.bannersCollectionId,
      documentId: id,
      data: data,
    );
  }

  Future<void> deleteBanner(String id) async {
    await _databases.deleteDocument(
      databaseId: _databaseId,
      collectionId: AppwriteConstants.bannersCollectionId,
      documentId: id,
    );
  }

  /// Quản lý App Config
  Future<Map<String, dynamic>?> getAppConfig() async {
    final result = await _databases.listDocuments(
      databaseId: _databaseId,
      collectionId: AppwriteConstants.appConfigCollectionId,
      queries: [Query.limit(1)],
    );
    if (result.documents.isEmpty) return null;
    return result.documents.first.toMap();
  }

  Future<void> updateAppConfig(String id, Map<String, dynamic> data) async {
    await _databases.updateDocument(
      databaseId: _databaseId,
      collectionId: AppwriteConstants.appConfigCollectionId,
      documentId: id,
      data: data,
    );
  }

  Future<void> createAppConfig(Map<String, dynamic> data) async {
    await _databases.createDocument(
      databaseId: _databaseId,
      collectionId: AppwriteConstants.appConfigCollectionId,
      documentId: 'system-config',
      data: data,
    );
  }

  /// Quản lý Sản phẩm/Linh kiện
  Future<List<Map<String, dynamic>>> getProducts() async {
    final result = await _databases.listDocuments(
      databaseId: _databaseId,
      collectionId: AppwriteConstants.productsCollectionId,
    );
    return result.documents.map((e) => {...e.data, '\$id': e.$id}).toList();
  }

  Future<void> createProduct(Map<String, dynamic> data) async {
    await _databases.createDocument(
      databaseId: _databaseId,
      collectionId: AppwriteConstants.productsCollectionId,
      documentId: ID.unique(),
      data: data,
    );
  }

  Future<void> updateProduct(String id, Map<String, dynamic> data) async {
    await _databases.updateDocument(
      databaseId: _databaseId,
      collectionId: AppwriteConstants.productsCollectionId,
      documentId: id,
      data: data,
    );
  }

  Future<void> deleteProduct(String id) async {
    await _databases.deleteDocument(
      databaseId: _databaseId,
      collectionId: AppwriteConstants.productsCollectionId,
      documentId: id,
    );
  }

  /// Quản lý Tài chính & Giao dịch
  Future<List<Map<String, dynamic>>> getTransactions() async {
    final result = await _databases.listDocuments(
      databaseId: _databaseId,
      collectionId: AppwriteConstants.transactionsCollectionId,
      // Sắp xếp theo $createdAt mặc định của Appwrite để không cần tạo Index thủ công
      queries: [Query.orderDesc('\$createdAt')],
    );
    return result.documents.map((e) => {
      ...e.data, 
      '\$id': e.$id,
      'systemCreatedAt': e.$createdAt,
    }).toList();
  }

  Future<void> updateTransactionStatus(String id, String status) async {
    await _databases.updateDocument(
      databaseId: _databaseId,
      collectionId: AppwriteConstants.transactionsCollectionId,
      documentId: id,
      data: {'status': status, 'updatedAt': DateTime.now().toIso8601String()},
    );
  }

  Future<void> createTransaction(Map<String, dynamic> data) async {
    await _databases.createDocument(
      databaseId: _databaseId,
      collectionId: AppwriteConstants.transactionsCollectionId,
      documentId: ID.unique(),
      data: {
        ...data,
        'createdAt': DateTime.now().toIso8601String(),
      },
    );
  }

  /// Quản lý Đánh giá (Reviews)
  Future<List<Map<String, dynamic>>> getReviews() async {
    final result = await _databases.listDocuments(
      databaseId: _databaseId,
      collectionId: AppwriteConstants.reviewsCollectionId,
      queries: [Query.orderDesc('createdAt')],
    );
    return result.documents.map((e) => {...e.data, '\$id': e.$id}).toList();
  }

  Future<void> deleteReview(String id) async {
    await _databases.deleteDocument(
      databaseId: _databaseId,
      collectionId: AppwriteConstants.reviewsCollectionId,
      documentId: id,
    );
  }

  /// QUẢN LÝ STORAGE
  Future<String> uploadFile(String bucketId, InputFile file) async {
    final result = await _storage.createFile(
      bucketId: bucketId,
      fileId: ID.unique(),
      file: file,
    );
    return result.$id;
  }

  Future<void> deleteFile(String bucketId, String fileId) async {
    await _storage.deleteFile(
      bucketId: bucketId,
      fileId: fileId,
    );
  }

  /// QUẢN LÝ COUPONS
  Future<List<CouponModel>> getCoupons() async {
    final result = await _databases.listDocuments(databaseId: _databaseId, collectionId: 'coupons');
    return result.documents.map((e) => CouponModel.fromMap(e.toMap())).toList();
  }

  Future<void> createCoupon(Map<String, dynamic> data) async {
    await _databases.createDocument(databaseId: _databaseId, collectionId: 'coupons', documentId: ID.unique(), data: data);
    await logAction('Created Coupon', data['code']);
  }

  /// AUDIT LOGS
  Future<void> logAction(String action, String target, {Map<String, dynamic>? metadata}) async {
    try {
      await _databases.createDocument(
        databaseId: _databaseId,
        collectionId: 'audit_logs',
        documentId: ID.unique(),
        data: {
          'adminName': 'Current Admin', 
          'action': action,
          'target': target,
          'metadata': metadata != null ? metadata.toString() : null, // Appwrite might need string if metadata is not a JSON object attribute
          'createdAt': DateTime.now().toIso8601String(),
        },
      );
    } catch (_) {}
  }

  Future<void> logDetailedAction({
    required String action,
    required String target,
    dynamic before,
    dynamic after,
  }) async {
    await logAction(action, target, metadata: {
      'before': before,
      'after': after,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  Future<List<AuditLogModel>> getAuditLogs() async {
    final result = await _databases.listDocuments(
      databaseId: _databaseId, collectionId: 'audit_logs',
      queries: [Query.orderDesc('createdAt'), Query.limit(100)],
    );
    return result.documents.map((e) => AuditLogModel.fromMap(e.toMap())).toList();
  }

  /// LIVE TECH MAP (Lấy vị trí thợ đang online)
  Future<List<Map<String, dynamic>>> getOnlineTechnicians() async {
    final result = await _databases.listDocuments(
      databaseId: _databaseId, collectionId: 'technicians',
      queries: [Query.equal('isOnline', true)],
    );
    return result.documents.map((e) => e.data).toList();
  }

  /// LỊCH SỬ THÔNG BÁO
  Future<List<Map<String, dynamic>>> getNotificationHistory() async {
    final result = await _databases.listDocuments(
      databaseId: _databaseId, collectionId: 'notifications',
      queries: [Query.orderDesc('createdAt'), Query.limit(50)],
    );
    return result.documents.map((e) => {...e.data, '\$id': e.$id}).toList();
  }

  /// QUẢN LÝ QUYỀN HẠN (SUB-ADMINS)
  Future<List<AppUser>> getAdminStaff() async {
    final result = await _databases.listDocuments(
      databaseId: _databaseId, collectionId: AppwriteConstants.usersCollectionId,
      queries: [Query.notEqual('role', 'customer'), Query.notEqual('role', 'technician')],
    );
    return result.documents.map((e) => AppUser.fromMap(e.toMap())).toList();
  }
}

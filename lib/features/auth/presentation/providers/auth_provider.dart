import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:fixit/core/config/app_environment_provider.dart';
import 'package:fixit/core/config/appwrite_provider.dart';
import 'package:fixit/features/auth/data/appwrite_auth_repository_impl.dart';
import 'package:fixit/features/auth/domain/auth_repository.dart';
import 'package:fixit/shared/models/user_model.dart';
import 'package:fixit/features/admin/domain/models/admin_models.dart';
import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as models;
import 'package:fixit/core/constants/app_constants.dart';

part 'auth_provider.g.dart';

@Riverpod(keepAlive: true)
AuthRepository authRepository(Ref ref) {
  final client = ref.watch(appwriteClientProvider);
  final account = ref.watch(appwriteAccountProvider);
  final db = ref.watch(appwriteDatabasesProvider);
  final storage = ref.watch(appwriteStorageProvider);
  final realtime = ref.watch(appwriteRealtimeProvider); // Thêm realtime
  final env = ref.watch(appEnvironmentProvider);
  return AppwriteAuthRepositoryImpl(
    client: client,
    account: account,
    databases: db,
    storage: storage,
    realtime: realtime, // Pass realtime
    projectId: env.appwriteProjectId,
    endpoint: env.appwriteEndpoint,
    databaseId: env.appwriteDatabaseId,
    usersCollectionId: 'users',
  );
}

@Riverpod(keepAlive: true)
Stream<models.User?> authState(Ref ref) async* {
  final repository = ref.watch(authRepositoryProvider);

  // 1. Phát ra trạng thái hiện tại ngay lập tức để tránh "stuck loading"
  final currentAccount = await repository.getAccount();
  yield currentAccount as models.User?;

  // 2. Lắng nghe các thay đổi tiếp theo
  yield* repository.userChanges.map((u) => u as models.User?);
}

@Riverpod(keepAlive: true)
Stream<UserModel?> currentUser(Ref ref) async* {
  final authAsync = ref.watch(authStateProvider);
  final repository = ref.watch(authRepositoryProvider);

  // Nếu đang load trạng thái auth ban đầu, ta cứ để nó load
  if (authAsync.isLoading) return;
  final auth = authAsync.valueOrNull;

  if (auth == null) {
    yield null;
    return;
  }

  // Đảm bảo document tồn tại trước khi lấy dữ liệu
  try {
    await repository.ensureUserDocument(auth);
    // Tự động đảm bảo User Settings cũng tồn tại khi load profile
    await repository.syncUserSettings(userId: auth.$id);
  } catch (e) {
    debugPrint('Appwrite: Error ensuring user document/settings: $e');
  }

  yield* repository.watchUserData(auth.$id);
}

@Riverpod(keepAlive: true)
Future<TechApplication?> currentUserApplication(Ref ref) async {
  final user = await ref.watch(currentUserProvider.future);
  if (user == null) return null;

  final db = ref.watch(appwriteDatabasesProvider);
  final env = ref.watch(appEnvironmentProvider);

  try {
    final result = await db.listDocuments(
      databaseId: env.appwriteDatabaseId,
      collectionId: AppwriteConstants.technicianApplicationsCollectionId,
      queries: [
        Query.equal('userId', user.uid),
        Query.orderDesc('createdAt'),
        Query.limit(1),
      ],
    );

    if (result.documents.isEmpty) return null;

    // Import Admin models for TechApplication
    return TechApplication.fromMap(result.documents.first.toMap());
  } catch (e) {
    debugPrint('Auth: Error fetching user application: $e');
    return null;
  }
}


@riverpod
class AuthNotifier extends _$AuthNotifier {
  @override
  FutureOr<void> build() => null;

  Future<void> signIn(String email, String password) async {
    state = const AsyncLoading();
    try {
      // 1. Thực hiện Sign In
      await ref.read(authRepositoryProvider).signInWithEmail(email, password);

      // 2. CHỜ ĐỢI Profile: Thay vì kết thúc ngay, ta đợi cho đến khi currentUser có dữ liệu
      // Việc này đảm bảo khi state chuyển sang AsyncData, Profile đã sẵn sàng trong Provider
      debugPrint('AuthNotifier: Sign in success, waiting for profile...');
      await ref.read(currentUserProvider.future);
      debugPrint('AuthNotifier: Profile loaded, completing sign in.');

      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }

  Future<void> signInWithGoogle() async {
    state = const AsyncLoading();
    try {
      await ref.read(authRepositoryProvider).signInWithGoogle();
      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }

  Future<void> signInWithFacebook() async {
    state = const AsyncLoading();
    try {
      await ref.read(authRepositoryProvider).signInWithFacebook();
      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }

  Future<void> register({
    required String email,
    required String password,
    required String name,
  }) async {
    state = const AsyncLoading();
    try {
      await ref.read(authRepositoryProvider).registerWithEmail(
            email: email,
            password: password,
            name: name,
          );
      // Đã xóa sendEmailOTP tại đây. Việc gửi mã sẽ do màn hình VerifyEmailScreen đảm nhận tự động.
      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }

  Future<void> signOut() async {
    state = const AsyncLoading();
    try {
      await ref.read(authRepositoryProvider).signOut();
      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    state = const AsyncLoading();
    try {
      await ref.read(authRepositoryProvider).sendPasswordResetEmail(email);
      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }

  Future<void> updatePassword(String newPassword) async {
    state = const AsyncLoading();
    try {
      await ref.read(authRepositoryProvider).updatePassword(newPassword);
      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st); // Dừng loading và báo lỗi vào state
      rethrow; // Bắn lỗi ra ngoài để ResetPasswordScreen bắt được
    }
  }

  Future<void> confirmPasswordReset({
    required String? userId,
    required String secret,
    required String newPassword,
    String? email, // Thêm email để hỗ trợ tìm userId nếu cần
  }) async {
    state = const AsyncLoading();
    try {
      String finalUserId = userId ?? '';

      // Nếu không có userId nhưng có email, ta phải tìm userId trước
      if (finalUserId.isEmpty && email != null) {
        finalUserId =
            await ref.read(authRepositoryProvider).getUserIdByEmail(email);
      }

      if (finalUserId.isEmpty) {
        throw Exception(
            'Không tìm thấy thông tin tài khoản. Vui lòng thử lại.');
      }

      await ref.read(authRepositoryProvider).confirmPasswordReset(
            userId: finalUserId,
            secret: secret,
            newPassword: newPassword,
          );
      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }

  Future<bool> verifyRecoverySecret({
    required String userId,
    required String secret,
  }) async {
    return ref.read(authRepositoryProvider).verifyRecoverySecret(
          userId: userId,
          secret: secret,
        );
  }

  Future<void> updateProfile({
    required String name,
    required String phone,
    String? avatar,
    File? avatarFile,
    String? dob,
    List<String>? addresses,
  }) async {
    state = const AsyncLoading();
    try {
      await ref.read(authRepositoryProvider).updateUserProfile(
            name: name,
            phone: phone,
            avatar: avatar,
            avatarFile: avatarFile,
            dob: dob,
            addresses: addresses,
          );

      // 1. Cập nhật trạng thái sang Loading cục bộ
      state = const AsyncLoading();

      // 2. Invalidate và ĐỢI dữ liệu mới nhất được nạp lại từ máy chủ
      debugPrint(
          'AuthNotifier: Invalidating providers and fetching fresh data...');
      ref.invalidate(authStateProvider);
      ref.invalidate(currentUserProvider);

      // Việc await các .future này sẽ đảm bảo chúng ta lấy bản record MỚI NHẤT từ Server
      final results = await Future.wait([
        ref.read(authStateProvider.future),
        ref.read(currentUserProvider.future),
      ]);

      final freshUser = results[1] as UserModel?;
      debugPrint(
          'AuthNotifier: Fresh data received. CurrentUser Name: ${freshUser?.name}, DOB: ${freshUser?.dob}');
      debugPrint('AuthNotifier: Profile refreshed and synced.');
      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }

  Future<void> updateRole(UserRole role) async {
    state = const AsyncLoading();
    try {
      await ref.read(authRepositoryProvider).updateUserRole(role);
      ref.invalidate(currentUserProvider); // Đồng bộ role mới

      // ĐÃ XÓA signOut() tại đây để cho phép đi tiếp đến bước Phone

      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }

  Future<void> sendEmailVerification() async {
    state = const AsyncLoading();
    try {
      await ref.read(authRepositoryProvider).sendEmailVerification();
      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }

  Future<void> sendEmailOTP(String email) async {
    state = const AsyncLoading();
    try {
      await ref.read(authRepositoryProvider).sendEmailOTP(email);
      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }

  Future<void> verifyEmailOTP({
    required String email,
    required String otp,
  }) async {
    state = const AsyncLoading();
    try {
      await ref.read(authRepositoryProvider).verifyEmailOTP(
            email: email,
            otp: otp,
          );
      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow; // Bắt buộc phải rethrow để giao diện biết có lỗi
    }
  }

  Future<bool> checkEmailExists(String email) async {
    return ref.read(authRepositoryProvider).checkEmailExists(email);
  }

  Future<String> getUserIdByEmail(String email) async {
    return ref.read(authRepositoryProvider).getUserIdByEmail(email);
  }

  Future<String> getUserIdByPhone(String phone) async {
    return ref.read(authRepositoryProvider).getUserIdByPhone(phone);
  }

  Future<bool> checkPhoneExists(String phone) async {
    return ref.read(authRepositoryProvider).checkPhoneExists(phone);
  }

  Future<PhoneVerificationChallenge> startPhoneVerification({
    required String phoneNumber,
    int? forceResendingToken,
  }) async {
    return ref.read(authRepositoryProvider).startPhoneVerification(
          phoneNumber: phoneNumber,
          forceResendingToken: forceResendingToken,
        );
  }

  Future<void> confirmPhoneVerification({
    required String verificationId,
    required String smsCode,
  }) async {
    state = const AsyncLoading();
    try {
      await ref.read(authRepositoryProvider).confirmPhoneVerification(
            verificationId: verificationId,
            smsCode: smsCode,
          );
      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }

  Future<void> submitTechnicianOnboarding({
    required String businessName,
    required String businessAddress,
    required String serviceType,
    required int experienceYears,
    required String serviceArea,
    required String startTime,
    required String endTime,
    required double hourlyRate,
    required double flatFee,
    required String? additionalInfo,
    required List<String> localDocumentPaths,
    String? identityNumber,
    String? identityCardFrontPath,
    String? identityCardBackPath,
    double? serviceRadius,
    String? workSchedule,
    List<String>? paymentMethods,
    double? latitude,
    double? longitude,
  }) async {
    // 1. Kiểm tra nếu đang loading thì không chạy tiếp
    if (state is AsyncLoading) {
      debugPrint(
          'AuthNotifier: submitTechnicianOnboarding is already loading, skipping.');
      return;
    }

    state = const AsyncLoading();

    try {
      debugPrint('AuthNotifier: Starting technician onboarding submission...');

      await ref.read(authRepositoryProvider).submitTechnicianApplication(
            businessName: businessName,
            businessAddress: businessAddress,
            serviceType: serviceType,
            experienceYears: experienceYears,
            serviceArea: serviceArea,
            startTime: startTime,
            endTime: endTime,
            hourlyRate: hourlyRate,
            flatFee: flatFee,
            additionalInfo: additionalInfo,
            localDocumentPaths: localDocumentPaths,
            identityNumber: identityNumber,
            identityCardFrontPath: identityCardFrontPath,
            identityCardBackPath: identityCardBackPath,
            serviceRadius: serviceRadius,
            workSchedule: workSchedule,
            paymentMethods: paymentMethods,
            latitude: latitude,
            longitude: longitude,
          );

      debugPrint('AuthNotifier: Submission successful.');

      // 2. Chờ một chút để backend Appwrite ổn định dữ liệu
      await Future.delayed(const Duration(milliseconds: 1000));

      state = const AsyncData(null);
    } catch (e) {
      debugPrint('AuthNotifier: Error during onboarding submission: $e');
      // KHÔNG cập nhật state thành AsyncError tại đây vì UI sẽ bắt lỗi này
      // Việc cập nhật state ở đây gây ra lỗi "Future already completed"
      rethrow;
    }
  }

  Future<models.User?> reloadCurrentUser() async {
    state = const AsyncLoading();
    final result = await AsyncValue.guard(
      () => ref.read(authRepositoryProvider).reloadCurrentUser(),
    );

    ref.invalidate(authStateProvider);

    state = result.when(
      data: (_) => const AsyncData(null),
      error: AsyncError.new,
      loading: () => const AsyncLoading(),
    );
    return result.valueOrNull as models.User?;
  }

  /// Xóa sạch mọi thông báo lỗi đang tồn tại trong hệ thống
  void clearError() {
    state = const AsyncData(null);
  }
}

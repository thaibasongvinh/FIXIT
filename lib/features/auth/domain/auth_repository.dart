import 'dart:io';

import '../../../shared/models/user_model.dart';

class PhoneVerificationChallenge {
  const PhoneVerificationChallenge({
    this.verificationId,
    this.resendToken,
    this.autoVerified = false,
  });

  const PhoneVerificationChallenge.autoVerified()
      : verificationId = null,
        resendToken = null,
        autoVerified = true;

  final String? verificationId;
  final int? resendToken;
  final bool autoVerified;

  bool get requiresSmsCode =>
      !autoVerified &&
      verificationId != null &&
      verificationId!.trim().isNotEmpty;
}

abstract class AuthRepository {
  Stream<dynamic> get userChanges;
  Stream<UserModel?> watchUserData(String uid);
  Future<UserModel?> getUserData(String uid);
  Future<UserModel> ensureUserDocument(dynamic user);
  Future<dynamic> getAccount();
  Future<void> signInWithEmail(String email, String password);
  Future<void> signInWithGoogle();
  Future<void> signInWithFacebook();
  Future<void> registerWithEmail({
    required String email,
    required String password,
    required String name,
  });
  Future<void> syncUserSettings({
    required String userId,
    String? themeMode,
    String? language,
  });
  Future<Map<String, dynamic>?> getUserSettings(String userId);
  Future<void> sendPasswordResetEmail(String email);
  Future<bool> checkEmailExists(String email);
  Future<bool> checkPhoneExists(String phoneNumber);
  Future<void> sendEmailVerification();
  Future<void> sendEmailOTP(String email);
  Future<void> verifyEmailOTP({required String email, required String otp});
  Future<String> getUserIdByEmail(String email);
  Future<String> getUserIdByPhone(String phone); // Thêm hàm lấy ID bằng phone
  Future<dynamic> reloadCurrentUser();
  Future<PhoneVerificationChallenge> startPhoneVerification({
    required String phoneNumber,
    int? forceResendingToken,
  });
  Future<void> confirmPhoneVerification({
    required String verificationId,
    required String smsCode,
    String? phoneNumber,
  });
  Future<void> updatePassword(String newPassword);
  Future<void> confirmPasswordReset({
    required String userId,
    required String secret,
    required String newPassword,
  });
  Future<bool> verifyRecoverySecret({
    required String userId,
    required String secret,
  });
  Future<void> updateUserProfile({
    required String name,
    required String phone,
    String? avatar,
    File? avatarFile,
    String? dob,
    List<String>? addresses, // Changed to List
  });
  Future<void> updateUserRole(UserRole role);
  Future<void> submitTechnicianApplication({
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
    // New Professional Fields
    String? identityNumber,
    String? identityCardFrontPath,
    String? identityCardBackPath,
    double? serviceRadius,
    String? workSchedule,
    List<String>? paymentMethods,
    double? latitude,
    double? longitude,
  });
  Future<void> signOut();
}

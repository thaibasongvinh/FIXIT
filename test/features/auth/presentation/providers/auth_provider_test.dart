import 'dart:async';
import 'dart:io';

import 'package:appwrite/models.dart' as models;
import 'package:fixit/features/auth/domain/auth_repository.dart';
import 'package:fixit/features/auth/presentation/providers/auth_provider.dart';
import 'package:fixit/shared/models/user_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';



void main() {
  group('AuthNotifier', () {
    test('delegates email sign in', () async {
      final repository = FakeAuthRepository();
      final container = ProviderContainer(
        overrides: [
          authRepositoryProvider.overrideWithValue(repository as AuthRepository),
        ],
      );
      addTearDown(container.dispose);

      await container.read(authNotifierProvider.notifier).signIn(
            'test@example.com',
            'secret123',
          );

      expect(repository.lastSignedInEmail, 'test@example.com');
      expect(repository.lastSignedInPassword, 'secret123');
      expect(container.read(authNotifierProvider).hasError, isFalse);
    });

    test('delegates Google sign in', () async {
      final repository = FakeAuthRepository();
      final container = ProviderContainer(
        overrides: [
          authRepositoryProvider.overrideWithValue(repository),
        ],
      );
      addTearDown(container.dispose);

      await container.read(authNotifierProvider.notifier).signInWithGoogle();

      expect(repository.googleSignInCount, 1);
      expect(container.read(authNotifierProvider).hasError, isFalse);
    });

    test('delegates registration', () async {
      final repository = FakeAuthRepository();
      final container = ProviderContainer(
        overrides: [
          authRepositoryProvider.overrideWithValue(repository),
        ],
      );
      addTearDown(container.dispose);

      await container.read(authNotifierProvider.notifier).register(
            email: 'new@example.com',
            password: 'secret123',
            name: 'New User',
          );

      expect(repository.lastRegisteredEmail, 'new@example.com');
      expect(repository.lastRegisteredPassword, 'secret123');
      expect(repository.lastRegisteredName, 'New User');
    });

    test('starts phone verification and returns challenge', () async {
      final repository = FakeAuthRepository(
        phoneChallenge: const PhoneVerificationChallenge(
          verificationId: 'verification-123',
          resendToken: 77,
        ),
      );
      final container = ProviderContainer(
        overrides: [
          authRepositoryProvider.overrideWithValue(repository),
        ],
      );
      addTearDown(container.dispose);

      final challenge = await container
          .read(authNotifierProvider.notifier)
          .startPhoneVerification(
            phoneNumber: '+84901234567',
          );

      expect(challenge.verificationId, 'verification-123');
      expect(challenge.resendToken, 77);
      expect(repository.lastPhoneNumber, '+84901234567');
      expect(container.read(authNotifierProvider).hasError, isFalse);
    });

    test('delegates phone verification confirmation', () async {
      final repository = FakeAuthRepository();
      final container = ProviderContainer(
        overrides: [
          authRepositoryProvider.overrideWithValue(repository),
        ],
      );
      addTearDown(container.dispose);

      await container
          .read(authNotifierProvider.notifier)
          .confirmPhoneVerification(
            verificationId: 'verification-123',
            smsCode: '123456',
          );

      expect(repository.lastConfirmedVerificationId, 'verification-123');
      expect(repository.lastConfirmedSmsCode, '123456');
      expect(container.read(authNotifierProvider).hasError, isFalse);
    });

    test('delegates email verification, reload, and sign out', () async {
      final repository = FakeAuthRepository();
      final container = ProviderContainer(
        overrides: [
          authRepositoryProvider.overrideWithValue(repository),
        ],
      );
      addTearDown(container.dispose);

      await container
          .read(authNotifierProvider.notifier)
          .sendEmailVerification();
      await container.read(authNotifierProvider.notifier).reloadCurrentUser();
      await container.read(authNotifierProvider.notifier).signOut();

      expect(repository.emailVerificationCount, 1);
      expect(repository.reloadCount, 1);
      expect(repository.signOutCount, 1);
      expect(container.read(authNotifierProvider).hasError, isFalse);
    });

    test('delegates Facebook sign in', () async {
      final repository = FakeAuthRepository();
      final container = ProviderContainer(
        overrides: [
          authRepositoryProvider.overrideWithValue(repository),
        ],
      );
      addTearDown(container.dispose);

      await container.read(authNotifierProvider.notifier).signInWithFacebook();

      expect(repository.facebookSignInCount, 1);
      expect(container.read(authNotifierProvider).hasError, isFalse);
    });

    test('delegates sendPasswordResetEmail', () async {
      final repository = FakeAuthRepository();
      final container = ProviderContainer(
        overrides: [
          authRepositoryProvider.overrideWithValue(repository),
        ],
      );
      addTearDown(container.dispose);

      await container
          .read(authNotifierProvider.notifier)
          .sendPasswordResetEmail('reset@example.com');

      expect(repository.lastPasswordResetEmail, 'reset@example.com');
      expect(container.read(authNotifierProvider).hasError, isFalse);
    });

    test('delegates updatePassword', () async {
      final repository = FakeAuthRepository();
      final container = ProviderContainer(
        overrides: [
          authRepositoryProvider.overrideWithValue(repository),
        ],
      );
      addTearDown(container.dispose);

      await container
          .read(authNotifierProvider.notifier)
          .updatePassword('new-secret-123');

      expect(repository.lastUpdatedPassword, 'new-secret-123');
      expect(container.read(authNotifierProvider).hasError, isFalse);
    });

    test('delegates confirmPasswordReset', () async {
      final repository = FakeAuthRepository();
      final container = ProviderContainer(
        overrides: [
          authRepositoryProvider.overrideWithValue(repository),
        ],
      );
      addTearDown(container.dispose);

      await container
          .read(authNotifierProvider.notifier)
          .confirmPasswordReset(
            userId: 'uid-456',
            secret: 'otp-secret',
            newPassword: 'brand-new-pass',
          );

      expect(repository.lastConfirmPasswordResetUserId, 'uid-456');
      expect(repository.lastConfirmPasswordResetSecret, 'otp-secret');
      expect(repository.lastConfirmPasswordResetNewPassword, 'brand-new-pass');
      expect(container.read(authNotifierProvider).hasError, isFalse);
    });

    test('confirmPasswordReset fetches userId if missing and email provided',
        () async {
      final repository = FakeAuthRepository();
      final container = ProviderContainer(
        overrides: [
          authRepositoryProvider.overrideWithValue(repository),
        ],
      );
      addTearDown(container.dispose);

      await container.read(authNotifierProvider.notifier).confirmPasswordReset(
            userId: null,
            email: 'search@example.com',
            secret: 'otp-secret',
            newPassword: 'brand-new-pass',
          );

      // getUserIdByEmail in FakeAuthRepository returns 'uid-123'
      expect(repository.lastConfirmPasswordResetUserId, 'uid-123');
      expect(container.read(authNotifierProvider).hasError, isFalse);
    });

    test('delegates updateProfile', () async {
      final repository = FakeAuthRepository();
      final container = ProviderContainer(
        overrides: [
          authRepositoryProvider.overrideWithValue(repository),
        ],
      );
      addTearDown(container.dispose);

      await container.read(authNotifierProvider.notifier).updateProfile(
            name: 'Updated Name',
            phone: '+84999999999',
            avatar: 'new_avatar_url',
            dob: '01/01/2000',
            addresses: ['Address 1'],
          );

      expect(repository.lastUpdatedProfileName, 'Updated Name');
      expect(repository.lastUpdatedProfilePhone, '+84999999999');
      expect(repository.lastUpdatedProfileAvatar, 'new_avatar_url');
      expect(repository.lastUpdatedProfileDob, '01/01/2000');
      expect(repository.lastUpdatedProfileAddresses, ['Address 1']);
      expect(container.read(authNotifierProvider).hasError, isFalse);
    });

    test('delegates updateRole', () async {
      final repository = FakeAuthRepository();
      final container = ProviderContainer(
        overrides: [
          authRepositoryProvider.overrideWithValue(repository),
        ],
      );
      addTearDown(container.dispose);

      await container
          .read(authNotifierProvider.notifier)
          .updateRole(UserRole.technician);

      expect(repository.lastUpdatedRole, UserRole.technician);
      expect(container.read(authNotifierProvider).hasError, isFalse);
    });

    test('delegates sendEmailOTP', () async {
      final repository = FakeAuthRepository();
      final container = ProviderContainer(
        overrides: [
          authRepositoryProvider.overrideWithValue(repository),
        ],
      );
      addTearDown(container.dispose);

      await container
          .read(authNotifierProvider.notifier)
          .sendEmailOTP('otp@example.com');

      expect(repository.lastSentEmailOTP, 'otp@example.com');
      expect(container.read(authNotifierProvider).hasError, isFalse);
    });

    test('delegates verifyEmailOTP', () async {
      final repository = FakeAuthRepository();
      final container = ProviderContainer(
        overrides: [
          authRepositoryProvider.overrideWithValue(repository),
        ],
      );
      addTearDown(container.dispose);

      await container.read(authNotifierProvider.notifier).verifyEmailOTP(
            email: 'otp@example.com',
            otp: '123456',
          );

      expect(repository.lastVerifiedEmailOTPEmail, 'otp@example.com');
      expect(repository.lastVerifiedEmailOTPOTP, '123456');
      expect(container.read(authNotifierProvider).hasError, isFalse);
    });

    test('delegates submitTechnicianOnboarding', () async {
      final repository = FakeAuthRepository();
      final container = ProviderContainer(
        overrides: [
          authRepositoryProvider.overrideWithValue(repository),
        ],
      );
      addTearDown(container.dispose);

      await container
          .read(authNotifierProvider.notifier)
          .submitTechnicianOnboarding(
            businessName: 'My Shop',
            businessAddress: '123 St',
            serviceType: 'Plumbing',
            experienceYears: 5,
            serviceArea: 'District 1',
            startTime: '08:00',
            endTime: '17:00',
            hourlyRate: 50.0,
            flatFee: 20.0,
            additionalInfo: 'Extra info',
            localDocumentPaths: ['path/1', 'path/2'],
            paymentMethods: ['bankTransfer'],
          );

      final app = repository.lastTechnicianApplication!;
      expect(app['businessName'], 'My Shop');
      expect(app['experienceYears'], 5);
      expect(app['localDocumentPaths'], ['path/1', 'path/2']);
      expect(app['paymentMethods'], ['bankTransfer']);
      expect(container.read(authNotifierProvider).hasError, isFalse);
    });

    test('delegates submitTechnicianOnboarding with professional fields', () async {
      final repository = FakeAuthRepository();
      final container = ProviderContainer(
        overrides: [
          authRepositoryProvider.overrideWithValue(repository),
        ],
      );
      addTearDown(container.dispose);

      await container
          .read(authNotifierProvider.notifier)
          .submitTechnicianOnboarding(
            businessName: 'Pro Fix',
            businessAddress: '456 Ave',
            serviceType: 'Electrician',
            experienceYears: 10,
            serviceArea: 'District 7',
            startTime: '07:00',
            endTime: '19:00',
            hourlyRate: 100.0,
            flatFee: 50.0,
            additionalInfo: 'Licensed pro',
            localDocumentPaths: ['cert.pdf'],
            identityNumber: '123456789',
            identityCardFrontPath: 'front.jpg',
            identityCardBackPath: 'back.jpg',
            serviceRadius: 15.0,
            workSchedule: 'Mon-Fri',
            paymentMethods: ['cash', 'wallet'],
          );

      final app = repository.lastTechnicianApplication!;
      expect(app['businessName'], 'Pro Fix');
      expect(app['identityNumber'], '123456789');
      expect(app['identityCardFrontPath'], 'front.jpg');
      expect(app['identityCardBackPath'], 'back.jpg');
      expect(app['serviceRadius'], 15.0);
      expect(app['workSchedule'], 'Mon-Fri');
      expect(app['paymentMethods'], ['cash', 'wallet']);
      expect(container.read(authNotifierProvider).hasError, isFalse);
    });

    test('clearError resets state to AsyncData(null)', () async {
      final repository = FakeAuthRepository();
      repository.errorToThrow = Exception('Error');

      final container = ProviderContainer(
        overrides: [
          authRepositoryProvider.overrideWithValue(repository),
        ],
      );
      addTearDown(container.dispose);

      // Trigger error
      try {
        await container.read(authNotifierProvider.notifier).signIn('a', 'b');
      } catch (_) {}

      expect(container.read(authNotifierProvider).hasError, isTrue);

      container.read(authNotifierProvider.notifier).clearError();

      expect(container.read(authNotifierProvider).hasError, isFalse);
      expect(container.read(authNotifierProvider), isA<AsyncData<void>>());
    });

    group('Error Handling', () {
      test('signIn rethrows and sets AsyncError', () async {
        final repository = FakeAuthRepository();
        final error = Exception('SignIn Failed');
        repository.errorToThrow = error;

        final container = ProviderContainer(
          overrides: [
            authRepositoryProvider.overrideWithValue(repository),
          ],
        );
        addTearDown(container.dispose);

        final notifier = container.read(authNotifierProvider.notifier);

        await expectLater(
          () => notifier.signIn('test@example.com', 'pass'),
          throwsA(error),
        );

        expect(container.read(authNotifierProvider).hasError, isTrue);
        expect(container.read(authNotifierProvider).error, error);
      });

      test('verifyEmailOTP rethrows and sets AsyncError', () async {
        final repository = FakeAuthRepository();
        final error = Exception('OTP Invalid');
        repository.errorToThrow = error;

        final container = ProviderContainer(
          overrides: [
            authRepositoryProvider.overrideWithValue(repository),
          ],
        );
        addTearDown(container.dispose);

        final notifier = container.read(authNotifierProvider.notifier);

        await expectLater(
          () => notifier.verifyEmailOTP(email: 'a@b.com', otp: '123'),
          throwsA(error),
        );

        expect(container.read(authNotifierProvider).hasError, isTrue);
      });
    });

    group('currentUser stream', () {
      test('hydrates the user document from auth state', () async {
        final repository = FakeAuthRepository();
        final authUser = _appwriteUser(
          id: 'uid-123',
          email: 'tester@example.com',
        );

        final container = ProviderContainer(
          overrides: [
            authRepositoryProvider.overrideWithValue(repository),
          ],
        );
        addTearDown(() async {
          await repository.dispose();
          container.dispose();
        });

        // Seed initial account value to allow currentUser to proceed
        repository.setInitialAccount(authUser);

        final values = <UserModel?>[];
        final listener = container.listen<AsyncValue<UserModel?>>(
          currentUserProvider,
          (_, next) {
            values.add(next.valueOrNull);
          },
          fireImmediately: true,
        );
        addTearDown(listener.close);

        // Emit through userChanges as well
        repository.emitAuthUser(authUser);
        // Đợi cho ensureUserDocument được thực thi và watchUserData được gọi
        await Future<void>.delayed(const Duration(milliseconds: 300));

        repository.emitUserModel(
          const UserModel(
            uid: 'uid-123',
            name: 'Tester',
            email: 'tester@example.com',
            phone: '+84901234567',
          ),
        );

        await Future<void>.delayed(const Duration(milliseconds: 300));

        expect(
          values.whereType<UserModel>().map((user) => user.uid),
          contains('uid-123'),
        );
      });
    });
  group('AuthNotifier - updateProfile', () {
    test('calls repository.updateUserProfile with all parameters', () async {
      final repository = FakeAuthRepository();
      final container = ProviderContainer(
        overrides: [
          authRepositoryProvider.overrideWithValue(repository),
        ],
      );
      addTearDown(container.dispose);

      await container.read(authNotifierProvider.notifier).updateProfile(
            name: 'Vinh',
            phone: '+84 784 145 753',
            avatar: 'new_url',
            dob: '15/09/2006',
            addresses: ['Add 1', 'Add 2'],
          );

      expect(repository.lastUpdatedProfileName, 'Vinh');
      expect(repository.lastUpdatedProfilePhone, '+84 784 145 753');
      expect(repository.lastUpdatedProfileAvatar, 'new_url');
      expect(repository.lastUpdatedProfileDob, '15/09/2006');
      expect(repository.lastUpdatedProfileAddresses, ['Add 1', 'Add 2']);
    });
  });
  });
}

models.User _appwriteUser({
  required String id,
  required String email,
}) {
  final now = DateTime(2026).toIso8601String();
  return models.User.fromMap({
    '\$id': id,
    '\$createdAt': now,
    '\$updatedAt': now,
    'name': 'Tester',
    'registration': now,
    'status': true,
    'labels': <String>[],
    'passwordUpdate': now,
    'email': email,
    'phone': '',
    'emailVerification': true,
    'phoneVerification': true,
    'mfa': false,
    'prefs': <String, dynamic>{},
    'targets': <Map<String, dynamic>>[],
    'accessedAt': now,
  });
}

class FakeAuthRepository implements AuthRepository {
  FakeAuthRepository({
    PhoneVerificationChallenge? phoneChallenge,
  }) : _phoneChallenge = phoneChallenge ??
            const PhoneVerificationChallenge(
              verificationId: 'default-verification',
              resendToken: 1,
            );

  final PhoneVerificationChallenge _phoneChallenge;
  final StreamController<dynamic> _authController =
      StreamController<dynamic>.broadcast();
  final StreamController<UserModel?> _userController =
      StreamController<UserModel?>.broadcast();

  String? lastSignedInEmail;
  String? lastSignedInPassword;
  String? lastRegisteredEmail;
  String? lastRegisteredPassword;
  String? lastRegisteredName;
  String? lastPhoneNumber;
  String? lastConfirmedVerificationId;
  String? lastConfirmedSmsCode;
  String? lastCheckedEmail;
  String? lastCheckedPhone;
  String? lastUpdatedPassword;
  String? lastPasswordResetEmail;
  String? lastConfirmPasswordResetUserId;
  String? lastConfirmPasswordResetSecret;
  String? lastConfirmPasswordResetNewPassword;
  String? lastVerifyRecoverySecretUserId;
  String? lastVerifyRecoverySecretSecret;
  String? lastUpdatedProfileName;
  String? lastUpdatedProfilePhone;
  String? lastUpdatedProfileAvatar;
  String? lastUpdatedProfileDob;
  List<String>? lastUpdatedProfileAddresses;
  UserRole? lastUpdatedRole;
  String? lastSentEmailOTP;
  String? lastVerifiedEmailOTPEmail;
  String? lastVerifiedEmailOTPOTP;
  String? lastSyncedSettingsUserId;
  String? lastSyncedThemeMode;
  String? lastSyncedLanguage;
  String? lastFetchedSettingsUserId;
  Map<String, dynamic>? lastTechnicianApplication;
  
  int googleSignInCount = 0;
  int facebookSignInCount = 0;
  int emailVerificationCount = 0;
  int reloadCount = 0;
  int signOutCount = 0;
  final List<String> ensuredUserIds = [];

  Object? errorToThrow;
  dynamic initialAccount;

  @override
  Stream<dynamic> get userChanges => _authController.stream;

  void emitAuthUser(dynamic user) => _authController.add(user);

  void setInitialAccount(dynamic account) => initialAccount = account;

  void emitUserModel(UserModel? user) => _userController.add(user);

  Future<void> dispose() async {
    await _authController.close();
    await _userController.close();
  }

  void _maybeThrow() {
    if (errorToThrow != null) {
      throw errorToThrow!;
    }
  }

  @override
  Future<void> confirmPhoneVerification({
    required String verificationId,
    required String smsCode,
    String? phoneNumber,
  }) async {
    _maybeThrow();
    lastConfirmedVerificationId = verificationId;
    lastConfirmedSmsCode = smsCode;
  }

  @override
  Future<UserModel> ensureUserDocument(dynamic user) async {
    _maybeThrow();
    late final String uid;
    late final String email;

    if (user is models.User) {
      uid = user.$id;
      email = user.email;
    } else if (user is Map<String, dynamic>) {
      uid = user['\$id'] as String;
      email = user['email'] as String? ?? 'tester@example.com';
    } else {
      final dynamic dynamicUser = user;
      uid = dynamicUser.uid as String;
      email = dynamicUser.email as String? ?? 'tester@example.com';
    }

    ensuredUserIds.add(uid);
    return UserModel(
      uid: uid,
      name: 'Tester',
      email: email,
      phone: '',
    );
  }

  @override
  Future<UserModel?> getUserData(String uid) async {
    _maybeThrow();
    return null;
  }

  @override
  Future<void> syncUserSettings({
    required String userId,
    String? themeMode,
    String? language,
  }) async {
    _maybeThrow();
    lastSyncedSettingsUserId = userId;
    lastSyncedThemeMode = themeMode;
    lastSyncedLanguage = language;
  }

  @override
  Future<Map<String, dynamic>?> getUserSettings(String userId) async {
    _maybeThrow();
    lastFetchedSettingsUserId = userId;
    return null;
  }

  @override
  Future<dynamic> reloadCurrentUser() async {
    _maybeThrow();
    reloadCount += 1;
    return null;
  }

  @override
  Future<void> registerWithEmail({
    required String email,
    required String password,
    required String name,
  }) async {
    _maybeThrow();
    lastRegisteredEmail = email;
    lastRegisteredPassword = password;
    lastRegisteredName = name;
  }

  @override
  Future<void> sendEmailVerification() async {
    _maybeThrow();
    emailVerificationCount += 1;
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    _maybeThrow();
    lastPasswordResetEmail = email;
  }

  @override
  Future<bool> checkEmailExists(String email) async {
    _maybeThrow();
    lastCheckedEmail = email;
    return false;
  }

  @override
  Future<bool> checkPhoneExists(String phoneNumber) async {
    _maybeThrow();
    lastCheckedPhone = phoneNumber;
    return false;
  }

  @override
  Future<void> updatePassword(String newPassword) async {
    _maybeThrow();
    lastUpdatedPassword = newPassword;
  }

  @override
  Future<dynamic> getAccount() async {
    _maybeThrow();
    return initialAccount;
  }

  @override
  Future<void> signInWithEmail(String email, String password) async {
    _maybeThrow();
    lastSignedInEmail = email;
    lastSignedInPassword = password;
  }

  @override
  Future<void> signInWithGoogle() async {
    _maybeThrow();
    googleSignInCount += 1;
  }

  @override
  Future<void> signOut() async {
    _maybeThrow();
    signOutCount += 1;
  }

  @override
  Future<void> updateUserRole(UserRole role) async {
    _maybeThrow();
    lastUpdatedRole = role;
  }

  @override
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
    String? identityNumber,
    String? identityCardFrontPath,
    String? identityCardBackPath,
    double? serviceRadius,
    String? workSchedule,
    List<String>? paymentMethods,
    double? latitude,
    double? longitude,
  }) async {
    _maybeThrow();
    lastTechnicianApplication = {
      'businessName': businessName,
      'businessAddress': businessAddress,
      'serviceType': serviceType,
      'experienceYears': experienceYears,
      'serviceArea': serviceArea,
      'startTime': startTime,
      'endTime': endTime,
      'hourlyRate': hourlyRate,
      'flatFee': flatFee,
      'additionalInfo': additionalInfo,
      'localDocumentPaths': localDocumentPaths,
      'identityNumber': identityNumber,
      'identityCardFrontPath': identityCardFrontPath,
      'identityCardBackPath': identityCardBackPath,
      'serviceRadius': serviceRadius,
      'workSchedule': workSchedule,
      'paymentMethods': paymentMethods,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  @override
  Future<PhoneVerificationChallenge> startPhoneVerification({
    required String phoneNumber,
    int? forceResendingToken,
  }) async {
    _maybeThrow();
    lastPhoneNumber = phoneNumber;
    return _phoneChallenge;
  }

  @override
  Stream<UserModel?> watchUserData(String uid) => _userController.stream;

  @override
  Future<void> signInWithFacebook() async {
    _maybeThrow();
    facebookSignInCount += 1;
  }

  @override
  Future<void> sendEmailOTP(String email) async {
    _maybeThrow();
    lastSentEmailOTP = email;
  }

  @override
  Future<void> verifyEmailOTP(
      {required String email, required String otp}) async {
    _maybeThrow();
    lastVerifiedEmailOTPEmail = email;
    lastVerifiedEmailOTPOTP = otp;
  }

  @override
  Future<void> confirmPasswordReset({
    required String userId,
    required String secret,
    required String newPassword,
  }) async {
    _maybeThrow();
    lastConfirmPasswordResetUserId = userId;
    lastConfirmPasswordResetSecret = secret;
    lastConfirmPasswordResetNewPassword = newPassword;
  }

  @override
  Future<bool> verifyRecoverySecret({
    required String userId,
    required String secret,
  }) async {
    _maybeThrow();
    lastVerifyRecoverySecretUserId = userId;
    lastVerifyRecoverySecretSecret = secret;
    return true;
  }

  @override
  Future<void> updateUserProfile({
    required String name,
    required String phone,
    String? avatar,
    File? avatarFile,
    String? dob,
    List<String>? addresses,
  }) async {
    _maybeThrow();
    lastUpdatedProfileName = name;
    lastUpdatedProfilePhone = phone;
    lastUpdatedProfileAvatar = avatar;
    lastUpdatedProfileDob = dob;
    lastUpdatedProfileAddresses = addresses;
  }

  @override
  Future<String> getUserIdByEmail(String email) async {
    _maybeThrow();
    return 'uid-123';
  }

  @override
  Future<String> getUserIdByPhone(String phone) async {
    _maybeThrow();
    return 'uid-123';
  }
}

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:appwrite/appwrite.dart';
import 'package:appwrite/enums.dart';
import 'package:appwrite/models.dart' as models;
import 'package:flutter/foundation.dart';
import '../../../core/constants/app_constants.dart';
import '../domain/auth_repository.dart';
import '../../../shared/models/user_model.dart';

class AppwriteAuthRepositoryImpl implements AuthRepository {
  AppwriteAuthRepositoryImpl({
    required Client client,
    required Account account,
    required Databases databases,
    required Storage storage,
    required Realtime realtime,
    required String projectId,
    required String endpoint,
    String? databaseId,
    String? usersCollectionId,
  })  : _client = client,
        _account = account,
        _db = databases,
        _storage = storage,
        _realtime = realtime,
        _projectId = projectId,
        _endpoint = endpoint.replaceFirst(RegExp(r'/$'), ''),
        _dbId = databaseId ?? AppwriteConstants.databaseId,
        _usersCollId = usersCollectionId ?? AppwriteConstants.usersCollectionId;

  final Client _client;
  final Account _account;
  final Databases _db;
  final Storage _storage;
  final Realtime _realtime;
  final String _projectId;
  final String _endpoint;
  final String _dbId;
  final String _usersCollId;

  final _userChangesController = StreamController<dynamic>.broadcast();
  final _pendingEmailOtpUserIds = <String, String>{};

  // Quyền hạn rộng hơn để đảm bảo tính tương thích và dễ dàng debug
  final List<String> _docPermissions = [
    Permission.read(Role.any()),
    Permission.write(Role.any()),
    Permission.update(Role.any()),
    Permission.delete(Role.any()),
  ];

  @override
  Stream<dynamic> get userChanges {
    return _userChangesController.stream;
  }

  Future<void> _checkUser() async {
    try {
      final user = await _account.get();
      // 3. Tự động khởi tạo User Settings
      await syncUserSettings(userId: user.$id);

      _userChangesController.add(user);
    } on AppwriteException catch (e) {
      if (e.code == 429) {
        debugPrint('Appwrite: Rate limit exceeded in _checkUser');
      }
      _userChangesController.add(null);
    } catch (_) {
      _userChangesController.add(null);
    }
  }

  @override
  Stream<UserModel?> watchUserData(String uid) async* {
    UserModel? current;
    try {
      current = await getUserData(uid);
      yield current;
    } catch (e) {
      debugPrint('Appwrite: Initial fetch error in watchUserData: $e');
    }

    try {
      final subscription = _realtime.subscribe(
          ['databases.$_dbId.collections.$_usersCollId.documents.$uid']);

      await for (final event in subscription.stream) {
        try {
          if (event.payload.isNotEmpty) {
            final newUser = _mapToUserModel(event.payload, uid);
            if (newUser != current) {
              current = newUser;
              yield current;
            }
          }
        } catch (e) {
          debugPrint('Appwrite: Error processing realtime event: $e');
        }
      }
    } catch (e) {
      debugPrint(
          'Appwrite: Realtime subscription failed: $e. Falling back to static data.');
    }
  }

  @override
  Future<UserModel?> getUserData(String uid) async {
    try {
      debugPrint('Appwrite: [DEBUG] getUserData start for $uid');
      final doc = await _db.getDocument(
        databaseId: _dbId,
        collectionId: _usersCollId,
        documentId: uid,
      );

      // Log cực kỳ chi tiết để soi xem Server trả về cái gì
      final rawJson = jsonEncode(doc.toMap());
      debugPrint('Appwrite: [DEBUG] Full Document JSON for $uid: $rawJson');
      debugPrint('Appwrite: [DEBUG] doc.data for $uid: ${doc.data}');

      if (doc.data.isEmpty) {
        debugPrint(
            'Appwrite: [CRITICAL] doc.data is EMPTY for $uid. Checking attributes in schema might be necessary.');
      }

      final user = _mapToUserModel(doc.data, uid);
      debugPrint('Appwrite: [DEBUG] Mapped user $uid with role: ${user.role}');
      return user;
    } on AppwriteException catch (e) {
      debugPrint(
          'Appwrite: [ERROR] getUserData for $uid: [${e.code}] ${e.message}');
      if (e.code == 404) {
        debugPrint(
            'Appwrite: [INFO] Document NOT FOUND for $uid. This is expected for new users.');
      }
      return null;
    } catch (e) {
      debugPrint('Appwrite: [FATAL] getUserData for $uid: $e');
      return null;
    }
  }

  @override
  Future<UserModel> ensureUserDocument(dynamic user) async {
    if (user is! models.User) throw Exception('Invalid user type for Appwrite');

    final uid = user.$id;
    debugPrint('Appwrite: [DEBUG] ensureUserDocument for $uid (${user.email})');

    // 1. Fetch dữ liệu hiện tại
    UserModel? existing;
    bool isTrulyEmpty = false;
    try {
      final doc = await _db.getDocument(
        databaseId: _dbId,
        collectionId: _usersCollId,
        documentId: uid,
      );
      isTrulyEmpty = doc.data.isEmpty;
      existing = _mapToUserModel(doc.data, uid);
    } catch (e) {
      debugPrint(
          'Appwrite: [INFO] Document not found or error fetching for $uid: $e');
    }

    // 2. Nếu đã có dữ liệu THẬT và KHÔNG rỗng -> Trả về luôn
    if (existing != null &&
        !isTrulyEmpty &&
        existing.name.isNotEmpty &&
        !existing.name.startsWith('User ')) {
      debugPrint(
          'Appwrite: [INFO] User document already exists with data. Skipping creation.');
      return existing;
    }

    final now = DateTime.now().toIso8601String();

    try {
      final data = {
        'name': user.name,
        'email': user.email,
        'phone': user.phone ?? '',
        'avatar': '',
        'dob': '',
        'addresses': [],
        'role': UserRole.none.name,
        'skills': [],
        'phoneVerifiedAt': null, // Thêm để tránh lỗi Required attribute
        'createdAt': now,
        'updatedAt': now,
      };

      try {
        debugPrint(
            'Appwrite: [DEBUG] Attempting to create user document for $uid');
        await _db.createDocument(
          databaseId: _dbId,
          collectionId: _usersCollId,
          documentId: uid,
          data: data,
          permissions: _docPermissions,
        );
        debugPrint('Appwrite: [SUCCESS] Created new document for $uid');
        return await getUserData(uid) ?? _mapToUserModel(data, uid);
      } on AppwriteException catch (e) {
        if (e.code == 409) {
          debugPrint(
              'Appwrite: [INFO] User document already exists (409). Checking if we need to repair it.');

          // Nếu document đã tồn tại nhưng trả về {}, có thể do permissions cũ hoặc schema
          // Ta thử UPDATE nó với data cơ bản nếu nó hoàn toàn trống rỗng
          if (existing != null && existing.name.isEmpty) {
            debugPrint(
                'Appwrite: [DEBUG] Document is empty. Attempting to repair with basic info.');
            try {
              await _db.updateDocument(
                databaseId: _dbId,
                collectionId: _usersCollId,
                documentId: uid,
                data: data,
                permissions: _docPermissions,
              );
              debugPrint(
                  'Appwrite: [SUCCESS] Repaired empty document for $uid');
            } catch (updateErr) {
              debugPrint(
                  'Appwrite: [ERROR] Failed to repair document: $updateErr');
            }
          }

          final fresh = await getUserData(uid);
          return fresh ?? _mapToUserModel(data, uid);
        }
        debugPrint(
            'Appwrite: [ERROR] createDocument error [${e.code}]: ${e.message}');
        rethrow;
      }
    } catch (e) {
      debugPrint('Appwrite: [FATAL] ensureUserDocument for $uid: $e');
      rethrow;
    }
  }

  @override
  Future<dynamic> getAccount() async {
    try {
      return await _account.get();
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> signInWithEmail(String email, String password) async {
    try {
      await _account.createEmailPasswordSession(
        email: email,
        password: password,
      );
      final user = await _account.get();
      try {
        await ensureUserDocument(user);
      } catch (e) {
        debugPrint('Appwrite: ensureUserDocument skipped or failed: $e');
      }
      await _checkUser();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> syncUserSettings({
    required String userId,
    String? themeMode,
    String? language,
  }) async {
    final data = {
      'userId': userId,
      'themeMode': themeMode ?? 'light',
      'language': language ?? 'vi',
      'updatedAt': DateTime.now().toIso8601String(),
    };

    try {
      try {
        await _db.createDocument(
          databaseId: _dbId,
          collectionId: AppwriteConstants.userSettingsCollectionId,
          documentId: userId, // Dùng userId làm documentId để duy nhất
          data: {...data, 'createdAt': DateTime.now().toIso8601String()},
          permissions: [
            Permission.read(Role.user(userId)),
            Permission.update(Role.user(userId)),
          ],
        );
      } on AppwriteException catch (e) {
        if (e.code == 409) {
          await _db.updateDocument(
            databaseId: _dbId,
            collectionId: AppwriteConstants.userSettingsCollectionId,
            documentId: userId,
            data: data,
          );
        } else {
          rethrow;
        }
      }
    } catch (e) {
      debugPrint('AppwriteAuth: Error syncing user settings: $e');
    }
  }

  @override
  Future<Map<String, dynamic>?> getUserSettings(String userId) async {
    try {
      final doc = await _db.getDocument(
        databaseId: _dbId,
        collectionId: AppwriteConstants.userSettingsCollectionId,
        documentId: userId,
      );
      return doc.data;
    } catch (e) {
      debugPrint('AppwriteAuth: Error fetching user settings: $e');
      return null;
    }
  }

  @override
  Future<void> signInWithGoogle() async {
    await _account.createOAuth2Session(provider: OAuthProvider.google);
    final user = await _account.get();
    await ensureUserDocument(user);
    await _checkUser();
  }

  @override
  Future<void> signInWithFacebook() async {
    await _account.createOAuth2Session(provider: OAuthProvider.facebook);
    final user = await _account.get();
    await ensureUserDocument(user);
    await _checkUser();
  }

  @override
  Future<void> registerWithEmail({
    required String email,
    required String password,
    required String name,
  }) async {
    await _account.create(
      userId: ID.unique(),
      email: email,
      password: password,
      name: name,
    );
    await signInWithEmail(email, password);
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    await _account.createRecovery(
      email: email.trim().toLowerCase(),
      url: 'https://fixit.app/reset-password',
    );
  }

  @override
  Future<bool> checkEmailExists(String email) async {
    final normalized = email.trim().toLowerCase();
    try {
      final result = await _db.listDocuments(
        databaseId: _dbId,
        collectionId: _usersCollId,
        queries: [Query.equal('email', normalized), Query.limit(1)],
      );
      if (result.documents.isNotEmpty) return true;
    } catch (e) {
      debugPrint('Appwrite: checkEmailExists (DB) error: $e');
    }
    return false;
  }

  @override
  Future<bool> checkPhoneExists(String phoneNumber) async {
    try {
      final result = await _db.listDocuments(
        databaseId: _dbId,
        collectionId: _usersCollId,
        queries: [Query.equal('phone', phoneNumber.trim()), Query.limit(1)],
      );
      return result.documents.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<void> sendEmailVerification() async {
    await _account.createEmailVerification(
        url: 'https://fixit.app/verify-email');
  }

  @override
  Future<void> sendEmailOTP(String email) async {
    final normalized = email.trim().toLowerCase();
    try {
      String userId = ID.unique();
      try {
        userId = await getUserIdByEmail(normalized);
      } catch (_) {}

      final token = await _account.createEmailToken(
        userId: userId,
        email: normalized,
      );

      _pendingEmailOtpUserIds[normalized] = token.userId;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<String> getUserIdByEmail(String email) async {
    final result = await _db.listDocuments(
      databaseId: _dbId,
      collectionId: _usersCollId,
      queries: [
        Query.equal('email', email.trim().toLowerCase()),
        Query.limit(1)
      ],
    );
    if (result.documents.isEmpty) throw Exception('user_not_found');
    return result.documents.first.$id;
  }

  @override
  Future<String> getUserIdByPhone(String phone) async {
    final result = await _db.listDocuments(
      databaseId: _dbId,
      collectionId: _usersCollId,
      queries: [Query.equal('phone', phone.trim()), Query.limit(1)],
    );
    if (result.documents.isEmpty) throw Exception('user_not_found');
    return result.documents.first.$id;
  }

  @override
  Future<void> verifyEmailOTP(
      {required String email, required String otp}) async {
    final normalized = email.trim().toLowerCase();
    final userId = _pendingEmailOtpUserIds[normalized];
    if (userId == null) {
      throw Exception('Mã xác thực email đã hết hạn. Vui lòng gửi lại mã.');
    }

    try {
      await _account.deleteSession(sessionId: 'current');
    } catch (_) {}

    try {
      await _account.createSession(userId: userId, secret: otp.trim());
      _pendingEmailOtpUserIds.remove(normalized);
      await ensureUserDocument(await _account.get());
      await _checkUser();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<dynamic> reloadCurrentUser() async {
    await _checkUser();
    return await _account.get();
  }

  @override
  Future<PhoneVerificationChallenge> startPhoneVerification({
    required String phoneNumber,
    int? forceResendingToken,
  }) async {
    String userId = ID.unique();
    try {
      userId = await getUserIdByPhone(phoneNumber);
    } catch (_) {}

    final token = await _account.createPhoneToken(
      userId: userId,
      phone: phoneNumber,
    );
    return PhoneVerificationChallenge(verificationId: token.userId);
  }

  @override
  Future<void> confirmPhoneVerification({
    required String verificationId,
    required String smsCode,
    String? phoneNumber,
  }) async {
    try {
      await _account.deleteSession(sessionId: 'current');
    } catch (_) {}

    await _account.createSession(
        userId: verificationId, secret: smsCode.trim());
    final user = await _account.get();
    await ensureUserDocument(user);
    await _db.updateDocument(
      databaseId: _dbId,
      collectionId: _usersCollId,
      documentId: user.$id,
      data: {
        if (phoneNumber != null) 'phone': phoneNumber,
        'phoneVerifiedAt': DateTime.now().toIso8601String(),
        'updatedAt': DateTime.now().toIso8601String(),
      },
    );
    await _checkUser();
  }

  @override
  Future<void> updatePassword(String newPassword) async {
    // Không dùng hàm này nữa vì bị lỗi 401 khi quên mật khẩu
    await _account.updatePassword(password: newPassword);
  }



  /// HÀM MỚI: Đổi mật khẩu thông qua Appwrite Function (Quyền Admin)
  /// Giúp đổi mật khẩu bằng mã OTP 6 số mà không cần mật khẩu cũ
  Future<void> resetPasswordWithOtpAdmin({
    required String email,
    required String otp,
    required String newPassword,
  }) async {
    try {
      final functions = Functions(_client);
      // SỬA TẠI ĐÂY: Thêm xasync: false để đợi Function chạy xong và trả về kết quả
      final response = await functions.createExecution(
        functionId: 'reset-password-admin',
        body: jsonEncode({
          'email': email,
          'otp': otp,
          'newPassword': newPassword,
        }),
        xasync: false,
      );

      // Kiểm tra trạng thái hoàn thành (hỗ trợ cả String và Enum)
      final status = response.status.toString();
      if (!status.contains('completed')) {
        debugPrint('Appwrite Function Error Status: $status');

        if (response.responseBody.isNotEmpty) {
          try {
            final errorJson = jsonDecode(response.responseBody);
            if (errorJson['success'] == false) {
              throw Exception(errorJson['message']);
            }
          } catch (e) {
            if (e is Exception) rethrow;
          }
        }
        throw Exception('Lỗi hệ thống ($status)');
      }

      final result = jsonDecode(response.responseBody);
      if (result['success'] == false) {
        throw Exception(result['message'] ?? 'Mã OTP không hợp lệ hoặc đã hết hạn.');
      }

      // Trả về message thành công để UI sử dụng nếu cần
      return;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> confirmPasswordReset({
    required String userId,
    required String secret,
    required String newPassword,
  }) async {
    await _account.updateRecovery(
      userId: userId,
      secret: secret,
      password: newPassword,
    );
  }

  @override
  Future<bool> verifyRecoverySecret({
    required String userId,
    required String secret,
  }) async {
    try {
      await _account.updateRecovery(
        userId: userId,
        secret: secret,
        password: '1',
      );
      return true;
    } on AppwriteException catch (e) {
      if (e.code == 401) return false;
      if (e.code == 400) return true;
      return false;
    } catch (e) {
      return false;
    }
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
    try {
      final user = await _account.get();
      final uid = user.$id;

      await _account.updateName(name: name);

      String finalAvatar = avatar ?? '';
      if (avatarFile != null) {
        final uploadedFile = await _storage.createFile(
          bucketId: AppwriteConstants.fixitAssetsBucketId,
          fileId: ID.unique(),
          file: InputFile.fromPath(path: avatarFile.path),
        );
        finalAvatar =
            _fileUrl(AppwriteConstants.fixitAssetsBucketId, uploadedFile.$id);
        await _account.updatePrefs(prefs: {
          ...user.prefs.data,
          'avatar': finalAvatar,
        });
      }

      final cleanedAddresses =
          addresses?.where((a) => a.trim().isNotEmpty).toList();

      final updateData = {
        'name': name,
        'phone': phone,
        'avatar': finalAvatar,
        if (dob != null) 'dob': dob,
        if (cleanedAddresses != null) 'addresses': cleanedAddresses,
        'updatedAt': DateTime.now().toIso8601String(),
      };

      await _db.updateDocument(
        databaseId: _dbId,
        collectionId: _usersCollId,
        documentId: uid,
        data: updateData,
        permissions: _docPermissions,
      );

      await _checkUser();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> updateUserRole(UserRole role) async {
    await _db.updateDocument(
      databaseId: _dbId,
      collectionId: _usersCollId,
      documentId: (await _account.get()).$id,
      data: {
        'role': role.name,
        'updatedAt': DateTime.now().toIso8601String(),
      },
    );
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
    // New Professional Fields
    String? identityNumber,
    String? identityCardFrontPath,
    String? identityCardBackPath,
    double? serviceRadius,
    String? workSchedule,
    List<String>? paymentMethods,
    double? latitude,
    double? longitude,
  }) async {
    final user = await _account.get();
    final uploadedDocuments = <String>[];

    // Upload general documents
    for (final path in localDocumentPaths) {
      final file = File(path);
      if (!await file.exists()) continue;
      final uploaded = await _storage.createFile(
        bucketId: AppwriteConstants.technicianDocumentsBucketId,
        fileId: ID.unique(),
        file: InputFile.fromPath(path: path),
      );
      uploadedDocuments.add(_fileUrl(
          AppwriteConstants.technicianDocumentsBucketId, uploaded.$id));
    }

    // Upload Identity Cards
    String? frontUrl;
    if (identityCardFrontPath != null) {
      final file = File(identityCardFrontPath);
      if (await file.exists()) {
        final uploaded = await _storage.createFile(
          bucketId: AppwriteConstants.technicianDocumentsBucketId,
          fileId: ID.unique(),
          file: InputFile.fromPath(path: identityCardFrontPath),
        );
        frontUrl = _fileUrl(
            AppwriteConstants.technicianDocumentsBucketId, uploaded.$id);
      }
    }

    String? backUrl;
    if (identityCardBackPath != null) {
      final file = File(identityCardBackPath);
      if (await file.exists()) {
        final uploaded = await _storage.createFile(
          bucketId: AppwriteConstants.technicianDocumentsBucketId,
          fileId: ID.unique(),
          file: InputFile.fromPath(path: identityCardBackPath),
        );
        backUrl = _fileUrl(
            AppwriteConstants.technicianDocumentsBucketId, uploaded.$id);
      }
    }

    final now = DateTime.now().toIso8601String();
    
    // --- CƠ CHẾ TỰ ĐỘNG VƯỢT LỖI SCHEMA THÔNG MINH ---
    Future<void> attemptCreate(Map<String, dynamic> docData) async {
      try {
        await _db.createDocument(
          databaseId: _dbId,
          collectionId: AppwriteConstants.technicianApplicationsCollectionId,
          documentId: ID.unique(),
          data: docData,
          permissions: [
            Permission.read(Role.user(user.$id)),
            Permission.update(Role.user(user.$id)),
          ],
        );
      } on AppwriteException catch (e) {
        // Tự động nhận diện trường bị thiếu và loại bỏ nó để retry
        final msg = e.message?.toLowerCase() ?? '';
        if (msg.contains('unknown attribute')) {
          // Trích xuất tên trường lỗi từ thông báo của Appwrite
          // Ví dụ: 'Unknown attribute: "latitude"'
          final RegExp regExp = RegExp(r'attribute: "([^"]+)"');
          final match = regExp.firstMatch(msg);
          
          if (match != null) {
            final fieldName = match.group(1);
            debugPrint('Appwrite Failsafe: DB missing "$fieldName", retrying without it...');
            final newData = Map<String, dynamic>.from(docData)..remove(fieldName);
            await attemptCreate(newData); // Đệ quy cho đến khi hết lỗi
          } else {
            rethrow;
          }
        } else {
          rethrow;
        }
      }
    }

    final applicationData = {
      'userId': user.$id,
      'fullName': user.name,
      'specialty': serviceType,
      'experience': '$experienceYears năm',
      'businessName': businessName,
      'businessAddress': businessAddress,
      'serviceArea': serviceArea,
      'startTime': startTime,
      'endTime': endTime,
      'hourlyRate': hourlyRate,
      'flatFee': flatFee,
      'additionalInfo': additionalInfo,
      'documents': uploadedDocuments,
      'status': 'pending',
      'identityNumber': identityNumber,
      'identityCardFront': frontUrl,
      'identityCardBack': backUrl,
      'serviceRadius': serviceRadius ?? 10.0,
      'workSchedule': workSchedule,
      'paymentMethods': paymentMethods,
      'latitude': latitude,
      'longitude': longitude,
      'verifiedStatus': 'unverified',
      'createdAt': now,
      'updatedAt': now,
    };

    await attemptCreate(applicationData);

    // 2. Cập nhật Role và Skills cho User gốc
    await _db.updateDocument(
      databaseId: _dbId,
      collectionId: _usersCollId,
      documentId: user.$id,
      data: {
        'role': UserRole.technician.name, 
        'skills': [serviceType],
        'verifiedStatus': 'pending', // Chuyển sang trạng thái chờ duyệt
        'updatedAt': now
      },
    );

    // 3. TẠO LIÊN KẾT: Đưa thợ vào bảng 'technicians' ngay lập tức (với trạng thái chưa sẵn sàng)
    try {
      final techData = {
        'userId': user.$id, // Trường liên kết quan trọng
        'name': user.name,
        'fullName': user.name,
        'phone': user.phone,
        'email': user.email,
        'bio': additionalInfo ?? '',
        'skills': [serviceType],
        'specialty': serviceType,
        'isAvailable': false, // Chưa được duyệt nên chưa cho nhận việc
        'rating': 5.0,
        'reviewCount': 0,
        'experience': experienceYears,
        'completedOrders': 0,
        'pricePerHour': hourlyRate.toInt(),
        'identityNumber': identityNumber,
        'identityCardFront': frontUrl,
        'identityCardBack': backUrl,
        'serviceRadius': serviceRadius ?? 10.0,
        'workSchedule': workSchedule,
        'businessName': businessName,
        'businessAddress': businessAddress,
        'serviceArea': serviceArea,
        'latitude': latitude,
        'longitude': longitude,
        'verifiedStatus': 'unverified',
        'updatedAt': now,
      };

      try {
        // Ép buộc dùng ID của User làm ID của thợ để liên kết bảng 1:1
        await _db.createDocument(
          databaseId: _dbId,
          collectionId: AppwriteConstants.techniciansCollectionId,
          documentId: user.$id, 
          data: {...techData, 'createdAt': now},
          permissions: [
            Permission.read(Role.any()),
            Permission.update(Role.user(user.$id)),
          ],
        );
      } on AppwriteException catch (e) {
        if (e.code == 409) {
          // Nếu đã tồn tại thì cập nhật thông tin mới nhất
          await _db.updateDocument(
            databaseId: _dbId,
            collectionId: AppwriteConstants.techniciansCollectionId,
            documentId: user.$id,
            data: techData,
          );
        } else {
          rethrow;
        }
      }
    } catch (e) {
      debugPrint('Appwrite: Error linking technician record: $e');
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _account.deleteSessions();
    } catch (_) {
      try {
        await _account.deleteSession(sessionId: 'current');
      } catch (_) {}
    }
    _userChangesController.add(null);
  }

  UserModel _mapToUserModel(Map<String, dynamic> data, String id) {
    debugPrint('Appwrite: [MAPPING] User $id');

    // Check if data is truly empty (likely permission issue on attributes)
    final bool isDataEmpty =
        data.isEmpty || (data['email'] == null && data['name'] == null);
    if (isDataEmpty) {
      debugPrint(
          'Appwrite: [CRITICAL] Mapping user $id with EMPTY data. Please check Attribute Permissions in Appwrite Console.');
    }

    final roleStr = data['role']?.toString() ?? UserRole.none.name;
    final role = UserRole.values.firstWhere(
      (r) => r.name == roleStr,
      orElse: () => UserRole.none,
    );

    // Xử lý mảng (List) từ Appwrite một cách an toàn
    final rawAddresses = data['addresses'];
    final List<String> addresses = (rawAddresses is List)
        ? rawAddresses.map((e) => e.toString()).toList()
        : [];

    final rawSkills = data['skills'];
    final List<String> skills =
        (rawSkills is List) ? rawSkills.map((e) => e.toString()).toList() : [];

    return UserModel(
      uid: id,
      name: data['name']?.toString() ?? (isDataEmpty ? 'User $id' : ''),
      email: data['email']?.toString() ?? '',
      phone: data['phone']?.toString() ?? '',
      avatar: data['avatar']?.toString() ?? '',
      dob: data['dob']?.toString() ?? '',
      addresses: addresses,
      role: role,
      skills: skills,
      verifiedStatus: data['verifiedStatus']?.toString() ?? 'unverified',
      identityNumber: data['identityNumber']?.toString(),
      identityCardFront: data['identityCardFront']?.toString(),
      identityCardBack: data['identityCardBack']?.toString(),
      rating: (data['rating'] ?? 0.0).toDouble(),
      reviewCount: (data['reviewCount'] ?? 0).toInt(),
      pushToken: data['pushToken']?.toString(),
      phoneVerifiedAt:
          DateTime.tryParse(data['phoneVerifiedAt']?.toString() ?? ''),
      createdAt: DateTime.tryParse(data['createdAt']?.toString() ?? ''),
      updatedAt: DateTime.tryParse(data['updatedAt']?.toString() ?? ''),
    );
  }

  String _fileUrl(String bucketId, String fileId) {
    return '$_endpoint/storage/buckets/$bucketId/files/$fileId/view?project=$_projectId';
  }
}

import 'dart:io';
import 'package:appwrite/appwrite.dart';
import 'package:fixit/core/config/appwrite_provider.dart';
import 'package:fixit/core/constants/app_constants.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'verification_repository.g.dart';

class VerificationRepository {
  final Databases _databases;
  final Storage _storage;
  final String _dbId;
  final String _usersCollId;

  VerificationRepository(
    this._databases,
    this._storage,
    this._dbId,
    this._usersCollId,
  );

  Future<void> submitIdentityVerification({
    required String userId,
    required String identityNumber,
    required File frontImage,
    required File backImage,
  }) async {
    // 1. Upload Front Image
    final frontFile = await _storage.createFile(
      bucketId: AppwriteConstants.fixitAssetsBucketId,
      fileId: ID.unique(),
      file: InputFile.fromPath(path: frontImage.path),
    );
    final frontUrl = _fileUrl(AppwriteConstants.fixitAssetsBucketId, frontFile.$id);

    // 2. Upload Back Image
    final backFile = await _storage.createFile(
      bucketId: AppwriteConstants.fixitAssetsBucketId,
      fileId: ID.unique(),
      file: InputFile.fromPath(path: backImage.path),
    );
    final backUrl = _fileUrl(AppwriteConstants.fixitAssetsBucketId, backFile.$id);

    // 3. Update User Document
    await _databases.updateDocument(
      databaseId: _dbId,
      collectionId: _usersCollId,
      documentId: userId,
      data: {
        'identityNumber': identityNumber,
        'identityCardFront': frontUrl,
        'identityCardBack': backUrl,
        'verifiedStatus': 'pending',
        'updatedAt': DateTime.now().toIso8601String(),
      },
    );
  }

  String _fileUrl(String bucketId, String fileId) {
    // Note: This URL construction might need to be adjusted based on environment
    // But since it's a static repository, we can use a helper or pass the endpoint
    // For now, let's assume it's the same pattern as in AuthRepository
    return 'https://sgp.cloud.appwrite.io/v1/storage/buckets/$bucketId/files/$fileId/view?project=6a145b8d001aa82f4dd5';
  }
}

@riverpod
VerificationRepository verificationRepository(Ref ref) {
  final databases = ref.watch(appwriteDatabasesProvider);
  final storage = ref.watch(appwriteStorageProvider);
  return VerificationRepository(
    databases,
    storage,
    AppwriteConstants.databaseId,
    AppwriteConstants.usersCollectionId,
  );
}

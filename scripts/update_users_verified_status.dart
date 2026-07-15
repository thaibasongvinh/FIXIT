import 'dart:io';
import 'package:dart_appwrite/dart_appwrite.dart';

final String endpoint = Platform.environment['APPWRITE_ENDPOINT'] ??
    'https://sgp.cloud.appwrite.io/v1';
final String projectId =
    Platform.environment['APPWRITE_PROJECT_ID'] ?? '6a145b8d001aa82f4dd5';
final String apiKey = Platform.environment['APPWRITE_API_KEY'] ??
    (throw StateError('APPWRITE_API_KEY is required'));
final String databaseId =
    Platform.environment['APPWRITE_DATABASE_ID'] ?? 'database-default';

void main() async {
  Client client =
      Client().setEndpoint(endpoint).setProject(projectId).setKey(apiKey);
  Databases databases = Databases(client);

  print('🛠️ Đang bổ sung trường verifiedStatus cho bảng users...');

  try {
    await databases.createStringAttribute(
      databaseId: databaseId,
      collectionId: 'users',
      key: 'verifiedStatus',
      size: 20,
      xrequired: false,
      xdefault: 'unverified',
    );
    print('✅ Thành công: users -> verifiedStatus');
  } catch (e) {
    print('ℹ️ Users verifiedStatus: $e');
  }

  print('\n🎯 Hoàn tất cập nhật!');
}

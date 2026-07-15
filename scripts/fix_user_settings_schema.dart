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
const String collectionId = 'user_settings';

void main() async {
  Client client =
      Client().setEndpoint(endpoint).setProject(projectId).setKey(apiKey);
  Databases databases = Databases(client);

  print('🛠️ Đang bổ sung trường updatedAt cho user_settings...');

  try {
    await databases.createStringAttribute(
      databaseId: databaseId,
      collectionId: collectionId,
      key: 'updatedAt',
      size: 50,
      xrequired: false,
    );
    print('✅ Thành công: updatedAt');

    await Future.delayed(Duration(seconds: 1));

    await databases.createStringAttribute(
      databaseId: databaseId,
      collectionId: collectionId,
      key: 'createdAt',
      size: 50,
      xrequired: false,
    );
    print('✅ Thành công: createdAt');
  } catch (e) {
    print('ℹ️ Lỗi/Đã tồn tại: $e');
  }

  print('\n🎯 Hoàn tất!');
}

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

  print('🛠️ Đang sửa lỗi thiết lập Chat (V2)...');

  // FIX chat_messages
  try {
    print('\n--- Cập nhật attributes cho: chat_messages ---');
    // Re-try type without default
    try {
      await databases.createStringAttribute(
          databaseId: databaseId,
          collectionId: 'chat_messages',
          key: 'type',
          size: 20,
          xrequired: true);
    } catch (_) {}

    await Future.delayed(Duration(seconds: 1));
    try {
      await databases.createStringAttribute(
          databaseId: databaseId,
          collectionId: 'chat_messages',
          key: 'imageUrl',
          size: 500,
          xrequired: false);
    } catch (_) {}

    await Future.delayed(Duration(seconds: 1));
    try {
      await databases.createBooleanAttribute(
          databaseId: databaseId,
          collectionId: 'chat_messages',
          key: 'isRead',
          xrequired: false,
          xdefault: false);
    } catch (_) {}

    print('✅ Hoàn tất kiểm tra chat_messages');
  } catch (e) {
    print('ℹ️ Lỗi: $e');
  }

  print('\n🎯 Hoàn tất!');
}

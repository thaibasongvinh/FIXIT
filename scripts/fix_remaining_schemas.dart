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

  print(
      '🛠️ Đang bổ sung các trường còn thiếu cho Wallets và Notifications...');

  // 1. Sửa Wallets
  try {
    print('\n--- Cập nhật wallets ---');
    await databases.createFloatAttribute(
        databaseId: databaseId,
        collectionId: 'wallets',
        key: 'totalEarned',
        xrequired: false,
        xdefault: 0.0);
    await Future.delayed(Duration(seconds: 1));
    await databases.createStringAttribute(
        databaseId: databaseId,
        collectionId: 'wallets',
        key: 'bankAccount',
        size: 1000,
        xrequired: false);
    print('✅ Thành công: wallets');
  } catch (e) {
    print('ℹ️ Wallets: $e');
  }

  // 2. Sửa Notifications
  try {
    print('\n--- Cập nhật notifications ---');
    await databases.createStringAttribute(
        databaseId: databaseId,
        collectionId: 'notifications',
        key: 'userId',
        size: 50,
        xrequired: false);
    await Future.delayed(Duration(seconds: 1));
    await databases.createBooleanAttribute(
        databaseId: databaseId,
        collectionId: 'notifications',
        key: 'isRead',
        xrequired: false,
        xdefault: false);
    await Future.delayed(Duration(seconds: 1));
    // Thêm trường body nếu message chưa đủ dùng
    await databases.createStringAttribute(
        databaseId: databaseId,
        collectionId: 'notifications',
        key: 'body',
        size: 1000,
        xrequired: false);
    print('✅ Thành công: notifications');
  } catch (e) {
    print('ℹ️ Notifications: $e');
  }

  print('\n🎯 Đã hoàn tất việc bổ sung cấu trúc!');
}

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

  print('🛠️ Đang thiết lập cấu trúc cho tính năng Cuộc gọi...');

  try {
    print('\n--- Tạo collection: calls ---');
    await databases.createCollection(
        databaseId: databaseId,
        collectionId: 'calls',
        name: 'Calls',
        permissions: [
          Permission.read(Role.users()),
          Permission.write(Role.users())
        ]);
    await Future.delayed(Duration(seconds: 2));

    await databases.createStringAttribute(
        databaseId: databaseId,
        collectionId: 'calls',
        key: 'callerId',
        size: 50,
        xrequired: true);
    await Future.delayed(Duration(seconds: 1));
    await databases.createStringAttribute(
        databaseId: databaseId,
        collectionId: 'calls',
        key: 'receiverId',
        size: 50,
        xrequired: true);
    await Future.delayed(Duration(seconds: 1));
    await databases.createStringAttribute(
        databaseId: databaseId,
        collectionId: 'calls',
        key: 'callerName',
        size: 100,
        xrequired: true);
    await Future.delayed(Duration(seconds: 1));
    await databases.createStringAttribute(
        databaseId: databaseId,
        collectionId: 'calls',
        key: 'receiverName',
        size: 100,
        xrequired: true);
    await Future.delayed(Duration(seconds: 1));
    await databases.createStringAttribute(
        databaseId: databaseId,
        collectionId: 'calls',
        key: 'callerAvatar',
        size: 500,
        xrequired: false);
    await Future.delayed(Duration(seconds: 1));
    await databases.createStringAttribute(
        databaseId: databaseId,
        collectionId: 'calls',
        key: 'receiverAvatar',
        size: 500,
        xrequired: false);
    await Future.delayed(Duration(seconds: 1));
    await databases.createStringAttribute(
        databaseId: databaseId,
        collectionId: 'calls',
        key: 'status',
        size: 20,
        xrequired: true);
    await Future.delayed(Duration(seconds: 1));
    await databases.createStringAttribute(
        databaseId: databaseId,
        collectionId: 'calls',
        key: 'createdAt',
        size: 50,
        xrequired: true);
    await Future.delayed(Duration(seconds: 1));
    await databases.createStringAttribute(
        databaseId: databaseId,
        collectionId: 'calls',
        key: 'startedAt',
        size: 50,
        xrequired: false);
    await Future.delayed(Duration(seconds: 1));
    await databases.createStringAttribute(
        databaseId: databaseId,
        collectionId: 'calls',
        key: 'endedAt',
        size: 50,
        xrequired: false);

    print('✅ Thành công: calls');
  } catch (e) {
    print('ℹ️ Lỗi hoặc đã tồn tại: $e');
  }

  print('\n🎯 Hoàn tất thiết lập Cuộc gọi!');
}

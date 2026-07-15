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
  Storage storage = Storage(client);

  print('🛠️ Đang thiết lập cấu trúc cho tính năng Chat...');

  // 1. CẬP NHẬT chat_rooms
  try {
    print('\n--- Cập nhật attributes cho: chat_rooms ---');
    await databases.createStringAttribute(
        databaseId: databaseId,
        collectionId: 'chat_rooms',
        key: 'participants',
        size: 50,
        xrequired: true,
        array: true);
    await Future.delayed(Duration(seconds: 1));
    await databases.createStringAttribute(
        databaseId: databaseId,
        collectionId: 'chat_rooms',
        key: 'lastMessage',
        size: 1000,
        xrequired: true);
    await Future.delayed(Duration(seconds: 1));
    await databases.createStringAttribute(
        databaseId: databaseId,
        collectionId: 'chat_rooms',
        key: 'lastMessageAt',
        size: 50,
        xrequired: true);
    await Future.delayed(Duration(seconds: 1));
    await databases.createStringAttribute(
        databaseId: databaseId,
        collectionId: 'chat_rooms',
        key: 'bookingId',
        size: 50,
        xrequired: true);
    await Future.delayed(Duration(seconds: 1));
    await databases.createStringAttribute(
        databaseId: databaseId,
        collectionId: 'chat_rooms',
        key: 'unreadCount',
        size: 1000,
        xrequired: false);
    print('✅ Thành công: chat_rooms');
  } catch (e) {
    print('ℹ️ Lỗi chat_rooms: $e');
  }

  // 2. CẬP NHẬT chat_messages
  try {
    print('\n--- Cập nhật attributes cho: chat_messages ---');
    await databases.createStringAttribute(
        databaseId: databaseId,
        collectionId: 'chat_messages',
        key: 'roomId',
        size: 50,
        xrequired: true);
    await Future.delayed(Duration(seconds: 1));
    await databases.createStringAttribute(
        databaseId: databaseId,
        collectionId: 'chat_messages',
        key: 'senderId',
        size: 50,
        xrequired: true);
    await Future.delayed(Duration(seconds: 1));
    await databases.createStringAttribute(
        databaseId: databaseId,
        collectionId: 'chat_messages',
        key: 'text',
        size: 2000,
        xrequired: false);
    await Future.delayed(Duration(seconds: 1));
    await databases.createStringAttribute(
        databaseId: databaseId,
        collectionId: 'chat_messages',
        key: 'type',
        size: 20,
        xrequired: true,
        xdefault: 'text');
    await Future.delayed(Duration(seconds: 1));
    await databases.createStringAttribute(
        databaseId: databaseId,
        collectionId: 'chat_messages',
        key: 'imageUrl',
        size: 500,
        xrequired: false);
    await Future.delayed(Duration(seconds: 1));
    await databases.createBooleanAttribute(
        databaseId: databaseId,
        collectionId: 'chat_messages',
        key: 'isRead',
        xrequired: false,
        xdefault: false);
    print('✅ Thành công: chat_messages');
  } catch (e) {
    print('ℹ️ Lỗi chat_messages: $e');
  }

  // 3. TẠO BUCKET CHO CHAT IMAGES
  try {
    print('\n--- Tạo bucket: chats ---');
    await storage.createBucket(
      bucketId: 'chats',
      name: 'Chat Images',
      permissions: [
        Permission.read(Role.any()),
        Permission.write(Role.users()),
      ],
      fileSecurity: true,
    );
    print('✅ Thành công: bucket chats');
  } catch (e) {
    print('ℹ️ Lỗi bucket: $e');
  }

  print('\n🎯 Hoàn tất thiết lập Chat!');
}

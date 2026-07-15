import 'dart:io';
import 'package:dart_appwrite/dart_appwrite.dart';

final String endpoint = Platform.environment['APPWRITE_ENDPOINT'] ?? 'https://sgp.cloud.appwrite.io/v1';
final String projectId = Platform.environment['APPWRITE_PROJECT_ID'] ?? '6a145b8d001aa82f4dd5';
final String apiKey = Platform.environment['APPWRITE_API_KEY'] ?? 'standard_6de4d38760a772bd4006cc26d99353ed12f03e1e9f1a743be083627ec864bb7cb9e58478865c1b8823f1f3793dcde25baaeba78244b8a8e8a5530da6412db68a1c00d329da03c6d19f57718c4714d6950d3218a33d2db9ba5001f12cd6f83352314888399d0cd72648989495cc06535781e57585cf7fc28b830f4e2a194f495b';
final String databaseId = 'database-default';

void main() async {
  Client client = Client().setEndpoint(endpoint).setProject(projectId).setKey(apiKey);
  Databases databases = Databases(client);

  print('🛠️ ĐANG CẬP NHẬT CẤU TRÚC BẢNG NOTIFICATIONS...');

  final attributes = [
    {'key': 'userId', 'type': 'string', 'size': 50},
    {'key': 'title', 'type': 'string', 'size': 255},
    {'key': 'body', 'type': 'string', 'size': 1000},
    {'key': 'type', 'type': 'string', 'size': 50},
    {'key': 'relatedId', 'type': 'string', 'size': 50},
    {'key': 'isRead', 'type': 'boolean'},
    {'key': 'createdAt', 'type': 'string', 'size': 50},
  ];

  for (var attr in attributes) {
    final String key = attr['key'] as String;
    try {
      if (attr['type'] == 'string') {
        await databases.createStringAttribute(
          databaseId: databaseId,
          collectionId: 'notifications',
          key: key,
          size: attr['size'] as int,
          xrequired: false,
        );
      } else if (attr['type'] == 'boolean') {
        await databases.createBooleanAttribute(
          databaseId: databaseId,
          collectionId: 'notifications',
          key: key,
          xrequired: false,
          xdefault: false,
        );
      }
      print('✅ Đã thêm: $key');
      await Future.delayed(const Duration(milliseconds: 500));
    } catch (e) {
      if (e.toString().contains('409')) {
        print('ℹ️ Bỏ qua: $key (đã tồn tại)');
      } else {
        print('❌ Lỗi $key: $e');
      }
    }
  }

  print('\n🎯 HOÀN TẤT CẬP NHẬT SCHEMA!');
}

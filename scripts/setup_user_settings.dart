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

  print('🛠️ Đang thiết lập bảng user_settings...');

  try {
    try {
      await databases.getCollection(
          databaseId: databaseId, collectionId: collectionId);
      print('📦 Bảng $collectionId đã có.');
    } catch (_) {
      print('✨ Tạo bảng mới: $collectionId');
      await databases.createCollection(
        databaseId: databaseId,
        collectionId: collectionId,
        name: 'User Settings',
        permissions: [
          Permission.read(Role.any()),
          Permission.write(Role.users()),
        ],
      );
      await Future.delayed(const Duration(seconds: 2));
    }

    final attrs = [
      {'key': 'userId', 'type': 'string', 'size': 50, 'required': true},
      {
        'key': 'themeMode',
        'type': 'string',
        'size': 20,
        'required': false,
        'default': 'light'
      },
      {
        'key': 'language',
        'type': 'string',
        'size': 10,
        'required': false,
        'default': 'vi'
      },
    ];

    for (var attr in attrs) {
      try {
        if (attr['type'] == 'string') {
          await databases.createStringAttribute(
            databaseId: databaseId,
            collectionId: collectionId,
            key: attr['key'] as String,
            size: attr['size'] as int,
            xrequired: attr['required'] as bool,
            xdefault: attr['default'] as String?,
          );
          print('   ✅ Đã thêm cột: ${attr['key']}');
          await Future.delayed(Duration(milliseconds: 500));
        }
      } catch (e) {
        print('   ℹ️ Cột ${attr['key']}: $e');
      }
    }
  } catch (e) {
    print('❌ Lỗi thiết lập user_settings: $e');
  }

  print('\n🎯 Hoàn tất cập nhật!');
}

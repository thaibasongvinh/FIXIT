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

  print('🛡️ Đang cập nhật lại quyền hạn (Sửa lỗi 401 Create)...');

  // Thêm quyền 'create' cho Role.users() (những người đã auth)
  final permissions = [
    Permission.read(Role.users()),
    Permission.create(Role.users()), // QUAN TRỌNG: Cho phép tạo document mới
    Permission.update(Role.users()),
    Permission.delete(Role.users()),
  ];

  final collections = [
    'users',
    'wallets',
    'transactions',
    'technician_applications',
    'notifications',
    'chat_rooms',
    'chat_messages',
    'calls',
    'address_book'
  ];

  for (var colId in collections) {
    try {
      print('🔒 Cập nhật: $colId...');
      await databases.updateCollection(
        databaseId: databaseId,
        collectionId: colId,
        name: colId,
        permissions: permissions,
        documentSecurity: true,
      );
      print('    ✅ Thành công');
    } catch (e) {
      print('    ❌ Lỗi: $e');
    }
  }

  print('\n🎯 Đã sửa xong lỗi phân quyền! Vui lòng thử đăng ký lại.');
}

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
      '🚀 Đang cập nhật quyền hạn cho toàn bộ các bảng để Admin có thể đọc dữ liệu...');

  final collections = [
    'users',
    'bookings',
    'technician_applications',
    'technicians',
    'services',
    'popular_services',
    'products',
    'reviews',
    'wallets',
    'transactions'
  ];

  for (var colId in collections) {
    try {
      print('🛠️ Cập nhật bảng: $colId...');
      await databases.updateCollection(
        databaseId: databaseId,
        collectionId: colId,
        name: colId, // Giữ nguyên tên
        permissions: [
          'read("any")',
          'write("any")',
          'create("any")',
          'update("any")',
          'delete("any")',
          'read("users")',
          'write("users")',
          'create("users")',
          'update("users")',
          'delete("users")',
        ],
      );
      print('✅ Thành công: $colId');
    } catch (e) {
      print('❌ Lỗi tại bảng $colId: $e');
    }
  }

  print('\n🎯 Hoàn tất! Bây giờ Admin Dashboard sẽ có thể lấy được dữ liệu.');
}

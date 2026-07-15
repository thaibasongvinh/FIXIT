import 'dart:io';
import 'package:dart_appwrite/dart_appwrite.dart';

final String endpoint = Platform.environment['APPWRITE_ENDPOINT'] ?? 'https://sgp.cloud.appwrite.io/v1';
final String projectId = Platform.environment['APPWRITE_PROJECT_ID'] ?? '6a145b8d001aa82f4dd5';
final String apiKey = Platform.environment['APPWRITE_API_KEY'] ?? '';
final String databaseId = Platform.environment['APPWRITE_DATABASE_ID'] ?? 'database-default';

void main() async {
  if (apiKey.isEmpty) {
    print('❌ APPWRITE_API_KEY is required');
    return;
  }
  
  Client client = Client().setEndpoint(endpoint).setProject(projectId).setKey(apiKey);
  Databases databases = Databases(client);

  final collections = [
    'app_config', 'banners', 'bookings', 'chat_messages', 'chat_rooms',
    'favorites', 'guide_bookmarks', 'guide_ratings', 'guide_steps', 'guides',
    'payment_methods', 'popular_services', 'products', 'reviews', 'service_issues',
    'services', 'technician_applications', 'technicians', 'transactions', 'users', 'wallets'
  ];

  print('🔓 Đang mở khóa toàn bộ các bảng trong Database...');

  for (var colId in collections) {
    try {
      await databases.updateCollection(
        databaseId: databaseId,
        collectionId: colId,
        name: colId,
        permissions: [
          'read("any")', 'write("any")', 'create("any")', 'update("any")', 'delete("any")',
          'read("users")', 'write("users")', 'create("users")', 'update("users")', 'delete("users")',
        ],
      );
      print('✅ Mở khóa thành công: $colId');
    } catch (e) {
      print('❌ Lỗi tại bảng $colId: $e');
    }
  }
  print('\n🎯 Xong! Toàn bộ hệ thống đã được mở quyền đầy đủ.');
}

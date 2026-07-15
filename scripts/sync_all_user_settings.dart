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

  print('🚀 Đang đồng bộ cài đặt cho toàn bộ người dùng...');

  try {
    final users = await databases.listDocuments(
        databaseId: databaseId, collectionId: 'users');
    print('📊 Tìm thấy ${users.total} người dùng.');

    for (var user in users.documents) {
      final userId = user.$id;
      print('🛠️ Đang khởi tạo settings cho: $userId');

      final data = {
        'userId': userId,
        'themeMode': 'light',
        'language': 'vi',
        'updatedAt': DateTime.now().toIso8601String(),
        'createdAt': DateTime.now().toIso8601String(),
      };

      try {
        await databases.createDocument(
          databaseId: databaseId,
          collectionId: 'user_settings',
          documentId: userId,
          data: data,
        );
        print('   ✅ Khởi tạo thành công.');
      } catch (e) {
        if (e.toString().contains('409')) {
          print('   ℹ️ Settings đã tồn tại.');
        } else {
          print('   ❌ Lỗi: $e');
        }
      }
    }
  } catch (e) {
    print('❌ Lỗi tổng quát: $e');
  }

  print('\n🎯 Hoàn tất đồng bộ!');
}

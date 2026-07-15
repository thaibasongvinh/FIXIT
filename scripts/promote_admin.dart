import 'dart:io';
import 'package:dart_appwrite/dart_appwrite.dart';

// Thông tin lấy từ file setup của bạn
final String endpoint = Platform.environment['APPWRITE_ENDPOINT'] ??
    'https://sgp.cloud.appwrite.io/v1';
final String projectId =
    Platform.environment['APPWRITE_PROJECT_ID'] ?? '6a145b8d001aa82f4dd5';
final String apiKey = Platform.environment['APPWRITE_API_KEY'] ??
    (throw StateError('APPWRITE_API_KEY is required'));
final String databaseId =
    Platform.environment['APPWRITE_DATABASE_ID'] ?? 'database-default';

void main(List<String> args) async {
  Client client =
      Client().setEndpoint(endpoint).setProject(projectId).setKey(apiKey);
  Databases databases = Databases(client);
  Users users = Users(client);

  print('🚀 Đang kiểm tra hệ thống...');

  try {
    // 1. Kiểm tra Database
    final db = await databases.get(databaseId: databaseId);
    print('✅ Database: ${db.name} (ID: $databaseId) - ĐANG HOẠT ĐỘNG');
  } catch (e) {
    print('❌ LỖI DATABASE: $e');
    print(
        '👉 Gợi ý: Hãy vào Appwrite Console -> Databases. Copy ID chính xác và dán vào AppwriteConstants.databaseId');
    return;
  }

  // 2. Lấy danh sách users từ Database (Bảng users)
  try {
    final result = await databases.listDocuments(
        databaseId: databaseId, collectionId: 'users');

    if (result.documents.isEmpty) {
      print('⚠️ Không tìm thấy người dùng nào trong bảng "users".');
      return;
    }

    print('\n--- DANH SÁCH NGƯỜI DÙNG ---');
    for (var doc in result.documents) {
      print(
          'ID: ${doc.$id} | Name: ${doc.data['name']} | Role: ${doc.data['role']}');
    }

    // Nếu bạn truyền ID vào khi chạy script: dart promote_admin.dart YOUR_USER_ID
    if (args.isNotEmpty) {
      String targetId = args[0];
      await databases.updateDocument(
          databaseId: databaseId,
          collectionId: 'users',
          documentId: targetId,
          data: {'role': 'admin'});
      print('\n🎉 THÀNH CÔNG! Đã nâng cấp User $targetId lên làm ADMIN.');
    } else {
      print(
          '\n👉 Để nâng cấp Admin, hãy chạy lệnh: dart scripts/promote_admin.dart [USER_ID]');
    }
  } catch (e) {
    print('❌ Lỗi truy cập bảng users: $e');
  }
}

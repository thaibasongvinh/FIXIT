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

  print('🚀 Đang làm mới toàn bộ hồ sơ thợ để Admin thấy được...');

  try {
    final result = await databases.listDocuments(
      databaseId: databaseId,
      collectionId: 'technician_applications',
    );

    print('📊 Tìm thấy ${result.total} hồ sơ.');

    for (var doc in result.documents) {
      print('🛠️ Đang cập nhật hồ sơ: ${doc.$id}');
      await databases.updateDocument(
        databaseId: databaseId,
        collectionId: 'technician_applications',
        documentId: doc.$id,
        data: {
          'status': 'pending', // Ép buộc về pending
          'updatedAt': DateTime.now().toIso8601String(),
        },
      );
    }
    print('\n🎯 Hoàn tất làm mới! Admin hãy tải lại trang (Pull to refresh).');
  } catch (e) {
    print('❌ Lỗi: $e');
  }
}

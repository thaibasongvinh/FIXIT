import 'dart:io';
import 'package:dart_appwrite/dart_appwrite.dart';

void main() async {
  final String endpoint = 'https://sgp.cloud.appwrite.io/v1';
  final String projectId = '6a145b8d001aa82f4dd5';
  final String apiKey = Platform.environment['APPWRITE_API_KEY'] ?? 'standard_6de4d38760a772bd4006cc26d99353ed12f03e1e9f1a743be083627ec864bb7cb9e58478865c1b8823f1f3793dcde25baaeba78244b8a8e8a5530da6412db68a1c00d329da03c6d19f57718c4714d6950d3218a33d2db9ba5001f12cd6f83352314888399d0cd72648989495cc06535781e57585cf7fc28b830f4e2a194f495b';
  final String databaseId = 'database-default';
  final String bucketId = 'fixit_assets';
  
  Client client = Client().setEndpoint(endpoint).setProject(projectId).setKey(apiKey);
  Databases databases = Databases(client);
  Storage storage = Storage(client);

  print('🔍 KIỂM TRA ĐỒNG BỘ GIỮA DATABASE VÀ STORAGE...');

  // 1. Lấy danh sách file trong Storage
  print('\n📂 [STORAGE] Danh sách File hiện có:');
  final storageFiles = <String>{};
  try {
    var response = await storage.listFiles(bucketId: bucketId);
    for (var f in response.files) {
      storageFiles.add(f.name);
      print('  - ${f.name} (ID: ${f.$id})');
    }
  } catch (e) { print('  ❌ Lỗi lấy Storage: $e'); }

  // 2. Lấy danh sách imagePath trong Database
  final collections = ['popular_services', 'services'];
  for (var collId in collections) {
    print('\n📊 [DATABASE] Bảng $collId:');
    try {
      var docs = await databases.listDocuments(databaseId: databaseId, collectionId: collId, queries: [Query.limit(100)]);
      for (var doc in docs.documents) {
        String path = doc.data['imagePath'] ?? 'TRỐNG';
        bool match = storageFiles.contains(path);
        String status = match ? '✅ KHỚP' : '❌ LỆCH (Không thấy file này trên Storage)';
        print('  - Doc [${doc.$id}]: $path -> $status');
      }
    } catch (e) { print('  ❌ Lỗi lấy DB: $e'); }
  }

  print('\n✨ Kiểm tra hoàn tất!');
}

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

  print('🚀 BẮT ĐẦU ĐỒNG BỘ ẢNH TOÀN DIỆN...');

  // Hàm chuyển đổi sang "Tên Hoa.png"
  String toBeautyName(String input) {
    if (input.isEmpty) return '';
    String clean = input.replaceAll('.png', '').replaceAll('_', ' ').replaceAll('-', ' ');
    return clean.split(' ').map((word) => word.isNotEmpty ? word[0].toUpperCase() + word.substring(1) : '').join(' ') + '.png';
  }

  // 1. Cập nhật Storage Filenames
  print('\n--- Cập nhật Storage (Filename) ---');
  try {
    var response = await storage.listFiles(bucketId: bucketId, queries: [Query.limit(200)]);
    for (var f in response.files) {
      String newName = toBeautyName(f.name);
      if (f.name != newName) {
        print('  Storage: ${f.name} -> $newName');
        await storage.updateFile(bucketId: bucketId, fileId: f.$id, name: newName);
      }
    }
  } catch (e) { print('  Lỗi Storage: $e'); }

  // 2. Cập nhật Database (imagePath)
  print('\n--- Cập nhật Database (imagePath) ---');
  final collections = ['popular_services', 'services'];
  for (var collId in collections) {
    try {
      var docs = await databases.listDocuments(databaseId: databaseId, collectionId: collId, queries: [Query.limit(100)]);
      for (var doc in docs.documents) {
        String currentPath = doc.data['imagePath'] ?? '';
        if (currentPath.isEmpty) continue;
        
        String newPath = toBeautyName(currentPath);
        if (currentPath != newPath) {
          print('  DB [$collId]: $currentPath -> $newPath');
          await databases.updateDocument(databaseId: databaseId, collectionId: collId, documentId: doc.$id, data: {'imagePath': newPath});
        }
      }
    } catch (e) { print('  Lỗi DB $collId: $e'); }
  }

  print('\n✨ HOÀN TẤT ĐỒNG BỘ!');
}

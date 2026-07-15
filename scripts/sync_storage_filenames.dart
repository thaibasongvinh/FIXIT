import 'dart:io';
import 'package:dart_appwrite/dart_appwrite.dart';

void main() async {
  final String endpoint = 'https://sgp.cloud.appwrite.io/v1';
  final String projectId = '6a145b8d001aa82f4dd5';
  final String apiKey = Platform.environment['APPWRITE_API_KEY'] ?? 'standard_6de4d38760a772bd4006cc26d99353ed12f03e1e9f1a743be083627ec864bb7cb9e58478865c1b8823f1f3793dcde25baaeba78244b8a8e8a5530da6412db68a1c00d329da03c6d19f57718c4714d6950d3218a33d2db9ba5001f12cd6f83352314888399d0cd72648989495cc06535781e57585cf7fc28b830f4e2a194f495b';
  final String bucketId = 'fixit_assets';
  
  Client client = Client().setEndpoint(endpoint).setProject(projectId).setKey(apiKey);
  Storage storage = Storage(client);
  Databases databases = Databases(client);

  print('🚀 Đang đồng bộ File ID và Name trên Storage...');

  try {
    var response = await storage.listFiles(bucketId: bucketId);
    for (var file in response.files) {
      // 1. Tạo Tên mới (Viết hoa + .png)
      // Ví dụ: plumber_png -> Plumber.png
      String baseName = file.name.replaceAll('.png', '').replaceAll('_', ' ');
      String newName = baseName.split(' ').map((word) => word.isNotEmpty ? word[0].toUpperCase() + word.substring(1) : '').join(' ') + '.png';
      
      // 2. Tạo ID mới (Không có khoảng trắng)
      // Ví dụ: Plumber.png
      String newId = newName.replaceAll(' ', '_');

      if (file.name != newName) {
        print('  Updating Name for ${file.$id}: ${file.name} -> $newName');
        await storage.updateFile(bucketId: bucketId, fileId: file.$id, name: newName, permissions: ['read("any")']);
      }

      // Appwrite không cho đổi ID trực tiếp, nên ta sẽ dựa vào ID mới này để cập nhật DB
      print('  Ready ID for DB: $newId (Name: $newName)');
    }

    // 3. Cập nhật lại Database để khớp với ID mới (Dùng dấu gạch dưới thay cho khoảng trắng)
    final dbCollections = ['popular_services', 'services'];
    for (var collId in dbCollections) {
      var docs = await databases.listDocuments(databaseId: 'database-default', collectionId: collId, queries: [Query.limit(100)]);
      for (var doc in docs.documents) {
        String path = doc.data['imagePath'] ?? '';
        if (path.isEmpty) continue;
        
        // Đổi khoảng trắng thành gạch dưới để khớp với quy tắc ID của Storage
        String correctPath = path.replaceAll(' ', '_');
        if (!correctPath.contains('.png')) correctPath += '.png';
        
        if (path != correctPath) {
          print('  Fixing DB $collId [${doc.$id}]: $path -> $correctPath');
          await databases.updateDocument(databaseId: 'database-default', collectionId: collId, documentId: doc.$id, data: {'imagePath': correctPath});
        }
      }
    }

  } catch (e) {
    print('Error: $e');
  }
  print('✨ Hoàn tất!');
}

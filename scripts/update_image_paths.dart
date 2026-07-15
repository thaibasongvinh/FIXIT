import 'dart:io';
import 'package:dart_appwrite/dart_appwrite.dart';

void main() async {
  final String endpoint = 'https://sgp.cloud.appwrite.io/v1';
  final String projectId = '6a145b8d001aa82f4dd5';
  final String apiKey = Platform.environment['APPWRITE_API_KEY'] ?? 'standard_6de4d38760a772bd4006cc26d99353ed12f03e1e9f1a743be083627ec864bb7cb9e58478865c1b8823f1f3793dcde25baaeba78244b8a8e8a5530da6412db68a1c00d329da03c6d19f57718c4714d6950d3218a33d2db9ba5001f12cd6f83352314888399d0cd72648989495cc06535781e57585cf7fc28b830f4e2a194f495b';
  final String databaseId = 'database-default';
  
  Client client = Client().setEndpoint(endpoint).setProject(projectId).setKey(apiKey);
  Databases databases = Databases(client);

  final collections = ['popular_services', 'services'];

  for (var collId in collections) {
    print('Processing collection: $collId...');
    try {
      final response = await databases.listDocuments(
        databaseId: databaseId,
        collectionId: collId,
        queries: [Query.limit(100)], // Tăng giới hạn lên 100 để không bỏ sót
      );

      for (var doc in response.documents) {
        String currentPath = doc.data['imagePath'] ?? '';
        if (currentPath.isEmpty || currentPath.contains('.')) {
          print('  Skipping ${doc.$id}: already updated or empty ($currentPath)');
          continue;
        }

        // Transformation Logic:
        // 1. Capitalize first letter
        // 2. Replace _ with space
        // 3. Append .png
        String newPath = currentPath[0].toUpperCase() + currentPath.substring(1);
        newPath = newPath.replaceAll('_', ' ') + '.png';

        print('  Updating ${doc.$id}: $currentPath -> $newPath');
        await databases.updateDocument(
          databaseId: databaseId,
          collectionId: collId,
          documentId: doc.$id,
          data: {'imagePath': newPath},
        );
      }
    } catch (e) {
      print('  Error processing $collId: $e');
    }
  }
  print('Done!');
}

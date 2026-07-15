import 'dart:io';
import 'package:dart_appwrite/dart_appwrite.dart';

void main() async {
  final String endpoint = 'https://sgp.cloud.appwrite.io/v1';
  final String projectId = '6a145b8d001aa82f4dd5';
  final String apiKey = 'standard_6de4d38760a772bd4006cc26d99353ed12f03e1e9f1a743be083627ec864bb7cb9e58478865c1b8823f1f3793dcde25baaeba78244b8a8e8a5530da6412db68a1c00d329da03c6d19f57718c4714d6950d3218a33d2db9ba5001f12cd6f83352314888399d0cd72648989495cc06535781e57585cf7fc28b830f4e2a194f495b';
  
  Client client = Client().setEndpoint(endpoint).setProject(projectId).setKey(apiKey);
  Databases databases = Databases(client);

  try {
    print('--- NORMALIZING TITLES AND IMAGEPATHS ---');

    for (var collection in ['popular_services', 'services']) {
      var result = await databases.listDocuments(
        databaseId: 'database-default',
        collectionId: collection,
        queries: [Query.limit(100)],
      );

      for (var doc in result.documents) {
        String currentTitle = (doc.data['title'] ?? doc.data['name'] ?? '').toString();
        
        if (currentTitle.endsWith('.png')) {
          String cleanTitle = currentTitle.substring(0, currentTitle.length - 4);
          String targetPath = '$cleanTitle.png';

          print('Updating ${doc.$id}: "$currentTitle" -> Title: "$cleanTitle", imagePath: "$targetPath"');
          
          Map<String, dynamic> updateData = {'imagePath': targetPath};
          if (doc.data.containsKey('title')) updateData['title'] = cleanTitle;
          if (doc.data.containsKey('name')) updateData['name'] = cleanTitle;

          await databases.updateDocument(
            databaseId: 'database-default',
            collectionId: collection,
            documentId: doc.$id,
            data: updateData,
          );
        }
      }
    }
    print('Done.');
  } catch (e) {
    print('Error: $e');
  }
}

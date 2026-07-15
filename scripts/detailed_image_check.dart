import 'dart:io';
import 'package:dart_appwrite/dart_appwrite.dart';

void main() async {
  final String endpoint = 'https://sgp.cloud.appwrite.io/v1';
  final String projectId = '6a145b8d001aa82f4dd5';
  final String apiKey = 'standard_6de4d38760a772bd4006cc26d99353ed12f03e1e9f1a743be083627ec864bb7cb9e58478865c1b8823f1f3793dcde25baaeba78244b8a8e8a5530da6412db68a1c00d329da03c6d19f57718c4714d6950d3218a33d2db9ba5001f12cd6f83352314888399d0cd72648989495cc06535781e57585cf7fc28b830f4e2a194f495b';
  
  Client client = Client().setEndpoint(endpoint).setProject(projectId).setKey(apiKey);
  Databases databases = Databases(client);
  Storage storage = Storage(client);

  try {
    var result = await databases.listDocuments(
      databaseId: 'database-default',
      collectionId: 'services',
      queries: [Query.limit(100)],
    );

    var filesResult = await storage.listFiles(bucketId: 'fixit_assets', queries: [Query.limit(200)]);
    Set<String> storageFilenames = filesResult.files.map((f) => f.name).toSet();

    Map<String, List<String>> fileUsage = {};
    int matchCount = 0;

    for (var doc in result.documents) {
      String title = (doc.data['name'] ?? doc.data['title'] ?? 'N/A').toString();
      String imagePath = (doc.data['imagePath'] ?? '').toString();

      if (storageFilenames.contains(imagePath)) {
        matchCount++;
        fileUsage.putIfAbsent(imagePath, () => []).add(title);
      }
    }

    print('--- DETAILED IMAGE SYNC REPORT ---');
    print('Total Services: ${result.total}');
    print('Services with matching images: $matchCount');
    print('Unique images used: ${fileUsage.keys.length}');
    
    print('\nBreakdown of files used by Services:');
    fileUsage.forEach((file, services) {
      print('- $file (Used by: ${services.join(", ")})');
    });

    var missing = result.documents.where((doc) => !storageFilenames.contains(doc.data['imagePath'])).toList();
    if (missing.isNotEmpty) {
      print('\nServices missing images in storage:');
      for (var m in missing) {
        print('- ${m.data['name'] ?? m.data['title']} (imagePath: ${m.data['imagePath']})');
      }
    }

  } catch (e) {
    print('Error: $e');
  }
}

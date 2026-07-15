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
    // 1. Get imagePaths from popular_services
    var result = await databases.listDocuments(
      databaseId: 'database-default',
      collectionId: 'popular_services',
    );
    List<String> dbImagePaths = result.documents
        .map((doc) => doc.data['imagePath']?.toString() ?? '')
        .where((path) => path.isNotEmpty)
        .toList();

    // 2. Get filenames from Storage
    var files = await storage.listFiles(bucketId: 'fixit_assets', queries: [Query.limit(200)]);
    Set<String> storageFilenames = files.files.map((f) => f.name).toSet();

    print('--- COMPARISON RESULT ---');
    print('Checking ${dbImagePaths.length} imagePaths from DB against ${storageFilenames.length} files in Storage...\n');

    for (var path in dbImagePaths) {
      bool exists = storageFilenames.contains(path);
      if (exists) {
        print('[MATCH] "$path" exists in Storage.');
      } else {
        // Try to find close matches (case-insensitive or singular/plural)
        var closeMatches = storageFilenames.where((name) => 
          name.toLowerCase().contains(path.toLowerCase().split('.').first) ||
          path.toLowerCase().contains(name.toLowerCase().split('.').first)
        ).toList();
        
        print('[MISS]  "$path" NOT FOUND.');
        if (closeMatches.isNotEmpty) {
          print('        Suggested matches in Storage: ${closeMatches.join(', ')}');
        }
      }
    }
  } catch (e) {
    print('Error: $e');
  }
}

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
    // 1. Get popular services
    var result = await databases.listDocuments(
      databaseId: 'database-default',
      collectionId: 'popular_services',
    );

    // 2. Get all files in storage to have a mapping
    var filesResult = await storage.listFiles(bucketId: 'fixit_assets', queries: [Query.limit(200)]);
    var files = filesResult.files;

    print('--- RENAME PROCESS ---');

    for (var doc in result.documents) {
      String title = doc.data['title'] ?? '';
      String currentImagePath = doc.data['imagePath'] ?? '';
      String targetFilename = '$title.png';

      if (title.isEmpty) continue;

      print('\nProcessing: "$title"');

      // Find the file that this document is currently using or supposed to use
      // We look by name or by ID (sometimes ID is related)
      var file = files.where((f) => f.name == currentImagePath).firstOrNull ??
                 files.where((f) => f.$id == doc.$id.replaceAll('pop_', '') + '_png').firstOrNull ??
                 files.where((f) => f.name.toLowerCase().contains(title.toLowerCase().split(' ').first)).firstOrNull;

      if (file != null) {
        if (file.name != targetFilename) {
          print('  -> Renaming file in Storage: "${file.name}" to "$targetFilename"');
          try {
            await storage.updateFile(
              bucketId: 'fixit_assets',
              fileId: file.$id,
              name: targetFilename,
            );
            print('     [SUCCESS] File renamed.');
          } catch (e) {
            print('     [ERROR] Failed to rename file: $e');
          }
        } else {
          print('  -> File name already matches target: "$targetFilename"');
        }

        // Update DB imagePath if it doesn't match
        if (currentImagePath != targetFilename) {
          print('  -> Updating imagePath in DB: "$currentImagePath" to "$targetFilename"');
          try {
            await databases.updateDocument(
              databaseId: 'database-default',
              collectionId: 'popular_services',
              documentId: doc.$id,
              data: {'imagePath': targetFilename},
            );
            print('     [SUCCESS] DB updated.');
          } catch (e) {
            print('     [ERROR] Failed to update DB: $e');
          }
        }
      } else {
        print('  -> [WARNING] No matching file found in Storage for title "$title"');
      }
    }
    
    print('\n--- PROCESS COMPLETE ---');
  } catch (e) {
    print('Error: $e');
  }
}

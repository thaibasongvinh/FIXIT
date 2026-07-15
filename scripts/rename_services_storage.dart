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
    // 1. Get services
    var result = await databases.listDocuments(
      databaseId: 'database-default',
      collectionId: 'services',
      queries: [Query.limit(100)],
    );

    // 2. Get all files in storage
    var filesResult = await storage.listFiles(bucketId: 'fixit_assets', queries: [Query.limit(200)]);
    var files = filesResult.files;

    print('--- SERVICES RENAME PROCESS ---');

    for (var doc in result.documents) {
      String title = (doc.data['name'] ?? doc.data['title'] ?? '').toString();
      String currentImagePath = (doc.data['imagePath'] ?? '').toString();
      
      if (title.isEmpty) continue;
      
      // Clean title for filename (replace / with _ etc if any)
      String targetFilename = '${title.replaceAll("/", "_")}.png';

      print('\nService: "$title"');

      // Find the file
      var file = files.where((f) => f.name == currentImagePath).firstOrNull ??
                 files.where((f) => f.$id == doc.$id.replaceAll('svc_', '') + '_png').firstOrNull ??
                 files.where((f) => f.name.toLowerCase() == targetFilename.toLowerCase()).firstOrNull;

      if (file != null) {
        // If the target filename already exists as ANOTHER file, we might have a conflict
        var existingTargetFile = files.where((f) => f.name == targetFilename && f.$id != file.$id).firstOrNull;
        
        if (existingTargetFile != null) {
          print('  -> [INFO] Target filename "$targetFilename" already exists (File ID: ${existingTargetFile.$id}).');
          print('  -> Updating DB only to point to "$targetFilename"');
          if (currentImagePath != targetFilename) {
            await databases.updateDocument(
              databaseId: 'database-default',
              collectionId: 'services',
              documentId: doc.$id,
              data: {'imagePath': targetFilename},
            );
            print('     [SUCCESS] DB updated.');
          } else {
            print('     Already matches.');
          }
        } else {
          // Rename the file
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

          // Update DB
          if (currentImagePath != targetFilename) {
            print('  -> Updating imagePath in DB: "$currentImagePath" to "$targetFilename"');
            try {
              await databases.updateDocument(
                databaseId: 'database-default',
                collectionId: 'services',
                documentId: doc.$id,
                data: {'imagePath': targetFilename},
              );
              print('     [SUCCESS] DB updated.');
            } catch (e) {
              print('     [ERROR] Failed to update DB: $e');
            }
          }
        }
      } else {
        print('  -> [WARNING] No matching file found in Storage for "$title" (current: "$currentImagePath")');
      }
    }
    
    print('\n--- PROCESS COMPLETE ---');
  } catch (e) {
    print('Error: $e');
  }
}

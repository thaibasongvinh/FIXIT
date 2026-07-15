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

    // 2. Get all files in storage
    var filesResult = await storage.listFiles(bucketId: 'fixit_assets', queries: [Query.limit(200)]);
    var files = filesResult.files;

    print('--- FIXING POPULAR SERVICES SYNC (DB & STORAGE) ---');

    for (var doc in result.documents) {
      String title = (doc.data['title'] ?? '').toString();
      String currentImagePath = (doc.data['imagePath'] ?? '').toString();
      
      if (title.isEmpty) continue;
      String targetFilename = '$title.png';

      if (currentImagePath != targetFilename) {
        print('\nProcessing: "$title"');
        print('  Current imagePath: "$currentImagePath"');
        print('  Target filename:   "$targetFilename"');

        // Find the file in Storage
        var file = files.where((f) => f.name == currentImagePath).firstOrNull;

        if (file != null) {
          // Check if target filename already exists (to avoid conflicts)
          var conflict = files.where((f) => f.name == targetFilename && f.$id != file!.$id).firstOrNull;
          
          if (conflict != null) {
            print('  -> [INFO] File "$targetFilename" already exists in Storage (ID: ${conflict.$id}).');
            print('  -> Updating DB to point to existing file.');
            await databases.updateDocument(
              databaseId: 'database-default',
              collectionId: 'popular_services',
              documentId: doc.$id,
              data: {'imagePath': targetFilename},
            );
            print('     [SUCCESS] DB updated.');
          } else {
            // Rename the file
            print('  -> Renaming Storage file: "${file.name}" to "$targetFilename"');
            try {
              await storage.updateFile(
                bucketId: 'fixit_assets',
                fileId: file.$id,
                name: targetFilename,
              );
              print('     [SUCCESS] File renamed.');
              
              // Update DB
              print('  -> Updating DB imagePath to "$targetFilename"');
              await databases.updateDocument(
                databaseId: 'database-default',
                collectionId: 'popular_services',
                documentId: doc.$id,
                data: {'imagePath': targetFilename},
              );
              print('     [SUCCESS] DB updated.');
            } catch (e) {
              print('     [ERROR] Failed to process rename/update: $e');
            }
          }
        } else {
          print('  -> [WARNING] File "$currentImagePath" not found in Storage. Checking if "$targetFilename" exists...');
          var existingTarget = files.where((f) => f.name == targetFilename).firstOrNull;
          if (existingTarget != null) {
            print('     Found "$targetFilename"! Updating DB only.');
            await databases.updateDocument(
              databaseId: 'database-default',
              collectionId: 'popular_services',
              documentId: doc.$id,
              data: {'imagePath': targetFilename},
            );
            print('     [SUCCESS] DB updated.');
          } else {
            print('     [ERROR] No suitable file found for "$title".');
          }
        }
      }
    }
    print('\n--- PROCESS COMPLETE ---');
  } catch (e) {
    print('Error: $e');
  }
}

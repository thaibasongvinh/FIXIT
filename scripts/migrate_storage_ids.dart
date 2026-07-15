import 'dart:io';
import 'dart:typed_data';
import 'package:dart_appwrite/dart_appwrite.dart';

void main() async {
  final String endpoint = 'https://sgp.cloud.appwrite.io/v1';
  final String projectId = '6a145b8d001aa82f4dd5';
  final String apiKey = 'standard_6de4d38760a772bd4006cc26d99353ed12f03e1e9f1a743be083627ec864bb7cb9e58478865c1b8823f1f3793dcde25baaeba78244b8a8e8a5530da6412db68a1c00d329da03c6d19f57718c4714d6950d3218a33d2db9ba5001f12cd6f83352314888399d0cd72648989495cc06535781e57585cf7fc28b830f4e2a194f495b';
  
  Client client = Client().setEndpoint(endpoint).setProject(projectId).setKey(apiKey);
  Storage storage = Storage(client);
  Databases databases = Databases(client);

  try {
    print('--- MIGRATING STORAGE IDs TO MATCH FILENAMES ---');
    
    // 1. Get all files
    var filesResult = await storage.listFiles(bucketId: 'fixit_assets', queries: [Query.limit(200)]);
    var files = filesResult.files;

    for (var file in files) {
      String currentId = file.$id;
      String filename = file.name;
      
      // Target ID is filename but without invalid characters (like spaces)
      // Appwrite IDs allow: a-z, A-Z, 0-9, ., -, _
      String targetId = filename.replaceAll(' ', '_').replaceAll('&', '__');

      if (currentId == targetId) {
        print('Skipping "${filename}" - ID already matches.');
        continue;
      }

      print('\nProcessing file: "$filename"');
      print('  Current ID: $currentId');
      print('  Target ID:  $targetId');

      try {
        // A. Download
        Uint8List bytes = await storage.getFileDownload(bucketId: 'fixit_assets', fileId: currentId);
        
        // B. Delete old (optional: we could upload first then delete, but Appwrite might conflict if names are same)
        // Check if targetId already exists
        var existing = files.where((f) => f.$id == targetId).firstOrNull;
        if (existing != null) {
          print('  [INFO] Target ID $targetId already exists. Skipping re-upload.');
        } else {
          // C. Upload with new ID
          await storage.createFile(
            bucketId: 'fixit_assets',
            fileId: targetId,
            file: InputFile.fromBytes(bytes: bytes, filename: filename),
            permissions: ['read("any")'],
          );
          print('  [SUCCESS] Uploaded with new ID.');

          // D. Delete old
          await storage.deleteFile(bucketId: 'fixit_assets', fileId: currentId);
          print('  [SUCCESS] Deleted old file ID.');
        }

        // E. Update Database across all collections
        for (var collection in ['popular_services', 'services']) {
          var docs = await databases.listDocuments(
            databaseId: 'database-default',
            collectionId: collection,
            queries: [Query.equal('imagePath', filename)],
          );

          for (var doc in docs.documents) {
            print('  Updating DB Doc ${doc.$id} in $collection...');
            await databases.updateDocument(
              databaseId: 'database-default',
              collectionId: collection,
              documentId: doc.$id,
              data: {'imagePath': targetId}, // Now imagePath matches the ID exactly
            );
          }
        }
      } catch (e) {
        print('  [ERROR] Failed to migrate file $filename: $e');
      }
    }
    
    print('\n--- MIGRATION COMPLETE ---');
  } catch (e) {
    print('Error: $e');
  }
}

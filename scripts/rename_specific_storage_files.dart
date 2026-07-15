import 'dart:io';
import 'package:dart_appwrite/dart_appwrite.dart';

void main() async {
  final String endpoint = 'https://sgp.cloud.appwrite.io/v1';
  final String projectId = '6a145b8d001aa82f4dd5';
  final String apiKey = 'standard_6de4d38760a772bd4006cc26d99353ed12f03e1e9f1a743be083627ec864bb7cb9e58478865c1b8823f1f3793dcde25baaeba78244b8a8e8a5530da6412db68a1c00d329da03c6d19f57718c4714d6950d3218a33d2db9ba5001f12cd6f83352314888399d0cd72648989495cc06535781e57585cf7fc28b830f4e2a194f495b';
  
  Client client = Client().setEndpoint(endpoint).setProject(projectId).setKey(apiKey);
  Storage storage = Storage(client);
  Databases databases = Databases(client);

  final Map<String, String> renameMap = {
    'Cctv (1).png': 'Cctv.png',
    'Plumber (1).png': 'Plumber.png',
    'Solar (1).png': 'Solar.png',
    'Laundry (1).png': 'Laundry.png',
  };

  try {
    print('--- RENAMING SPECIFIC STORAGE FILES ---');
    var filesResult = await storage.listFiles(bucketId: 'fixit_assets', queries: [Query.limit(200)]);
    var files = filesResult.files;

    for (var entry in renameMap.entries) {
      String oldName = entry.key;
      String newName = entry.value;

      var fileToRename = files.where((f) => f.name == oldName).firstOrNull;
      if (fileToRename != null) {
        // Check if target name already exists
        var existingNew = files.where((f) => f.name == newName).firstOrNull;
        
        if (existingNew != null) {
          print('Conflict: File "$newName" already exists (ID: ${existingNew.$id}).');
          print('Will delete existing "$newName" and rename "$oldName" to replace it.');
          try {
            await storage.deleteFile(bucketId: 'fixit_assets', fileId: existingNew.$id);
            print('  Deleted old "$newName".');
          } catch (e) {
            print('  Failed to delete: $e');
          }
        }

        print('Renaming "$oldName" (ID: ${fileToRename.$id}) to "$newName"...');
        await storage.updateFile(
          bucketId: 'fixit_assets',
          fileId: fileToRename.$id,
          name: newName,
        );
        print('  [SUCCESS] Renamed.');

        // Update DB
        for (var collection in ['popular_services', 'services']) {
          var docs = await databases.listDocuments(
            databaseId: 'database-default',
            collectionId: collection,
            queries: [Query.equal('imagePath', oldName)],
          );
          for (var doc in docs.documents) {
            print('  Updating DB Doc ${doc.$id} in $collection...');
            await databases.updateDocument(
              databaseId: 'database-default',
              collectionId: collection,
              documentId: doc.$id,
              data: {'imagePath': newName},
            );
          }
        }
      } else {
        print('File "$oldName" not found in Storage. Skipping.');
      }
    }
    print('\n--- PROCESS COMPLETE ---');
  } catch (e) {
    print('Error: $e');
  }
}

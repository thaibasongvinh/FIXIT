import 'dart:io';
import 'package:dart_appwrite/dart_appwrite.dart';

void main() async {
  final String endpoint = 'https://sgp.cloud.appwrite.io/v1';
  final String projectId = '6a145b8d001aa82f4dd5';
  final String apiKey = 'standard_6de4d38760a772bd4006cc26d99353ed12f03e1e9f1a743be083627ec864bb7cb9e58478865c1b8823f1f3793dcde25baaeba78244b8a8e8a5530da6412db68a1c00d329da03c6d19f57718c4714d6950d3218a33d2db9ba5001f12cd6f83352314888399d0cd72648989495cc06535781e57585cf7fc28b830f4e2a194f495b';
  
  Client client = Client().setEndpoint(endpoint).setProject(projectId).setKey(apiKey);
  Databases databases = Databases(client);
  Storage storage = Storage(client);

  print('--- AUDIT REPORT ---');
  print('Date: ${DateTime.now()}');

  print('\n[1] Popular Services (Collection: popular_services)');
  try {
    var result = await databases.listDocuments(
      databaseId: 'database-default',
      collectionId: 'popular_services',
      queries: [Query.limit(100)],
    );
    print('Total: ${result.total}');
    for (var doc in result.documents) {
      print('- Document: ${doc.data}');
    }
  } catch (e) {
    print('Error listing popular_services: $e');
  }

  print('\n[2] Storage (Bucket: fixit_assets)');
  try {
    var files = await storage.listFiles(bucketId: 'fixit_assets', queries: [Query.limit(100)]);
    print('Total files: ${files.total}');
    for (var f in files.files) {
      print('- ID: ${f.$id} | Name: ${f.name} | Size: ${(f.sizeOriginal / 1024).toStringAsFixed(2)} KB');
    }
  } catch (e) {
    print('Error listing storage: $e');
  }
  
  print('\n--- END OF REPORT ---');
}

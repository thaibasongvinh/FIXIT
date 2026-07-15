import 'dart:io';
import 'package:dart_appwrite/dart_appwrite.dart';

void main() async {
  final String endpoint = 'https://sgp.cloud.appwrite.io/v1';
  final String projectId = '6a145b8d001aa82f4dd5';
  final String apiKey = 'standard_6de4d38760a772bd4006cc26d99353ed12f03e1e9f1a743be083627ec864bb7cb9e58478865c1b8823f1f3793dcde25baaeba78244b8a8e8a5530da6412db68a1c00d329da03c6d19f57718c4714d6950d3218a33d2db9ba5001f12cd6f83352314888399d0cd72648989495cc06535781e57585cf7fc28b830f4e2a194f495b';
  
  Client client = Client().setEndpoint(endpoint).setProject(projectId).setKey(apiKey);
  Databases databases = Databases(client);

  // Mapping from Singular (Current in Services) to Plural (Current in Popular & Storage)
  final Map<String, String> namingMap = {
    'Solar': 'Solars',
    'Laundry': 'Laundrys',
    'Painting': 'Paintings',
    'Flooring': 'Floorings',
    'Locksmith': 'Locksmiths',
    'Plumber': 'Plumbers',
  };

  try {
    var result = await databases.listDocuments(
      databaseId: 'database-default',
      collectionId: 'services',
      queries: [Query.limit(100)],
    );

    print('--- SYNCING SERVICES NAMING TO MATCH POPULAR/STORAGE ---');

    for (var doc in result.documents) {
      String currentTitle = (doc.data['name'] ?? doc.data['title'] ?? '').toString();
      
      if (namingMap.containsKey(currentTitle)) {
        String newTitle = namingMap[currentTitle]!;
        String newImagePath = '$newTitle.png';

        print('\nUpdating Service ID: ${doc.$id}');
        print('  Title: "$currentTitle" -> "$newTitle"');
        print('  imagePath: "${doc.data['imagePath']}" -> "$newImagePath"');

        Map<String, dynamic> updateData = {'imagePath': newImagePath};
        if (doc.data.containsKey('name')) updateData['name'] = newTitle;
        if (doc.data.containsKey('title')) updateData['title'] = newTitle;

        await databases.updateDocument(
          databaseId: 'database-default',
          collectionId: 'services',
          documentId: doc.$id,
          data: updateData,
        );
        print('  [SUCCESS] Updated.');
      }
    }

    print('\n--- PROCESS COMPLETE ---');
  } catch (e) {
    print('Error: $e');
  }
}

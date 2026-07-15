import 'dart:io';
import 'package:dart_appwrite/dart_appwrite.dart';

void main() async {
  final String endpoint = 'https://sgp.cloud.appwrite.io/v1';
  final String projectId = '6a145b8d001aa82f4dd5';
  final String apiKey = 'standard_6de4d38760a772bd4006cc26d99353ed12f03e1e9f1a743be083627ec864bb7cb9e58478865c1b8823f1f3793dcde25baaeba78244b8a8e8a5530da6412db68a1c00d329da03c6d19f57718c4714d6950d3218a33d2db9ba5001f12cd6f83352314888399d0cd72648989495cc06535781e57585cf7fc28b830f4e2a194f495b';
  
  Client client = Client().setEndpoint(endpoint).setProject(projectId).setKey(apiKey);
  Databases databases = Databases(client);

  try {
    var result = await databases.listDocuments(
      databaseId: 'database-default',
      collectionId: 'popular_services',
    );

    print('--- POPULAR SERVICES SYNC CHECK ---');
    int matchCount = 0;
    int mismatchCount = 0;

    for (var doc in result.documents) {
      String title = (doc.data['title'] ?? '').toString();
      String imagePath = (doc.data['imagePath'] ?? '').toString();
      String expectedImagePath = '$title.png';

      if (imagePath == expectedImagePath) {
        matchCount++;
        print('[MATCH] Title: "$title" | imagePath: "$imagePath"');
      } else {
        mismatchCount++;
        print('[MISMATCH] Title: "$title" | imagePath: "$imagePath" (Expected: "$expectedImagePath")');
      }
    }

    print('\n--- SUMMARY ---');
    print('Total Popular Services: ${result.total}');
    print('Matches: $matchCount');
    print('Mismatches: $mismatchCount');

    if (mismatchCount == 0) {
      print('STATUS: PERFECT - All popular services match their titles!');
    }
  } catch (e) {
    print('Error: $e');
  }
}

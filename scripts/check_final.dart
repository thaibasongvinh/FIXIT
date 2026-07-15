import 'dart:io';
import 'package:dart_appwrite/dart_appwrite.dart';

final String endpoint = Platform.environment['APPWRITE_ENDPOINT'] ??
    'https://sgp.cloud.appwrite.io/v1';
final String projectId =
    Platform.environment['APPWRITE_PROJECT_ID'] ?? '6a145b8d001aa82f4dd5';
final String apiKey = Platform.environment['APPWRITE_API_KEY'] ??
    (throw StateError('APPWRITE_API_KEY is required'));
final String databaseId =
    Platform.environment['APPWRITE_DATABASE_ID'] ?? 'database-default';

void main() async {
  Client client =
      Client().setEndpoint(endpoint).setProject(projectId).setKey(apiKey);
  Databases databases = Databases(client);

  final collections = [
    'technicians',
    'technician_applications',
    'bookings',
    'wallets',
    'notifications',
    'address_book'
  ];

  for (var coll in collections) {
    try {
      print('\n--- Attributes for $coll ---');
      final res = await databases.listAttributes(
          databaseId: databaseId, collectionId: coll);
      for (var attr in res.attributes) {
        print(attr['key']);
      }
    } catch (e) {
      print('Error for $coll: $e');
    }
  }
}

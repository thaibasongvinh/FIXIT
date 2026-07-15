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

  try {
    print('--- Attributes for bookings ---');
    final bookings = await databases.listAttributes(
        databaseId: databaseId, collectionId: 'bookings');
    for (var attr in bookings.attributes) {
      print(attr['key']);
    }

    print('\n--- Attributes for technician_applications ---');
    final apps = await databases.listAttributes(
        databaseId: databaseId, collectionId: 'technician_applications');
    for (var attr in apps.attributes) {
      print(attr['key']);
    }
  } catch (e) {
    print(e);
  }
}

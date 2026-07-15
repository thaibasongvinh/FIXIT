import 'dart:io';
import 'package:dart_appwrite/dart_appwrite.dart';

final String endpoint = Platform.environment['APPWRITE_ENDPOINT'] ??
    'https://sgp.cloud.appwrite.io/v1';
final String projectId =
    Platform.environment['APPWRITE_PROJECT_ID'] ?? '6a145b8d001aa82f4dd5';
final String apiKey = Platform.environment['APPWRITE_API_KEY'] ??
    (throw StateError('APPWRITE_API_KEY is required'));

void main() async {
  Client client =
      Client().setEndpoint(endpoint).setProject(projectId).setKey(apiKey);
  Storage storage = Storage(client);

  try {
    final result = await storage.listBuckets();
    print('Existing Buckets:');
    for (var bucket in result.buckets) {
      print('- ${bucket.$id} (${bucket.name})');
    }
  } catch (e) {
    print('Error: $e');
  }
}

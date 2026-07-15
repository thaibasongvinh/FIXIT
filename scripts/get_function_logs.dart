import 'dart:io';
import 'package:dart_appwrite/dart_appwrite.dart';

final String endpoint = Platform.environment['APPWRITE_ENDPOINT'] ??
    'https://sgp.cloud.appwrite.io/v1';
final String projectId =
    Platform.environment['APPWRITE_PROJECT_ID'] ?? '6a145b8d001aa82f4dd5';
final String apiKey = Platform.environment['APPWRITE_API_KEY'] ??
    (throw StateError('APPWRITE_API_KEY is required'));
const String functionId = 'reset-password-admin';

void main() async {
  Client client =
      Client().setEndpoint(endpoint).setProject(projectId).setKey(apiKey);
  Functions functions = Functions(client);

  try {
    print('🔍 Fetching last executions for: $functionId');
    final executions = await functions.listExecutions(
        functionId: functionId, queries: [Query.limit(5), Query.orderDesc('')]);

    for (var exec in executions.executions) {
      print('--- Execution: ${exec.$id} ---');
      print('Status: ${exec.status}');
      print('Log: ${exec.logs}');
      print('Error: ${exec.errors}');
      print('---------------------------');
    }
  } catch (e) {
    print('❌ Error fetching logs: $e');
  }
}

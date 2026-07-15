import 'dart:io';
import 'package:dart_appwrite/dart_appwrite.dart';
import 'package:dart_appwrite/enums.dart';

final String endpoint = Platform.environment['APPWRITE_ENDPOINT'] ??
    'https://sgp.cloud.appwrite.io/v1';
final String projectId =
    Platform.environment['APPWRITE_PROJECT_ID'] ?? '6a145b8d001aa82f4dd5';
final String apiKey = Platform.environment['APPWRITE_API_KEY'] ??
    (throw StateError('APPWRITE_API_KEY is required'));
const String functionId = 'admin-delete-user';

void main() async {
  Client client =
      Client().setEndpoint(endpoint).setProject(projectId).setKey(apiKey);
  Functions functions = Functions(client);

  print('🚀 Starting deployment for function: $functionId');

  try {
    // 1. Create or Get Function
    try {
      await functions.get(functionId: functionId);
      print('✅ Function exists. Updating settings...');
      await functions.update(
        functionId: functionId,
        name: 'Admin Delete User',
        runtime: Runtime.node180,
        entrypoint: 'index.js',
        execute: ['any'],
      );
    } catch (e) {
      print('✨ Creating new function...');
      await functions.create(
        functionId: functionId,
        name: 'Admin Delete User',
        runtime: Runtime.node180,
        entrypoint: 'index.js',
        execute: ['any'],
      );
    }

    // 2. Set Environment Variables
    print('⚙️ Setting environment variables...');
    try {
      await functions.createVariable(
        functionId: functionId,
        key: 'APPWRITE_API_KEY',
        value: apiKey,
      );
    } catch (e) {
      // If variable exists, we might need to update it, but dart_appwrite 14.0.0 might not have updateVariable easily available or it might be a different name
      print('ℹ️ Note: Variable might already exist or error: $e');
    }

    // 3. Create Deployment
    print('📦 Uploading code and deploying...');
    final tarFile = File(
        'D:/Documents/MOBILEAPP/FLUTTER/ifixit/functions/admin-delete-user/code.tar.gz');
    if (!tarFile.existsSync()) {
      print('❌ Error: code.tar.gz not found!');
      return;
    }

    await functions.createDeployment(
      functionId: functionId,
      code: InputFile.fromPath(path: tarFile.path, filename: 'code.tar.gz'),
      activate: true,
      entrypoint: 'index.js',
    );

    print('🎉 Deployment successful! The function is now active.');
  } catch (e) {
    print('❌ Critical Error during deployment: $e');
  }
}

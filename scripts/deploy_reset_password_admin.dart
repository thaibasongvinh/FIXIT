import 'dart:io';
import 'package:dart_appwrite/dart_appwrite.dart';
import 'package:dart_appwrite/enums.dart';

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

  print('🚀 Starting deployment for function: $functionId');

  try {
    // 1. Create or Get Function
    try {
      await functions.get(functionId: functionId);
      print('✅ Function exists. Updating settings...');
      await functions.update(
        functionId: functionId,
        name: 'Reset Password Admin',
        runtime: Runtime.node180,
        entrypoint: 'index.js',
        execute: ['any'],
      );
    } catch (e) {
      print('✨ Creating new function...');
      await functions.create(
        functionId: functionId,
        name: 'Reset Password Admin',
        runtime: Runtime.node180,
        entrypoint: 'index.js',
        execute: ['any'],
      );
    }

    // 2. Set Environment Variables
    print('⚙️ Setting environment variables...');
    final variables = {
      'APPWRITE_API_KEY': apiKey,
      'APPWRITE_FUNCTION_ENDPOINT': endpoint,
      'APPWRITE_FUNCTION_PROJECT_ID': projectId,
    };

    for (var entry in variables.entries) {
      try {
        await functions.createVariable(
          functionId: functionId,
          key: entry.key,
          value: entry.value,
        );
        print('✅ Created variable: ${entry.key}');
      } catch (e) {
        if (e.toString().contains('409')) {
          // Update if already exists
          // Appwrite Dart SDK doesn't have an easy updateVariable in some versions,
          // but we can try to delete and recreate or just ignore if it's correct.
          print('ℹ️ Variable ${entry.key} already exists.');
        } else {
          print('⚠️ Error setting ${entry.key}: $e');
        }
      }
    }

    // 3. Create Deployment
    print('📦 Uploading code and deploying...');
    final tarFile = File(
        'D:/Documents/MOBILEAPP/FLUTTER/ifixit/functions/reset-password-admin/code.tar.gz');
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

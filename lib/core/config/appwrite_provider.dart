import 'package:appwrite/appwrite.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../services/legacy_databases.dart';
import 'app_environment_provider.dart';

part 'appwrite_provider.g.dart';

@Riverpod(keepAlive: true)
Client appwriteClient(Ref ref) {
  final env = ref.watch(appEnvironmentProvider);
  return Client()
    ..setEndpoint(env.appwriteEndpoint)
    ..setProject(env.appwriteProjectId)
    ..setSelfSigned(status: env.flavor.isDev);
}

@Riverpod(keepAlive: true)
Account appwriteAccount(Ref ref) {
  final client = ref.watch(appwriteClientProvider);
  return Account(client);
}

@Riverpod(keepAlive: true)
Databases appwriteDatabases(Ref ref) {
  final client = ref.watch(appwriteClientProvider);
  return LegacyDatabases(client); // Khôi phục lại Legacy để fix lỗi EMPTY data
}

@Riverpod(keepAlive: true)
Storage appwriteStorage(Ref ref) {
  final client = ref.watch(appwriteClientProvider);
  return Storage(client);
}

@Riverpod(keepAlive: true)
Realtime appwriteRealtime(Ref ref) {
  final client = ref.watch(appwriteClientProvider);
  return Realtime(client);
}

@Riverpod(keepAlive: true)
Functions appwriteFunctions(Ref ref) {
  final client = ref.watch(appwriteClientProvider);
  return Functions(client);
}

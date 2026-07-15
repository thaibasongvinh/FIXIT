import 'package:appwrite/appwrite.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../config/app_environment_provider.dart';
import '../config/appwrite_provider.dart';

class Phase5Config {
  const Phase5Config({
    this.deepLinksEnabled = true,
    this.aiDiagnosisEnabled = false,
    this.advancedSearchEnabled = false,
    this.maintenanceMode = false,
    this.minAppVersion = '1.0.0',
    this.featureFlags = const {},
  });

  factory Phase5Config.fromJson(Map<String, dynamic> json) {
    return Phase5Config(
      deepLinksEnabled: json['deepLinksEnabled'] as bool? ?? true,
      aiDiagnosisEnabled: json['aiDiagnosisEnabled'] as bool? ?? false,
      advancedSearchEnabled: json['advancedSearchEnabled'] as bool? ?? false,
      maintenanceMode: json['maintenanceMode'] as bool? ?? false,
      minAppVersion: json['minAppVersion'] as String? ?? '1.0.0',
      featureFlags: Map<String, bool>.from(json['featureFlags'] ?? {}),
    );
  }

  static const defaults = Phase5Config();

  final bool deepLinksEnabled;
  final bool aiDiagnosisEnabled;
  final bool advancedSearchEnabled;
  final bool maintenanceMode;
  final String minAppVersion;
  final Map<String, bool> featureFlags;

  bool isFeatureEnabled(String featureName) => featureFlags[featureName] ?? false;
}

final phase5ConfigProvider = FutureProvider<Phase5Config>((ref) async {
  final env = ref.watch(appEnvironmentProvider);
  final db = ref.watch(appwriteDatabasesProvider);

  try {
    final doc = await db.getDocument(
      databaseId: env.appwriteDatabaseId,
      collectionId: 'app_config',
      documentId: 'default_config',
    );
    return Phase5Config.fromJson(doc.data);
  } on AppwriteException catch (e) {
    debugPrint('Appwrite: remoteConfig error [${e.code}]: ${e.message}');
    return Phase5Config.defaults;
  } catch (_) {
    return Phase5Config.defaults;
  }
});

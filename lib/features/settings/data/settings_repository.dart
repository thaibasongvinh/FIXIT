import 'package:appwrite/appwrite.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/config/app_environment_provider.dart';
import '../../../core/config/appwrite_provider.dart';
import '../domain/user_settings.dart';

part 'settings_repository.g.dart';

class SettingsRepository {
  final Databases _databases;
  final String _dbId;
  final String _configCollId = 'app_config';
  final String _settingsCollId = 'user_settings';

  SettingsRepository(this._databases, this._dbId);

  // Lấy cấu hình mặc định từ hệ thống
  Future<Map<String, dynamic>> getSystemConfig() async {
    try {
      final doc = await _databases.getDocument(
        databaseId: _dbId,
        collectionId: _configCollId,
        documentId: 'system-settings',
      );
      return doc.data;
    } catch (e) {
      return {
        'defaultLanguage': 'vi',
        'defaultTheme': 'system',
      };
    }
  }

  // Lấy cài đặt cá nhân của user
  Future<UserSettings?> getUserSettings(String userId) async {
    try {
      final docs = await _databases.listDocuments(
        databaseId: _dbId,
        collectionId: _settingsCollId,
        queries: [
          Query.equal('userId', userId),
        ],
      );
      if (docs.documents.isNotEmpty) {
        return UserSettings.fromJson(docs.documents.first.data);
      }
    } catch (e) {
      print('Error getting user settings: $e');
    }
    return null;
  }

  // Cập nhật hoặc tạo mới cài đặt user
  Future<void> updateUserSettings(String userId, UserSettings settings) async {
    try {
      final docs = await _databases.listDocuments(
        databaseId: _dbId,
        collectionId: _settingsCollId,
        queries: [
          Query.equal('userId', userId),
        ],
      );

      if (docs.documents.isNotEmpty) {
        await _databases.updateDocument(
          databaseId: _dbId,
          collectionId: _settingsCollId,
          documentId: docs.documents.first.$id,
          data: settings.toJson(),
        );
      } else {
        await _databases.createDocument(
          databaseId: _dbId,
          collectionId: _settingsCollId,
          documentId: ID.unique(),
          data: {
            ...settings.toJson(),
            'userId': userId,
          },
        );
      }
    } catch (e) {
      print('Error updating user settings: $e');
      rethrow;
    }
  }
}

@Riverpod(keepAlive: true)
SettingsRepository settingsRepository(Ref ref) {
  final databases = ref.watch(appwriteDatabasesProvider);
  final env = ref.watch(appEnvironmentProvider);
  return SettingsRepository(databases, env.appwriteDatabaseId);
}

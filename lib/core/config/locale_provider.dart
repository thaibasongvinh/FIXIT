import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';
import '../../features/settings/data/settings_repository.dart';
import '../../features/settings/domain/user_settings.dart';

part 'locale_provider.g.dart';

@riverpod
class LocaleNotifier extends _$LocaleNotifier {
  static const _key = 'app_locale';

  @override
  Locale build() {
    // Watch authState để trigger rebuild/sync khi user login/logout
    final auth = ref.watch(authStateProvider).valueOrNull;
    
    // Khởi tạo đồng bộ từ SharedPreferences
    _init(auth);
    
    return const Locale('vi');
  }

  Future<void> _init(dynamic auth) async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString(_key);
    if (code != null) {
      state = Locale(code);
    }
    
    if (auth != null) {
      _syncWithAppwrite(auth.$id);
    }
  }

  Future<void> _syncWithAppwrite(String userId) async {
    try {
      final repository = ref.read(settingsRepositoryProvider);
      final userSettings = await repository.getUserSettings(userId);
      if (userSettings != null && userSettings.language != state.languageCode) {
        state = Locale(userSettings.language);
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_key, userSettings.language);
      }
    } catch (e) {
      debugPrint('Locale sync error: $e');
    }
  }

  Future<void> setLocale(Locale locale) async {
    state = locale;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, locale.languageCode);

    final auth = ref.read(authStateProvider).valueOrNull;
    if (auth != null) {
      final repository = ref.read(settingsRepositoryProvider);
      final currentSettings = await repository.getUserSettings(auth.$id) ?? 
          UserSettings(themeMode: 'system', language: 'vi');
      
      await repository.updateUserSettings(
        auth.$id, 
        currentSettings.copyWith(language: locale.languageCode)
      );
    }
  }
}

@riverpod
class ThemeModeNotifier extends _$ThemeModeNotifier {
  static const _key = 'theme_mode';

  @override
  ThemeMode build() {
    // Không watch authState ở đây để tránh rebuild vòng lặp
    final auth = ref.read(authStateProvider).valueOrNull;
    
    // Khởi tạo ngay lập tức giá trị mặc định là DARK
    _init(auth);
    return ThemeMode.dark;
  }

  Future<void> _init(dynamic auth) async {
    final prefs = await SharedPreferences.getInstance();
    final index = prefs.getInt(_key);
    
    if (index != null) {
      state = ThemeMode.values[index];
    } else {
      // Nếu chưa có cài đặt, ép buộc lưu Dark Mode vào máy
      state = ThemeMode.dark;
      await prefs.setInt(_key, ThemeMode.dark.index);
    }
    
    if (auth != null) {
      _syncWithAppwrite(auth.$id);
    }
  }

  Future<void> _syncWithAppwrite(String userId) async {
    try {
      final repository = ref.read(settingsRepositoryProvider);
      final userSettings = await repository.getUserSettings(userId);
      if (userSettings != null) {
        final remoteMode = _parseThemeMode(userSettings.themeMode);
        if (remoteMode != state) {
          state = remoteMode;
          final prefs = await SharedPreferences.getInstance();
          await prefs.setInt(_key, remoteMode.index);
        }
      }
    } catch (e) {
      debugPrint('Theme sync error: $e');
    }
  }

  ThemeMode _parseThemeMode(String mode) {
    return switch (mode) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };
  }

  String _themeModeToString(ThemeMode mode) {
    return switch (mode) {
      ThemeMode.light => 'light',
      ThemeMode.dark => 'dark',
      ThemeMode.system => 'system',
    };
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    state = mode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_key, mode.index);

    final auth = ref.read(authStateProvider).valueOrNull;
    if (auth != null) {
      final repository = ref.read(settingsRepositoryProvider);
      final currentSettings = await repository.getUserSettings(auth.$id) ?? 
          UserSettings(themeMode: 'system', language: 'vi');
      
      await repository.updateUserSettings(
        auth.$id, 
        currentSettings.copyWith(themeMode: _themeModeToString(mode))
      );
    }
  }
}

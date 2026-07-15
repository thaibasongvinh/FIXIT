import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fixit/core/config/locale_provider.dart';
import 'package:fixit/l10n/app_localizations.dart';

class SettingsDialogs {
  static void showThemeSelector(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final currentTheme = ref.watch(themeModeNotifierProvider);

    showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              l10n.selectTheme,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildThemeOption(
              context,
              ref,
              title: l10n.systemMode,
              mode: ThemeMode.system,
              isSelected: currentTheme == ThemeMode.system,
              icon: Icons.brightness_auto_rounded,
            ),
            _buildThemeOption(
              context,
              ref,
              title: l10n.lightMode,
              mode: ThemeMode.light,
              isSelected: currentTheme == ThemeMode.light,
              icon: Icons.light_mode_rounded,
            ),
            _buildThemeOption(
              context,
              ref,
              title: l10n.darkMode,
              mode: ThemeMode.dark,
              isSelected: currentTheme == ThemeMode.dark,
              icon: Icons.dark_mode_rounded,
            ),
          ],
        ),
      ),
    );
  }

  static Widget _buildThemeOption(
    BuildContext context,
    WidgetRef ref, {
    required String title,
    required ThemeMode mode,
    required bool isSelected,
    required IconData icon,
  }) {
    return ListTile(
      leading: Icon(icon, color: isSelected ? Colors.blue : null),
      title: Text(
        title,
        style: TextStyle(
          color: isSelected ? Colors.blue : null,
          fontWeight: isSelected ? FontWeight.bold : null,
        ),
      ),
      trailing: isSelected ? const Icon(Icons.check_circle, color: Colors.blue) : null,
      onTap: () {
        ref.read(themeModeNotifierProvider.notifier).setThemeMode(mode);
        Navigator.pop(context);
      },
    );
  }

  static void showLanguageSelector(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final currentLocale = ref.watch(localeNotifierProvider);

    showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              l10n.selectLanguage,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildLanguageOption(
              context,
              ref,
              title: l10n.vietnamese,
              locale: const Locale('vi'),
              isSelected: currentLocale.languageCode == 'vi',
              flag: '🇻🇳',
            ),
            _buildLanguageOption(
              context,
              ref,
              title: l10n.english,
              locale: const Locale('en'),
              isSelected: currentLocale.languageCode == 'en',
              flag: '🇺🇸',
            ),
          ],
        ),
      ),
    );
  }

  static Widget _buildLanguageOption(
    BuildContext context,
    WidgetRef ref, {
    required String title,
    required Locale locale,
    required bool isSelected,
    required String flag,
  }) {
    return ListTile(
      leading: Text(flag, style: const TextStyle(fontSize: 24)),
      title: Text(
        title,
        style: TextStyle(
          color: isSelected ? Colors.blue : null,
          fontWeight: isSelected ? FontWeight.bold : null,
        ),
      ),
      trailing: isSelected ? const Icon(Icons.check_circle, color: Colors.blue) : null,
      onTap: () {
        ref.read(localeNotifierProvider.notifier).setLocale(locale);
        Navigator.pop(context);
      },
    );
  }
}

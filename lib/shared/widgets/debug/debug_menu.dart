import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/config/locale_provider.dart';

class DebugMenu extends ConsumerWidget {
  const DebugMenu({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Drawer(
      child: ListView(
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.redAccent),
            child: Text(
              'DEBUG MENU',
              style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          ListTile(
            title: const Text('Theme Mode'),
            trailing: DropdownButton<ThemeMode>(
              value: ref.watch(themeModeNotifierProvider),
              onChanged: (mode) {
                if (mode != null) {
                  ref.read(themeModeNotifierProvider.notifier).setThemeMode(mode);
                }
              },
              items: ThemeMode.values.map((e) => DropdownMenuItem(value: e, child: Text(e.name))).toList(),
            ),
          ),
          ListTile(
            title: const Text('Language'),
            trailing: DropdownButton<Locale>(
              value: ref.watch(localeNotifierProvider),
              onChanged: (locale) {
                if (locale != null) {
                  ref.read(localeNotifierProvider.notifier).setLocale(locale);
                }
              },
              items: const [
                DropdownMenuItem(value: Locale('en'), child: Text('English')),
                DropdownMenuItem(value: Locale('vi'), child: Text('Tiếng Việt')),
              ],
            ),
          ),
          const Divider(),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text('App Info', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          // Here you could add more info like environment, appwrite endpoint, etc.
        ],
      ),
    );
  }
}

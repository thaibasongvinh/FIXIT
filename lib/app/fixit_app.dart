import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/config/app_environment_provider.dart';
import '../core/config/locale_provider.dart';
import '../core/router/app_router.dart';
import '../core/theme/app_theme.dart';
import '../l10n/app_localizations.dart';
import 'app_setup_wrapper.dart';

class FixitApp extends ConsumerWidget {
  const FixitApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final environment = ref.watch(appEnvironmentProvider);
    final router = ref.watch(appRouterProvider);
    final locale = ref.watch(localeNotifierProvider);
    final themeMode = ref.watch(themeModeNotifierProvider);

    return MaterialApp.router(
      restorationScopeId: 'app',
      title: environment.appTitle,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode,
      routerConfig: router,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      locale: locale,
      builder: (context, child) => AppSetupWrapper(child: child),
      debugShowCheckedModeBanner: false,
    );
  }
}

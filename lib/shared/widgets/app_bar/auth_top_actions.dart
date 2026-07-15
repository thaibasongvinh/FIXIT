import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:fixit/core/config/locale_provider.dart';
import 'package:fixit/core/theme/app_theme.dart';
import 'package:fixit/l10n/app_localizations.dart';
import '../buttons/top_action_button.dart';

class AuthTopActions extends ConsumerWidget {
  final bool showSkip;
  final VoidCallback? onSkip;

  const AuthTopActions({
    super.key,
    this.showSkip = false,
    this.onSkip,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeNotifierProvider);
    final themeMode = ref.watch(themeModeNotifierProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    return Row(
      children: [
        const Spacer(),
        
        // Nút chuyển Theme
        TopActionButton(
          isDark: isDark,
          onPressed: () {
            HapticFeedback.mediumImpact();
            ref.read(themeModeNotifierProvider.notifier).setThemeMode(
              themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark,
            );
          },
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: Icon(
              themeMode == ThemeMode.dark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
              key: ValueKey(themeMode),
              color: isDark ? Colors.white : Colors.blueGrey.shade800,
              size: 20,
            ),
          ),
        ),
        const Gap(12),

        // Nút chuyển Ngôn ngữ
        TopActionButton(
          isDark: isDark,
          onPressed: () {
            HapticFeedback.mediumImpact();
            ref.read(localeNotifierProvider.notifier).setLocale(
              locale.languageCode == 'en' ? const Locale('vi') : const Locale('en'),
            );
          },
          child: Text(
            locale.languageCode.toUpperCase(),
            style: TextStyle(
              color: isDark ? Colors.white : Colors.blueGrey.shade800,
              fontWeight: FontWeight.w900,
              fontSize: 12,
            ),
          ),
        ),
        
        if (showSkip) ...[
          const Gap(12),
          TextButton(
            onPressed: onSkip,
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              visualDensity: VisualDensity.compact,
            ),
            child: Text(
              l10n.skip,
              style: TextStyle(
                color: isDark ? Colors.white.withOpacity(0.6) : Colors.black45,
                letterSpacing: 1.5,
                fontSize: 12,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ],
    );
  }
}

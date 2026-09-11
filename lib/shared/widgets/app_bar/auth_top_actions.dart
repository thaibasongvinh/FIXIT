import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:fixit/core/config/locale_provider.dart';
import 'package:fixit/core/constants/languages.dart';
import 'package:fixit/l10n/app_localizations.dart';
import 'package:fixit/shared/widgets/typography/translated_text.dart';
import '../buttons/top_action_button.dart';

class AuthTopActions extends ConsumerWidget {
  final bool showSkip;
  final bool showBack;
  final VoidCallback? onSkip;
  final VoidCallback? onBack;

  const AuthTopActions({
    super.key,
    this.showSkip = false,
    this.showBack = false,
    this.onSkip,
    this.onBack,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeNotifierProvider);
    final themeMode = ref.watch(themeModeNotifierProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    return Row(
      children: [
        if (showBack)
          TopActionButton(
            isDark: isDark,
            onPressed: onBack ?? () => Navigator.of(context).pop(),
            child: Icon(
              Icons.arrow_back_ios_new,
              color: isDark ? Colors.white : Colors.blueGrey.shade800,
              size: 18,
            ),
          )
        else
          // Giữ khoảng trống đối xứng cho header
          const SizedBox(width: 42),

        const Spacer(),

        // Cụm nút chức năng bên phải
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            TopActionButton(
              isDark: isDark,
              onPressed: () {
                HapticFeedback.mediumImpact();
                ref.read(themeModeNotifierProvider.notifier).setThemeMode(
                      themeMode == ThemeMode.dark
                          ? ThemeMode.light
                          : ThemeMode.dark,
                    );
              },
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: Icon(
                  isDark ? Icons.nightlight_round : Icons.wb_sunny_rounded,
                  key: ValueKey(isDark),
                  color: isDark ? Colors.white : Colors.amber.shade700,
                  size: 20,
                ),
              ),
            ),
            const Gap(12),
            TopActionButton(
              isDark: isDark,
              onPressed: () => _showLanguagePicker(context, ref, isDark),
              child: Text(
                supportedLanguages
                    .firstWhere((l) => l.code == locale.languageCode,
                        orElse: () => supportedLanguages[0])
                    .flag,
                style: const TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
          ],
        ),

        if (showSkip) ...[
          const Gap(12),
          TextButton(
            onPressed: onSkip,
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              visualDensity: VisualDensity.compact,
            ),
            child: TranslatedText(
              l10n.skip,
              style: TextStyle(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.6)
                    : Colors.black45,
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

  void _showLanguagePicker(BuildContext context, WidgetRef ref, bool isDark) {
    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? const Color(0xFF1A1A1A) : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TranslatedText(
                'SELECT LANGUAGE',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2,
                  color: isDark ? Colors.white54 : Colors.black54,
                ),
              ),
              const Gap(16),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: supportedLanguages.length,
                  itemBuilder: (context, index) {
                    final lang = supportedLanguages[index];
                    final isSelected =
                        ref.watch(localeNotifierProvider).languageCode ==
                            lang.code;

                    return ListTile(
                      leading:
                          Text(lang.flag, style: const TextStyle(fontSize: 24)),
                      title: TranslatedText(
                        lang.name.toUpperCase(),
                        style: TextStyle(
                          color: isDark ? Colors.white : Colors.black,
                          fontWeight:
                              isSelected ? FontWeight.w900 : FontWeight.w400,
                        ),
                      ),
                      trailing: isSelected
                          ? const Icon(Icons.check, color: Colors.greenAccent)
                          : null,
                      onTap: () {
                        ref
                            .read(localeNotifierProvider.notifier)
                            .setLocale(Locale(lang.code));
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

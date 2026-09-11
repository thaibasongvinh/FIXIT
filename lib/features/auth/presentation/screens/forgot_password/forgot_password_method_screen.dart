import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:fixit/core/router/app_router.dart';
import 'package:fixit/features/auth/presentation/widgets/figma_auth_widgets.dart';
import 'package:fixit/core/presentation/widgets/app_background.dart';
import 'package:fixit/l10n/app_localizations.dart';

import 'package:fixit/shared/widgets/typography/translated_text.dart';
import 'package:fixit/core/config/locale_provider.dart';
import 'package:fixit/core/services/translation_provider.dart';

import '../../../../../shared/widgets/app_bar/auth_top_actions.dart';

class ForgotPasswordMethodScreen extends ConsumerStatefulWidget {
  const ForgotPasswordMethodScreen({super.key});

  @override
  ConsumerState<ForgotPasswordMethodScreen> createState() =>
      _ForgotPasswordMethodScreenState();
}

class _ForgotPasswordMethodScreenState
    extends ConsumerState<ForgotPasswordMethodScreen> {
  String _selectedMethod = "Email";

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final locale = ref.watch(localeNotifierProvider);
    final targetLang = locale.languageCode;

    // Tải trước bản dịch cho Forgot Password Method Screen
    if (targetLang != 'en') {
      ref.watch(translatedBatchProvider([
        l10n.forgotPasswordQuery,
        l10n.chooseResetMethod,
        l10n.emailAddress,
        l10n.emailMethodSubtitle,
        l10n.mobileNumber,
        l10n.phoneMethodSubtitle,
        l10n.next,
      ], targetLang));
    }

    return AppBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        children: [
                          AuthTopActions(
                            showBack: context.canPop(),
                            onBack: () {
                              HapticFeedback.selectionClick();
                              context.pop();
                            },
                          ),
                          const Spacer(flex: 3),
                          _buildLogoBadge(isDark),
                          const Gap(24),
                          TranslatedText(
                            l10n.forgotPasswordQuery,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w900,
                              color: isDark
                                  ? Colors.white
                                  : Colors.blueGrey.shade900,
                              letterSpacing: -0.5,
                            ),
                          ),
                          const Gap(8),
                          TranslatedText(
                            l10n.chooseResetMethod,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              color: isDark
                                  ? Colors.white.withOpacity(0.6)
                                  : Colors.blueGrey.shade600,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const Gap(32),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(30),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
                              child: Container(
                                padding: const EdgeInsets.all(24),
                                decoration: BoxDecoration(
                                  color: isDark
                                      ? Colors.white.withOpacity(0.03)
                                      : Colors.white.withOpacity(0.4),
                                  borderRadius: BorderRadius.circular(30),
                                  border: Border.all(
                                    color: isDark
                                        ? Colors.white.withOpacity(0.15)
                                        : Colors.white.withOpacity(0.6),
                                    width: 0.8,
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    _buildMethodTile(
                                      title: l10n.emailAddress,
                                      subtitle: l10n.emailMethodSubtitle,
                                      icon: Icons.alternate_email_rounded,
                                      method: "Email",
                                      isDark: isDark,
                                    ),
                                    const Gap(16),
                                    _buildMethodTile(
                                      title: l10n.mobileNumber,
                                      subtitle: l10n.phoneMethodSubtitle,
                                      icon: Icons.phone_android_rounded,
                                      method: "Phone",
                                      isDark: isDark,
                                    ),
                                    const Gap(32),
                                    SizedBox(
                                      width: double.infinity,
                                      height: 56,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          HapticFeedback.mediumImpact();
                                          if (_selectedMethod == "Email") {
                                            context.push(
                                                AppRoutes.forgotPasswordEmail);
                                          } else {
                                            context.push(
                                                AppRoutes.forgotPasswordPhone);
                                          }
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: isDark
                                              ? Colors.white
                                              : Theme.of(context).primaryColor,
                                          foregroundColor: isDark
                                              ? const Color(0xFF0D47A1)
                                              : Colors.white,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(16)),
                                          elevation: isDark ? 0 : 8,
                                        ),
                                        child: TranslatedText(
                                          l10n.next.toUpperCase(),
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w900,
                                              fontSize: 16,
                                              letterSpacing: 1),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const Spacer(flex: 4),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildLogoBadge(bool isDark) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 1.0, end: 1.05),
      duration: const Duration(seconds: 2),
      curve: Curves.easeInOut,
      builder: (context, value, child) {
        return Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                  color:
                      Colors.blueAccent.withOpacity(isDark ? 0.4 * value : 0.2),
                  blurRadius: 40,
                  spreadRadius: 5),
            ],
          ),
          child: Center(
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                border:
                    Border.all(color: Colors.white.withOpacity(0.8), width: 3),
              ),
              child: ClipOval(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Image.asset('assets/images/app_icon.png',
                      fit: BoxFit.contain),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildMethodTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required String method,
    required bool isDark,
  }) {
    bool isSelected = _selectedMethod == method;
    final primaryColor = Theme.of(context).primaryColor;

    return InkWell(
      onTap: () {
        HapticFeedback.selectionClick();
        setState(() => _selectedMethod = method);
      },
      borderRadius: BorderRadius.circular(20),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark
                  ? Colors.white.withOpacity(0.12)
                  : primaryColor.withOpacity(0.08))
              : (isDark
                  ? Colors.white.withOpacity(0.03)
                  : Colors.black.withOpacity(0.02)),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? (isDark ? Colors.blueAccent : primaryColor)
                : (isDark
                    ? Colors.white.withOpacity(0.1)
                    : Colors.black.withOpacity(0.05)),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isSelected
                    ? (isDark
                        ? Colors.blueAccent.withOpacity(0.2)
                        : primaryColor.withOpacity(0.1))
                    : (isDark
                        ? Colors.white.withOpacity(0.05)
                        : Colors.black.withOpacity(0.03)),
                shape: BoxShape.circle,
              ),
              child: Icon(icon,
                  color: isSelected
                      ? (isDark ? Colors.blueAccent : primaryColor)
                      : (isDark ? Colors.white60 : Colors.blueGrey),
                  size: 24),
            ),
            const Gap(16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TranslatedText(title,
                      style: TextStyle(
                          color:
                              isDark ? Colors.white : Colors.blueGrey.shade900,
                          fontSize: 16,
                          fontWeight:
                              isSelected ? FontWeight.w800 : FontWeight.w600)),
                  TranslatedText(subtitle,
                      style: TextStyle(
                          color: isDark
                              ? Colors.white.withOpacity(0.5)
                              : Colors.blueGrey.shade600,
                          fontSize: 13)),
                ],
              ),
            ),
            if (isSelected)
              Icon(Icons.check_circle_rounded,
                  color: isDark ? Colors.blueAccent : primaryColor, size: 24),
          ],
        ),
      ),
    );
  }
}

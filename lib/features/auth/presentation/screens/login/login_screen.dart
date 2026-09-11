import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import 'package:fixit/shared/widgets/typography/translated_text.dart';
import 'package:fixit/shared/utils/snackbar_utils.dart';
import 'package:fixit/core/router/app_router.dart';
import 'package:fixit/core/presentation/widgets/app_background.dart';
import 'package:fixit/shared/widgets/app_bar/auth_top_actions.dart';
import 'package:fixit/l10n/app_localizations.dart';
import 'package:fixit/features/auth/presentation/providers/auth_provider.dart';
import 'package:fixit/features/auth/presentation/widgets/figma_auth_widgets.dart';

import 'package:fixit/core/config/locale_provider.dart';
import 'package:fixit/core/services/translation_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    HapticFeedback.mediumImpact();
    try {
      await ref.read(authNotifierProvider.notifier).signIn(
            _emailController.text.trim(),
            _passwordController.text,
          );
    } catch (e) {
      debugPrint('Login: Submit error: $e');
    }
  }

  String _mapError(Object error, AppLocalizations l10n) {
    final value = error.toString().toLowerCase();

    if (value.contains('user_invalid_credentials') ||
        value.contains('invalid-credential') ||
        value.contains('401')) {
      return l10n.errorInvalidCredentials;
    }

    if (value.contains('network') || value.contains('connection')) {
      return l10n.errorNetwork;
    }

    return l10n.errorUnknown;
  }

  @override
  Widget build(BuildContext context) {
    // TỐI ƯU: Chỉ watch isLoading thay vì toàn bộ state (Gợi ý số 1)
    final isLoading =
        ref.watch(authNotifierProvider.select((s) => s.isLoading));
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final locale = ref.watch(localeNotifierProvider);
    final targetLang = locale.languageCode;

    // Tối ưu dịch theo lô cho màn hình Login
    if (targetLang != 'en') {
      ref.watch(translatedBatchProvider([
        l10n.welcomeBack,
        l10n.loginSubtitle,
        l10n.emailAddress,
        l10n.password,
        l10n.forgotPasswordQuery,
        l10n.signIn,
        l10n.dontHaveAccount,
        l10n.signUp,
        l10n.orLogInWith,
      ], targetLang));
    }

    ref.listen(authNotifierProvider, (_, next) {
      next.whenOrNull(
        error: (error, _) =>
            AppSnackbar.showError(context, _mapError(error, l10n)),
      );
    });

    return AppBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isKeyboardOpen =
                  MediaQuery.of(context).viewInsets.bottom > 0;

              return SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                  ),
                  child: IntrinsicHeight(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            AuthTopActions(
                              showBack: context.canPop(),
                              onBack: () {
                                HapticFeedback.selectionClick();
                                context.pop();
                              },
                            ),

                            // Khoảng trống trên cùng (linh hoạt khi không bàn phím)
                            if (!isKeyboardOpen)
                              const Spacer(flex: 3)
                            else
                              const Gap(20),

                            // Logo Badge (Cố định kích thước để chống bóp méo)
                            TweenAnimationBuilder<double>(
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
                                        color: Colors.blueAccent.withValues(
                                            alpha: isDark ? 0.5 * value : 0.3),
                                        blurRadius: 40,
                                        spreadRadius: 8,
                                      ),
                                    ],
                                  ),
                                  child: Center(
                                    child: Container(
                                      width: 85,
                                      height: 85,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.white,
                                        border: Border.all(
                                          color: Colors.white
                                              .withValues(alpha: 0.9),
                                          width: 3,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black
                                                .withValues(alpha: 0.15),
                                            blurRadius: 15,
                                            offset: const Offset(0, 8),
                                          )
                                        ],
                                      ),
                                      child: ClipOval(
                                        child: Padding(
                                          padding: const EdgeInsets.all(12),
                                          child: Image.asset(
                                            'assets/images/app_icon.png',
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),

                            const Gap(24),
                            TranslatedText(
                              l10n.welcomeBack,
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.w900,
                                color: isDark
                                    ? Colors.white
                                    : Colors.blueGrey.shade900,
                                letterSpacing: -0.5,
                              ),
                            ),
                            const Gap(4),
                            TranslatedText(
                              l10n.loginSubtitle,
                              style: TextStyle(
                                fontSize: 14,
                                color: isDark
                                    ? Colors.white.withOpacity(0.6)
                                    : Colors.blueGrey.shade600,
                                fontWeight: FontWeight.w500,
                              ),
                            ),

                            const Gap(24),

                            // Glassmorphism Card
                            ClipRRect(
                              borderRadius: BorderRadius.circular(30),
                              child: BackdropFilter(
                                filter:
                                    ImageFilter.blur(sigmaX: 30, sigmaY: 30),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      FigmaAuthTextField(
                                        controller: _emailController,
                                        label: l10n.emailAddress,
                                        hint: l10n.emailHint,
                                        icon: Icons.alternate_email_rounded,
                                        darkTheme: isDark,
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        autofillHints: const [
                                          AutofillHints.email
                                        ],
                                        textInputAction: TextInputAction.next,
                                        validator: (value) =>
                                            (value == null || value.isEmpty)
                                                ? l10n.enterEmail
                                                : null,
                                      ),
                                      const Gap(20),
                                      FigmaAuthTextField(
                                        controller: _passwordController,
                                        label: l10n.password,
                                        hint: l10n.passwordHint,
                                        icon: Icons.lock_person_outlined,
                                        isPassword: true,
                                        obscure: _obscurePassword,
                                        darkTheme: isDark,
                                        autofillHints: const [
                                          AutofillHints.password
                                        ],
                                        textInputAction: TextInputAction.done,
                                        onToggleVisibility: () => setState(() =>
                                            _obscurePassword =
                                                !_obscurePassword),
                                        validator: (value) =>
                                            (value == null || value.length < 6)
                                                ? l10n.min6Chars
                                                : null,
                                      ),
                                      const Gap(12),
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: TextButton(
                                          onPressed: () {
                                            HapticFeedback.selectionClick();
                                            context
                                                .push(AppRoutes.forgotPassword);
                                          },
                                          child: TranslatedText(
                                            l10n.forgotPasswordQuery,
                                            style: TextStyle(
                                                color: isDark
                                                    ? Colors.white
                                                        .withOpacity(0.7)
                                                    : Theme.of(context)
                                                        .primaryColor,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                      ),
                                      const Gap(16),
                                      SizedBox(
                                        width: double.infinity,
                                        height: 56,
                                        child: ElevatedButton(
                                          onPressed: isLoading ? null : _submit,
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: isDark
                                                ? Colors.white
                                                : Theme.of(context)
                                                    .primaryColor,
                                            foregroundColor: isDark
                                                ? const Color(0xFF0D47A1)
                                                : Colors.white,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(18)),
                                            elevation: isDark ? 0 : 8,
                                            shadowColor: Theme.of(context)
                                                .primaryColor
                                                .withOpacity(0.4),
                                          ),
                                          child: isLoading
                                              ? const CircularProgressIndicator()
                                              : TranslatedText(
                                                  l10n.signIn.toUpperCase(),
                                                  style: const TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w900,
                                                      letterSpacing: 1),
                                                ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),

                            // Khoảng trống linh hoạt giữa Card và Footer
                            if (!isKeyboardOpen)
                              const Spacer(flex: 2)
                            else
                              const Gap(24),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                TranslatedText(l10n.dontHaveAccount,
                                    style: TextStyle(
                                        color: isDark
                                            ? Colors.white.withOpacity(0.6)
                                            : Colors.blueGrey.shade600)),
                                GestureDetector(
                                  onTap: () {
                                    HapticFeedback.selectionClick();
                                    context.push(AppRoutes.register);
                                  },
                                  child: TranslatedText(
                                    l10n.signUp.toUpperCase(),
                                    style: TextStyle(
                                        color: isDark
                                            ? Colors.white
                                            : Theme.of(context).primaryColor,
                                        fontWeight: FontWeight.w900,
                                        decoration: TextDecoration.underline),
                                  ),
                                ),
                              ],
                            ),
                            const Gap(24),
                            FigmaAuthDivider(
                                label: l10n.orLogInWith,
                                color:
                                    isDark ? Colors.white24 : Colors.black12),
                            const Gap(16),
                            Row(
                              children: [
                                Expanded(
                                    child: _SocialBtn(
                                        icon: 'assets/images/Google.png',
                                        label: 'Google',
                                        isDark: isDark,
                                        onTap: () {
                                          HapticFeedback.mediumImpact();
                                          ref
                                              .read(
                                                  authNotifierProvider.notifier)
                                              .signInWithGoogle();
                                        })),
                                const Gap(16),
                                Expanded(
                                    child: _SocialBtn(
                                        icon: 'assets/images/Facebook.png',
                                        label: 'Facebook',
                                        isDark: isDark,
                                        onTap: () {
                                          HapticFeedback.mediumImpact();
                                          ref
                                              .read(
                                                  authNotifierProvider.notifier)
                                              .signInWithFacebook();
                                        })),
                              ],
                            ),

                            // Khoảng trống cuối cùng để nhấc Footer lên
                            if (!isKeyboardOpen)
                              const Spacer(flex: 2)
                            else
                              const Gap(24),
                          ],
                        ),
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
}

class _SocialBtn extends StatelessWidget {
  final String icon;
  final String label;
  final VoidCallback onTap;
  final bool isDark;
  const _SocialBtn(
      {required this.icon,
      required this.label,
      required this.onTap,
      required this.isDark});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            height: 58,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                  color: isDark
                      ? Colors.white.withOpacity(0.15)
                      : Colors.black.withOpacity(0.1)),
              color: isDark
                  ? Colors.white.withOpacity(0.05)
                  : Colors.white.withOpacity(0.3),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(icon, width: 24),
                const Gap(12),
                Text(label,
                    style: TextStyle(
                      color: isDark ? Colors.white : Colors.blueGrey.shade800,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

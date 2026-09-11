import 'dart:ui';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import 'package:fixit/shared/widgets/typography/translated_text.dart';
import 'package:fixit/shared/utils/snackbar_utils.dart';
import 'package:fixit/core/presentation/widgets/app_background.dart';
import 'package:fixit/l10n/app_localizations.dart';
import 'package:fixit/features/auth/presentation/providers/auth_provider.dart';
import 'package:fixit/features/auth/presentation/widgets/figma_auth_widgets.dart';

import '../../../../../shared/widgets/app_bar/auth_top_actions.dart';

import 'package:fixit/core/config/locale_provider.dart';
import 'package:fixit/core/services/translation_provider.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _agreeToTerms = false;

  void _showTermsBottomSheet() {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.85,
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1A1F2E) : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: Column(
          children: [
            const Gap(12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: isDark ? Colors.white24 : Colors.black12,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const Gap(20),
            TranslatedText(
              l10n.termsConditions,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
            const Gap(12),
            const Divider(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTermsSection(
                      "1. Accept terms",
                      "By registering an account and using the Fixit app, you confirm that you have read, understood and agree to be bound by these Terms and Conditions, along with our Privacy Policy.",
                      isDark,
                    ),
                    _buildTermsSection(
                      "2. Our services",
                      "Fixit provides a technology platform connecting users (Customers) who have needs for repairing and maintaining equipment with service providing partners (Technicians). Fixit does not directly provide repair services and is not responsible for the quality of the Technician's work unless otherwise specified.",
                      isDark,
                    ),
                    _buildTermsSection(
                      "3. User accounts",
                      "You must provide accurate, complete and up-to-date information. You are responsible for maintaining the confidentiality of your password and all activities that occur under your account. Fixit reserves the right to temporarily suspend or terminate an account if fraudulent or violating behavior is detected.",
                      isDark,
                    ),
                    _buildTermsSection(
                      "4. Payment regulations",
                      "Service prices displayed on the application are estimated prices. The final cost may change based on the actual condition of the device and the agreement between the Customer and the Technician. Payment can be made via cash or integrated e-wallets.",
                      isDark,
                    ),
                    _buildTermsSection(
                      "5. Cancellation policy",
                      "Customers have the right to cancel the order before the Technician starts moving. If the order is canceled when the Technician has arrived, a small moving fee may be applied to support the partner.",
                      isDark,
                    ),
                    _buildTermsSection(
                      "6. Intellectual property rights",
                      "All content, logo, design and source code of the Fixit application are our exclusive property. You are not allowed to copy, modify or use for commercial purposes without written consent.",
                      isDark,
                    ),
                    _buildTermsSection(
                      "7. Limitation of liability",
                      "To the extent permitted by law, Fixit will not be liable for any indirect, incidental or consequential damages arising from the use or inability to use the service.",
                      isDark,
                    ),
                    _buildTermsSection(
                      "8. Information security",
                      "We are committed to protecting your personal data according to the highest encryption standards. Your information is only shared with the Technician performing your order for the purpose of completing the service.",
                      isDark,
                    ),
                    _buildTermsSection(
                      "9. Changes to terms",
                      "Fixit reserves the right to modify these terms at any time. Changes will take effect as soon as they are posted on the application. Your continued use of the application after changes means that you accept the new terms.",
                      isDark,
                    ),
                    const Gap(40),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () => context.pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        isDark ? Colors.white : const Color(0xFF0D47A1),
                    foregroundColor:
                        isDark ? const Color(0xFF0D47A1) : Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                  ),
                  child: TranslatedText("I UNDERSTAND",
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTermsSection(String title, String content, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TranslatedText(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.blueAccent : const Color(0xFF0D47A1),
          ),
        ),
        const Gap(8),
        TranslatedText(
          content,
          style: TextStyle(
            fontSize: 14,
            height: 1.5,
            color: isDark ? Colors.white70 : Colors.black54,
          ),
        ),
        const Gap(24),
      ],
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final l10n = AppLocalizations.of(context)!;
    if (!_agreeToTerms) {
      AppSnackbar.showWarning(context, l10n.pleaseAgree);
      return;
    }

    HapticFeedback.mediumImpact();
    try {
      await ref.read(authNotifierProvider.notifier).register(
            email: _emailController.text.trim(),
            password: _passwordController.text,
            name: _nameController.text.trim(),
          );
    } catch (e) {
      debugPrint('Register: Submit error: $e');
    }
  }

  String _mapError(Object error, AppLocalizations l10n) {
    final value = error.toString().toLowerCase();

    if (value.contains('user_already_exists') ||
        value.contains('already exists')) {
      return l10n.errorEmailAlreadyExists;
    }

    if (value.contains('network') || value.contains('connection')) {
      return l10n.errorNetwork;
    }

    return l10n.errorUnknown;
  }

  @override
  Widget build(BuildContext context) {
    // TỐI ƯU: Chỉ watch isLoading
    final isLoading =
        ref.watch(authNotifierProvider.select((s) => s.isLoading));
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final locale = ref.watch(localeNotifierProvider);
    final targetLang = locale.languageCode;

    // Tải trước bản dịch cho Register Screen
    if (targetLang != 'en') {
      ref.watch(translatedBatchProvider([
        l10n.signUp,
        l10n.registerSubtitle,
        l10n.fullName,
        l10n.emailAddress,
        l10n.password,
        l10n.agreeTo,
        l10n.termsConditions,
        l10n.alreadyHaveAccount,
        l10n.signIn,
        l10n.orRegisterWith,
        "I UNDERSTAND",
        "1. Accept terms",
        "By registering an account and using the Fixit app, you confirm that you have read, understood and agree to be bound by these Terms and Conditions, along with our Privacy Policy.",
        "2. Our services",
        "Fixit provides a technology platform connecting users (Customers) who have needs for repairing and maintaining equipment with service providing partners (Technicians). Fixit does not directly provide repair services and is not responsible for the quality of the Technician's work unless otherwise specified.",
        "3. User accounts",
        "You must provide accurate, complete and up-to-date information. You are responsible for maintaining the confidentiality of your password and all activities that occur under your account. Fixit reserves the right to temporarily suspend or terminate an account if fraudulent or violating behavior is detected.",
        "4. Payment regulations",
        "Service prices displayed on the application are estimated prices. The final cost may change based on the actual condition of the device and the agreement between the Customer and the Technician. Payment can be made via cash or integrated e-wallets.",
        "5. Cancellation policy",
        "Customers have the right to cancel the order before the Technician starts moving. If the order is canceled when the Technician has arrived, a small moving fee may be applied to support the partner.",
        "6. Intellectual property rights",
        "All content, logo, design and source code of the Fixit application are our exclusive property. You are not allowed to copy, modify or use for commercial purposes without written consent.",
        "7. Limitation of liability",
        "To the extent permitted by law, Fixit will not be liable for any indirect, incidental or consequential damages arising from the use or inability to use the service.",
        "8. Information security",
        "We are committed to protecting your personal data according to the highest encryption standards. Your information is only shared with the Technician performing your order for the purpose of completing the service.",
        "9. Changes to terms",
        "Fixit reserves the right to modify these terms at any time. Changes will take effect as soon as they are posted on the application. Your continued use of the application after changes means that you accept the new terms.",
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
                              showBack: true,
                              onBack: () {
                                HapticFeedback.selectionClick();
                                context.pop();
                              },
                            ),

                            // Khoảng trống trên cùng
                            if (!isKeyboardOpen)
                              const Spacer(flex: 3)
                            else
                              const Gap(20),

                            // Logo Badge
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
                              l10n.signUp.toUpperCase(),
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
                              l10n.registerSubtitle,
                              style: TextStyle(
                                fontSize: 14,
                                color: isDark
                                    ? Colors.white.withOpacity(0.6)
                                    : Colors.blueGrey.shade600,
                                fontWeight: FontWeight.w500,
                              ),
                            ),

                            const Gap(24),

                            // Glassmorphism Form
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
                                        controller: _nameController,
                                        label: l10n.fullName,
                                        hint: 'John Doe',
                                        icon: Icons.person_outline_rounded,
                                        darkTheme: isDark,
                                        autofillHints: const [
                                          AutofillHints.name
                                        ],
                                        textInputAction: TextInputAction.next,
                                        validator: (value) =>
                                            (value == null || value.isEmpty)
                                                ? l10n.enterName
                                                : null,
                                      ),
                                      const Gap(16),
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
                                        validator: (value) => (value == null ||
                                                !value.contains('@'))
                                            ? l10n.enterEmail
                                            : null,
                                      ),
                                      const Gap(16),
                                      FigmaAuthTextField(
                                        controller: _passwordController,
                                        label: l10n.password,
                                        hint: l10n.passwordHint,
                                        icon: Icons.lock_person_outlined,
                                        isPassword: true,
                                        obscure: _obscurePassword,
                                        darkTheme: isDark,
                                        autofillHints: const [
                                          AutofillHints.newPassword
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

                                      // Terms Checkbox
                                      InkWell(
                                        onTap: () => setState(() =>
                                            _agreeToTerms = !_agreeToTerms),
                                        borderRadius: BorderRadius.circular(12),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 4),
                                          child: Row(
                                            children: [
                                              SizedBox(
                                                width: 20,
                                                height: 20,
                                                child: Checkbox(
                                                  value: _agreeToTerms,
                                                  onChanged: (v) => setState(
                                                      () => _agreeToTerms =
                                                          v ?? false),
                                                  activeColor: isDark
                                                      ? Colors.blueAccent
                                                      : Theme.of(context)
                                                          .primaryColor,
                                                  checkColor: Colors.white,
                                                  side: BorderSide(
                                                      color: isDark
                                                          ? Colors.white38
                                                          : Colors.black26,
                                                      width: 1.5),
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              4)),
                                                ),
                                              ),
                                              const Gap(12),
                                              Expanded(
                                                child: Wrap(
                                                  crossAxisAlignment: WrapCrossAlignment.center,
                                                  children: [
                                                    TranslatedText(
                                                      l10n.agreeTo,
                                                      style: TextStyle(
                                                        color: isDark
                                                            ? Colors.white
                                                                .withValues(alpha: 0.6)
                                                            : Colors.blueGrey
                                                                .shade700,
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                    GestureDetector(
                                                      onTap: () {
                                                        HapticFeedback
                                                            .selectionClick();
                                                        _showTermsBottomSheet();
                                                      },
                                                      child: TranslatedText(
                                                        l10n.termsConditions,
                                                        style: TextStyle(
                                                          color: isDark
                                                              ? Colors
                                                                  .blueAccent
                                                              : Theme.of(
                                                                      context)
                                                                  .primaryColor,
                                                          fontWeight:
                                                              FontWeight.w800,
                                                          fontSize: 12,
                                                          decoration:
                                                              TextDecoration
                                                                  .underline,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),

                                      const Gap(20),
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
                                                    BorderRadius.circular(16)),
                                            elevation: isDark ? 0 : 8,
                                            shadowColor: Theme.of(context)
                                                .primaryColor
                                                .withOpacity(0.4),
                                          ),
                                          child: isLoading
                                              ? const CircularProgressIndicator()
                                              : TranslatedText(
                                                  l10n.signUp.toUpperCase(),
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

                            // Khoảng trống linh hoạt giữa Form và Footer
                            if (!isKeyboardOpen)
                              const Spacer(flex: 2)
                            else
                              const Gap(24),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                TranslatedText(l10n.alreadyHaveAccount,
                                    style: TextStyle(
                                        color: isDark
                                            ? Colors.white.withOpacity(0.6)
                                            : Colors.blueGrey.shade600)),
                                GestureDetector(
                                  onTap: () {
                                    HapticFeedback.selectionClick();
                                    context.pop();
                                  },
                                  child: TranslatedText(
                                    l10n.signIn.toUpperCase(),
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
                                label: l10n.orRegisterWith,
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

                            // Khoảng trống cuối cùng
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
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
              color: isDark
                  ? Colors.white.withOpacity(0.1)
                  : Colors.black.withOpacity(0.05)),
          color: isDark
              ? Colors.white.withOpacity(0.05)
              : Colors.black.withOpacity(0.02),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(icon, width: 22),
            const Gap(10),
            Text(label,
                style: TextStyle(
                    color: isDark ? Colors.white : Colors.blueGrey.shade800,
                    fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}

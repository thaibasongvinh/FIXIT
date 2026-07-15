import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import 'package:fixit/shared/utils/snackbar_utils.dart';
import 'package:fixit/core/router/app_router.dart';
import 'package:fixit/core/presentation/widgets/app_background.dart';
import 'package:fixit/shared/widgets/app_bar/auth_top_actions.dart';
import 'package:fixit/l10n/app_localizations.dart';
import 'package:fixit/features/auth/presentation/providers/auth_provider.dart';
import 'package:fixit/features/auth/presentation/widgets/figma_auth_widgets.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> with SingleTickerProviderStateMixin {
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
    final isLoading = ref.watch(authNotifierProvider.select((s) => s.isLoading));
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    ref.listen(authNotifierProvider, (_, next) {
      next.whenOrNull(
        error: (error, _) => AppSnackbar.showError(context, _mapError(error, l10n)),
      );
    });

    return AppBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const AuthTopActions(),
                  const Gap(10),
                  Row(
                    children: [
                      if (context.canPop())
                        IconButton(
                          onPressed: () {
                            HapticFeedback.selectionClick();
                            context.pop();
                          },
                          icon: Icon(
                            Icons.arrow_back_ios_new, 
                            color: isDark ? Colors.white : Colors.black87, 
                            size: 22
                          ),
                        ),
                    ],
                  ),
                  const Gap(20),
                  
                  // Logo Badge
                  TweenAnimationBuilder<double>(
                    tween: Tween(begin: 1.0, end: 1.05),
                    duration: const Duration(seconds: 2),
                    curve: Curves.easeInOut,
                    builder: (context, value, child) {
                      return Container(
                        width: 110,
                        height: 110,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blueAccent.withValues(alpha: isDark ? 0.4 * value : 0.2),
                              blurRadius: 40,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: Center(
                          child: Container(
                            width: 90,
                            height: 90,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.8),
                                width: 4,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.1),
                                  blurRadius: 10,
                                  offset: const Offset(0, 5),
                                )
                              ],
                            ),
                            child: ClipOval(
                              child: Padding(
                                padding: const EdgeInsets.all(14),
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
                  const Gap(32),
                  Text(
                    l10n.welcomeBack,
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      color: isDark ? Colors.white : Colors.blueGrey.shade900,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const Gap(8),
                  Text(
                    l10n.loginSubtitle,
                    style: TextStyle(
                      fontSize: 16,
                      color: isDark ? Colors.white.withOpacity(0.6) : Colors.blueGrey.shade600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Gap(40),
                  
                  // Glassmorphism Card
                  ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                      child: Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: isDark ? Colors.white.withOpacity(0.08) : Colors.black.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                            color: isDark ? Colors.white.withOpacity(0.15) : Colors.black.withOpacity(0.05)
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            FigmaAuthTextField(
                              controller: _emailController,
                              label: l10n.emailAddress,
                              hint: l10n.emailHint,
                              icon: Icons.alternate_email_rounded,
                              darkTheme: isDark,
                              keyboardType: TextInputType.emailAddress,
                              autofillHints: const [AutofillHints.email],
                              textInputAction: TextInputAction.next,
                              validator: (value) => (value == null || value.isEmpty) ? l10n.enterEmail : null,
                            ),
                            const Gap(24),
                            FigmaAuthTextField(
                              controller: _passwordController,
                              label: l10n.password,
                              hint: l10n.passwordHint,
                              icon: Icons.lock_person_outlined,
                              isPassword: true,
                              obscure: _obscurePassword,
                              darkTheme: isDark,
                              autofillHints: const [AutofillHints.password],
                              textInputAction: TextInputAction.done,
                              onToggleVisibility: () => setState(() => _obscurePassword = !_obscurePassword),
                              validator: (value) => (value == null || value.length < 6) ? l10n.min6Chars : null,
                            ),
                            const Gap(12),
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () {
                                  HapticFeedback.selectionClick();
                                  context.push(AppRoutes.forgotPassword);
                                },
                                child: Text(
                                  l10n.forgotPasswordQuery,
                                  style: TextStyle(
                                    color: isDark ? Colors.white.withOpacity(0.7) : Theme.of(context).primaryColor,
                                    fontWeight: FontWeight.w600
                                  ),
                                ),
                              ),
                            ),
                            const Gap(24),
                            SizedBox(
                              width: double.infinity,
                              height: 62,
                              child: ElevatedButton(
                                onPressed: isLoading ? null : _submit,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: isDark ? Colors.white : Theme.of(context).primaryColor,
                                  foregroundColor: isDark ? const Color(0xFF0D47A1) : Colors.white,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                                  elevation: isDark ? 0 : 8,
                                  shadowColor: Theme.of(context).primaryColor.withOpacity(0.4),
                                ),
                                child: isLoading
                                  ? const CircularProgressIndicator()
                                  : Text(
                                      l10n.signIn.toUpperCase(),
                                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, letterSpacing: 1),
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  
                  const Gap(32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        l10n.dontHaveAccount, 
                        style: TextStyle(color: isDark ? Colors.white.withOpacity(0.6) : Colors.blueGrey.shade600)
                      ),
                      GestureDetector(
                        onTap: () {
                          HapticFeedback.selectionClick();
                          context.push(AppRoutes.register);
                        },
                        child: Text(
                          l10n.signUp,
                          style: TextStyle(
                            color: isDark ? Colors.white : Theme.of(context).primaryColor, 
                            fontWeight: FontWeight.w900, 
                            decoration: TextDecoration.underline
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Gap(40),
                  FigmaAuthDivider(
                    label: l10n.orLogInWith, 
                    color: isDark ? Colors.white24 : Colors.black12
                  ),
                  const Gap(24),
                  Row(
                    children: [
                      Expanded(
                        child: _SocialBtn(
                          icon: 'assets/images/Google.png', 
                          label: 'Google', 
                          isDark: isDark,
                          onTap: () {
                            HapticFeedback.mediumImpact();
                            ref.read(authNotifierProvider.notifier).signInWithGoogle();
                          }
                        )
                      ),
                      const Gap(16),
                      Expanded(
                        child: _SocialBtn(
                          icon: 'assets/images/Facebook.png', 
                          label: 'Facebook', 
                          isDark: isDark,
                          onTap: () {
                            HapticFeedback.mediumImpact();
                            ref.read(authNotifierProvider.notifier).signInWithFacebook();
                          }
                        )
                      ),
                    ],
                  ),
                  const Gap(40),
                ],
              ),
            ),
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
  const _SocialBtn({required this.icon, required this.label, required this.onTap, required this.isDark});

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
            color: isDark ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.05)
          ),
          color: isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.02),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(icon, width: 22),
            const Gap(10),
            Text(
              label, 
              style: TextStyle(
                color: isDark ? Colors.white : Colors.blueGrey.shade800, 
                fontWeight: FontWeight.bold
              )
            ),
          ],
        ),
      ),
    );
  }
}

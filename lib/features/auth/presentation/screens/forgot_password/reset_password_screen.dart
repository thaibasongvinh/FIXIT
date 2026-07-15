import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:fixit/core/router/app_router.dart';
import 'package:fixit/features/auth/presentation/providers/auth_provider.dart';
import 'package:fixit/features/auth/presentation/widgets/figma_auth_widgets.dart';
import 'package:fixit/shared/utils/snackbar_utils.dart';
import 'package:fixit/core/presentation/widgets/app_background.dart';
import 'package:fixit/l10n/app_localizations.dart';

import '../../../data/appwrite_auth_repository_impl.dart';

class ResetPasswordScreen extends ConsumerStatefulWidget {
  final String? userId;
  final String? secret;
  final String? email;

  const ResetPasswordScreen({
    super.key,
    this.userId,
    this.secret,
    this.email,
  });

  @override
  ConsumerState<ResetPasswordScreen> createState() =>
      _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends ConsumerState<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final l10n = AppLocalizations.of(context)!;
    HapticFeedback.mediumImpact();

    try {
      final notifier = ref.read(authNotifierProvider.notifier);
      final repo =
          ref.read(authRepositoryProvider) as AppwriteAuthRepositoryImpl;

      AppSnackbar.showInfo(context, l10n.settingNewPassword);

      await repo.resetPasswordWithOtpAdmin(
        email: widget.email ?? '',
        otp: widget.secret ?? '',
        newPassword: _passwordController.text,
      );

      if (mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (dialogContext) => Dialog(
            backgroundColor: Colors.transparent,
            insetPadding: const EdgeInsets.symmetric(horizontal: 32),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(32),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                child: Container(
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0D47A1).withOpacity(0.9),
                    borderRadius: BorderRadius.circular(32),
                    border: Border.all(color: Colors.white.withOpacity(0.2)),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.greenAccent.withOpacity(0.15),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.check_circle_rounded,
                            color: Colors.greenAccent, size: 56),
                      ),
                      const Gap(24),
                      Text(
                        l10n.success,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.w900,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const Gap(12),
                      Text(
                        l10n.passwordUpdatedSuccess,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          height: 1.5,
                        ),
                      ),
                      const Gap(32),
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: () async {
                            await notifier.signOut();
                            if (mounted) {
                              Navigator.of(dialogContext).pop();
                              context.go(AppRoutes.login);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: const Color(0xFF0D47A1),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16)),
                            elevation: 0,
                          ),
                          child: Text(
                            l10n.backToLogin,
                            style: const TextStyle(
                                fontWeight: FontWeight.w900,
                                fontSize: 15,
                                letterSpacing: 0.5),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        debugPrint('RESET PASSWORD ACTUAL ERROR: $e');
        String errorMessage = e.toString().toLowerCase();

        if (errorMessage.contains('invalid') ||
            errorMessage.contains('expired')) {
          errorMessage = l10n.otpInvalidOrExpired;
        } else {
          errorMessage = '${l10n.error}: $e';
        }

        AppSnackbar.showError(context, errorMessage);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authNotifierProvider).isLoading;
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        await ref.read(authNotifierProvider.notifier).signOut();
        if (context.mounted) context.go(AppRoutes.login);
      },
      child: AppBackground(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 10),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () async {
                          HapticFeedback.selectionClick();
                          await ref
                              .read(authNotifierProvider.notifier)
                              .signOut();
                          if (context.mounted) context.go(AppRoutes.login);
                        },
                        icon: Icon(
                          Icons.arrow_back_ios_new,
                          color: isDark ? Colors.white : Colors.black87,
                          size: 22,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          const Gap(20),
                          _buildLogoBadge(isDark),
                          const Gap(32),
                          Text(
                            l10n.newPassword,
                            style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.w900,
                                color: isDark ? Colors.white : Colors.blueGrey.shade900,
                                letterSpacing: -1),
                          ),
                          const Gap(8),
                          Text(
                            l10n.createStrongPassword,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 16,
                                color: isDark ? Colors.white.withOpacity(0.6) : Colors.blueGrey.shade600,
                                fontWeight: FontWeight.w500),
                          ),
                          const Gap(40),

                          ClipRRect(
                            borderRadius: BorderRadius.circular(30),
                            child: BackdropFilter(
                              filter:
                                  ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                              child: Container(
                                padding: const EdgeInsets.all(24),
                                decoration: BoxDecoration(
                                  color: isDark ? Colors.white.withOpacity(0.08) : Colors.black.withOpacity(0.05),
                                  borderRadius: BorderRadius.circular(30),
                                  border: Border.all(
                                      color: isDark ? Colors.white.withOpacity(0.15) : Colors.black.withOpacity(0.05)),
                                ),
                                child: Column(
                                  children: [
                                    FigmaAuthTextField(
                                      controller: _passwordController,
                                      label: l10n.newPassword,
                                      hint: '**********',
                                      icon: Icons.lock_outline_rounded,
                                      isPassword: true,
                                      obscure: _obscurePassword,
                                      darkTheme: isDark,
                                      autofillHints: const [AutofillHints.newPassword],
                                      textInputAction: TextInputAction.next,
                                      onToggleVisibility: () => setState(() =>
                                          _obscurePassword =
                                              !_obscurePassword),
                                      validator: (value) {
                                        if (value == null ||
                                            value.length < 8) {
                                          return l10n.passwordMin8;
                                        }
                                        return null;
                                      },
                                    ),
                                    const Gap(20),
                                    FigmaAuthTextField(
                                      controller: _confirmPasswordController,
                                      label: l10n.confirmPassword,
                                      hint: '**********',
                                      icon: Icons.vpn_key_outlined,
                                      isPassword: true,
                                      obscure: _obscureConfirmPassword,
                                      darkTheme: isDark,
                                      autofillHints: const [AutofillHints.newPassword],
                                      textInputAction: TextInputAction.done,
                                      onToggleVisibility: () => setState(() =>
                                          _obscureConfirmPassword =
                                              !_obscureConfirmPassword),
                                      validator: (value) {
                                        if (value !=
                                            _passwordController.text) {
                                          return l10n.passwordsDoNotMatch;
                                        }
                                        return null;
                                      },
                                    ),
                                    const Gap(40),
                                    SizedBox(
                                      width: double.infinity,
                                      height: 60,
                                      child: ElevatedButton(
                                        onPressed: isLoading ? null : _submit,
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: isDark ? Colors.white : Theme.of(context).primaryColor,
                                          foregroundColor: isDark ? const Color(0xFF0D47A1) : Colors.white,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(16)),
                                          elevation: isDark ? 0 : 8,
                                        ),
                                        child: isLoading
                                            ? const CircularProgressIndicator()
                                            : Text(l10n.savePassword,
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.w900,
                                                    fontSize: 16,
                                                    letterSpacing: 1)),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],),
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
          width: 110,
          height: 110,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.blueAccent.withOpacity(isDark ? 0.4 * value : 0.2),
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
                  color: Colors.white.withOpacity(0.8),
                  width: 3,
                ),
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
    );
  }
}

import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import 'package:fixit/features/auth/presentation/providers/auth_provider.dart';
import 'package:fixit/features/auth/presentation/widgets/figma_auth_widgets.dart';
import 'package:fixit/shared/utils/snackbar_utils.dart';
import 'package:fixit/core/router/app_router.dart';
import 'package:fixit/core/presentation/widgets/app_background.dart';
import 'package:fixit/l10n/app_localizations.dart';

import 'package:fixit/shared/widgets/typography/translated_text.dart';
import 'package:fixit/core/config/locale_provider.dart';
import 'package:fixit/core/services/translation_provider.dart';

class VerifyEmailScreen extends ConsumerStatefulWidget {
  final bool isForgotPassword;
  final String? email;
  const VerifyEmailScreen(
      {super.key, this.isForgotPassword = false, this.email});

  @override
  ConsumerState<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends ConsumerState<VerifyEmailScreen> {
  Timer? _timer;
  int _secondsRemaining = 0;
  String _otpCode = "";

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(authNotifierProvider.notifier).clearError();
    });
    _startTimer();
    if (!widget.isForgotPassword) {
      Future.delayed(
          const Duration(milliseconds: 500), () => _sendEmail(isInitial: true));
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    setState(() => _secondsRemaining = 60);
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      setState(
          () => _secondsRemaining > 0 ? _secondsRemaining-- : _timer?.cancel());
    });
  }

  Future<void> _sendEmail({bool isInitial = false}) async {
    final email =
        widget.email ?? ref.read(authStateProvider).valueOrNull?.email;
    if (email == null) return;
    final l10n = AppLocalizations.of(context)!;

    try {
      final notifier = ref.read(authNotifierProvider.notifier);
      await notifier.sendEmailOTP(email);

      if (mounted) {
        _startTimer();
        AppSnackbar.showSuccess(
            context,
            isInitial
                ? l10n.verificationCodeSentSmall
                : l10n.codeResentSuccess);
      }
    } catch (e) {
      if (mounted) AppSnackbar.showError(context, l10n.failedToSendCode);
    }
  }

  Future<void> _checkVerification() async {
    final l10n = AppLocalizations.of(context)!;
    if (_otpCode.length < 6) {
      return AppSnackbar.showError(context, l10n.enterAllDigits);
    }

    final email =
        widget.email ?? ref.read(authStateProvider).valueOrNull?.email;
    if (email == null) return;

    HapticFeedback.mediumImpact();
    try {
      final notifier = ref.read(authNotifierProvider.notifier);
      await notifier.verifyEmailOTP(email: email, otp: _otpCode.trim());

      if (mounted) {
        AppSnackbar.showSuccess(context, l10n.verificationSuccessful);
        if (widget.isForgotPassword) {
          final uri = Uri(
            path: AppRoutes.resetPassword,
            queryParameters: {'email': email},
          );
          context.go(uri.toString());
        } else {
          context.go(AppRoutes.roleSelection, extra: {'isRegistration': true});
        }
      }
    } catch (e) {
      if (mounted) AppSnackbar.showError(context, l10n.invalidOTP);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authNotifierProvider).isLoading;
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final locale = ref.watch(localeNotifierProvider);
    final targetLang = locale.languageCode;

    // Tải trước bản dịch cho Verify Email Screen
    if (targetLang != 'en') {
      ref.watch(translatedBatchProvider([
        'Email Verification',
        'Enter your email address to receive OTP',
        l10n.otpVerification,
        l10n.enterCodeSentTo,
        l10n.yourEmail,
        l10n.verify,
        l10n.didntReceiveCode,
        l10n.resendCode,
      ], targetLang));
    }

    return AppBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () async {
                        HapticFeedback.selectionClick();
                        if (widget.isForgotPassword) {
                          context.pop();
                        } else {
                          await ref
                              .read(authNotifierProvider.notifier)
                              .signOut();
                          if (mounted) context.go(AppRoutes.login);
                        }
                      },
                      icon: Icon(Icons.arrow_back_ios_new,
                          color: isDark ? Colors.white : Colors.black87,
                          size: 22),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    children: [
                      const Gap(20),
                      _buildLogoBadge(isDark),
                      const Gap(32),
                      TranslatedText(
                        l10n.emailVerification,
                        style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w900,
                            color: isDark
                                ? Colors.white
                                : Colors.blueGrey.shade900,
                            letterSpacing: -1),
                      ),
                      const Gap(8),
                      TranslatedText(
                        l10n.enterEmailToReceiveOTP,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 16,
                            color: isDark
                                ? Colors.white.withValues(alpha: 0.6)
                                : Colors.blueGrey.shade600,
                            fontWeight: FontWeight.w500),
                      ),
                      Text(
                        widget.email ?? l10n.yourEmail,
                        style: TextStyle(
                            fontSize: 14,
                            color: isDark ? Colors.blueAccent : Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold),
                      ),
                      const Gap(40),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                          child: Container(
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? Colors.white.withOpacity(0.08)
                                  : Colors.black.withOpacity(0.05),
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(
                                  color: isDark
                                      ? Colors.white.withOpacity(0.15)
                                      : Colors.black.withOpacity(0.05)),
                            ),
                            child: Column(
                              children: [
                                // PIN Input thích ứng theo theme
                                FigmaAuthPINInput(
                                  key: const ValueKey('otp_input'),
                                  length: 6,
                                  darkTheme: isDark,
                                  onChanged: (code) =>
                                      setState(() => _otpCode = code),
                                ),
                                const Gap(40),
                                SizedBox(
                                  width: double.infinity,
                                  height: 60,
                                  child: ElevatedButton(
                                    onPressed:
                                        isLoading ? null : _checkVerification,
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
                                    child: isLoading
                                        ? const CircularProgressIndicator()
                                        : TranslatedText(l10n.verify,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w900,
                                                fontSize: 16,
                                                letterSpacing: 2)),
                                  ),
                                ),
                                const Gap(32),
                                _ResendSection(
                                  seconds: _secondsRemaining,
                                  onResend: _sendEmail,
                                  isDark: isDark,
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
            ],
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
          width: 115,
          height: 115,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color:
                    Colors.blueAccent.withOpacity(isDark ? 0.4 * value : 0.2),
                blurRadius: 40,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Center(
            child: Container(
              width: 95,
              height: 95,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                border: Border.all(
                  color: Colors.white.withOpacity(0.8),
                  width: 4,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
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
    );
  }
}

class _ResendSection extends StatelessWidget {
  final int seconds;
  final VoidCallback onResend;
  final bool isDark;
  const _ResendSection(
      {required this.seconds, required this.onResend, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      children: [
        TranslatedText(
          l10n.didntReceiveCode,
          style: TextStyle(
              color: isDark
                  ? Colors.white.withOpacity(0.5)
                  : Colors.blueGrey.shade600,
              fontSize: 14),
        ),
        const Gap(8),
        TextButton(
          onPressed: seconds == 0 ? onResend : null,
          child: TranslatedText(
            seconds == 0 ? l10n.resendCode : l10n.resendIn(seconds),
            style: TextStyle(
              color: seconds == 0
                  ? (isDark ? Colors.white : Theme.of(context).primaryColor)
                  : (isDark ? Colors.white24 : Colors.black26),
              fontWeight: FontWeight.w800,
              letterSpacing: 1,
              decoration: seconds == 0 ? TextDecoration.underline : null,
            ),
          ),
        ),
      ],
    );
  }
}

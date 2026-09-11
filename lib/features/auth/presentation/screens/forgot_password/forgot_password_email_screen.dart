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
import 'package:fixit/l10n/app_localizations.dart';
import 'package:fixit/core/presentation/widgets/app_background.dart';

import 'package:fixit/shared/widgets/typography/translated_text.dart';
import 'package:fixit/core/config/locale_provider.dart';
import 'package:fixit/core/services/translation_provider.dart';
import '../../../../../shared/widgets/app_bar/auth_top_actions.dart';

import 'package:fixit/shared/widgets/typography/translated_text.dart';
import 'package:fixit/core/config/locale_provider.dart';
import 'package:fixit/core/services/translation_provider.dart';

class ForgotPasswordEmailScreen extends ConsumerStatefulWidget {
  const ForgotPasswordEmailScreen({super.key});

  @override
  ConsumerState<ForgotPasswordEmailScreen> createState() =>
      _ForgotPasswordEmailScreenState();
}

class _ForgotPasswordEmailScreenState
    extends ConsumerState<ForgotPasswordEmailScreen> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  Timer? _timer;
  int _secondsRemaining = 0;

  @override
  void dispose() {
    _emailController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    setState(() => _secondsRemaining = 60);
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      setState(() {
        if (_secondsRemaining > 0) {
          _secondsRemaining--;
        } else {
          _timer?.cancel();
        }
      });
    });
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_secondsRemaining > 0) return;

    final email = _emailController.text.trim();
    final l10n = AppLocalizations.of(context)!;
    HapticFeedback.mediumImpact();
    
    try {
      final notifier = ref.read(authNotifierProvider.notifier);
      final exists = await notifier.checkEmailExists(email);
      if (!exists) {
        if (mounted)
          AppSnackbar.showError(context, l10n.accountNotRegistered);
        return;
      }

      await notifier.sendEmailOTP(email);

      if (mounted) {
        _startTimer();
        AppSnackbar.showSuccess(
            context, l10n.verificationCodeSent);
        final uri = Uri(
          path: AppRoutes.verifyEmail,
          queryParameters: {
            'isForgotPassword': 'true',
            'email': email,
          },
        );
        context.push(uri.toString());
      }
    } catch (e) {
      if (mounted) {
        final error = e.toString();
        if (error.contains('rate_limit_exceeded') || error.contains('429')) {
          _startTimer();
          AppSnackbar.showError(context, l10n.tooManyRequests);
        } else {
          AppSnackbar.showError(context, '${l10n.error}: $error');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authNotifierProvider).isLoading;
    final canSubmit = _secondsRemaining == 0 && !isLoading;
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
                            const Spacer(flex: 3),
                            _buildLogoBadge(isDark),
                            const Gap(24),
                            TranslatedText(
                              l10n.emailVerification,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.w900,
                                  color: isDark ? Colors.white : Colors.blueGrey.shade900,
                                  letterSpacing: -0.5),
                            ),
                            const Gap(8),
                            TranslatedText(
                              l10n.enterEmailToReceiveOTP,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 14,
                                  color: isDark ? Colors.white.withOpacity(0.6) : Colors.blueGrey.shade600,
                                  fontWeight: FontWeight.w500),
                            ),
                            const Gap(32),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(30),
                              child: BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
                                child: Container(
                                  padding: const EdgeInsets.all(24),
                                  decoration: BoxDecoration(
                                    color: isDark ? Colors.white.withOpacity(0.03) : Colors.white.withOpacity(0.4),
                                    borderRadius: BorderRadius.circular(30),
                                    border: Border.all(
                                        color: isDark ? Colors.white.withOpacity(0.15) : Colors.white.withOpacity(0.6),
                                        width: 0.8),
                                  ),
                                  child: Column(
                                    children: [
                                      FigmaAuthTextField(
                                        controller: _emailController,
                                        label: l10n.emailAddress,
                                        hint: l10n.emailHint,
                                        icon: Icons.alternate_email_rounded,
                                        darkTheme: isDark,
                                        keyboardType: TextInputType.emailAddress,
                                        autofillHints: const [AutofillHints.email],
                                        textInputAction: TextInputAction.done,
                                        validator: (value) => (value == null ||
                                                !value.contains('@'))
                                            ? l10n.enterEmail
                                            : null,
                                      ),
                                      const Gap(32),
                                      SizedBox(
                                        width: double.infinity,
                                        height: 56,
                                        child: ElevatedButton(
                                          onPressed: canSubmit ? _submit : null,
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: canSubmit
                                                ? (isDark ? Colors.white : Theme.of(context).primaryColor)
                                                : (isDark ? Colors.white.withOpacity(0.3) : Colors.black12),
                                            foregroundColor: isDark ? const Color(0xFF0D47A1) : Colors.white,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(16)),
                                            elevation: canSubmit ? (isDark ? 0 : 8) : 0,
                                          ),
                                          child: isLoading
                                              ? const CircularProgressIndicator()
                                              : TranslatedText(
                                                  _secondsRemaining > 0
                                                      ? l10n.waitSeconds(_secondsRemaining)
                                                      : l10n.sendCode,
                                                  style: const TextStyle(
                                                      fontWeight: FontWeight.w900,
                                                      fontSize: 16,
                                                      letterSpacing: 1)),
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
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildLogoBadge(bool isDark) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
              color: Colors.blueAccent.withOpacity(isDark ? 0.3 : 0.1),
              blurRadius: 40,
              spreadRadius: 5)
        ],
      ),
      child: Center(
        child: Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            border: Border.all(color: Colors.white.withOpacity(0.8), width: 3),
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
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:fixit/core/router/app_router.dart';
import 'package:fixit/features/auth/presentation/providers/auth_provider.dart';
import 'package:fixit/shared/models/user_model.dart';
import 'package:fixit/features/auth/presentation/providers/login_success_provider.dart';
import 'package:fixit/features/auth/presentation/widgets/figma_auth_widgets.dart';

import 'package:fixit/shared/utils/snackbar_utils.dart';

import 'package:fixit/l10n/app_localizations.dart';
import 'package:fixit/shared/widgets/typography/translated_text.dart';
import 'package:fixit/core/config/locale_provider.dart';
import 'package:fixit/core/services/translation_provider.dart';

class PhoneVerificationScreen extends ConsumerStatefulWidget {
  final UserRole? role;
  const PhoneVerificationScreen({super.key, this.role});

  @override
  ConsumerState<PhoneVerificationScreen> createState() =>
      _PhoneVerificationScreenState();
}

class _PhoneVerificationScreenState
    extends ConsumerState<PhoneVerificationScreen> {
  final TextEditingController _controller = TextEditingController();
  bool _isCountryListOpen = false;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(loginSuccessNotifierProvider.notifier).clear();
    });
  }

  final List<Map<String, String>> _countries = [
    {'name': 'Afghanistan', 'code': '+93', 'flag': '🇦🇫'},
    {'name': 'Albania', 'code': '+355', 'flag': '🇦🇱'},
    {'name': 'Algeria', 'code': '+213', 'flag': '🇩🇿'},
    {'name': 'Andorra', 'code': '+376', 'flag': '🇦🇩'},
    {'name': 'Angola', 'code': '+244', 'flag': '🇦🇴'},
    {'name': 'Anguilla', 'code': '+1', 'flag': '🇦🇮'},
    {'name': 'Antigua', 'code': '+1', 'flag': '🇦🇬'},
    {'name': 'Argentina', 'code': '+54', 'flag': '🇦🇷'},
    {'name': 'Armenia', 'code': '+374', 'flag': '🇦🇲'},
    {'name': 'Australia', 'code': '+61', 'flag': '🇦🇺'},
    {'name': 'Austria', 'code': '+43', 'flag': '🇦🇹'},
    {'name': 'Azerbaijan', 'code': '+994', 'flag': '🇦🇿'},
    {'name': 'Bahamas', 'code': '+1', 'flag': '🇧🇸'},
    {'name': 'Việt Nam', 'code': '+84', 'flag': '🇻🇳'},
  ];

  Map<String, String> _selectedCountry = {
    'name': 'Việt Nam',
    'code': '+84',
    'flag': '🇻🇳'
  };

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onInputChanged(String value) {
    String digitsOnly = value.replaceAll(RegExp(r'\D'), '');
    if (digitsOnly.length > 10) {
      digitsOnly = digitsOnly.substring(0, 10);
    }
    _controller.text = digitsOnly;
    _controller.selection = TextSelection.fromPosition(
        TextPosition(offset: _controller.text.length));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isLoading = ref.watch(authNotifierProvider).isLoading;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    bool isButtonEnabled = _controller.text.length >= 9 && _errorText == null;

    final locale = ref.watch(localeNotifierProvider);
    final targetLang = locale.languageCode;

    // Tải trước bản dịch cho Phone Verification Screen (từ English sang targetLang)
    if (targetLang != 'en') {
      ref.watch(translatedBatchProvider([
        'Phone Verification',
        'Enter your phone number to receive OTP',
        'Skip for now',
        'SEND CODE',
        'Vui lòng nhập số điện thoại',
      ], targetLang));
    }

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: FigmaAuthHeader(
                onBack: () => context.pushReplacement(AppRoutes.roleSelection),
                currentStep: 2,
              ),
            ),
            Expanded(
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Gap(40),
                        const TranslatedText('Phone Verification',
                            style: TextStyle(
                                fontSize: 32, fontWeight: FontWeight.w900)),
                        const Gap(8),
                        const TranslatedText('Enter your phone number to receive OTP',
                            style: TextStyle(fontSize: 16, color: Colors.grey)),
                        const Gap(40),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: _errorText != null
                                  ? Colors.red
                                  : kFixitBorder,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () => setState(() =>
                                    _isCountryListOpen = !_isCountryListOpen),
                                child: Row(
                                  children: [
                                    Text(_selectedCountry['flag']!,
                                        style: const TextStyle(fontSize: 24)),
                                    const Gap(4),
                                    const Icon(Icons.keyboard_arrow_down,
                                        color: Colors.grey),
                                  ],
                                ),
                              ),
                              const Gap(12),
                              const Text('|',
                                  style: TextStyle(
                                      fontSize: 24,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w200)),
                              const Gap(12),
                              Text('${_selectedCountry['code']} ',
                                  style: const TextStyle(
                                      fontSize: 18, color: Color(0xFF424242))),
                              Expanded(
                                child: TextField(
                                  controller: _controller,
                                  onChanged: _onInputChanged,
                                  keyboardType: TextInputType.phone,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                  ],
                                  style: TextStyle(fontSize: 18, color: isDark ? Colors.white : const Color(0xFF424242)),
                                  decoration: const InputDecoration(
                                    hintText: '345 986 4343',
                                    border: InputBorder.none,
                                    hintStyle: TextStyle(color: Colors.grey),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (_errorText != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 8, left: 4),
                            child: TranslatedText(_errorText!,
                                style: const TextStyle(
                                    color: Colors.red, fontSize: 13)),
                          ),
                        const Spacer(),
                        Center(
                          child: TextButton(
                            onPressed: isLoading
                                ? null
                                : () async {
                                    // 1. Luồng Skip for now: Cập nhật Role (nếu chưa có) và BẮT BUỘC Logout
                                    if (widget.role != null) {
                                      await ref
                                          .read(authNotifierProvider.notifier)
                                          .updateRole(widget.role!);
                                    }

                                    // Gọi signOut để kết thúc luồng thiết lập
                                    await ref
                                        .read(authNotifierProvider.notifier)
                                        .signOut();

                                    if (!mounted) return;
                                    AppSnackbar.showSuccess(context,
                                        'Setup successful. Please log in again.');
                                    context.go(AppRoutes.login);
                                  },
                            child: const TranslatedText(
                              'Skip for now',
                              style: TextStyle(
                                color: kFixitMutedText,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ),
                        const Gap(16),
                        FigmaAuthPrimaryButton(
                          label: 'SEND CODE',
                          onPressed: isButtonEnabled && !isLoading
                              ? _onSendCode
                              : null,
                          isLoading: isLoading,
                        ),
                        const Gap(20),
                      ],
                    ),
                  ),
                  if (_isCountryListOpen)
                    Positioned.fill(
                      top: 150,
                      child: Container(
                        color: isDark ? const Color(0xFF1A1F2E) : Colors.white,
                        child: ListView.builder(
                          itemCount: _countries.length,
                          itemBuilder: (context, index) {
                            final country = _countries[index];
                            return ListTile(
                              leading: Text(country['flag']!,
                                  style: const TextStyle(fontSize: 24)),
                              title: TranslatedText(country['name']!,
                                  style: TextStyle(fontSize: 16, color: isDark ? Colors.white : Colors.black87)),
                              trailing: Text(country['code']!,
                                  style: const TextStyle(
                                      color: kFixitBlue,
                                      fontWeight: FontWeight.w500)),
                              onTap: () {
                                setState(() {
                                  _selectedCountry = country;
                                  _isCountryListOpen = false;
                                });
                              },
                            );
                          },
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onSendCode() async {
    final phone = _controller.text.trim();
    if (phone.isEmpty) {
      setState(() => _errorText = 'Vui lòng nhập số điện thoại');
      return;
    }

    String formattedPhone = '${_selectedCountry['code']}$phone';

    try {
      final challenge =
          await ref.read(authNotifierProvider.notifier).startPhoneVerification(
                phoneNumber: formattedPhone,
              );

      if (mounted) {
        context.push(
          AppRoutes.verifyPhone,
          extra: {
            'phoneNumber': formattedPhone,
            'verificationId': challenge.verificationId,
          },
        );
      }
    } catch (e) {
      if (mounted) {
        AppSnackbar.showError(context, 'Lỗi: $e');
      }
    }
  }
}

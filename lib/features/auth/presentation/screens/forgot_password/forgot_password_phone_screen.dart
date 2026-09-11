import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:fixit/core/router/app_router.dart';
import 'package:fixit/features/auth/presentation/providers/auth_provider.dart';
import 'package:fixit/shared/utils/snackbar_utils.dart';
import 'package:fixit/features/auth/presentation/widgets/figma_auth_widgets.dart';
import 'package:fixit/core/presentation/widgets/app_background.dart';
import 'package:fixit/l10n/app_localizations.dart';

import 'package:fixit/shared/widgets/typography/translated_text.dart';
import 'package:fixit/core/config/locale_provider.dart';
import 'package:fixit/core/services/translation_provider.dart';
import '../../../../../shared/widgets/app_bar/auth_top_actions.dart';

class ForgotPasswordPhoneScreen extends ConsumerStatefulWidget {
  const ForgotPasswordPhoneScreen({super.key});

  @override
  ConsumerState<ForgotPasswordPhoneScreen> createState() => _ForgotPasswordPhoneScreenState();
}

class _ForgotPasswordPhoneScreenState extends ConsumerState<ForgotPasswordPhoneScreen> {
  final TextEditingController _controller = TextEditingController();
  bool _isCountryListOpen = false;
  String? _errorText;

  final List<Map<String, String>> _countries = [
    {'name': 'Vietnam', 'code': '+84', 'flag': '🇻🇳'},
    {'name': 'Afghanistan', 'code': '+93', 'flag': '🇦🇫'},
    {'name': 'Armenia', 'code': '+374', 'flag': '🇦🇲'},
    {'name': 'Azerbaijan', 'code': '+994', 'flag': '🇦🇿'},
    {'name': 'Bahrain', 'code': '+973', 'flag': '🇧🇭'},
    {'name': 'Bangladesh', 'code': '+880', 'flag': '🇧🇩'},
    {'name': 'Bhutan', 'code': '+975', 'flag': '🇧🇹'},
    {'name': 'Brunei', 'code': '+673', 'flag': '🇧🇳'},
    {'name': 'Cambodia', 'code': '+855', 'flag': '🇰🇭'},
    {'name': 'China', 'code': '+86', 'flag': '🇨🇳'},
    {'name': 'Cyprus', 'code': '+357', 'flag': '🇨🇾'},
    {'name': 'Georgia', 'code': '+995', 'flag': '🇬🇪'},
    {'name': 'India', 'code': '+91', 'flag': '🇮🇳'},
    {'name': 'Indonesia', 'code': '+62', 'flag': '🇮🇩'},
    {'name': 'Iran', 'code': '+98', 'flag': '🇮🇷'},
    {'name': 'Iraq', 'code': '+964', 'flag': '🇮🇶'},
    {'name': 'Israel', 'code': '+972', 'flag': '🇮🇱'},
    {'name': 'Japan', 'code': '+81', 'flag': '🇯🇵'},
    {'name': 'Jordan', 'code': '+962', 'flag': '🇯🇴'},
    {'name': 'Kazakhstan', 'code': '+7', 'flag': '🇰🇿'},
    {'name': 'Kuwait', 'code': '+965', 'flag': '🇰🇼'},
    {'name': 'Kyrgyzstan', 'code': '+996', 'flag': '🇰🇬'},
    {'name': 'Laos', 'code': '+856', 'flag': '🇱🇦'},
    {'name': 'Lebanon', 'code': '+961', 'flag': '🇱🇧'},
    {'name': 'Malaysia', 'code': '+60', 'flag': '🇲🇾'},
    {'name': 'Maldives', 'code': '+960', 'flag': '🇲🇻'},
    {'name': 'Mongolia', 'code': '+976', 'flag': '🇲🇳'},
    {'name': 'Myanmar', 'code': '+95', 'flag': '🇲🇲'},
    {'name': 'Nepal', 'code': '+977', 'flag': '🇳🇵'},
    {'name': 'North Korea', 'code': '+850', 'flag': '🇰🇵'},
    {'name': 'Oman', 'code': '+968', 'flag': '🇴🇲'},
    {'name': 'Pakistan', 'code': '+92', 'flag': '🇵🇰'},
    {'name': 'Palestine', 'code': '+970', 'flag': '🇵🇸'},
    {'name': 'Philippines', 'code': '+63', 'flag': '🇵🇭'},
    {'name': 'Qatar', 'code': '+974', 'flag': '🇶🇦'},
    {'name': 'Saudi Arabia', 'code': '+966', 'flag': '🇸🇦'},
    {'name': 'Singapore', 'code': '+65', 'flag': '🇸🇬'},
    {'name': 'South Korea', 'code': '+82', 'flag': '🇰🇷'},
    {'name': 'Sri Lanka', 'code': '+94', 'flag': '🇱🇰'},
    {'name': 'Syria', 'code': '+963', 'flag': '🇸🇾'},
    {'name': 'Taiwan', 'code': '+886', 'flag': '🇹🇼'},
    {'name': 'Tajikistan', 'code': '+992', 'flag': '🇹🇯'},
    {'name': 'Thailand', 'code': '+66', 'flag': '🇹🇭'},
    {'name': 'Timor-Leste', 'code': '+670', 'flag': '🇹🇱'},
    {'name': 'Turkey', 'code': '+90', 'flag': '🇹🇷'},
    {'name': 'Turkmenistan', 'code': '+993', 'flag': '🇹🇲'},
    {'name': 'UAE', 'code': '+971', 'flag': '🇦🇪'},
    {'name': 'Uzbekistan', 'code': '+998', 'flag': '🇺🇿'},
    {'name': 'Yemen', 'code': '+967', 'flag': '🇾🇪'},
  ];

  Map<String, String> _selectedCountry = {'name': 'Vietnam', 'code': '+84', 'flag': '🇻🇳'};

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onInputChanged(String value) {
    if (value.startsWith('0')) {
      _controller.text = value.substring(1);
      _controller.selection = TextSelection.fromPosition(TextPosition(offset: _controller.text.length));
      return;
    }
    setState(() => _errorText = (value.replaceAll(' ', '').length > 9) ? 'Max 9 digits' : null);
  }

  Future<void> _onSendCode() async {
    final phone = _controller.text.replaceAll(' ', '').trim();
    if (phone.length < 9) {
      setState(() => _errorText = 'Enter 9 digits');
      return;
    }

    String formattedPhone = '${_selectedCountry['code']}$phone';
    final l10n = AppLocalizations.of(context)!;
    HapticFeedback.mediumImpact();
    
    try {
      final exists = await ref.read(authNotifierProvider.notifier).checkPhoneExists(formattedPhone);
      if (!exists) {
        if (mounted) AppSnackbar.showError(context, l10n.accountNotRegistered);
        return;
      }
      final challenge = await ref.read(authNotifierProvider.notifier).startPhoneVerification(phoneNumber: formattedPhone);
      if (mounted) {
        AppSnackbar.showSuccess(context, l10n.verificationCodeSent);
        context.push(AppRoutes.verifyPhone, extra: {
          'phoneNumber': formattedPhone, 
          'verificationId': challenge.verificationId, 
          'isForgotPassword': true
        });
      }
    } catch (e) {
      if (mounted) AppSnackbar.showError(context, '${l10n.error}: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authNotifierProvider).isLoading;
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    bool isButtonEnabled = _controller.text.replaceAll(' ', '').length >= 9 && _errorText == null;

    final targetLang = ref.watch(localeNotifierProvider).languageCode;

    // Tải trước bản dịch cho Forgot Password Phone Screen
    if (targetLang != 'en') {
      ref.watch(translatedBatchProvider([
        l10n.phoneVerification,
        l10n.enterPhoneToReceiveOTP,
        l10n.sendCode,
      ], targetLang));
    }

    return AppBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Stack(
                children: [
                  SingleChildScrollView(
                    physics: const ClampingScrollPhysics(),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(minHeight: constraints.maxHeight),
                      child: IntrinsicHeight(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
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
                                l10n.phoneVerification, 
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 28, 
                                  fontWeight: FontWeight.w900, 
                                  color: isDark ? Colors.white : Colors.blueGrey.shade900, 
                                  letterSpacing: -0.5
                                ),
                              ),
                              const Gap(8),
                              TranslatedText(
                                l10n.enterPhoneToReceiveOTP,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 14, 
                                  color: isDark ? Colors.white.withOpacity(0.6) : Colors.blueGrey.shade600, 
                                  fontWeight: FontWeight.w500
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
                                      color: isDark ? Colors.white.withOpacity(0.03) : Colors.white.withOpacity(0.4),
                                      borderRadius: BorderRadius.circular(30),
                                      border: Border.all(
                                          color: isDark ? Colors.white.withOpacity(0.15) : Colors.white.withOpacity(0.6),
                                          width: 0.8),
                                    ),
                                    child: Column(
                                      children: [
                                        _buildPhoneInput(isDark),
                                        if (_errorText != null)
                                          Padding(
                                            padding: const EdgeInsets.only(top: 8),
                                            child: TranslatedText(_errorText!, style: const TextStyle(color: Color(0xFFFF5252), fontSize: 12)),
                                          ),
                                        const Gap(32),
                                        SizedBox(
                                          width: double.infinity,
                                          height: 56,
                                          child: ElevatedButton(
                                            onPressed: isButtonEnabled && !isLoading ? _onSendCode : null,
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: isButtonEnabled 
                                                  ? (isDark ? Colors.white : Theme.of(context).primaryColor) 
                                                  : (isDark ? Colors.white.withOpacity(0.3) : Colors.black12),
                                              foregroundColor: isDark ? const Color(0xFF0D47A1) : Colors.white,
                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                              elevation: isButtonEnabled && !isDark ? 8 : 0,
                                            ),
                                            child: isLoading 
                                              ? const CircularProgressIndicator()
                                              : TranslatedText(
                                                  l10n.sendCode, 
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.w900, 
                                                    fontSize: 16, 
                                                    letterSpacing: 1,
                                                  )
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
                  ),
                  if (_isCountryListOpen) _buildCountryPicker(),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildLogoBadge(bool isDark) {
    return Container(
      width: 100, height: 100,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.blueAccent.withOpacity(isDark ? 0.3 : 0.1),
            blurRadius: 40,
            spreadRadius: 5
          )
        ],
      ),
      child: Center(
        child: Container(
          width: 80, height: 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            border: Border.all(color: Colors.white.withOpacity(0.8), width: 3),
          ),
          child: ClipOval(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Image.asset('assets/images/app_icon.png', fit: BoxFit.contain),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPhoneInput(bool isDark) {
    final textColor = isDark ? Colors.white : Colors.blueGrey.shade900;
    return Container(
      height: 65,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.02),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? Colors.white.withOpacity(0.15) : Colors.black.withOpacity(0.05)),
      ),
      child: Row(
        children: [
          InkWell(
            onTap: () => setState(() => _isCountryListOpen = !_isCountryListOpen),
            child: Row(
              children: [
                Text(_selectedCountry['flag']!, style: const TextStyle(fontSize: 24)),
                const Gap(4),
                Icon(Icons.keyboard_arrow_down_rounded, color: isDark ? Colors.white70 : Colors.blueGrey, size: 20),
              ],
            ),
          ),
          const Gap(12),
          Container(width: 1, height: 24, color: isDark ? Colors.white24 : Colors.black12),
          const Gap(12),
          Text(_selectedCountry['code']!, style: TextStyle(fontSize: 17, color: textColor, fontWeight: FontWeight.bold)),
          const Gap(8),
          Expanded(
            child: TextField(
              controller: _controller,
              onChanged: _onInputChanged,
              keyboardType: TextInputType.phone,
              style: TextStyle(fontSize: 17, color: textColor, fontWeight: FontWeight.w600),
              cursorColor: Colors.blueAccent,
              decoration: InputDecoration(
                hintText: '345 986 4343',
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                contentPadding: EdgeInsets.zero,
                hintStyle: TextStyle(color: isDark ? Colors.white24 : Colors.black26, fontWeight: FontWeight.w400),
                fillColor: Colors.transparent,
                filled: false,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCountryPicker() {
    return Positioned.fill(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: GestureDetector(
          onTap: () => setState(() => _isCountryListOpen = false),
          child: Container(
            color: Colors.black.withOpacity(0.6),
            child: Center(
              child: Container(
                margin: const EdgeInsets.all(32),
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.dark ? const Color(0xFF1A237E) : Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: Colors.white.withOpacity(0.1)),
                ),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _countries.length,
                  itemBuilder: (context, index) {
                    final c = _countries[index];
                    final isDark = Theme.of(context).brightness == Brightness.dark;
                    return ListTile(
                      leading: Text(c['flag']!, style: const TextStyle(fontSize: 24)),
                      title: Text(c['name']!, style: TextStyle(color: isDark ? Colors.white : Colors.black87, fontWeight: FontWeight.bold)),
                      trailing: Text(c['code']!, style: const TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold)),
                      onTap: () => setState(() { _selectedCountry = c; _isCountryListOpen = false; }),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

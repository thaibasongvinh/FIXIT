import 'dart:ui';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import 'package:fixit/shared/utils/snackbar_utils.dart';
import 'package:fixit/core/presentation/widgets/app_background.dart';
import 'package:fixit/l10n/app_localizations.dart';
import 'package:fixit/features/auth/presentation/providers/auth_provider.dart';
import 'package:fixit/features/auth/presentation/widgets/figma_auth_widgets.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> with SingleTickerProviderStateMixin {
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
            Text(
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
                      "1. Chấp thuận điều khoản",
                      "Bằng việc đăng ký tài khoản và sử dụng ứng dụng Fixit, bạn xác nhận đã đọc, hiểu và đồng ý bị ràng buộc bởi các Điều khoản và Điều kiện này, cùng với Chính sách bảo mật của chúng tôi.",
                      isDark,
                    ),
                    _buildTermsSection(
                      "2. Dịch vụ của chúng tôi",
                      "Fixit cung cấp một nền tảng công nghệ kết nối người dùng (Khách hàng) có nhu cầu sửa chữa, bảo trì thiết bị với các đối tác cung cấp dịch vụ (Kỹ thuật viên). Fixit không trực tiếp cung cấp dịch vụ sửa chữa và không chịu trách nhiệm về chất lượng công việc của Kỹ thuật viên trừ khi có quy định khác.",
                      isDark,
                    ),
                    _buildTermsSection(
                      "3. Tài khoản người dùng",
                      "Bạn phải cung cấp thông tin chính xác, đầy đủ và cập nhật. Bạn chịu trách nhiệm bảo mật mật khẩu và mọi hoạt động diễn ra dưới tài khoản của mình. Fixit có quyền tạm khóa hoặc chấm dứt tài khoản nếu phát hiện hành vi gian lận hoặc vi phạm.",
                      isDark,
                    ),
                    _buildTermsSection(
                      "4. Quy định về thanh toán",
                      "Giá dịch vụ được hiển thị trên ứng dụng là mức giá dự kiến. Chi phí cuối cùng có thể thay đổi dựa trên tình trạng thực tế của thiết bị và sự thỏa thuận giữa Khách hàng và Kỹ thuật viên. Thanh toán có thể thực hiện qua tiền mặt hoặc các ví điện tử tích hợp.",
                      isDark,
                    ),
                    _buildTermsSection(
                      "5. Chính sách hủy đơn",
                      "Khách hàng có quyền hủy đơn hàng trước khi Kỹ thuật viên bắt đầu di chuyển. Nếu hủy đơn khi Kỹ thuật viên đã đến nơi, một khoản phí di chuyển nhỏ có thể được áp dụng để hỗ trợ đối tác.",
                      isDark,
                    ),
                    _buildTermsSection(
                      "6. Quyền sở hữu trí tuệ",
                      "Tất cả nội dung, logo, thiết kế và mã nguồn của ứng dụng Fixit là tài sản độc quyền của chúng tôi. Bạn không được phép sao chép, sửa đổi hoặc sử dụng cho mục đích thương mại khi chưa có sự đồng ý bằng văn bản.",
                      isDark,
                    ),
                    _buildTermsSection(
                      "7. Giới hạn trách nhiệm",
                      "Trong phạm vi luật pháp cho phép, Fixit sẽ không chịu trách nhiệm cho bất kỳ thiệt hại gián tiếp, ngẫu nhiên hoặc do hậu quả nào phát sinh từ việc sử dụng hoặc không thể sử dụng dịch vụ.",
                      isDark,
                    ),
                    _buildTermsSection(
                      "8. Bảo mật thông tin",
                      "Chúng tôi cam kết bảo vệ dữ liệu cá nhân của bạn theo tiêu chuẩn mã hóa cao nhất. Thông tin của bạn chỉ được chia sẻ với Kỹ thuật viên thực hiện đơn hàng của bạn nhằm mục đích hoàn thành dịch vụ.",
                      isDark,
                    ),
                    _buildTermsSection(
                      "9. Thay đổi điều khoản",
                      "Fixit bảo lưu quyền sửa đổi các điều khoản này bất cứ lúc nào. Các thay đổi sẽ có hiệu lực ngay khi được đăng tải trên ứng dụng. Việc bạn tiếp tục sử dụng ứng dụng sau khi có thay đổi đồng nghĩa với việc bạn chấp nhận các điều khoản mới.",
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
                    backgroundColor: isDark ? Colors.white : const Color(0xFF0D47A1),
                    foregroundColor: isDark ? const Color(0xFF0D47A1) : Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: const Text("TÔI ĐÃ HIỂU", style: TextStyle(fontWeight: FontWeight.bold)),
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
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.blueAccent : const Color(0xFF0D47A1),
          ),
        ),
        const Gap(8),
        Text(
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
    
    if (value.contains('user_already_exists') || value.contains('already exists')) {
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
                  const Gap(20),
                  Row(
                    children: [
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
                  ),
                  
                  const Gap(32),
                  Text(
                    l10n.signUp,
                    style: TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.w900,
                      color: isDark ? Colors.white : Colors.blueGrey.shade900,
                      letterSpacing: -1,
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
                  const Gap(32),
                  
                  // Glassmorphism Form
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
                              controller: _nameController,
                              label: l10n.fullName,
                              hint: 'John Doe',
                              icon: Icons.person_outline_rounded,
                              darkTheme: isDark,
                              autofillHints: const [AutofillHints.name],
                              textInputAction: TextInputAction.next,
                              validator: (value) => (value == null || value.isEmpty) ? l10n.enterName : null,
                            ),
                            const Gap(20),
                            FigmaAuthTextField(
                              controller: _emailController,
                              label: l10n.emailAddress,
                              hint: l10n.emailHint,
                              icon: Icons.alternate_email_rounded,
                              darkTheme: isDark,
                              keyboardType: TextInputType.emailAddress,
                              autofillHints: const [AutofillHints.email],
                              textInputAction: TextInputAction.next,
                              validator: (value) => (value == null || !value.contains('@')) ? l10n.enterEmail : null,
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
                              autofillHints: const [AutofillHints.newPassword],
                              textInputAction: TextInputAction.done,
                              onToggleVisibility: () => setState(() => _obscurePassword = !_obscurePassword),
                              validator: (value) => (value == null || value.length < 6) ? l10n.min6Chars : null,
                            ),
                            const Gap(20),
                            
                            // Terms Checkbox
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: InkWell(
                                onTap: () => setState(() => _agreeToTerms = !_agreeToTerms),
                                borderRadius: BorderRadius.circular(12),
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: _agreeToTerms ? (isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.02)) : Colors.transparent,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: 24,
                                        height: 24,
                                        child: Checkbox(
                                          value: _agreeToTerms,
                                          onChanged: (v) => setState(() => _agreeToTerms = v ?? false),
                                          activeColor: isDark ? Colors.blueAccent : Theme.of(context).primaryColor,
                                          checkColor: Colors.white,
                                          side: BorderSide(color: isDark ? Colors.white70 : Colors.black45, width: 2),
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: RichText(
                                          text: TextSpan(
                                            style: TextStyle(
                                              color: isDark ? Colors.white.withOpacity(0.7) : Colors.blueGrey.shade700,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                            ),
                                            children: [
                                              TextSpan(text: l10n.agreeTo),
                                              TextSpan(
                                                text: l10n.termsConditions,
                                                style: TextStyle(
                                                  color: isDark ? Colors.blueAccent : Theme.of(context).primaryColor,
                                                  fontWeight: FontWeight.w800,
                                                  decoration: TextDecoration.underline,
                                                ),
                                                recognizer: TapGestureRecognizer()..onTap = () {
                                                  HapticFeedback.selectionClick();
                                                  _showTermsBottomSheet();
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
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
                                      l10n.signUp.toUpperCase(),
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
                        l10n.alreadyHaveAccount, 
                        style: TextStyle(color: isDark ? Colors.white.withOpacity(0.6) : Colors.blueGrey.shade600)
                      ),
                      GestureDetector(
                        onTap: () {
                          HapticFeedback.selectionClick();
                          context.pop();
                        },
                        child: Text(
                          l10n.signIn,
                          style: TextStyle(
                            color: isDark ? Colors.white : Theme.of(context).primaryColor, 
                            fontWeight: FontWeight.w900, 
                            decoration: TextDecoration.underline
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Gap(32),
                  FigmaAuthDivider(
                    label: l10n.orRegisterWith, 
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

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:fixit/features/auth/presentation/providers/auth_provider.dart';
import 'package:fixit/features/profile/presentation/widgets/components/menu/logout_dialog.dart';

class AccountDeactivatedScreen extends ConsumerWidget {
  const AccountDeactivatedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Stack(
        children: [
          _buildBackground(),
          _buildAmbientOrbs(),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                children: [
                  const Spacer(),
                  _buildAnimatedWarning(),
                  const Gap(60),
                  const Text(
                    "TÀI KHOẢN BỊ VÔ HIỆU HÓA",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      letterSpacing: 1,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const Gap(20),
                  Text(
                    "Tài khoản của bạn tạm thời bị vô hiệu hóa vì vi phạm chính sách cộng đồng của Fixit.",
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.white.withOpacity(0.6),
                      fontWeight: FontWeight.w500,
                      height: 1.6,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const Gap(40),
                  _buildViolationNotice(),
                  const Gap(32),
                  _buildAppealButton(context),
                  const Spacer(),
                  _buildLogoutButton(context, ref),
                  const Gap(20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackground() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [Color(0xFFB71C1C), Color(0xFF1A237E), Color(0xFF010A1A)],
        ),
      ),
    );
  }

  Widget _buildAmbientOrbs() {
    return Stack(
      children: [
        Positioned(
          top: -50,
          right: -100,
          child: _AmbientOrb(size: 300, color: Colors.redAccent.withOpacity(0.1)),
        ),
        Positioned(
          bottom: 150,
          left: -150,
          child: _AmbientOrb(size: 400, color: Colors.blueAccent.withOpacity(0.1)),
        ),
      ],
    );
  }

  Widget _buildAnimatedWarning() {
    return Container(
      height: 160,
      width: 160,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        shape: BoxShape.circle,
        border: Border.all(color: Colors.redAccent.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.redAccent.withOpacity(0.1),
            blurRadius: 40,
            spreadRadius: 10,
          )
        ],
      ),
      child: const Icon(Icons.gpp_bad_rounded, size: 80, color: Colors.redAccent),
    );
  }

  Widget _buildViolationNotice() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.info_outline_rounded, color: Colors.redAccent.withOpacity(0.8), size: 20),
              const Gap(12),
              const Text(
                "Chi tiết vi phạm",
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
              ),
            ],
          ),
          const Gap(12),
          Text(
            "Tài khoản sẽ được xem xét lại sau 7 ngày. Bạn có thể gửi phản hồi nếu cho rằng đây là một sự nhầm lẫn.",
            style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 13, height: 1.4),
          ),
        ],
      ),
    );
  }

  Widget _buildAppealButton(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: [Colors.white.withOpacity(0.1), Colors.white.withOpacity(0.05)],
        ),
      ),
      child: OutlinedButton(
        onPressed: () {
          // Gửi phản hồi (Tính năng mở rộng)
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Yêu cầu của bạn đã được gửi tới ban quản trị.")),
          );
        },
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: Colors.white.withOpacity(0.2)),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        child: const Text(
          "GỬI PHẢN ĐỐI",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, letterSpacing: 1),
        ),
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context, WidgetRef ref) {
    return TextButton.icon(
      onPressed: () => _showLogoutDialog(context, ref),
      icon: const Icon(Icons.logout_rounded, color: Colors.white30, size: 18),
      label: const Text("Thoát tài khoản",
          style: TextStyle(color: Colors.white30, fontWeight: FontWeight.w700, fontSize: 13)),
    );
  }

  void _showLogoutDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => LogoutDialog(
        onLogout: () {
          Navigator.pop(context);
          ref.read(authNotifierProvider.notifier).signOut();
        },
      ),
    );
  }
}

class _AmbientOrb extends StatelessWidget {
  final double size;
  final Color color;
  const _AmbientOrb({required this.size, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size, height: size,
      decoration: BoxDecoration(shape: BoxShape.circle, boxShadow: [BoxShadow(color: color, blurRadius: 100, spreadRadius: 50)]),
    );
  }
}

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:fixit/core/router/app_router.dart';

class BookingSuccessScreen extends StatelessWidget {
  final String? bookingId;
  const BookingSuccessScreen({super.key, this.bookingId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 1. Futuristic Background
          _buildBackground(),

          // 2. Celebration Content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(),
                  
                  // Lottie Animation or Large Icon
                  _buildSuccessAnimation(),
                  
                  const Gap(40),
                  const Text(
                    'ĐẶT LỊCH THÀNH CÔNG!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      letterSpacing: 2,
                    ),
                  ),
                  const Gap(16),
                  Text(
                    'Yêu cầu sửa chữa của bạn đã được gửi đi thành công. Vui lòng đợi trong giây lát để thợ xác nhận.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white.withOpacity(0.6),
                      height: 1.5,
                    ),
                  ),
                  
                  const Spacer(),
                  
                  // Action Buttons
                  _buildActionButtons(context),
                  
                  const Gap(40),
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
          colors: [Color(0xFF1565C0), Color(0xFF0D47A1), Color(0xFF010A1A)],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -100,
            right: -100,
            child: _AmbientOrb(size: 300, color: Colors.blue.withOpacity(0.2)),
          ),
          Positioned(
            bottom: -50,
            left: -100,
            child: _AmbientOrb(size: 400, color: Colors.blueAccent.withOpacity(0.1)),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessAnimation() {
    return Container(
      width: 200,
      height: 200,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withOpacity(0.05),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.greenAccent.withOpacity(0.2),
            blurRadius: 40,
            spreadRadius: 10,
          )
        ],
      ),
      child: Center(
        child: Lottie.asset(
          'assets/animations/success_check.json', // Ensure you have this or use an Icon
          width: 150,
          height: 150,
          repeat: false,
          errorBuilder: (_, __, ___) => const Icon(
            Icons.check_rounded,
            size: 100,
            color: Colors.greenAccent,
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        _FuturisticButton(
          text: 'XEM CHI TIẾT ĐƠN HÀNG',
          onTap: () {
            if (bookingId != null) {
              context.go('/booking/$bookingId');
            } else {
              context.go(AppRoutes.bookings);
            }
          },
        ),
        const Gap(16),
        TextButton(
          onPressed: () => context.go(AppRoutes.home),
          child: Text(
            'QUAY VỀ TRANG CHỦ',
            style: TextStyle(
              color: Colors.white.withOpacity(0.5),
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
        ),
      ],
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
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [BoxShadow(color: color, blurRadius: 100, spreadRadius: 50)],
      ),
    );
  }
}

class _FuturisticButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  const _FuturisticButton({required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF005CB7).withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          )
        ],
      ),
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF005CB7),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          elevation: 0,
        ),
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w900,
            fontSize: 16,
            letterSpacing: 1,
          ),
        ),
      ),
    );
  }
}

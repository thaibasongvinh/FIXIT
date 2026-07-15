import 'package:fixit/shared/utils/vietnam_address_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fixit/core/router/app_router.dart';
import 'package:fixit/core/theme/app_theme.dart';

import 'package:fixit/core/presentation/widgets/app_background.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.0, 0.5, curve: Curves.easeIn)),
    );

    _scaleAnimation = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.0, 0.7, curve: Curves.easeOutBack)),
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.7, 1.0, curve: Curves.easeInOut)),
    );

    _controller.forward();
    _initializeApp();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _initializeApp() async {
    // 1. Pre-fetch dữ liệu nặng trong khi đang hiện Splash (Gợi ý số 3)
    await Future.wait([
      VietnamAddressProvider.loadData(),
      Future.delayed(const Duration(seconds: 3)), // Đảm bảo splash hiện ít nhất 3s
    ]);

    if (mounted) {
      context.go(AppRoutes.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D47A1),
      body: Stack(
        children: [
          // Nền Gradient phức hợp tạo chiều sâu (Cố định, không theo Theme)
          Container(
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.center,
                radius: 1.5,
                colors: [
                  Color(0xFF1E88E5),
                  Color(0xFF1565C0),
                  Color(0xFF0D47A1),
                ],
              ),
            ),
          ),
          
          // Các đốm sáng mờ ảo di chuyển
          const _AnimatedGlowCircle(top: -50, left: -50, size: 300, color: Colors.blueAccent),
          const _AnimatedGlowCircle(bottom: -100, right: -50, size: 400, color: Color(0xFF1976D2)),

          // Nội dung chính
          Center(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return FadeTransition(
                  opacity: _fadeAnimation,
                  child: Transform.scale(
                    scale: _scaleAnimation.value * (0.95 + (0.05 * _pulseAnimation.value)),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Logo với hiệu ứng hào quang kép
                        Container(
                          padding: const EdgeInsets.all(30),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.white.withOpacity(0.15 * _fadeAnimation.value),
                                blurRadius: 60,
                                spreadRadius: 20,
                              ),
                              BoxShadow(
                                color: Colors.blue.withOpacity(0.3 * _fadeAnimation.value),
                                blurRadius: 100,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                          child: Image.asset(
                            'assets/images/app_icon.png',
                            width: 160,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Loading bar và Slogan phía dưới
          Positioned(
            bottom: 80,
            left: 0,
            right: 0,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Column(
                children: [
                  // Thanh loading siêu mảnh kiểu Tesla/Apple
                  Container(
                    width: 120,
                    height: 2,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(1),
                    ),
                    child: Stack(
                      children: [
                        AnimatedBuilder(
                          animation: _controller,
                          builder: (context, child) {
                            return Container(
                              width: 120 * _controller.value,
                              height: 2,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [Colors.blueAccent, Colors.white],
                                ),
                                borderRadius: BorderRadius.circular(1),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.blueAccent.withOpacity(0.5),
                                    blurRadius: 4,
                                    offset: const Offset(0, 0),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  Text(
                    '•~~  FIXIT  ~~•',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.6),
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 6,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AnimatedGlowCircle extends StatelessWidget {
  final double? top, bottom, left, right;
  final double size;
  final Color color;

  const _AnimatedGlowCircle({
    this.top, this.bottom, this.left, this.right,
    required this.size, required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top, bottom: bottom, left: left, right: right,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.15),
              blurRadius: 100,
              spreadRadius: 50,
            ),
          ],
        ),
      ),
    );
  }
}

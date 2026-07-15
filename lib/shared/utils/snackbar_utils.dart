import 'dart:ui';
import 'package:flutter/material.dart';

class AppSnackbar {
  static void showSuccess(BuildContext context, String message) {
    _show(
      context,
      message,
      gradient: const LinearGradient(colors: [Color(0xFF2E7D32), Color(0xFF43A047)]),
      icon: Icons.check_circle_rounded,
      glowColor: Colors.greenAccent,
    );
  }

  static void showError(BuildContext context, String message) {
    _show(
      context,
      message,
      gradient: const LinearGradient(colors: [Color(0xFFC62828), Color(0xFFE53935)]),
      icon: Icons.error_rounded,
      glowColor: Colors.redAccent,
    );
  }

  static void showWarning(BuildContext context, String message) {
    _show(
      context,
      message,
      gradient: const LinearGradient(colors: [Color(0xFFEF6C00), Color(0xFFFB8C00)]),
      icon: Icons.warning_rounded,
      glowColor: Colors.orangeAccent,
    );
  }

  static void showInfo(BuildContext context, String message) {
    _show(
      context,
      message,
      gradient: const LinearGradient(colors: [Color(0xFF0277BD), Color(0xFF0288D1)]),
      icon: Icons.info_outline_rounded,
      glowColor: Colors.lightBlueAccent,
    );
  }

  static void _show(
    BuildContext context,
    String message, {
    required Gradient gradient,
    required IconData icon,
    required Color glowColor,
  }) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 24), // Đẩy cao lên một chút
        duration: const Duration(seconds: 4),
        content: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    gradient.colors[0].withOpacity(0.8),
                    gradient.colors[1].withOpacity(0.7),
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white.withOpacity(0.2), width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: glowColor.withOpacity(0.3),
                    blurRadius: 20,
                    spreadRadius: -5,
                  )
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(icon, color: Colors.white, size: 20),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      message,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.3,
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
}

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class UnsavedChangesDialog extends StatelessWidget {
  final VoidCallback onSave;
  final VoidCallback onDiscard;

  const UnsavedChangesDialog({
    super.key,
    required this.onSave,
    required this.onDiscard,
  });

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: TweenAnimationBuilder<double>(
          duration: const Duration(milliseconds: 400),
          tween: Tween(begin: 0.8, end: 1.0),
          curve: Curves.easeOutBack,
          builder: (context, scale, child) {
            return Transform.scale(
              scale: scale,
              child: child,
            );
          },
          child: Container(
            padding: const EdgeInsets.all(24.0),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: Colors.white.withOpacity(0.5), width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 30,
                  offset: const Offset(0, 15),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 3D Door/Alert Icon with Glow
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFFFFF4E5).withOpacity(0.8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.orange.withOpacity(0.1),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: Image.asset(
                    'assets/images/Door.png',
                    height: 110,
                    width: 110,
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => const Icon(
                      Icons.warning_amber_rounded,
                      size: 70,
                      color: Colors.orange,
                    ),
                  ),
                ),
                const Gap(24),
                const Text(
                  'Unsaved Changes',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1A1D1E),
                    letterSpacing: -0.5,
                  ),
                ),
                const Gap(10),
                Text(
                  'You have unsaved information.\nWould you like to save it before leaving?',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF1A1D1E).withOpacity(0.6),
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
                const Gap(32),
                // Save Button
                Container(
                  width: double.infinity,
                  height: 58,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: const LinearGradient(
                      colors: [Color(0xFF0054A5), Color(0xFF007BFF)],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF0054A5).withOpacity(0.3),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: onSave,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    child: const Text(
                      'Save Changes',
                      style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800),
                    ),
                  ),
                ),
                const Gap(12),
                // Discard Button
                TextButton(
                  onPressed: onDiscard,
                  child: const Text(
                    'Discard & Exit',
                    style: TextStyle(
                      color: Color(0xFFE53935),
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const Gap(4),
                // Stay here
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'Keep Editing',
                    style: TextStyle(
                      color: const Color(0xFF1A1D1E).withOpacity(0.4),
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

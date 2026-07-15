import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:fixit/l10n/app_localizations.dart';

class LogoutDialog extends StatelessWidget {
  final VoidCallback onLogout;
  const LogoutDialog({super.key, required this.onLogout});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;

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
            padding: const EdgeInsets.all(28.0),
            decoration: BoxDecoration(
              color: isDark 
                  ? const Color(0xFF0D47A1).withOpacity(0.4) 
                  : Colors.white.withOpacity(0.9),
              borderRadius: BorderRadius.circular(35),
              border: Border.all(
                color: isDark ? Colors.white.withOpacity(0.2) : Colors.black.withOpacity(0.05), 
                width: 1.5
              ),
              boxShadow: [
                BoxShadow(
                  color: isDark ? Colors.blue.withOpacity(0.2) : Colors.black.withOpacity(0.05),
                  blurRadius: 40,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Icon Container
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isDark ? Colors.white.withOpacity(0.05) : colorScheme.primary.withOpacity(0.05),
                    boxShadow: [
                      BoxShadow(
                        color: colorScheme.primary.withOpacity(0.2),
                        blurRadius: 30,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Image.asset(
                    'assets/images/Out.png',
                    height: 120,
                    width: 120,
                    fit: BoxFit.contain,
                  ),
                ),
                const Gap(32),
                Text(
                  l10n.logoutConfirmTitle,
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w900,
                    color: isDark ? Colors.white : colorScheme.onSurface,
                    letterSpacing: 2,
                  ),
                ),
                const Gap(12),
                Text(
                  l10n.logoutConfirmMessage,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: (isDark ? Colors.white : colorScheme.onSurface).withOpacity(0.6),
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const Gap(40),
                // Logout Button
                SizedBox(
                  width: double.infinity,
                  height: 62,
                  child: ElevatedButton(
                    onPressed: onLogout,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isDark ? Colors.white : colorScheme.primary,
                      foregroundColor: isDark ? const Color(0xFF0D47A1) : Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      elevation: isDark ? 10 : 0,
                      shadowColor: Colors.blue.withOpacity(0.5),
                    ),
                    child: Text(
                      l10n.logoutButton,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, letterSpacing: 1),
                    ),
                  ),
                ),
                const Gap(16),
                // Cancel Button
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    l10n.cancelButton,
                    style: TextStyle(
                      color: (isDark ? Colors.white : colorScheme.onSurface).withOpacity(0.7),
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
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

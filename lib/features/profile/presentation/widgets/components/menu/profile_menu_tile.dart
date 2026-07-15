import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class ProfileMenuTile extends StatelessWidget {
  final String? assetPath;
  final IconData? icon;
  final String title;
  final VoidCallback? onTap;
  final bool trailing;
  final Color? titleColor;

  const ProfileMenuTile({
    super.key,
    this.assetPath,
    this.icon,
    required this.title,
    required this.onTap,
    this.trailing = true,
    this.titleColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(20),
            child: Container(
              height: 76,
              padding: const EdgeInsets.symmetric(horizontal: 18),
              decoration: BoxDecoration(
                color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.white.withValues(alpha: 0.9),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isDark ? Colors.white.withValues(alpha: 0.1) : Colors.white.withValues(alpha: 0.5),
                  width: 1,
                ),
                boxShadow: isDark ? [] : [
                  BoxShadow(
                    color: theme.colorScheme.primary.withValues(alpha: 0.08),
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: isDark
                          ? [Colors.white.withValues(alpha: 0.1), Colors.white.withValues(alpha: 0.05)]
                          : [const Color(0xFFF0F5FF), const Color(0xFFE0E9FF)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Center(
                      child: assetPath != null
                          ? Image.asset(
                              assetPath!,
                              width: 32,
                              height: 32,
                              errorBuilder: (_, __, ___) => Icon(
                                icon ?? Icons.help_outline,
                                color: theme.colorScheme.primary,
                                size: 28,
                              ),
                            )
                          : Icon(
                              icon ?? Icons.help_outline,
                              color: theme.colorScheme.primary,
                              size: 28,
                            ),
                    ),
                  ),
                  const Gap(16),
                  Expanded(
                    child: Text(
                      title,
                      style: TextStyle(
                        color: titleColor ?? theme.colorScheme.onSurface,
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        letterSpacing: -0.3,
                      ),
                    ),
                  ),
                  if (trailing)
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [theme.colorScheme.primary, theme.colorScheme.primary.withValues(alpha: 0.8)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: isDark ? [] : [
                          BoxShadow(
                            color: theme.colorScheme.primary.withValues(alpha: 0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.chevron_right_rounded,
                        color: Colors.white,
                        size: 22,
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

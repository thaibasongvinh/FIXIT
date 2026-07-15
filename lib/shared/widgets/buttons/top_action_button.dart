import 'package:flutter/material.dart';

class TopActionButton extends StatelessWidget {
  final Widget child;
  final VoidCallback onPressed;
  final bool isDark;

  const TopActionButton({
    super.key,
    required this.child,
    required this.onPressed,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(0.12) : Colors.black.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.05),
        ),
      ),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: SizedBox(
            width: 24,
            height: 24,
            child: Center(child: child),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class HomeSectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback onViewAll;

  const HomeSectionHeader({
    super.key,
    required this.title,
    required this.onViewAll,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              width: 3.5,
              height: 14,
              decoration: BoxDecoration(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(width: 10),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w900,
                color: isDark ? Colors.white : const Color(0xFF1A1D1E),
                letterSpacing: 0.2,
              ),
            ),
          ],
        ),
        GestureDetector(
          onTap: onViewAll,
          child: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.03),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.arrow_forward_ios_rounded,
              color: isDark ? Colors.white54 : Colors.black.withOpacity(1),
              size: 11,
            ),
          ),
        ),
      ],
    );
  }
}

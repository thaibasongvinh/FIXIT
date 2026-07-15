import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class TechnicianStatsCard extends StatelessWidget {
  final int earnings;
  final int activeOrders;
  final int completedOrders;

  const TechnicianStatsCard({
    super.key,
    required this.earnings,
    required this.activeOrders,
    required this.completedOrders,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(0.05) : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: isDark ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.05)),
        boxShadow: isDark ? [] : [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _StatItem(
            assetPath: 'assets/images/Earnings.png',
            iconColor: const Color(0xFF4CAF50),
            value: '\$${earnings}',
            label: 'Thu nhập',
          ),
          _StatItem(
            assetPath: 'assets/images/Active.png',
            iconColor: const Color(0xFFFFB300),
            value: '${activeOrders}',
            label: 'Đang chạy',
          ),
          _StatItem(
            assetPath: 'assets/images/Completed.png',
            iconColor: const Color(0xFFFF7043),
            value: '${completedOrders}',
            label: 'Hoàn thành',
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String assetPath;
  final Color iconColor;
  final String value;
  final String label;

  const _StatItem({
    required this.assetPath,
    required this.iconColor,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.12),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Image.asset(assetPath, width: 32, height: 32),
        ),
        const Gap(10),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w900,
            color: isDark ? Colors.white : const Color(0xFF2450A4),
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: isDark ? Colors.white38 : Colors.grey.shade600,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.2,
          ),
        ),
      ],
    );
  }
}

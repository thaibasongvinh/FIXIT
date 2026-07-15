import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../../home/presentation/widgets/components/shimmer_loading.dart';

class TechnicianCardSkeleton extends StatelessWidget {
  const TechnicianCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1C1C1E) : Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ShimmerBox(
            width: 70,
            height: 70,
            borderRadius: 20,
          ),
          const Gap(16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const ShimmerBox(width: 120, height: 16, borderRadius: 4),
                const Gap(8),
                const ShimmerBox(width: double.infinity, height: 12, borderRadius: 4),
                const Gap(12),
                Row(
                  children: [
                    const ShimmerBox(width: 40, height: 12, borderRadius: 4),
                    const Gap(12),
                    const ShimmerBox(
                      width: 4,
                      height: 4,
                      shape: BoxShape.circle,
                    ),
                    const Gap(12),
                    const ShimmerBox(width: 60, height: 14, borderRadius: 4),
                  ],
                ),
                const Gap(12),
                Row(
                  children: [
                    const ShimmerBox(
                      width: 60,
                      height: 22,
                      borderRadius: 100,
                    ),
                    const Gap(8),
                    const ShimmerBox(
                      width: 60,
                      height: 22,
                      borderRadius: 100,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class AppSkeleton extends StatelessWidget {
  final double? width;
  final double? height;
  final double borderRadius;

  const AppSkeleton({
    super.key,
    this.width,
    this.height,
    this.borderRadius = 8,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Shimmer.fromColors(
      baseColor: isDark ? Colors.white.withValues(alpha: 0.08) : const Color(0xFFF2F4F7),
      highlightColor: isDark ? Colors.white.withValues(alpha: 0.15) : const Color(0xFFFFFFFF),
      period: const Duration(milliseconds: 1500),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }

  /// Skeleton cho một danh sách item
  static Widget list({int count = 5}) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: count,
      itemBuilder: (context, index) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: Row(
          children: [
            const AppSkeleton(width: 60, height: 60, borderRadius: 12),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppSkeleton(width: double.infinity, height: 16),
                  const SizedBox(height: 8),
                  AppSkeleton(width: 150, height: 12),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Skeleton cho card hướng dẫn (Guide Card)
  static Widget guideCard() {
    return Container(
      width: 200,
      margin: const EdgeInsets.only(right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppSkeleton(width: 200, height: 120, borderRadius: 16),
          const SizedBox(height: 12),
          const AppSkeleton(width: 160, height: 16),
          const SizedBox(height: 8),
          const AppSkeleton(width: 100, height: 12),
        ],
      ),
    );
  }
}

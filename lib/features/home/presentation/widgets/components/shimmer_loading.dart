import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:gap/gap.dart';

class ShimmerBox extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;
  final BoxShape shape;

  const ShimmerBox({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = 8,
    this.shape = BoxShape.rectangle,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    final baseColor = isDark 
        ? Colors.white.withValues(alpha: 0.08) 
        : const Color(0xFFF2F4F7);
    final highlightColor = isDark 
        ? Colors.white.withValues(alpha: 0.15) 
        : const Color(0xFFFFFFFF);

    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      period: const Duration(milliseconds: 1500),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: shape == BoxShape.rectangle ? BorderRadius.circular(borderRadius) : null,
          shape: shape,
        ),
      ),
    );
  }
}

class PopularServiceSkeleton extends StatelessWidget {
  const PopularServiceSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: 85,
      height: 110,
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.white,
        borderRadius: BorderRadius.circular(16), 
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black.withValues(alpha: 0.2) : Colors.black.withValues(alpha: 0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ShimmerBox(width: 45, height: 45, borderRadius: 8), 
          Gap(8),
          ShimmerBox(width: 60, height: 14, borderRadius: 4),
        ],
      ),
    );
  }
}

class ProviderCardSkeleton extends StatelessWidget {
  const ProviderCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: 190,
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: isDark ? Border.all(color: Colors.white.withValues(alpha: 0.05)) : null,
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black.withValues(alpha: 0.1) : Colors.black.withValues(alpha: 0.04),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 6,
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: ShimmerBox(width: double.infinity, height: double.infinity, borderRadius: 16),
            ),
          ),
          Expanded(
            flex: 3,
            child: Padding(
              padding: EdgeInsets.fromLTRB(12, 0, 12, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShimmerBox(width: 100, height: 16, borderRadius: 4),
                  Gap(4),
                  ShimmerBox(width: 60, height: 12, borderRadius: 4),
                  Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          ShimmerBox(width: 18, height: 18, shape: BoxShape.circle),
                          Gap(4),
                          ShimmerBox(width: 24, height: 12, borderRadius: 2),
                        ],
                      ),
                      ShimmerBox(width: 65, height: 28, borderRadius: 8),
                    ],
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

class BannerSkeleton extends StatelessWidget {
  const BannerSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: ShimmerBox(
        width: double.infinity,
        height: 200,
        borderRadius: 16,
      ),
    );
  }
}

class CategorizedProviderSkeleton extends StatelessWidget {
  const CategorizedProviderSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(20, 20, 20, 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  ShimmerBox(width: 24, height: 24, shape: BoxShape.circle),
                  Gap(8),
                  ShimmerBox(width: 140, height: 20, borderRadius: 4),
                ],
              ),
              ShimmerBox(width: 24, height: 24, shape: BoxShape.circle),
            ],
          ),
        ),
        SizedBox(
          height: 275,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: 3,
            separatorBuilder: (_, __) => const SizedBox(width: 16),
            itemBuilder: (context, index) => const ProviderCardSkeleton(),
          ),
        ),
      ],
    );
  }
}

class IssueItemSkeleton extends StatelessWidget {
  const IssueItemSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
      ),
      child: const Row(
        children: [
          ShimmerBox(width: 80, height: 80, borderRadius: 22),
          Gap(20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShimmerBox(width: 150, height: 20, borderRadius: 4),
                Gap(8),
                ShimmerBox(width: double.infinity, height: 14, borderRadius: 4),
                Gap(4),
                ShimmerBox(width: 100, height: 14, borderRadius: 4),
              ],
            ),
          ),
          Gap(10),
          ShimmerBox(width: 32, height: 32, borderRadius: 12),
        ],
      ),
    );
  }
}

class ServiceSolutionSkeleton extends StatelessWidget {
  const ServiceSolutionSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FA),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ShimmerBox(width: double.infinity, height: 220, borderRadius: 0),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const ShimmerBox(width: 200, height: 24, borderRadius: 4),
                  const Gap(24),
                  _StepSkeleton(),
                  _StepSkeleton(),
                  _StepSkeleton(),
                  const Gap(32),
                  const ShimmerBox(width: 220, height: 24, borderRadius: 4),
                  const Gap(20),
                  const ShimmerBox(width: double.infinity, height: 100, borderRadius: 24),
                  const Gap(16),
                  const ShimmerBox(width: double.infinity, height: 100, borderRadius: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StepSkeleton extends StatelessWidget {
  const _StepSkeleton();
  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShimmerBox(width: 32, height: 32, borderRadius: 10),
          Gap(16),
          Expanded(child: ShimmerBox(width: double.infinity, height: 60, borderRadius: 8)),
        ],
      ),
    );
  }
}

class TechnicianProfileSkeleton extends StatelessWidget {
  const TechnicianProfileSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      body: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ShimmerBox(width: double.infinity, height: 280, borderRadius: 0),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ShimmerBox(width: 200, height: 32, borderRadius: 4),
                          Gap(8),
                          ShimmerBox(width: 120, height: 20, borderRadius: 4),
                        ],
                      ),
                      Row(
                        children: [
                          const ShimmerBox(width: 46, height: 46, shape: BoxShape.circle),
                          const Gap(12),
                          const ShimmerBox(width: 46, height: 46, shape: BoxShape.circle),
                        ],
                      ),
                    ],
                  ),
                  const Gap(24),
                  const ShimmerBox(width: double.infinity, height: 100, borderRadius: 28),
                  const Gap(32),
                  const ShimmerBox(width: 80, height: 22, borderRadius: 4),
                  const Gap(16),
                  Row(
                    children: [
                      const ShimmerBox(width: 80, height: 36, borderRadius: 12),
                      const Gap(12),
                      const ShimmerBox(width: 80, height: 36, borderRadius: 12),
                      const Gap(12),
                      const ShimmerBox(width: 80, height: 36, borderRadius: 12),
                    ],
                  ),
                  const Gap(32),
                  const ShimmerBox(width: double.infinity, height: 56, borderRadius: 16),
                  const Gap(32),
                  const ShimmerBox(width: 50, height: 22, borderRadius: 4),
                  const Gap(14),
                  const ShimmerBox(width: double.infinity, height: 80, borderRadius: 8),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

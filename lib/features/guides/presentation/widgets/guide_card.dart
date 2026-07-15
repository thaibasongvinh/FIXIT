import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import '../../domain/models/guide_model.dart';

class GuideCard extends StatelessWidget {
  final GuideModel guide;
  const GuideCard({super.key, required this.guide});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return RepaintBoundary(
      child: GestureDetector(
        onTap: () => context.push('/guides/detail/${guide.id}'),
        child: Container(
          margin: const EdgeInsets.only(bottom: 20),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1A1A1A) : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.05)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (guide.coverImage.isNotEmpty)
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                  child: CachedNetworkImage(
                    imageUrl: guide.coverImage,
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    memCacheHeight: 400, // Tối ưu RAM cho ảnh
                  ),
                ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        _NothingBadge(label: guide.device.toUpperCase()),
                        const Gap(10),
                        Text(
                          '${guide.estimatedTime}M',
                          style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Colors.red),
                        ),
                      ],
                    ),
                    const Gap(12),
                    Text(
                      guide.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        height: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NothingBadge extends StatelessWidget {
  final String label;
  const _NothingBadge({required this.label});
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isDark ? Colors.white : Colors.black,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isDark ? Colors.black : Colors.white,
          fontSize: 9,
          fontWeight: FontWeight.w900,
          letterSpacing: 1,
        ),
      ),
    );
  }
}

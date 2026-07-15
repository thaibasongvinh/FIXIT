import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import '../../domain/models/technician_model.dart';

class TechnicianCard extends StatelessWidget {
  final TechnicianModel tech;
  final Position? userPosition;

  const TechnicianCard({super.key, required this.tech, this.userPosition});

  String get _distanceText {
    if (userPosition == null ||
        tech.latitude == null ||
        tech.longitude == null) {
      return '';
    }
    final double distanceInMeters = Geolocator.distanceBetween(
      userPosition!.latitude,
      userPosition!.longitude,
      tech.latitude!,
      tech.longitude!,
    );
    if (distanceInMeters < 1000) {
      return '${distanceInMeters.toStringAsFixed(0)}m';
    }
    return '${(distanceInMeters / 1000).toStringAsFixed(1)}km';
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return RepaintBoundary(
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.0, end: 1.0),
        duration: const Duration(milliseconds: 400),
        builder: (context, value, child) {
          return Opacity(
            opacity: value,
            child: Transform.translate(
              offset: Offset(0, 20 * (1 - value)),
              child: child,
            ),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1C1C1E) : Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: InkWell(
            onTap: () {
              HapticFeedback.lightImpact();
              context.push('/marketplace/${tech.uid}');
            },
            borderRadius: BorderRadius.circular(24),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Hero(
                    tag: 'tech_avatar_${tech.uid}',
                    child: Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: cs.primaryContainer,
                        image: tech.avatar.isNotEmpty
                            ? DecorationImage(
                                image: CachedNetworkImageProvider(
                                  tech.avatar,
                                  maxHeight: 200, // Tối ưu RAM cho avatar
                                ),
                                fit: BoxFit.cover,
                              )
                            : null,
                      ),
                      child: tech.avatar.isEmpty
                          ? Center(
                              child: Text(
                                _initialFor(tech.name),
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: cs.onPrimaryContainer,
                                ),
                              ),
                            )
                          : null,
                    ),
                  ),
                  const Gap(16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                tech.name,
                                style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0,
                                ),
                              ),
                            ),
                            if (tech.isVerified)
                              Icon(Icons.verified, size: 18, color: cs.primary),
                          ],
                        ),
                        const Gap(4),
                        Text(
                          tech.bio,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 13,
                            color: cs.onSurface.withValues(alpha: 0.6),
                          ),
                        ),
                        const Gap(10),
                        Row(
                          children: [
                            Icon(Icons.star_rounded,
                                size: 18, color: Colors.amber.shade700),
                            const Gap(4),
                            Text(
                              tech.rating.toString(),
                              style: const TextStyle(
                                  fontSize: 13, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              ' (${tech.reviewCount})',
                              style: TextStyle(
                                fontSize: 12,
                                color: cs.onSurface.withValues(alpha: 0.4),
                              ),
                            ),
                            const Gap(12),
                            if (_distanceText.isNotEmpty) ...[
                              Icon(Icons.location_on_outlined,
                                  size: 14,
                                  color: cs.onSurface.withValues(alpha: 0.4)),
                              const Gap(2),
                              Text(
                                _distanceText,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: cs.onSurface.withValues(alpha: 0.4),
                                ),
                              ),
                              const Gap(12),
                            ],
                            Container(
                              width: 4,
                              height: 4,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: cs.onSurface.withValues(alpha: 0.2),
                              ),
                            ),
                            const Gap(12),
                            Text(
                              tech.priceText,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: cs.primary,
                              ),
                            ),
                          ],
                        ),
                        const Gap(10),
                        Wrap(
                          spacing: 6,
                          runSpacing: 4,
                          children: tech.skills
                              .take(2)
                              .map((s) => _SkillBadge(label: s))
                              .toList(),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 10,
                    height: 10,
                    margin: const EdgeInsets.only(top: 4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color:
                          tech.isAvailable ? Colors.green : Colors.grey.shade400,
                      border: Border.all(color: Colors.white, width: 2),
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

  String _initialFor(String name) {
    final trimmed = name.trim();
    return trimmed.isEmpty ? '?' : trimmed[0].toUpperCase();
  }
}

class _SkillBadge extends StatelessWidget {
  final String label;
  const _SkillBadge({required this.label});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: cs.secondaryContainer.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(100),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: cs.onSecondaryContainer,
        ),
      ),
    );
  }
}

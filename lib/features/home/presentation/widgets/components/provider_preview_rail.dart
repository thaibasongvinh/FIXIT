import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:fixit/core/router/app_router.dart';
import 'package:fixit/core/utils/appwrite_utils.dart';
import '../../../../marketplace/domain/models/technician_model.dart';
import '../../../../marketplace/presentation/providers/technician_provider.dart';
import 'shimmer_loading.dart';

class ProviderPreviewRail extends ConsumerWidget {
  const ProviderPreviewRail({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final techniciansAsync = ref.watch(techniciansNotifierProvider);

    return techniciansAsync.when(
      data: (techs) {
        if (techs.isEmpty) {
          return const SizedBox.shrink(); // Load xong mà trống thì ẩn, không shimmer mãi
        }
        return SizedBox(
          height: 250,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: techs.length,
            separatorBuilder: (_, __) => const SizedBox(width: 16),
            itemBuilder: (context, index) => _ProviderPreviewCard(
              tech: techs[index],
            ),
          ),
        );
      },
      loading: () => SizedBox(
        height: 250,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          itemCount: 3,
          separatorBuilder: (_, __) => const SizedBox(width: 16),
          itemBuilder: (context, index) => const ProviderCardSkeleton(),
        ),
      ),
      error: (e, _) => const SizedBox.shrink(),
    );
  }
}

class _ProviderPreviewCard extends StatelessWidget {
  final TechnicianModel tech;
  const _ProviderPreviewCard({required this.tech});

  @override
  Widget build(BuildContext context) {
    // Ưu tiên dùng màu từ DB
    final Color actualBgColor = tech.color != null && tech.color!.isNotEmpty
        ? Color(int.parse(tech.color!.replaceFirst('#', '0xFF')))
        : const Color(0xFFB3D7F4);

    return GestureDetector(
      onTap: () => context.push('${AppRoutes.marketplace}/${tech.uid}'),
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 180,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Section
            Expanded(
              flex: 5,
              child: Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: actualBgColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: _buildAvatar(tech.avatar),
                    ),
                    if (tech.isVerified)
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.verified, color: Color(0xFF0054A5), size: 16),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            
            // Info Section
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tech.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 14,
                        color: Color(0xFF333333),
                      ),
                    ),
                    const Gap(1),
                    Text(
                      tech.skills.isNotEmpty ? tech.skills.join(', ') : 'Technician',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.star_rounded, color: Color(0xFFFFB800), size: 18),
                            const Gap(4),
                            Text(
                              tech.rating.toString(),
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF333333),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: const Color(0xFF0054A5),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Text(
                            'Details',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar(String avatar) {
    if (avatar.startsWith('http')) {
      return CachedNetworkImage(
        imageUrl: avatar,
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.contain,
        alignment: Alignment.bottomCenter,
        placeholder: (context, url) => const Center(child: CircularProgressIndicator(strokeWidth: 2)),
        errorWidget: (context, url, error) => const Icon(Icons.person, size: 50, color: Colors.white),
      );
    }

    // Xử lý fallback cho ảnh local assets
    // Ưu tiên dùng avatar name nếu nó hợp lệ, nếu không dùng công thức hash
    String assetName = avatar.contains('image 83') ? avatar : 'image 83 (${(tech.uid.hashCode % 20).abs()}).png';
    
    return Image.asset(
      'assets/images/$assetName',
      width: double.infinity,
      height: double.infinity,
      fit: BoxFit.contain,
      alignment: Alignment.bottomCenter,
      errorBuilder: (context, error, stackTrace) {
        return const Icon(Icons.person, size: 50, color: Colors.white);
      },
    );
  }
}

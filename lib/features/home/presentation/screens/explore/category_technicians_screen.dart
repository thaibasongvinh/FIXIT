import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import 'package:fixit/core/router/app_router.dart';
import 'package:fixit/core/utils/appwrite_utils.dart';
import 'package:fixit/features/marketplace/domain/models/technician_model.dart';
import 'package:fixit/features/marketplace/presentation/providers/technician_provider.dart';
import '../../providers/services_provider.dart';

class CategoryTechniciansScreen extends ConsumerWidget {
  final String categoryTitle;

  const CategoryTechniciansScreen({
    super.key,
    required this.categoryTitle,
  });

  Widget _buildCategoryImage(String path, double size) {
    if (path.isEmpty) return Icon(Icons.category_rounded, size: size, color: Colors.grey);
    
    if (!path.contains('/') && !path.contains('.')) {
      final imageUrl = 'https://sgp.cloud.appwrite.io/v1/storage/buckets/fixit_assets/files/$path/view?project=6a145b8d001aa82f4dd5';
      return CachedNetworkImage(
        imageUrl: imageUrl, 
        width: size, 
        height: size,
        errorWidget: (context, url, error) => Icon(Icons.category_rounded, size: size, color: Colors.grey),
      );
    }

    return path.startsWith('http')
        ? CachedNetworkImage(imageUrl: path, width: size, height: size)
        : Image.asset(path.contains('assets/') ? path : 'assets/images/$path', width: size, height: size);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final servicesAsync = ref.watch(allServicesProvider);
    final techniciansAsync = ref.watch(techniciansNotifierProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF9F9F9),
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        leadingWidth: 60,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Center(
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF333333), size: 16),
                onPressed: () {
                  if (context.canPop()) {
                    context.pop();
                  } else {
                    context.go(AppRoutes.home);
                  }
                },
                padding: EdgeInsets.zero,
              ),
            ),
          ),
        ),
        title: servicesAsync.when(
          data: (services) {
            final parent = services.where((s) => s.id.startsWith('pop_')).firstWhere(
                  (s) => s.title.toLowerCase() == categoryTitle.toLowerCase(),
                  orElse: () => services.first,
                );
            
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: Color(parent.color).withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Color(parent.color).withValues(alpha: 0.1), width: 1),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildCategoryImage(parent.imagePath, 22),
                  const Gap(8),
                  Text(
                    parent.title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w900,
                      color: Color(parent.color).withValues(alpha: 0.9),
                      letterSpacing: -0.5,
                    ),
                  ),
                ],
              ),
            );
          },
          loading: () => Text(categoryTitle),
          error: (_, __) => Text(categoryTitle),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.tune_rounded, color: Color(0xFF333333)),
            onPressed: () => context.push('/search/filter'),
          ),
          const Gap(8),
        ],
      ),
      body: servicesAsync.when(
        data: (services) => techniciansAsync.when(
          data: (techs) {
            // Lấy danh sách thợ thuộc nhóm này
            final parent = services.where((s) => s.id.startsWith('pop_')).firstWhere(
                  (s) => s.title.toLowerCase() == categoryTitle.toLowerCase(),
                  orElse: () => services.first,
                );

            final childServiceTitles = services
                .where((s) => s.parentId == parent.id)
                .map((s) => s.title.toLowerCase())
                .toList();
            childServiceTitles.add(parent.title.toLowerCase());

            final filteredTechs = techs.where((t) {
              return t.skills.any((skill) => childServiceTitles.contains(skill.toLowerCase()));
            }).toList();

            if (filteredTechs.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.person_search_rounded, size: 80, color: Colors.grey[300]),
                    const Gap(16),
                    Text(
                      'No technicians found in this category',
                      style: TextStyle(color: Colors.grey[600], fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              );
            }

            return GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.72,
              ),
              itemCount: filteredTechs.length,
              itemBuilder: (context, index) {
                return _TechnicianGridCard(
                  tech: filteredTechs[index],
                  categoryName: parent.title, // Dùng title chuẩn từ parent category
                );
              },
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('Error: $e')),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }
}

class _TechnicianGridCard extends StatelessWidget {
  final TechnicianModel tech;
  final String categoryName;

  const _TechnicianGridCard({
    required this.tech,
    required this.categoryName,
  });

  @override
  Widget build(BuildContext context) {
    // Ưu tiên dùng màu từ DB
    final Color bgColor = tech.color != null && tech.color!.isNotEmpty
        ? Color(int.parse(tech.color!.replaceFirst('#', '0xFF')))
        : const Color(0xFFE3F2FD);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24), // Tăng bo góc cho đồng bộ Premium
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              context.push('/marketplace/${tech.uid}');
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image part
                Expanded(
                  flex: 6,
                  child: Container(
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: bgColor.withOpacity(0.15), // Dùng màu nền thợ nhẹ nhàng
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
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
                              child: const Icon(Icons.verified, color: Color(0xFF0054A5), size: 14),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                
                // Info part
                Expanded(
                  flex: 4,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          tech.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 16,
                            color: Color(0xFF1A1A1A),
                            letterSpacing: -0.5,
                          ),
                        ),
                        const Gap(2),
                        Text(
                          tech.skills.isNotEmpty ? tech.skills.join(', ') : categoryName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Spacer(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.star_rounded, color: Color(0xFFFFB800), size: 16),
                                const Gap(4),
                                Text(
                                  tech.rating.toString(),
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w900,
                                    color: Color(0xFF333333),
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: const Color(0xFF0054A5),
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFF0054A5).withOpacity(0.2),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: const Text(
                                'Details',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 0.5,
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

    final imageUrl = AppwriteUtils.getImageUrl(avatar);
    if (imageUrl.contains('/storage/buckets/')) {
      return CachedNetworkImage(
        imageUrl: imageUrl,
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.contain,
        alignment: Alignment.bottomCenter,
        placeholder: (context, url) => const Center(child: CircularProgressIndicator(strokeWidth: 2)),
        errorWidget: (context, url, error) => _buildAssetFallback(),
      );
    }

    return _buildAssetFallback();
  }

  Widget _buildAssetFallback() {
    String assetName = tech.avatar.contains('image 83') 
        ? tech.avatar 
        : 'image 83 (${(tech.uid.hashCode % 20).abs()}).png';
    
    return Image.asset(
      'assets/images/$assetName',
      width: double.infinity,
      height: double.infinity,
      fit: BoxFit.contain,
      alignment: Alignment.bottomCenter,
      errorBuilder: (context, error, stackTrace) => const Icon(Icons.person, size: 50, color: Colors.white),
    );
  }
}

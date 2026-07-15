import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import 'package:fixit/core/router/app_router.dart';
import '../../../domain/entities/home_category.dart';
import '../../providers/services_provider.dart';
import '../../widgets/components/shimmer_loading.dart';

class CategoryProvidersScreen extends ConsumerWidget {
  final String categoryTitle;
  const CategoryProvidersScreen({super.key, required this.categoryTitle});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final servicesAsync = ref.watch(allServicesProvider);

    return FutureBuilder(
      future: Future.delayed(const Duration(milliseconds: 800)),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            backgroundColor: const Color(0xFFF9F9F9),
            appBar: _buildAppBar(context, ref),
            body: _buildSkeletonGrid(),
          );
        }

        return Scaffold(
          backgroundColor: const Color(0xFFF9F9F9),
          appBar: _buildAppBar(context, ref),
          body: servicesAsync.when(
            data: (allServices) {
              // Tìm ID của category cha dựa trên title (ví dụ: title "Plumber" -> id "pop_plumber")
              final parent = allServices.where((s) => s.id.startsWith('pop_')).firstWhere(
                    (s) => s.title.toLowerCase() == categoryTitle.toLowerCase(),
                    orElse: () => allServices.first,
                  );

              // Lọc các dịch vụ con dựa trên parentId
              final filtered = allServices.where((s) => s.parentId == parent.id).toList();

              if (filtered.isEmpty) {
                return const Center(child: Text('Không tìm thấy dịch vụ con nào'));
              }

              return GridView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 28,
                  childAspectRatio: 0.68, // Tăng chiều cao để tránh overflow chữ
                ),
                itemCount: filtered.length,
                itemBuilder: (context, index) => _ServiceItem(category: filtered[index]),
              );
            },
            loading: () => _buildSkeletonGrid(),
            error: (e, _) => Center(child: Text('Lỗi: $e')),
          ),
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, WidgetRef ref) {
    final servicesAsync = ref.watch(allServicesProvider);

    return AppBar(
      backgroundColor: const Color(0xFFF9F9F9),
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: true,
      leading: Padding(
        padding: const EdgeInsets.only(left: 12),
        child: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF333333), size: 18),
          onPressed: () => context.pop(),
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
    );
  }

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

  Widget _buildSkeletonGrid() {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 20,
        mainAxisSpacing: 28,
        childAspectRatio: 0.68,
      ),
      itemCount: 9,
      itemBuilder: (context, index) => const PopularServiceSkeleton(),
    );
  }
}

class _ServiceItem extends StatelessWidget {
  final HomeCategory category;
  const _ServiceItem({required this.category});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () => context.push('${AppRoutes.allProviders}/category?title=${category.title}'),
      child: Column(
        children: [
          AspectRatio(
            aspectRatio: 1,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24), // Bo góc mượt mà hơn
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04), // Đổ bóng nhẹ tinh tế
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: category.imagePath.isEmpty
                  ? const Icon(Icons.build_circle_outlined, color: Colors.grey)
                  : category.imagePath.startsWith('http')
                      ? CachedNetworkImage(
                          imageUrl: category.imagePath,
                          fit: BoxFit.contain,
                          placeholder: (context, url) => const Center(
                            child: SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          ),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.broken_image, color: Colors.grey),
                        )
                      : Image.asset(
                          category.imagePath,
                          fit: BoxFit.contain,
                          errorBuilder: (_, __, ___) => const Icon(Icons.image_not_supported),
                        ),
            ),
          ),
          const Gap(12),
          Text(
            category.title,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 12.5,
              color: Color(0xFF444444),
              height: 1.2, // Giãn dòng nhẹ
            ),
          ),
        ],
      ),
    );
  }
}

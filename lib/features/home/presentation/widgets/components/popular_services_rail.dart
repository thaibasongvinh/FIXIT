import 'package:fixit/core/utils/service_translation_helper.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:fixit/core/router/app_router.dart';
import 'package:fixit/core/utils/appwrite_utils.dart';
import '../../../domain/entities/home_category.dart';
import '../../providers/services_provider.dart';
import '../../providers/home_provider.dart';
import 'shimmer_loading.dart';

class PopularServicesRail extends ConsumerWidget {
  const PopularServicesRail({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final servicesAsync = ref.watch(popularServicesProvider);

    return servicesAsync.when(
      data: (services) {
        final validServices = services.where((s) => s.title.isNotEmpty).toList();

        if (validServices.isEmpty) {
          return const SizedBox.shrink(); // Đã load xong mà không có dữ liệu thì ẩn luôn
        }
        return SizedBox(
          height: 115,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            physics: const BouncingScrollPhysics(),
            itemCount: validServices.length,
            separatorBuilder: (_, __) => const SizedBox(width: 14),
            itemBuilder: (context, index) => _ServiceIcon(category: validServices[index]),
          ),
        );
      },
      loading: () => SizedBox(
        height: 115,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          itemCount: 5,
          separatorBuilder: (_, __) => const SizedBox(width: 14),
          itemBuilder: (context, index) => const PopularServiceSkeleton(),
        ),
      ),
      error: (e, _) => const SizedBox.shrink(),
    );
  }
}

class _ServiceIcon extends StatefulWidget {
  final HomeCategory category;
  const _ServiceIcon({required this.category});

  @override
  State<_ServiceIcon> createState() => _ServiceIconState();
}

class _ServiceIconState extends State<_ServiceIcon> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: () => context.push('${AppRoutes.allServices}?category=${Uri.encodeComponent(widget.category.title)}'),
      child: AnimatedScale(
        scale: _isPressed ? 0.92 : 1.0,
        duration: const Duration(milliseconds: 150),
        child: Column(
          children: [
            Container(
              width: 80,
              height: 80,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                  BoxShadow(
                    color: Color(widget.category.color).withValues(alpha: 0.08),
                    blurRadius: 15,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: widget.category.imagePath.isEmpty 
                  ? const Icon(Icons.build_circle_outlined, color: Colors.grey)
                  : _buildImage(widget.category.imagePath),
            ),
            const SizedBox(height: 8),
            Text(
              widget.category.title.translateService(context),
              style: TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF1A1D1E).withValues(alpha: 0.8),
                letterSpacing: -0.2,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage(String path) {
    // Luôn lấy URL từ AppwriteUtils
    final imageUrl = AppwriteUtils.getImageUrl(path);
    
    // Sử dụng CachedNetworkImage vì ảnh hiện tại nằm trên Server (Storage)
    return CachedNetworkImage(
      imageUrl: imageUrl,
      fit: BoxFit.contain,
      placeholder: (context, url) => const Center(
        child: SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      ),
      errorWidget: (context, url, error) {
        // Nếu lỗi mạng, thử fallback về asset local (nếu có)
        return Image.asset(
          'assets/images/$path',
          fit: BoxFit.contain,
          errorBuilder: (_, __, ___) => const Icon(Icons.broken_image, color: Colors.grey),
        );
      },
    );
  }
}

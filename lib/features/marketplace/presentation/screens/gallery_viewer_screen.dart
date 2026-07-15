import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'package:fixit/core/utils/appwrite_utils.dart';

import '../providers/favorites_provider.dart';

class GalleryViewerScreen extends ConsumerWidget {
  final String techId;
  final String techName;
  final List<String> images;

  const GalleryViewerScreen({
    super.key,
    required this.techId,
    required this.techName,
    required this.images,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favorites = ref.watch(favoritesProvider).valueOrNull ?? {};
    final isFavorite = favorites.contains(techId);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: Color(0xFF2450A4), size: 20),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Gallery',
          style: TextStyle(
            color: Color(0xFF2450A4),
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
              color: isFavorite ? Colors.red : const Color(0xFF2450A4),
              size: 24,
            ),
            onPressed: () {
              ref.read(favoritesProvider.notifier).toggleFavorite(techId);
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: images.isEmpty
          ? const Center(child: Text('Chưa có ảnh nào trong bộ sưu tập.'))
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: StaggeredGrid.count(
                crossAxisCount: 4,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                children: _buildGridItems(context),
              ),
            ),
    );
  }

  List<Widget> _buildGridItems(BuildContext context) {
    final List<Widget> items = [];

    for (int i = 0; i < images.length; i++) {
      final url = images[i];
      // Logic layout:
      // Item 0: Chiếm 2x2 (Góc trên trái)
      // Item 1: Chiếm 2x1 (Góc trên phải)
      // Item 2: Chiếm 2x1 (Góc trên phải dưới Item 1)
      // Các item sau: 2x2 hoặc 2x1 xen kẽ
      int crossAxisCellCount = 2;
      int mainAxisCellCount = 2;

      if (i == 1 || i == 2) {
        mainAxisCellCount = 1;
      }

      items.add(
        StaggeredGridTile.count(
          crossAxisCellCount: crossAxisCellCount,
          mainAxisCellCount: mainAxisCellCount,
          child: _ImageTile(url: url),
        ),
      );
    }
    return items;
  }
}

class _ImageTile extends StatelessWidget {
  final String url;
  const _ImageTile({required this.url});

  @override
  Widget build(BuildContext context) {
    final imageUrl = AppwriteUtils.getImageUrl(url);
    final isHttp = imageUrl.startsWith('http');

    return GestureDetector(
      onTap: () => _showFullScreen(context, url),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: !isHttp
            ? Image.asset(url, fit: BoxFit.cover)
            : CachedNetworkImage(
                imageUrl: imageUrl,
                fit: BoxFit.cover,
                placeholder: (_, __) => Container(color: Colors.grey.shade100),
                errorWidget: (_, __, ___) => const Icon(Icons.broken_image),
              ),
      ),
    );
  }

  void _showFullScreen(BuildContext context, String url) {
    final imageUrl = AppwriteUtils.getImageUrl(url);
    final isHttp = imageUrl.startsWith('http');

    showDialog(
      context: context,
      useSafeArea: false,
      builder: (context) => Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            Center(
              child: InteractiveViewer(
                child: !isHttp
                    ? Image.asset(url, fit: BoxFit.contain)
                    : CachedNetworkImage(
                        imageUrl: imageUrl,
                        fit: BoxFit.contain,
                      ),
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).padding.top + 10,
              right: 16,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white, size: 30),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

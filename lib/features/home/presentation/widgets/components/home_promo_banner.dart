import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:fixit/core/utils/service_translation_helper.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fixit/core/utils/appwrite_utils.dart';

import '../../providers/banner_provider.dart';
import '../../../domain/entities/banner_model.dart';
import 'shimmer_loading.dart';

class HomePromoBanner extends ConsumerStatefulWidget {
  const HomePromoBanner({super.key});

  @override
  ConsumerState<HomePromoBanner> createState() => _HomePromoBannerState();
}

class _HomePromoBannerState extends ConsumerState<HomePromoBanner> {
  static const int _virtualItemCount = 10000;
  late final PageController _pageController;
  int _currentPageIndex = 0;
  Timer? _timer;
  bool _isUserInteracting = false;

  @override
  void initState() {
    super.initState();
    _currentPageIndex = _virtualItemCount ~/ 2;
    _pageController = PageController(initialPage: _currentPageIndex);
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (!_isUserInteracting && _pageController.hasClients) {
        _pageController.nextPage(
          duration: const Duration(milliseconds: 1200),
          curve: Curves.easeInOutQuart,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bannersAsync = ref.watch(homeBannersProvider);

    return bannersAsync.when(
      data: (banners) {
        if (banners.isEmpty) {
          return const SizedBox.shrink();
        }

        return Listener(
          onPointerDown: (_) => setState(() => _isUserInteracting = true),
          onPointerUp: (_) => setState(() => _isUserInteracting = false),
          child: SizedBox(
            height: 200,
            width: double.infinity,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                PageView.builder(
                  controller: _pageController,
                  clipBehavior: Clip.none,
                  onPageChanged: (index) => setState(() => _currentPageIndex = index),
                  itemCount: _virtualItemCount,
                  itemBuilder: (context, index) {
                    final bannerIndex = index % banners.length;
                    final banner = banners[bannerIndex];

                    return AnimatedBuilder(
                      animation: _pageController,
                      builder: (context, child) {
                        double pageOffset = 0;
                        if (_pageController.position.haveDimensions) {
                          pageOffset = _pageController.page! - index;
                        } else {
                          pageOffset = (_virtualItemCount ~/ 2).toDouble() - index;
                        }

                        return _BannerItem(
                          title: banner.title.translateService(context),
                          subtitle: banner.subtitle.translateService(context),
                          image: banner.image,
                          colors: banner.colors.map((c) => Color(c)).toList(),
                          parallaxOffset: pageOffset,
                        );
                      },
                    );
                  },
                ),
                // Chỉ số trang (Dots Indicator)
                Positioned(
                  bottom: 30,
                  left: 40,
                  child: Row(
                    children: List.generate(banners.length, (index) {
                      final bannerIndex = _currentPageIndex % banners.length;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.only(right: 6),
                        height: 6,
                        width: bannerIndex == index ? 20 : 6,
                        decoration: BoxDecoration(
                          color: Colors.white.withAlpha(bannerIndex == index ? 255 : 100),
                          borderRadius: BorderRadius.circular(3),
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),
        );
      },
      loading: () => BannerSkeleton(),
      error: (e, _) => const SizedBox.shrink(),
    );
  }
}

class _BannerItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final String image;
  final List<Color> colors;
  final double parallaxOffset;

  const _BannerItem({
    required this.title,
    required this.subtitle,
    required this.image,
    required this.colors,
    required this.parallaxOffset,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Lớp nền (Nền cố định)
        Container(
          width: double.infinity,
          height: 200,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: colors,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        
        // Ảnh người (Hiệu ứng Parallax)
        Positioned(
          right: -parallaxOffset * 100,
          bottom: -10,
          top: -20,
          child: AppwriteUtils.getImageUrl(image).startsWith('http')
              ? CachedNetworkImage(
                  imageUrl: AppwriteUtils.getImageUrl(image),
                  fit: BoxFit.contain,
                  alignment: Alignment.bottomRight,
                  errorWidget: (context, url, error) => Image.asset(
                    'assets/images/image 83 (2).png',
                    fit: BoxFit.contain,
                    alignment: Alignment.bottomRight,
                  ),
                )
              : Image.asset(
                  image.isNotEmpty ? image : 'assets/images/image 83 (2).png',
                  fit: BoxFit.contain,
                  alignment: Alignment.bottomRight,
                  errorBuilder: (context, error, stackTrace) => Image.asset(
                    'assets/images/image 83 (2).png',
                    fit: BoxFit.contain,
                    alignment: Alignment.bottomRight,
                  ),
                ),
        ),
        
        // Nội dung chữ (Hiệu ứng Parallax và Fade)
        Positioned(
          left: 20 - (parallaxOffset * 150),
          top: 20,
          child: Opacity(
            opacity: (1 - parallaxOffset.abs()).clamp(0.0, 1.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 32, // Giảm nhẹ size để tránh tràn nếu text dài
                    fontWeight: FontWeight.w800,
                    letterSpacing: -1,
                  ),
                ),
                const Gap(8),
                SizedBox(
                  width: 150,
                  child: Text(
                    subtitle,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      height: 1.2,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

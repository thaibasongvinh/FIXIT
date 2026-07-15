import 'package:fixit/core/presentation/widgets/app_background.dart';
import 'package:fixit/core/utils/service_translation_helper.dart';
import 'package:fixit/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:fixit/core/utils/appwrite_utils.dart';
import 'package:fixit/core/router/app_router.dart';
import '../../domain/models/product_model.dart';
import '../providers/service_flow_provider.dart';
import '../../../home/presentation/widgets/components/shimmer_loading.dart';

class ServiceSolutionScreen extends ConsumerWidget {
  final String issueId;
  final String issueTitle;
  final String serviceTitle;

  const ServiceSolutionScreen({
    super.key,
    required this.issueId,
    required this.issueTitle,
    required this.serviceTitle,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final guideAsync = ref.watch(issueGuideProvider(issueId));
    final productsAsync = ref.watch(issueProductsProvider(issueId));
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: AppBackground(
        child: guideAsync.when(
          loading: () => const ServiceSolutionSkeleton(),
          error: (e, _) => Center(child: Text('Error: $e')),
          data: (guide) => CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              _buildModernAppBar(context, theme),
              
              // 1. Step-by-Step Guide
              if (guide != null)
                _GuideTimelineSection(guideId: guide.id)
              else
                SliverToBoxAdapter(
                  child: Container(
                    margin: const EdgeInsets.all(24),
                    padding: const EdgeInsets.all(40),
                    decoration: BoxDecoration(
                      color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.white,
                      borderRadius: BorderRadius.circular(32),
                      border: Border.all(color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.black.withValues(alpha: 0.02)),
                    ),
                    child: Column(
                      children: [
                        Icon(Icons.auto_stories_rounded, size: 48, color: theme.colorScheme.onSurface.withValues(alpha: 0.2)),
                        const Gap(16),
                        Text(
                          'Detailed guide coming soon.',
                          style: TextStyle(
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              // 2. Shopping Section Header
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 40, 24, 16),
                  child: Text(
                    l10n.recommendedTools,
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w900,
                      color: theme.colorScheme.onSurface,
                      letterSpacing: -0.8,
                    ),
                  ),
                ),
              ),

              // 3. Products Horizontal List
              productsAsync.when(
                data: (products) {
                  if (products.isEmpty) {
                    return SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Text(
                          'No specific tools found for this fix.',
                          style: TextStyle(color: theme.colorScheme.onSurface.withValues(alpha: 0.4), fontWeight: FontWeight.w500),
                        ),
                      ),
                    );
                  }
                  return SliverToBoxAdapter(
                    child: SizedBox(
                      height: 280,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        itemCount: products.length,
                        separatorBuilder: (_, __) => const Gap(16),
                        itemBuilder: (context, index) => _ProductCard(product: products[index]),
                      ),
                    ),
                  );
                },
                loading: () => const SliverToBoxAdapter(child: SizedBox.shrink()),
                error: (e, _) => const SliverToBoxAdapter(child: SizedBox.shrink()),
              ),

              // 4. Final CTA
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 60, 24, 120),
                  child: _buildFinalCTA(context, theme, l10n),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModernAppBar(BuildContext context, ThemeData theme) {
    final isDark = theme.brightness == Brightness.dark;
    return SliverAppBar(
      expandedHeight: 200,
      pinned: true,
      stretch: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      leadingWidth: 64,
      leading: Padding(
        padding: const EdgeInsets.only(left: 16),
        child: Center(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 16),
              onPressed: () => context.pop(),
            ),
          ),
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        titlePadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        title: Text(
          issueTitle.translateService(context),
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w900,
            color: Colors.white,
            letterSpacing: -0.5,
          ),
        ),
        background: Stack(
          fit: StackFit.expand,
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isDark 
                      ? [const Color(0xFF1E40AF), const Color(0xFF1E3A8A)]
                      : [const Color(0xFF0054A5), const Color(0xFF003E96)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
            Positioned(
              right: -40,
              top: -40,
              child: Opacity(
                opacity: 0.1,
                child: Icon(Icons.auto_fix_high_rounded, size: 240, color: Colors.white.withValues(alpha: 0.5)),
              ),
            ),
            // Glassy bottom fade
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              height: 40,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      (isDark ? const Color(0xFF0D1B3E) : const Color(0xFFF0F4F8)).withValues(alpha: 0.5),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFinalCTA(BuildContext context, ThemeData theme, AppLocalizations l10n) {
    final isDark = theme.brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.white,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.transparent),
        boxShadow: isDark ? [] : [
          BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 30, offset: const Offset(0, 10)),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: (isDark ? Colors.white : const Color(0xFF0054A5)).withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.support_agent_rounded, size: 48, color: isDark ? Colors.white : const Color(0xFF0054A5)),
          ),
          const Gap(24),
          Text(
            l10n.stillCantFixIt,
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: theme.colorScheme.onSurface, letterSpacing: -0.5),
          ),
          const Gap(10),
          Text(
            l10n.techAtDoorDesc,
            textAlign: TextAlign.center,
            style: TextStyle(color: theme.colorScheme.onSurface.withValues(alpha: 0.5), height: 1.5, fontSize: 14, fontWeight: FontWeight.w500),
          ),
          const Gap(32),
          SizedBox(
            width: double.infinity,
            height: 60,
            child: ElevatedButton(
              onPressed: () => context.push('${AppRoutes.allProviders}/category?title=$serviceTitle'),
              style: ElevatedButton.styleFrom(
                backgroundColor: isDark ? const Color(0xFF1E40AF) : const Color(0xFF0054A5),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                elevation: 0,
              ),
              child: Text(l10n.bookAProfessional, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }
}

class _GuideTimelineSection extends ConsumerWidget {
  final String guideId;
  const _GuideTimelineSection({required this.guideId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stepsAsync = ref.watch(issueGuideStepsProvider(guideId));
    final theme = Theme.of(context);

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)!.repairInstructions, 
              style: TextStyle(
                fontSize: 26, 
                fontWeight: FontWeight.w900, 
                color: theme.colorScheme.onSurface, 
                letterSpacing: -0.8,
              ),
            ),
            const Gap(32),
            stepsAsync.when(
              data: (steps) => AnimationLimiter(
                child: Column(
                  children: List.generate(steps.length, (index) {
                    return AnimationConfiguration.staggeredList(
                      position: index,
                      duration: const Duration(milliseconds: 600),
                      child: SlideAnimation(
                        verticalOffset: 30.0,
                        child: FadeInAnimation(
                          child: _TimelineStep(
                            step: steps[index],
                            isLast: index == steps.length - 1,
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Text('Error: $e'),
            ),
          ],
        ),
      ),
    );
  }
}

class _TimelineStep extends StatelessWidget {
  final Map<String, dynamic> step;
  final bool isLast;
  const _TimelineStep({required this.step, required this.isLast});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final accentColor = isDark ? const Color(0xFF1E40AF) : const Color(0xFF0054A5);

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Step Line & Dot
          Column(
            children: [
              Container(
                width: 40, height: 40,
                decoration: BoxDecoration(
                  color: accentColor,
                  shape: BoxShape.circle,
                  boxShadow: [BoxShadow(color: accentColor.withValues(alpha: 0.3), blurRadius: 10, offset: const Offset(0, 4))],
                ),
                child: Center(child: Text('${step['stepNumber']}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 16))),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2.5,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [accentColor.withValues(alpha: 0.6), accentColor.withValues(alpha: 0.05)],
                      ),
                      borderRadius: BorderRadius.circular(1),
                    ),
                  ),
                ),
            ],
          ),
          const Gap(24),
          // Step Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 40),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.white,
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.transparent),
                  boxShadow: isDark ? [] : [
                    BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 20, offset: const Offset(0, 10)),
                  ],
                ),
                child: Text(
                  (step['content'] as String).translateService(context),
                  style: TextStyle(
                    fontSize: 16, 
                    height: 1.6, 
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.8), 
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final ProductModel product;
  const _ProductCard({required this.product});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final accentColor = isDark ? const Color(0xFF1E40AF) : const Color(0xFF0054A5);

    return Container(
      width: 190,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.transparent),
        boxShadow: isDark ? [] : [
          BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 20, offset: const Offset(0, 10)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: isDark ? Colors.white.withValues(alpha: 0.05) : const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(20),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: _buildProductImage(product),
                ),
              ),
            ),
          ),
          const Gap(16),
          Text(
            product.name.translateService(context),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontWeight: FontWeight.w900, fontSize: 15, color: theme.colorScheme.onSurface),
          ),
          const Gap(6),
          Text(
            '${product.price.toString().replaceAllMapped(RegExp(r"(\d)(?=(\d{3})+(?!\d))"), (m) => "${m[1]}.")}đ',
            style: TextStyle(color: accentColor, fontWeight: FontWeight.w900, fontSize: 16),
          ),
          const Gap(12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: accentColor.withValues(alpha: 0.1),
                foregroundColor: accentColor,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: Text(AppLocalizations.of(context)!.buy, style: const TextStyle(fontWeight: FontWeight.w800)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductImage(ProductModel product) {
    final lowerName = product.name.toLowerCase();
    
    // DEFENSIVE MAPPING: Luôn dùng đúng icon công cụ cho các sản phẩm phổ biến
    if (lowerName.contains('keo') || lowerName.contains('băng tan') || lowerName.contains('bột thông')) {
      return Image.asset('assets/images/Water Tap.png', fit: BoxFit.contain);
    }
    if (lowerName.contains('nhựa') || lowerName.contains('ống') || lowerName.contains('thụt') || lowerName.contains('cây')) {
      return Image.asset('assets/images/Pipe Wrench.png', fit: BoxFit.contain);
    }
    if (lowerName.contains('cờ lê') || lowerName.contains('mỏ lết')) {
      return Image.asset('assets/images/Pipe Wrench.png', fit: BoxFit.contain);
    }
    if (lowerName.contains('khoan')) {
      return Image.asset('assets/images/Drilling.png', fit: BoxFit.contain);
    }

    final imageUrl = AppwriteUtils.getImageUrl(product.imagePath);
    final lowerUrl = imageUrl.toLowerCase();

    // Loại bỏ triệt để ảnh thợ (image 83)
    bool hasPerson = lowerUrl.contains('image_83') || 
                     lowerUrl.contains('image 83') ||
                     lowerUrl.contains('provider') || 
                     lowerUrl.contains('painter') || 
                     lowerUrl.contains('boy');

    if (hasPerson || imageUrl.isEmpty) {
      return _buildFallbackImage(product.name);
    }

    if (imageUrl.startsWith('http')) {
      return CachedNetworkImage(
        imageUrl: imageUrl,
        fit: BoxFit.contain,
        placeholder: (context, url) => const Center(child: CircularProgressIndicator(strokeWidth: 2)),
        errorWidget: (context, url, error) => _buildFallbackImage(product.name),
      );
    }

    if (imageUrl.contains('assets/')) {
      return Image.asset(
        imageUrl,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) => _buildFallbackImage(product.name),
      );
    }

    return _buildFallbackImage(product.name);
  }

  Widget _buildFallbackImage(String name) {
    final lowerName = name.toLowerCase();
    
    // Ánh xạ tên sản phẩm sang các Icon công cụ thuần túy (không có người)
    if (lowerName.contains('keo') || lowerName.contains('nhựa') || lowerName.contains('ống') || lowerName.contains('băng tan') || lowerName.contains('pvc')) {
      return Image.asset('assets/images/Plumbing Pipe.png', fit: BoxFit.contain);
    }
    if (lowerName.contains('kìm') || lowerName.contains('kéo')) {
      return Image.asset('assets/images/Pliers.png', fit: BoxFit.contain);
    }
    if (lowerName.contains('cờ lê') || lowerName.contains('mỏ lết') || lowerName.contains('vặn') || lowerName.contains('tua vít')) {
      return Image.asset('assets/images/Pipe Wrench.png', fit: BoxFit.contain);
    }
    if (lowerName.contains('điện') || lowerName.contains('đo') || lowerName.contains('đồng hồ')) {
      return Image.asset('assets/images/Multimeter.png', fit: BoxFit.contain);
    }
    if (lowerName.contains('khóa') || lowerName.contains('chốt') || lowerName.contains('ổ khóa')) {
      return Image.asset('assets/images/Sturdy lock.png', fit: BoxFit.contain);
    }
    if (lowerName.contains('khoan') || lowerName.contains('vít') || lowerName.contains('máy')) {
      return Image.asset('assets/images/Drilling.png', fit: BoxFit.contain);
    }
    if (lowerName.contains('sơn') || lowerName.contains('lăn') || lowerName.contains('cọ')) {
      return Image.asset('assets/images/Painting.png', fit: BoxFit.contain);
    }

    // Mặc định trả về một bộ công cụ trung tính
    final toolAssets = [
      'Pipe Wrench.png',
      'Pliers.png',
      'Multimeter.png',
      'Plumbing Pipe.png',
    ];
    
    final assetName = toolAssets[(name.hashCode % toolAssets.length).abs()];
    return Image.asset('assets/images/$assetName', fit: BoxFit.contain);
  }
}

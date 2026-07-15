import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import 'package:fixit/core/utils/service_translation_helper.dart';
import 'package:fixit/core/presentation/widgets/app_background.dart';
import 'package:fixit/core/router/app_router.dart';
import 'package:fixit/core/utils/appwrite_utils.dart';
import 'package:fixit/l10n/app_localizations.dart';
import '../../../domain/entities/home_category.dart';
import '../../providers/services_provider.dart';
import '../../widgets/components/shimmer_loading.dart';

class AllServicesScreen extends ConsumerStatefulWidget {
  final String? initialCategory;
  const AllServicesScreen({super.key, this.initialCategory});

  @override
  ConsumerState<AllServicesScreen> createState() => _AllServicesScreenState();
}

class _AllServicesScreenState extends ConsumerState<AllServicesScreen> {
  final ScrollController _scrollController = ScrollController();
  final Map<String, GlobalKey> _sectionKeys = {};
  String _activeCategory = '';
  bool _isManualScrolling = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isManualScrolling) return;
    
    String? currentId;
    double minDistance = double.infinity;

    _sectionKeys.forEach((id, key) {
      final context = key.currentContext;
      if (context != null) {
        final box = context.findRenderObject() as RenderBox;
        final position = box.localToGlobal(Offset.zero).dy;
        final distance = (position - 150).abs(); 
        if (distance < minDistance) {
          minDistance = distance;
          currentId = id;
        }
      }
    });

    if (currentId != null && _activeCategory != currentId) {
      setState(() => _activeCategory = currentId!);
    }
  }

  void _scrollToSection(String categoryId) async {
    final key = _sectionKeys[categoryId];
    if (key != null && key.currentContext != null) {
      setState(() {
        _activeCategory = categoryId;
        _isManualScrolling = true;
      });
      
      await Scrollable.ensureVisible(
        key.currentContext!,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOutCubic,
        alignment: 0.1, 
      );

      Future.delayed(const Duration(milliseconds: 100), () {
        if (mounted) setState(() => _isManualScrolling = false);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final servicesAsync = ref.watch(allServicesProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: AppBackground(
        child: servicesAsync.when(
          data: (services) {
            final allParents = services.where((s) => s.id.startsWith('pop_')).toList();
            
            if (_activeCategory.isEmpty && allParents.isNotEmpty) {
              _activeCategory = allParents.first.id;
            }

            final displayParents = widget.initialCategory != null
                ? allParents.where((p) => p.title.toLowerCase() == widget.initialCategory!.toLowerCase()).toList()
                : allParents;

            final selectedCategory = widget.initialCategory != null && displayParents.isNotEmpty ? displayParents.first : null;

            for (var p in allParents) {
              _sectionKeys.putIfAbsent(p.id, () => GlobalKey());
            }

            return AnimationLimiter(
              child: CustomScrollView(
                controller: _scrollController,
                physics: const BouncingScrollPhysics(),
                slivers: [
                  _buildModernAppBar(context, theme, widget.initialCategory != null ? widget.initialCategory!.translateService(context) : l10n.allServices, selectedCategory, l10n),
                  
                  if (selectedCategory != null) _buildCategoryHeader(selectedCategory, theme, l10n),
                  
                  if (selectedCategory == null && allParents.isNotEmpty)
                    SliverPersistentHeader(
                      pinned: true,
                      delegate: _SliverCategoryDelegate(
                        child: ClipRRect(
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                            child: Container(
                              height: 70,
                              decoration: BoxDecoration(
                                color: (isDark ? const Color(0xFF010A1A) : Colors.white).withValues(alpha: 0.1),
                                border: Border(
                                  bottom: BorderSide(
                                    color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.05),
                                    width: 0.5,
                                  ),
                                ),
                              ),
                              child: ListView.separated(
                                scrollDirection: Axis.horizontal,
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                                itemCount: allParents.length,
                                separatorBuilder: (_, __) => const Gap(10),
                                itemBuilder: (context, index) {
                                  final p = allParents[index];
                                  final isActive = _activeCategory == p.id;
                                  final accentColor = Color(p.color);
                                  return GestureDetector(
                                    onTap: () => _scrollToSection(p.id),
                                    child: AnimatedContainer(
                                      duration: const Duration(milliseconds: 300),
                                      padding: const EdgeInsets.symmetric(horizontal: 20),
                                      decoration: BoxDecoration(
                                        color: isActive ? accentColor : (isDark ? Colors.white.withValues(alpha: 0.05) : Colors.white),
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(
                                          color: isActive ? Colors.transparent : theme.colorScheme.onSurface.withValues(alpha: 0.1),
                                        ),
                                        boxShadow: [
                                          if (isActive)
                                            BoxShadow(
                                              color: accentColor.withValues(alpha: 0.3),
                                              blurRadius: 10,
                                              offset: const Offset(0, 4),
                                            ),
                                        ],
                                      ),
                                      child: Center(
                                        child: Text(
                                          p.title.translateService(context),
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w800,
                                            color: isActive ? Colors.white : theme.colorScheme.onSurface.withValues(alpha: 0.6),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                  SliverPadding(
                    padding: EdgeInsets.only(top: selectedCategory != null ? 0 : 12, bottom: 60),
                    sliver: _buildCategorizedView(services, displayParents, theme, l10n, hideHeader: selectedCategory != null),
                  ),
                ],
              ),
            );
          },
          loading: () => _buildSkeletonView(theme),
          error: (e, _) => Center(child: Text(l10n.error(e.toString()))),
        ),
      ),
    );
  }

  Widget _buildCategorizedView(List<HomeCategory> allServices, List<HomeCategory> parents, ThemeData theme, AppLocalizations l10n, {bool hideHeader = false}) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final parent = parents[index];
          final children = allServices.where((s) => s.parentId == parent.id).toList();

          if (children.isEmpty) return const SizedBox.shrink();

          return AnimationConfiguration.staggeredList(
            position: index,
            duration: const Duration(milliseconds: 600),
            child: SlideAnimation(
              verticalOffset: 30.0,
              child: FadeInAnimation(
                child: Container(
                  key: _sectionKeys[parent.id], 
                  margin: const EdgeInsets.only(bottom: 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (!hideHeader)
                        Padding(
                          padding: const EdgeInsets.fromLTRB(24, 0, 24, 18),
                          child: Row(
                            children: [
                              Container(
                                width: 4,
                                height: 20,
                                decoration: BoxDecoration(
                                  color: Color(parent.color),
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                              const Gap(12),
                              Text(
                                parent.title.translateService(context),
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w900,
                                  color: theme.colorScheme.onSurface,
                                  letterSpacing: -0.5,
                                ),
                              ),
                              const Spacer(),
                              Text(
                                l10n.items(children.length),
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
                                ),
                              ),
                            ],
                          ),
                        ),
                      
                      hideHeader 
                        ? Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: children.length,
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 20,
                                crossAxisSpacing: 20,
                                mainAxisExtent: 180,
                              ),
                              itemBuilder: (context, idx) => _ServiceItem(
                                category: children[idx],
                                accentColor: Color(parent.color),
                                isLarge: true,
                              ),
                            ),
                          )
                        : SizedBox(
                            height: 160,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              padding: const EdgeInsets.symmetric(horizontal: 24),
                              physics: const BouncingScrollPhysics(),
                              itemCount: children.length,
                              separatorBuilder: (_, __) => const Gap(16),
                              itemBuilder: (context, idx) => _ServiceItem(
                                category: children[idx],
                                accentColor: Color(parent.color),
                                isLarge: false,
                              ),
                            ),
                          ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
        childCount: parents.length,
      ),
    );
  }

  Widget _buildModernAppBar(BuildContext context, ThemeData theme, String title, HomeCategory? category, AppLocalizations l10n) {
    final isDark = theme.brightness == Brightness.dark;
    return SliverAppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 2,
      pinned: true,
      centerTitle: true,
      leadingWidth: 64,
      leading: Padding(
        padding: const EdgeInsets.only(left: 16),
        child: Center(
          child: Container(
            decoration: BoxDecoration(
              color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.white,
              shape: BoxShape.circle,
              boxShadow: isDark ? [] : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: IconButton(
              icon: Icon(Icons.arrow_back_ios_new_rounded, color: theme.colorScheme.onSurface, size: 16),
              onPressed: () => context.pop(),
            ),
          ),
        ),
      ),
      title: category != null 
        ? Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Color(category.color).withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Color(category.color).withValues(alpha: 0.1), width: 1),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildCategoryImage(category.imagePath, 24),
                const Gap(10),
                Text(
                  category.title.translateService(context),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    color: Color(category.color).withValues(alpha: 0.9),
                    letterSpacing: -0.5,
                  ),
                ),
              ],
            ),
          )
        : Text(
            title,
            style: TextStyle(
              color: theme.colorScheme.onSurface,
              fontWeight: FontWeight.w900,
              fontSize: 22,
              letterSpacing: -0.8,
            ),
          ),
      actions: const [
        SizedBox(width: 64), 
      ],
    );
  }

  Widget _buildCategoryHeader(HomeCategory category, ThemeData theme, AppLocalizations l10n) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 28),
        child: Container(
          width: double.infinity,
          height: 160,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(category.color).withValues(alpha: 0.15),
                Color(category.color).withValues(alpha: 0.05),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(32),
          ),
          child: Stack(
            children: [
              Positioned(
                right: -20,
                bottom: -20,
                child: Opacity(
                  opacity: 0.2,
                  child: Transform.rotate(
                    angle: -0.2,
                    child: _buildCategoryImage(category.imagePath, 160),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      l10n.reliableServices(category.title.translateService(context)),
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w900,
                        color: Color(category.color).withValues(alpha: 0.9),
                        height: 1.1,
                        letterSpacing: -1,
                      ),
                    ),
                    const Gap(12),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: Color(category.color).withValues(alpha: 0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Text(
                        l10n.expertSupport,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: Color(category.color),
                        ),
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

  Widget _buildSkeletonView(ThemeData theme) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(backgroundColor: theme.colorScheme.surface, elevation: 0, title: const Text('')),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(24, 20, 24, 12),
                  child: ShimmerBox(width: 140, height: 32, borderRadius: 12),
                ),
                SizedBox(
                  height: 165,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    itemCount: 4,
                    separatorBuilder: (_, __) => const Gap(18),
                    itemBuilder: (context, index) => const _ServiceItemSkeleton(),
                  ),
                ),
              ],
            ),
            childCount: 3,
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryImage(String path, double size) {
    if (path.isEmpty) return Icon(Icons.category_rounded, size: size, color: Colors.grey);
    
    final imageUrl = AppwriteUtils.getImageUrl(path);

    return CachedNetworkImage(
      imageUrl: imageUrl,
      width: size,
      height: size,
      fit: BoxFit.contain,
      errorWidget: (context, url, error) {
        // Fallback to asset if it looks like a path
        if (path.contains('assets/') || (path.contains('.') && path.length < 30)) {
          return Image.asset(
            path.contains('assets/') ? path : 'assets/images/$path',
            width: size,
            height: size,
            fit: BoxFit.contain,
            errorBuilder: (_, __, ___) => Icon(Icons.category_rounded, size: size, color: Colors.grey),
          );
        }
        return Icon(Icons.category_rounded, size: size, color: Colors.grey);
      },
    );
  }
}

class _SliverCategoryDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  _SliverCategoryDelegate({required this.child});

  @override
  double get minExtent => 70;
  @override
  double get maxExtent => 70;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  bool shouldRebuild(covariant _SliverCategoryDelegate oldDelegate) => true;
}

class _ServiceItem extends StatefulWidget {
  final HomeCategory category;
  final Color? accentColor;
  final bool isLarge;
  const _ServiceItem({required this.category, this.accentColor, this.isLarge = false});

  @override
  State<_ServiceItem> createState() => _ServiceItemState();
}

class _ServiceItemState extends State<_ServiceItem> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    final Color itemBgColor = widget.isLarge 
        ? (widget.accentColor?.withValues(alpha: 0.05) ?? theme.colorScheme.surface)
        : (isDark ? Colors.white.withValues(alpha: 0.05) : Colors.white);

    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: () {
        context.push(
          Uri(
            path: '${AppRoutes.serviceIssues}/${widget.category.id}',
            queryParameters: {
              'title': widget.category.title,
            },
          ).toString(),
        );
      },
      child: AnimatedScale(
        scale: _isPressed ? 0.95 : 1.0,
        duration: const Duration(milliseconds: 150),
        child: SizedBox(
          width: 110,
          child: Column(
            children: [
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: itemBgColor,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: widget.accentColor?.withValues(alpha: 0.1) ?? Colors.transparent,
                      width: 1.5,
                    ),
                    boxShadow: isDark ? [] : [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.03),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: widget.category.imagePath.isEmpty
                      ? const Icon(Icons.build_circle_outlined, color: Colors.grey)
                      : _buildItemImage(widget.category.imagePath),
                ),
              ),
              const Gap(10),
              Text(
                widget.category.title.translateService(context),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 12,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
                  height: 1.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildItemImage(String path) {
    final imageUrl = AppwriteUtils.getImageUrl(path);

    return CachedNetworkImage(
      imageUrl: imageUrl,
      fit: BoxFit.contain,
      placeholder: (context, url) => const ShimmerBox(
        width: double.infinity,
        height: double.infinity,
        borderRadius: 24,
      ),
      errorWidget: (context, url, error) {
        // Fallback to asset
        if (path.contains('assets/') || (path.contains('.') && path.length < 30)) {
          return Image.asset(
            path.contains('assets/') ? path : 'assets/images/$path',
            fit: BoxFit.contain,
            errorBuilder: (_, __, ___) => const Icon(Icons.broken_image),
          );
        }
        return const Icon(Icons.broken_image);
      },
    );
  }
}

class _ServiceItemSkeleton extends StatelessWidget {
  const _ServiceItemSkeleton();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 90,
      child: Column(
        children: [
          ShimmerBox(width: 90, height: 90, borderRadius: 28),
          Gap(10),
          ShimmerBox(width: 70, height: 14, borderRadius: 4),
        ],
      ),
    );
  }
}

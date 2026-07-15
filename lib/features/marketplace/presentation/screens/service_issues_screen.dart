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
import '../../../home/presentation/widgets/components/shimmer_loading.dart';
import '../../domain/models/service_issue_model.dart';
import '../providers/service_flow_provider.dart';

class ServiceIssuesScreen extends ConsumerWidget {
  final String serviceId;
  final String serviceTitle;

  const ServiceIssuesScreen({
    super.key,
    required this.serviceId,
    required this.serviceTitle,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: AppBackground(
        child: Consumer(
          builder: (context, ref, child) {
            final issuesAsync = ref.watch(serviceIssuesProvider(serviceId));

            return issuesAsync.when(
              loading: () => const _IssuesSkeleton(),
              error: (e, _) => Center(child: Text('Error: $e')),
              data: (issues) => AnimationLimiter(
                child: CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    _buildModernAppBar(context, theme, l10n),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.commonIssues,
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.w900,
                                color: theme.colorScheme.onSurface,
                                letterSpacing: -1.5,
                                height: 1.1,
                              ),
                            ),
                            const Gap(12),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                              decoration: BoxDecoration(
                                color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.white,
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.black.withValues(alpha: 0.05),
                                ),
                              ),
                              child: Text(
                                l10n.tapToSeeGuide,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (issues.isEmpty)
                      SliverFillRemaining(
                        child: Center(
                          child: Text(
                            l10n.noResultsFound,
                            style: TextStyle(color: theme.colorScheme.onSurface.withValues(alpha: 0.5)),
                          ),
                        ),
                      )
                    else
                      SliverPadding(
                        padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
                        sliver: SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) => AnimationConfiguration.staggeredList(
                              position: index,
                              duration: const Duration(milliseconds: 600),
                              child: SlideAnimation(
                                verticalOffset: 50.0,
                                child: FadeInAnimation(
                                  child: _IssueModernCard(issue: issues[index], serviceTitle: serviceTitle),
                                ),
                              ),
                            ),
                            childCount: issues.length,
                          ),
                        ),
                      ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(24, 0, 24, 60),
                        child: _buildHireCTA(context, theme, l10n),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildModernAppBar(BuildContext context, ThemeData theme, AppLocalizations l10n) {
    final isDark = theme.brightness == Brightness.dark;
    return SliverAppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      pinned: true,
      centerTitle: true,
      leadingWidth: 64,
      leading: Padding(
        padding: const EdgeInsets.only(left: 16),
        child: Center(
          child: Container(
            decoration: BoxDecoration(
              color: isDark ? Colors.white.withValues(alpha: 0.08) : Colors.white,
              shape: BoxShape.circle,
              boxShadow: isDark ? [] : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
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
      title: Text(
        serviceTitle.translateService(context),
        style: TextStyle(
          color: theme.colorScheme.onSurface,
          fontWeight: FontWeight.w900,
          fontSize: 20,
          letterSpacing: -0.8,
        ),
      ),
    );
  }

  Widget _buildHireCTA(BuildContext context, ThemeData theme, AppLocalizations l10n) {
    final isDark = theme.brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark 
              ? [const Color(0xFF1E40AF), const Color(0xFF1E3A8A)]
              : [const Color(0xFF0054A5), const Color(0xFF003E96)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: (isDark ? const Color(0xFF1E40AF) : const Color(0xFF0054A5)).withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.engineering_rounded, color: Colors.white, size: 32),
          ),
          const Gap(20),
          Text(
            l10n.needAnExpert,
            style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w900, letterSpacing: -0.5),
          ),
          const Gap(8),
          Text(
            l10n.bookVerifiedPro,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 14, fontWeight: FontWeight.w500),
          ),
          const Gap(28),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: () => context.push('${AppRoutes.allProviders}/category?title=$serviceTitle'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFF0054A5),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 0,
              ),
              child: Text(
                l10n.findTechnician,
                style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16, letterSpacing: -0.2),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _IssueModernCard extends StatelessWidget {
  final ServiceIssueModel issue;
  final String serviceTitle;
  const _IssueModernCard({required this.issue, required this.serviceTitle});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.transparent,
        ),
        boxShadow: isDark ? [] : [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => context.push(
            Uri(
              path: '${AppRoutes.serviceSolution}/${issue.id}',
              queryParameters: {
                'title': issue.title,
                'serviceTitle': serviceTitle,
              },
            ).toString(),
          ),
          borderRadius: BorderRadius.circular(28),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 76,
                  height: 76,
                  decoration: BoxDecoration(
                    color: isDark ? Colors.white.withValues(alpha: 0.05) : const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(
                      color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.black.withValues(alpha: 0.02),
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(22),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: _buildIssueImage(issue, isDark),
                    ),
                  ),
                ),
                const Gap(16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        issue.title.translateService(context),
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 16,
                          color: theme.colorScheme.onSurface,
                          letterSpacing: -0.3,
                        ),
                      ),
                      const Gap(6),
                      Text(
                        issue.description.translateService(context),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                          fontSize: 13,
                          height: 1.3,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                const Gap(8),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: (isDark ? Colors.white : const Color(0xFF0054A5)).withValues(alpha: 0.05),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: isDark ? Colors.white.withValues(alpha: 0.5) : const Color(0xFF0054A5),
                    size: 12,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIssueImage(ServiceIssueModel issue, bool isDark) {
    final imageUrl = AppwriteUtils.getImageUrl(issue.imagePath);

    if (imageUrl.contains('image 83') || imageUrl.isEmpty) {
      return Icon(Icons.build_rounded, color: isDark ? Colors.white38 : Colors.blueGrey);
    }

    if (imageUrl.startsWith('http')) {
      return CachedNetworkImage(
        imageUrl: imageUrl,
        fit: BoxFit.contain,
        placeholder: (context, url) => const ShimmerBox(width: double.infinity, height: double.infinity, borderRadius: 12),
        errorWidget: (_, __, ___) => Icon(Icons.build_rounded, color: isDark ? Colors.white38 : Colors.blueGrey),
      );
    }

    return Image.asset(
      imageUrl,
      fit: BoxFit.contain,
      errorBuilder: (_, __, ___) => Icon(Icons.build_rounded, color: isDark ? Colors.white38 : Colors.blueGrey),
    );
  }
}

class _IssuesSkeleton extends StatelessWidget {
  const _IssuesSkeleton();
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Gap(100),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShimmerBox(width: 200, height: 32, borderRadius: 8),
                Gap(12),
                ShimmerBox(width: 250, height: 40, borderRadius: 14),
              ],
            ),
          ),
          const Gap(32),
          ...List.generate(3, (index) => const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
            child: ShimmerBox(width: double.infinity, height: 108, borderRadius: 28),
          )),
        ],
      ),
    );
  }
}

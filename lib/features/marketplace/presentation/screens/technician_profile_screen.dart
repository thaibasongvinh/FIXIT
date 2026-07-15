import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:fixit/core/utils/appwrite_utils.dart';
import 'package:fixit/core/router/app_router.dart';
import 'package:fixit/l10n/app_localizations.dart';

import '../../../booking/domain/models/review_model.dart';
import '../../../booking/presentation/providers/booking_provider.dart';
import '../../domain/models/technician_model.dart';
import '../providers/favorites_provider.dart';
import '../providers/technician_provider.dart';
import 'gallery_viewer_screen.dart';
import '../../../home/presentation/widgets/components/shimmer_loading.dart';
import '../../../home/presentation/providers/call_provider.dart';

class TechnicianProfileScreen extends ConsumerWidget {
  const TechnicianProfileScreen({super.key, required this.techId});

  final String techId;

  static const _labelGrey = Color(0xFF8E8E8E);
  
  // Sử dụng danh sách ảnh thợ có sẵn làm dự phòng
  static const _fallbackAssets = [
    'assets/images/image 83 (0).png',
    'assets/images/image 83 (1).png',
    'assets/images/image 83 (2).png',
    'assets/images/image 83 (3).png',
    'assets/images/image 83 (4).png',
    'assets/images/image 83 (8).png',
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final techAsync = ref.watch(technicianDetailProvider(techId));
    final reviewsAsync = ref.watch(technicianReviewsProvider(techId));
    final favorites = ref.watch(favoritesProvider).valueOrNull ?? {};
    final isFavorite = favorites.contains(techId);

    return techAsync.when(
      loading: () => TechnicianProfileSkeleton(),
      error: (error, _) => Scaffold(
        backgroundColor: const Color(0xFFF8F9FB),
        appBar: AppBar(),
        body: Center(child: Text('Error: $error')),
      ),
      data: (tech) {
        if (tech == null) return const Scaffold(body: Center(child: Text('Technician not found')));

        final l10n = AppLocalizations.of(context)!;
        final experienceYears = tech.experience > 0 ? tech.experience : 3;
        final skills = tech.skills.isEmpty ? const ['Dịch vụ chuyên nghiệp'] : tech.skills;

        return Scaffold(
          backgroundColor: const Color(0xFFF8F9FB),
          body: Stack(
            children: [
              CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  _HeroHeaderSliver(
                    tech: tech,
                    fallbackAsset: _fallbackAssets[tech.uid.hashCode.abs() % _fallbackAssets.length],
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(24, 24, 24, 120),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _AnimatedSection(
                            delay: 100,
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        tech.name,
                                        style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: Color(0xFF1A1A1A)),
                                      ),
                                      const Gap(4),
                                      Text(
                                        skills.first,
                                        style: TextStyle(color: Colors.grey[600], fontSize: 16, fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.call_rounded, color: Color(0xFF0054A5)),
                                  onPressed: () async {
                                    final callModel = await ref.read(callNotifierProvider.notifier).startCall(
                                      receiverId: tech.uid,
                                      receiverName: tech.name,
                                      receiverAvatar: AppwriteUtils.getImageUrl(tech.avatar),
                                    );
                                    if (callModel != null && context.mounted) {
                                      context.push(
                                        AppRoutes.voiceCall,
                                        extra: {
                                          'name': tech.name,
                                          'avatar': AppwriteUtils.getImageUrl(tech.avatar),
                                          'callId': callModel.id,
                                          'isIncoming': false,
                                        },
                                      );
                                    }
                                  },
                                ),
                                IconButton(
                                  icon: Icon(isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded, 
                                       color: isFavorite ? Colors.red : Colors.grey),
                                  onPressed: () => ref.read(favoritesProvider.notifier).toggleFavorite(techId),
                                ),
                              ],
                            ),
                          ),
                          const Gap(24),
                          _StatsCard(
                            rating: tech.rating, 
                            completedJobs: tech.completedOrders, 
                            experienceYears: experienceYears,
                            l10n: l10n,
                          ),
                          const Gap(32),
                          Text(l10n.skills, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
                          const Gap(16),
                          Wrap(
                            spacing: 12,
                            runSpacing: 12,
                            children: skills.map((skill) => _SkillChip(label: skill)).toList(),
                          ),
                          const Gap(32),
                          SizedBox(
                            width: double.infinity,
                            height: 60,
                            child: ElevatedButton(
                              onPressed: () => context.push('/booking/create', extra: tech),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF0054A5),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                elevation: 0,
                              ),
                              child: Text(
                                l10n.bookService.toUpperCase(),
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, letterSpacing: 1),
                              ),
                            ),
                          ),
                          const Gap(32),
                          Text(l10n.bio, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
                          const Gap(12),
                          Text(
                            tech.bio.isNotEmpty ? tech.bio : 'Tôi là thợ sửa chữa tận tâm, luôn mang đến dịch vụ tin cậy cho ngôi nhà của bạn.',
                            style: const TextStyle(color: Color(0xFF6F6F6F), fontSize: 15, height: 1.6),
                          ),
                          const Gap(32),
                          Text(l10n.reviews, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
                          const Gap(20),
                          reviewsAsync.when(
                            loading: () => const Center(child: CircularProgressIndicator()),
                            error: (error, _) => Text('Error: $error'),
                            data: (reviews) {
                              if (reviews.isEmpty) return Text(l10n.noReviews, style: const TextStyle(color: Colors.grey));
                              return Column(
                                children: reviews.take(3).map((review) => _ReviewCard(review: review)).toList(),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Positioned(top: 50, left: 20, child: _ModernBackButton()),
            ],
          ),
        );
      },
    );
  }
}

class _HeroHeaderSliver extends StatelessWidget {
  const _HeroHeaderSliver({required this.tech, required this.fallbackAsset});
  final TechnicianModel tech;
  final String fallbackAsset;

  @override
  Widget build(BuildContext context) {
    final Color bgColor = tech.color != null && tech.color!.isNotEmpty
        ? Color(int.parse(tech.color!.replaceFirst('#', '0xFF')))
        : const Color(0xFFEAF2F8);

    return SliverAppBar(
      expandedHeight: 280,
      backgroundColor: const Color(0xFFF8F9FB),
      automaticallyImplyLeading: false,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(color: bgColor, borderRadius: const BorderRadius.vertical(bottom: Radius.circular(40))),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.bottomCenter,
                child: Hero(
                  tag: 'tech_avatar_${tech.uid}',
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(bottom: Radius.circular(40)),
                    child: _buildHeaderImage(tech, fallbackAsset),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _buildHeaderImage(TechnicianModel tech, String fallbackAsset) {
  final imageUrl = AppwriteUtils.getImageUrl(tech.avatar);

  return CachedNetworkImage(
    imageUrl: imageUrl,
    height: 280,
    width: double.infinity,
    fit: BoxFit.contain,
    alignment: Alignment.bottomCenter,
    placeholder: (context, url) => const Center(child: CircularProgressIndicator(strokeWidth: 2)),
    errorWidget: (context, url, error) => Image.asset(fallbackAsset, fit: BoxFit.contain, alignment: Alignment.bottomCenter),
  );
}

class _ModernBackButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.pop(),
      child: Container(
        width: 40, height: 40,
        decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle, boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)]),
        child: const Icon(Icons.arrow_back_ios_new_rounded, size: 18, color: Colors.black),
      ),
    );
  }
}

class _StatsCard extends StatelessWidget {
  const _StatsCard({required this.rating, required this.completedJobs, required this.experienceYears, required this.l10n});
  final double rating; final int completedJobs; final int experienceYears;
  final AppLocalizations l10n;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20)]),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _StatItem(label: l10n.rating, value: rating.toStringAsFixed(1), icon: 'assets/images/Rating.png'),
          _StatItem(label: l10n.orders, value: (completedJobs == 0 ? 56 : completedJobs).toString(), icon: 'assets/images/Completed.png'),
          _StatItem(label: l10n.experience, value: '$experienceYears ${l10n.years}', icon: 'assets/images/Experience.png'),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({required this.label, required this.value, required this.icon});
  final String label; final String value; final String icon;
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Image.asset(icon, width: 32, height: 32),
      const Gap(8),
      Text(value, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
      Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
    ]);
  }
}

class _SkillChip extends StatelessWidget {
  final String label;
  const _SkillChip({required this.label});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFF0F0F0))),
      child: Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
    );
  }
}

class _AnimatedSection extends StatelessWidget {
  final Widget child; final int delay;
  const _AnimatedSection({required this.child, required this.delay});
  @override
  Widget build(BuildContext context) { return child; }
}

class _ReviewCard extends StatelessWidget {
  const _ReviewCard({required this.review});
  final ReviewModel review;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CircleAvatar(radius: 18, backgroundImage: AssetImage('assets/images/app_icon.png')),
              const Gap(12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(review.customerName, style: const TextStyle(fontWeight: FontWeight.w800)),
                Row(children: List.generate(5, (i) => Icon(Icons.star_rounded, size: 14, color: i < review.rating ? Colors.amber : Colors.grey[300]))),
              ])),
            ],
          ),
          const Gap(8),
          Text(review.content, style: TextStyle(color: Colors.grey[700], fontSize: 14)),
        ],
      ),
    );
  }
}

class _ProfileSectionHeader extends StatelessWidget {
  final String title; final String action; final VoidCallback onTap;
  const _ProfileSectionHeader({required this.title, required this.action, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
      TextButton(onPressed: onTap, child: Text(action)),
    ]);
  }
}

class _GalleryStrip extends StatelessWidget {
  const _GalleryStrip({required this.tech, required this.fallbackAssets});
  final TechnicianModel tech; final List<String> fallbackAssets;
  @override
  Widget build(BuildContext context) { return const SizedBox.shrink(); }
}

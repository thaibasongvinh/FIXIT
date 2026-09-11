import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:fixit/core/router/app_router.dart';
import 'package:fixit/core/utils/appwrite_utils.dart';
import 'package:fixit/l10n/app_localizations.dart';
import '../../../../../core/presentation/widgets/app_background.dart';
import '../../../../../shared/models/user_model.dart';
import '../../../../auth/presentation/providers/auth_provider.dart';
import 'package:fixit/features/profile/presentation/widgets/profile_widgets.dart';
import '../../../domain/entities/home_category.dart';
import '../../providers/home_provider.dart';
import '../../providers/services_provider.dart';
import '../../providers/banner_provider.dart';
import '../../../../marketplace/presentation/providers/technician_provider.dart';
import '../../widgets/home_widgets.dart';
import '../../../../search/presentation/providers/filter_provider.dart';
import 'package:fixit/features/notifications/presentation/providers/notification_provider.dart';
import 'package:fixit/features/chat/presentation/providers/chat_provider.dart';
import '../../../../marketplace/domain/models/technician_model.dart';
import '../../../../booking/presentation/providers/booking_provider.dart';
import '../../../../booking/presentation/widgets/booking_card.dart';
import '../../widgets/user_settings_drawer.dart';
import '../../../../main/presentation/providers/ui_state_provider.dart';
import 'package:fixit/shared/utils/seed_sample_data.dart';
import 'package:fixit/features/guides/domain/models/guide_model.dart'; // Import GuideModel
import 'package:fixit/features/guides/presentation/providers/guide_provider.dart';

import 'package:fixit/shared/widgets/typography/translated_text.dart';
import 'package:fixit/core/services/translation_provider.dart';
import 'package:fixit/core/config/locale_provider.dart';
import 'package:fixit/core/utils/service_translation_helper.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with SingleTickerProviderStateMixin {
  final _searchController = TextEditingController();
  late AnimationController _entranceController;
  final ScrollController _scrollController = ScrollController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _entranceController.forward();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _entranceController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _clearSearch() {
    ref.read(searchQueryProvider.notifier).state = '';
    ref.read(searchFilterProvider.notifier).state = FilterState();
    _searchController.clear();
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider).valueOrNull;
    final searchQuery = ref.watch(searchQueryProvider);
    final filter = ref.watch(searchFilterProvider);
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final locale = ref.watch(localeNotifierProvider);
    final targetLang = locale.languageCode;

    // Tải trước bản dịch cho HomeScreen
    if (targetLang != 'en') {
      ref.watch(translatedBatchProvider([
        l10n.services,
        l10n.professionalTechnicians,
        l10n.todayJobs,
        l10n.todayEarnings,
        l10n.completedOrders,
        l10n.acceptanceRate,
        l10n.activeJobs,
        l10n.noJobData,
        l10n.service,
        l10n.technicianSmall,
        l10n.noResultsFound,
        'GUIDES',
      ], targetLang));
    }

    // Lắng nghe thay đổi query để tìm kiếm hướng dẫn (Tránh giật do rebuild loop)
    ref.listen(searchQueryProvider, (previous, next) {
      if (next.isNotEmpty) {
        ref.read(guidesFeedNotifierProvider.notifier).search(next);
      }
    });

    final bool hasActiveFilters = filter.serviceCategory != 'ALL' ||
        filter.minRating > 3.0 ||
        filter.minPrice > 0;
    final isSearching = searchQuery.isNotEmpty || hasActiveFilters;

    final isTechnician = user?.role == UserRole.technician;

    return Scaffold(
      key: _scaffoldKey,
      drawer: const UserSettingsDrawer(),
      onDrawerChanged: (isOpen) {
        ref.read(drawerStateProvider.notifier).setOpen(isOpen);
      },
      body: AppBackground(
        child: Stack(
          children: [
            RefreshIndicator(
              onRefresh: () async {
                if (isTechnician) {
                  ref.invalidate(technicianBookingsProvider(user!.uid));
                } else {
                  ref.invalidate(homeBannersProvider);
                  ref.invalidate(allServicesProvider);
                  ref.invalidate(popularServicesProvider);
                  ref.invalidate(techniciansNotifierProvider);
                }
                await Future.delayed(const Duration(milliseconds: 800));
              },
              child: CustomScrollView(
                controller: _scrollController,
                physics: const AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics(),
                ),
                slivers: [
                  _buildAppBar(context, l10n, isDark, theme),
                  SliverToBoxAdapter(
                    child: isTechnician
                        ? _buildTechnicianDashboard(user, l10n, isDark)
                        : _buildCustomerMarketplace(l10n, isDark),
                  ),
                ],
              ),
            ),
            if (!isTechnician && isSearching)
              _buildSearchOverlay(
                  context, searchQuery, filter, hasActiveFilters, l10n, isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, AppLocalizations l10n, bool isDark,
      ThemeData theme) {
    final userAsync = ref.watch(currentUserProvider);

    return SliverAppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      pinned: true,
      centerTitle: false,
      automaticallyImplyLeading: false,
      expandedHeight: 70,
      title: userAsync.when(
        data: (user) => InkWell(
          onTap: () => _scaffoldKey.currentState?.openDrawer(),
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                  color: Colors.blueAccent.withOpacity(0.3), width: 1.5),
            ),
            child: ProfileAvatar(
              user: user ??
                  const UserModel(
                      uid: '', name: '', email: '', role: UserRole.none),
              size: 32,
            ),
          ),
        ),
        loading: () => const SizedBox(width: 32, height: 32),
        error: (_, __) => Image.asset('assets/images/app_icon.png', height: 32),
      ),
      actions: [
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                color: isDark ? Colors.white.withOpacity(0.05) : Colors.white,
                shape: BoxShape.circle,
                boxShadow: isDark
                    ? []
                    : [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
              ),
              child: IconButton(
                icon: Image.asset('assets/images/Chat.png',
                    width: 28, height: 28),
                onPressed: () => context.push(AppRoutes.chat),
              ),
            ),
            Consumer(
              builder: (context, ref, child) {
                final unreadCount = ref.watch(unreadChatCountProvider);
                if (unreadCount == 0) return const SizedBox.shrink();
                return Positioned(
                  right: 8,
                  top: 12,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                        color: Colors.redAccent, shape: BoxShape.circle),
                    constraints:
                        const BoxConstraints(minWidth: 16, minHeight: 16),
                    child: Text(
                      unreadCount > 9 ? '9+' : unreadCount.toString(),
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 8,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
        const Gap(12),
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                color: isDark ? Colors.white.withOpacity(0.05) : Colors.white,
                shape: BoxShape.circle,
                boxShadow: isDark
                    ? []
                    : [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
              ),
              child: IconButton(
                icon: Image.asset('assets/images/Notification.png',
                    width: 28, height: 28),
                onPressed: () => context.push('/notifications'),
              ),
            ),
            Consumer(
              builder: (context, ref, child) {
                final unreadCount = ref.watch(unreadNotificationsCountProvider);
                if (unreadCount == 0) return const SizedBox.shrink();
                return Positioned(
                  right: 8,
                  top: 12,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                        color: Colors.redAccent, shape: BoxShape.circle),
                    constraints:
                        const BoxConstraints(minWidth: 16, minHeight: 16),
                    child: Text(
                      unreadCount > 9 ? '9+' : unreadCount.toString(),
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 8,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
        const Gap(16),
      ],
    );
  }

  Widget _buildCustomerMarketplace(AppLocalizations l10n, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildEntranceWidget(delay: 0.1, child: const Gap(12)),
        _buildEntranceWidget(
          delay: 0.2,
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: HomePromoBanner(),
          ),
        ),
        _buildEntranceWidget(
          delay: 0.4,
          child: Transform.translate(
            offset: const Offset(0, -20),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: HomeSearchBar(
                controller: _searchController,
                onFilterPressed: () => context.push('/search/filter'),
              ),
            ),
          ),
        ),
        _buildEntranceWidget(
          delay: 0.6,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: HomeSectionHeader(
              title: l10n.services.toUpperCase(),
              onViewAll: () => context.push(AppRoutes.allServices),
            ),
          ),
        ),
        const Gap(16),
        _buildEntranceWidget(delay: 0.7, child: const PopularServicesRail()),
        const Gap(32),
        _buildEntranceWidget(
          delay: 0.8,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: HomeSectionHeader(
              title: l10n.professionalTechnicians,
              onViewAll: () => context.push(AppRoutes.allProviders),
            ),
          ),
        ),
        const Gap(16),
        _buildEntranceWidget(delay: 0.9, child: const ProviderPreviewRail()),
        const Gap(120),
      ],
    );
  }

  Widget _buildTechnicianDashboard(
      UserModel? user, AppLocalizations l10n, bool isDark) {
    final bookingsAsync =
        ref.watch(technicianBookingsProvider(user?.uid ?? ''));

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildEntranceWidget(
            delay: 0.1,
            child: Text(
              l10n.helloUser(user?.name.toUpperCase() ?? ''),
              style: TextStyle(
                  color: isDark ? Colors.white : Colors.black,
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.5),
            ),
          ),
          const Gap(4),
          _buildEntranceWidget(
            delay: 0.2,
            child: Text(
              l10n.todayJobs,
              style: TextStyle(
                  color:
                      (isDark ? Colors.white : Colors.black).withOpacity(0.4),
                  fontSize: 14),
            ),
          ),
          const Gap(32),
          _buildEntranceWidget(
            delay: 0.3,
            child: _buildEarningsCard(l10n, isDark),
          ),
          const Gap(40),
          _buildEntranceWidget(
            delay: 0.4,
            child: Row(
              children: [
                const Icon(Icons.rocket_launch_rounded,
                    color: Colors.blueAccent, size: 20),
                const Gap(12),
                Text(
                  l10n.activeJobs,
                  style: TextStyle(
                      color: isDark ? Colors.white : Colors.black,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.5,
                      fontSize: 12),
                ),
              ],
            ),
          ),
          const Gap(16),
          bookingsAsync.when(
            data: (bookings) {
              final active = bookings
                  .where((b) => b.status.isActive || b.status.isPending)
                  .toList();
              if (active.isEmpty) {
                return _buildEntranceWidget(
                  delay: 0.5,
                  child: _buildEmptyState(l10n.noJobData, isDark),
                );
              }
              return Column(
                children: List.generate(active.length, (index) {
                  return _buildEntranceWidget(
                    delay: 0.5 + (index * 0.1),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: BookingCard(booking: active[index]),
                    ),
                  );
                }),
              );
            },
            loading: () => Center(
                child: CircularProgressIndicator(
                    color: isDark ? Colors.white12 : Colors.black12)),
            error: (e, _) => Text(l10n.error(e.toString()),
                style:
                    TextStyle(color: isDark ? Colors.white24 : Colors.black26)),
          ),
          const Gap(100),
        ],
      ),
    );
  }

  Widget _buildEarningsCard(AppLocalizations l10n, bool isDark) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.blueAccent.withOpacity(0.2),
                Colors.blueAccent.withOpacity(0.05)
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(
                color: (isDark ? Colors.white : Colors.black).withOpacity(0.1)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l10n.todayEarnings,
                  style: TextStyle(
                      color: isDark ? Colors.white54 : Colors.black54,
                      fontSize: 12,
                      fontWeight: FontWeight.bold)),
              const Gap(8),
              Text('1.250.000₫',
                  style: TextStyle(
                      color: isDark ? Colors.white : Colors.black,
                      fontSize: 32,
                      fontWeight: FontWeight.w900)),
              const Gap(24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildMiniStat(l10n.completedOrders, '12', isDark),
                  _buildMiniStat(l10n.acceptanceRate, '98%', isDark),
                  const Icon(Icons.trending_up_rounded,
                      color: Colors.greenAccent, size: 32),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMiniStat(String label, String value, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TranslatedText(label,
            style: TextStyle(
                color: isDark ? Colors.white38 : Colors.black38,
                fontSize: 10,
                fontWeight: FontWeight.bold)),
        const Gap(4),
        Text(value,
            style: TextStyle(
                color: isDark ? Colors.white : Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildEmptyState(String msg, bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: (isDark ? Colors.white : Colors.black).withOpacity(0.03),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
            color: (isDark ? Colors.white : Colors.black).withOpacity(0.05)),
      ),
      child: Column(
        children: [
          Icon(Icons.inbox_outlined,
              size: 48,
              color: (isDark ? Colors.white : Colors.black).withOpacity(0.1)),
          const Gap(16),
          Text(msg,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color:
                      (isDark ? Colors.white : Colors.black).withOpacity(0.2),
                  fontSize: 13)),
        ],
      ),
    );
  }

  Widget _buildSearchOverlay(BuildContext context, String query,
      FilterState filter, bool hasFilters, AppLocalizations l10n, bool isDark) {
    return Positioned.fill(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          color: isDark
              ? const Color(0xFF0F172A).withValues(alpha: 0.95)
              : Colors.white.withValues(alpha: 0.9),
          child: Column(
            children: [
              const Gap(54),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back_ios_new_rounded,
                          color: isDark ? Colors.white : Colors.black,
                          size: 20),
                      onPressed: _clearSearch,
                    ),
                    Expanded(
                      child: HomeSearchBar(
                        controller: _searchController,
                        onFilterPressed: () => context.push('/search/filter'),
                      ),
                    ),
                  ],
                ),
              ),
              const Gap(20),
              Expanded(
                child: DefaultTabController(
                  length: 3,
                  child: Column(
                    children: [
                      TabBar(
                        tabs: [
                          Tab(text: l10n.service),
                          Tab(text: l10n.technicianSmall),
                          const Tab(child: TranslatedText('GUIDES')),
                        ],
                        labelColor: isDark ? Colors.white : Colors.black,
                        unselectedLabelColor:
                            (isDark ? Colors.white : Colors.black)
                                .withValues(alpha: 0.3),
                        indicatorColor: const Color(0xFF005CB7),
                        indicatorWeight: 3,
                        labelStyle: const TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 13,
                            letterSpacing: 1),
                      ),
                      Expanded(
                        child: TabBarView(
                          children: [
                            _buildServiceResults(query, isDark, l10n),
                            _buildTechnicianResults(l10n, isDark),
                            _buildGuideResults(query, isDark, l10n),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGuideResults(String query, bool isDark, AppLocalizations l10n) {
    final guidesAsync = ref.watch(guidesFeedNotifierProvider);

    return guidesAsync.when(
      data: (state) {
        if (state.items.isEmpty) return _buildNoResults(l10n, isDark);
        return GridView.builder(
          padding: const EdgeInsets.all(20),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            mainAxisExtent: 260,
          ),
          itemCount: state.items.length,
          itemBuilder: (context, index) =>
              _GuidePremiumCard(guide: state.items[index], isDark: isDark),
        );
      },
      loading: () => Center(
          child: CircularProgressIndicator(
              color: isDark ? Colors.white12 : Colors.black12)),
      error: (e, _) => Center(
          child: Text(l10n.error(e.toString()),
              style: TextStyle(color: isDark ? Colors.white : Colors.black))),
    );
  }

  Widget _buildServiceResults(
      String query, bool isDark, AppLocalizations l10n) {
    final servicesAsync = ref.watch(allServicesProvider);
    return servicesAsync.when(
      data: (services) {
        final results = services
            .where((s) =>
                !s.id.startsWith('pop_') &&
                s.title.toLowerCase().contains(query.toLowerCase()))
            .toList();
        if (results.isEmpty) return _buildNoResults(l10n, isDark);
        return ListView.separated(
          padding: const EdgeInsets.all(20),
          itemCount: results.length,
          separatorBuilder: (_, __) => const Gap(12),
          itemBuilder: (context, index) =>
              _ServiceGlassTile(service: results[index], isDark: isDark),
        );
      },
      loading: () => Center(
          child: CircularProgressIndicator(
              color: isDark ? Colors.white12 : Colors.black12)),
      error: (e, _) => Center(
          child: Text(l10n.error(e.toString()),
              style: TextStyle(color: isDark ? Colors.white : Colors.black))),
    );
  }

  Widget _buildTechnicianResults(AppLocalizations l10n, bool isDark) {
    final techsAsync = ref.watch(filteredTechniciansProvider);
    return techsAsync.when(
      data: (techs) {
        if (techs.isEmpty) return _buildNoResults(l10n, isDark);
        return ListView.separated(
          padding: const EdgeInsets.all(20),
          itemCount: techs.length,
          separatorBuilder: (_, __) => const Gap(12),
          itemBuilder: (context, index) =>
              _TechnicianGlassCard(tech: techs[index], isDark: isDark),
        );
      },
      loading: () => Center(
          child: CircularProgressIndicator(
              color: isDark ? Colors.white12 : Colors.black12)),
      error: (e, _) => Center(
          child: Text(l10n.error(e.toString()),
              style: TextStyle(color: isDark ? Colors.white : Colors.black))),
    );
  }

  Widget _buildNoResults(AppLocalizations l10n, bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off_rounded,
              size: 80,
              color: (isDark ? Colors.white : Colors.black).withOpacity(0.05)),
          const Gap(16),
          Text(l10n.noResultsFound,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: (isDark ? Colors.white : Colors.black)
                      .withOpacity(0.24))),
        ],
      ),
    );
  }

  Widget _buildEntranceWidget({required double delay, required Widget child}) {
    return AnimatedBuilder(
      animation: _entranceController,
      builder: (context, child) {
        final curve = CurvedAnimation(
            parent: _entranceController,
            curve: Interval(delay, (delay + 0.4).clamp(0, 1.0),
                curve: Curves.easeOutQuart));
        return Opacity(
            opacity: curve.value,
            child: Transform.translate(
                offset: Offset(0, 30 * (1 - curve.value)), child: child));
      },
      child: child,
    );
  }
}

class _GuidePremiumCard extends StatelessWidget {
  final GuideModel guide;
  final bool isDark;
  const _GuidePremiumCard({required this.guide, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: () => context.push(
        Uri(
          path: '/guides/reader',
          queryParameters: {'guideId': guide.id, 'title': guide.title},
        ).toString(),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: isDark
              ? []
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cover Image with Badge
            Expanded(
              child: Stack(
                children: [
                  Positioned.fill(
                    child: ClipRRect(
                      borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(24)),
                      child: CachedNetworkImage(
                        imageUrl: guide.coverImage,
                        fit: BoxFit.cover,
                        errorWidget: (_, __, ___) => Container(
                          color:
                              theme.colorScheme.primary.withValues(alpha: 0.1),
                          child: Icon(Icons.menu_book_rounded,
                              color: theme.colorScheme.primary),
                        ),
                      ),
                    ),
                  ),
                  // Time Badge
                  Positioned(
                    top: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.timer_outlined,
                              size: 12, color: Colors.white),
                          const Gap(4),
                          Text(
                            '${guide.estimatedTime}m',
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Title & Difficulty
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    guide.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: isDark ? Colors.white : const Color(0xFF1A1A1A),
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      height: 1.3,
                    ),
                  ),
                  const Gap(8),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.amber.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          guide.difficulty.toUpperCase(),
                          style: const TextStyle(
                              color: Colors.amber,
                              fontSize: 9,
                              fontWeight: FontWeight.w900),
                        ),
                      ),
                      const Spacer(),
                      Icon(
                        Icons.star_rounded,
                        size: 14,
                        color: Colors.amber.shade700,
                      ),
                      const Gap(2),
                      Text(
                        guide.rating.toString(),
                        style: TextStyle(
                          color: isDark ? Colors.white70 : Colors.black54,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GuideGlassTile extends StatelessWidget {
  final GuideModel guide;
  final bool isDark;
  const _GuideGlassTile({required this.guide, required this.isDark});
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: isDark
            ? theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3)
            : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: isDark
            ? []
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
        border: Border.all(
            color: isDark
                ? Colors.white.withValues(alpha: 0.05)
                : Colors.grey.shade100),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: CachedNetworkImage(
            imageUrl: guide.coverImage,
            width: 60,
            height: 60,
            fit: BoxFit.cover,
            errorWidget: (_, __, ___) => Container(
                color: Colors.blueAccent.withOpacity(0.1),
                child: const Icon(Icons.menu_book_rounded,
                    color: Colors.blueAccent)),
          ),
        ),
        title: Text(
          guide.title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
              color: isDark ? Colors.white : const Color(0xFF333333),
              fontWeight: FontWeight.bold,
              fontSize: 14),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Row(
            children: [
              const Icon(Icons.bolt_rounded, size: 14, color: Colors.amber),
              const Gap(4),
              Text(
                guide.difficulty.toUpperCase(),
                style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                    color: Colors.amber),
              ),
              const Gap(12),
              const Icon(Icons.timer_outlined, size: 14, color: Colors.grey),
              const Gap(4),
              Text(
                '${guide.estimatedTime}p',
                style: const TextStyle(
                    fontSize: 10,
                    color: Colors.grey,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        trailing: Icon(Icons.arrow_forward_ios_rounded,
            color: (isDark ? Colors.white : Colors.black).withOpacity(0.1),
            size: 14),
        onTap: () => context.push(
          Uri(
            path: '/guides/reader',
            queryParameters: {'guideId': guide.id, 'title': guide.title},
          ).toString(),
        ),
      ),
    );
  }
}

class _ServiceGlassTile extends StatelessWidget {
  final HomeCategory service;
  final bool isDark;
  const _ServiceGlassTile({required this.service, required this.isDark});
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: isDark
            ? theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3)
            : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: isDark
            ? []
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
        border: Border.all(
            color: isDark
                ? Colors.white.withValues(alpha: 0.05)
                : Colors.grey.shade100),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: Color(service.color).withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: _buildServiceImage(service.imagePath),
          ),
        ),
        title: Text(
          service.title.translateService(context),
          style: TextStyle(
              color: isDark ? Colors.white : const Color(0xFF333333),
              fontWeight: FontWeight.bold,
              fontSize: 16),
        ),
        trailing: Icon(Icons.arrow_forward_ios_rounded,
            color: (isDark ? Colors.white : Colors.black).withOpacity(0.1),
            size: 14),
        onTap: () => context
            .push('${AppRoutes.allProviders}/category?title=${service.title}'),
      ),
    );
  }

  Widget _buildServiceImage(String path) {
    if (path.isEmpty)
      return const Icon(Icons.plumbing_rounded, color: Colors.blueAccent);

    // Nếu là URL thật (bắt đầu bằng http)
    if (path.startsWith('http')) {
      return CachedNetworkImage(
        imageUrl: path,
        fit: BoxFit.cover,
        placeholder: (_, __) =>
            const Center(child: CircularProgressIndicator(strokeWidth: 2)),
        errorWidget: (_, __, ___) =>
            const Icon(Icons.plumbing_rounded, color: Colors.blueAccent),
      );
    }

    // Nếu là ảnh từ Appwrite (dùng helper lấy URL)
    final imageUrl = AppwriteUtils.getImageUrl(path);
    if (imageUrl.contains('/storage/buckets/')) {
      return CachedNetworkImage(
        imageUrl: imageUrl,
        fit: BoxFit.cover,
        placeholder: (_, __) =>
            const Center(child: CircularProgressIndicator(strokeWidth: 2)),
        errorWidget: (_, __, ___) => _buildAssetFallback(path),
      );
    }

    return _buildAssetFallback(path);
  }

  Widget _buildAssetFallback(String path) {
    return Image.asset(
      path.contains('assets/') ? path : 'assets/images/$path',
      width: 24,
      height: 24,
      errorBuilder: (context, error, stackTrace) => const Icon(
          Icons.plumbing_rounded,
          color: Colors.blueAccent,
          size: 24),
    );
  }
}

class _TechnicianGlassCard extends StatelessWidget {
  final TechnicianModel tech;
  final bool isDark;
  const _TechnicianGlassCard({required this.tech, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // Đồng bộ màu nền theo style trang chủ
    final Color actualBgColor = tech.color != null && tech.color!.isNotEmpty
        ? Color(int.parse(tech.color!.replaceFirst('#', '0xFF')))
        : const Color(0xFFB3D7F4);

    return GestureDetector(
      onTap: () => context.push('${AppRoutes.marketplace}/${tech.uid}'),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isDark
              ? theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3)
              : Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: isDark
              ? []
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
          border: Border.all(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.05)
                  : Colors.grey.shade100),
        ),
        child: Row(
          children: [
            // Image Section (Đồng bộ avatar style)
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: actualBgColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: _buildAvatar(tech),
                  ),
                  if (tech.isVerified)
                    Positioned(
                      top: 4,
                      right: 4,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.verified,
                            color: Color(0xFF0054A5), size: 12),
                      ),
                    ),
                ],
              ),
            ),
            const Gap(16),

            // Info Section
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tech.name,
                    style: TextStyle(
                      color: isDark ? Colors.white : const Color(0xFF333333),
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const Gap(2),
                  Text(
                    tech.skills.join(', '),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: (isDark ? Colors.white : Colors.black)
                          .withValues(alpha: 0.4),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Gap(8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.star_rounded,
                              color: Color(0xFFFFB800), size: 18),
                          const Gap(4),
                          Text(
                            tech.rating.toString(),
                            style: TextStyle(
                              color: isDark
                                  ? Colors.white
                                  : const Color(0xFF333333),
                              fontWeight: FontWeight.w800,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            '${tech.pricePerHour.round()}₫/h',
                            style: const TextStyle(
                              color: Color(0xFF0054A5),
                              fontWeight: FontWeight.w900,
                              fontSize: 13,
                            ),
                          ),
                          const Gap(8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: const Color(0xFF0054A5),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Text(
                              'Details',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar(TechnicianModel tech) {
    if (tech.avatar.startsWith('http')) {
      return CachedNetworkImage(
        imageUrl: tech.avatar,
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.contain,
        alignment: Alignment.bottomCenter,
        errorWidget: (_, __, ___) =>
            const Icon(Icons.person, size: 40, color: Colors.white),
      );
    }

    String assetName = tech.avatar.contains('image 83')
        ? tech.avatar
        : 'image 83 (${(tech.uid.hashCode % 20).abs()}).png';

    return Image.asset(
      'assets/images/$assetName',
      width: double.infinity,
      height: double.infinity,
      fit: BoxFit.contain,
      alignment: Alignment.bottomCenter,
      errorBuilder: (context, error, stackTrace) {
        return const Icon(Icons.person, size: 40, color: Colors.white);
      },
    );
  }
}

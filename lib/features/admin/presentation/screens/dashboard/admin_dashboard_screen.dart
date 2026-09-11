import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';

// Imports quan trọng
import 'package:fixit/core/presentation/widgets/app_background.dart';
import 'package:fixit/core/router/app_router.dart';
import 'package:fixit/shared/utils/export_utils.dart';
import 'package:fixit/features/auth/presentation/providers/auth_provider.dart';
import 'package:fixit/features/profile/presentation/widgets/components/menu/logout_dialog.dart';
import 'package:fixit/features/profile/presentation/widgets/profile_widgets.dart';
import 'package:fixit/features/admin/presentation/providers/admin_provider.dart';
import 'package:fixit/features/admin/data/appwrite_admin_repository.dart';
import 'package:fixit/features/admin/domain/models/admin_models.dart';
import 'package:fixit/l10n/app_localizations.dart';
import 'package:fixit/shared/utils/permission_utils.dart';
import 'package:fixit/shared/models/user_model.dart';
import 'package:fixit/features/admin/presentation/screens/dashboard/widgets/admin_settings_drawer.dart';

import 'package:fixit/shared/widgets/typography/translated_text.dart';
import '../../../../profile/presentation/widgets/components/avatar/profile_avatar.dart';

class AdminDashboardScreen extends ConsumerWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(adminDashboardStatsProvider);
    final appsAsync = ref.watch(recentApplicationsProvider);
    final scaffoldKey = GlobalKey<ScaffoldState>();
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    final cardColor = isDark ? Colors.white.withValues(alpha: 0.06) : Colors.white.withValues(alpha: 0.85);
    final textColor = isDark ? Colors.white : const Color(0xFF0D1B2A);
    final subTextColor = isDark ? Colors.white.withValues(alpha: 0.4) : const Color(0xFF415A77);

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.transparent, 
      endDrawer: const AdminSettingsDrawer(),
      body: AppBackground(
        child: SafeArea(
          child: RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(adminDashboardStatsProvider);
              ref.invalidate(recentApplicationsProvider);
            },
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
              slivers: [
                _buildAppBar(context, ref, scaffoldKey, isDark),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildWelcomeSection(ref, l10n, textColor),
                        const Gap(32),
                        statsAsync.when(
                          data: (stats) {
                            final user = ref.watch(currentUserProvider).valueOrNull;
                            final role = user?.role ?? UserRole.none;
                            
                            final showRevenueChart = role == UserRole.admin || role == UserRole.finance_manager;
                            final showJobChart = role == UserRole.admin || role == UserRole.support_staff || role == UserRole.moderator;

                            return Column(
                              children: [
                                _buildStatsGrid(stats, l10n, cardColor, textColor, subTextColor, role),
                                if (showRevenueChart) ...[
                                  const Gap(32),
                                  _buildSectionHeader(l10n.revenueTrend, subTextColor),
                                  const Gap(16),
                                  _RevenueChart(weeklyRevenue: stats.weeklyRevenue, cardColor: cardColor, isDark: isDark),
                                ],
                                if (showJobChart) ...[
                                  const Gap(32),
                                  _buildSectionHeader(l10n.jobDistribution, subTextColor),
                                  const Gap(16),
                                  _JobDistributionChart(distribution: stats.jobDistribution, cardColor: cardColor, textColor: textColor, subTextColor: subTextColor),
                                ],
                              ],
                            );
                          },
                          loading: () => Center(child: CircularProgressIndicator(color: isDark ? Colors.white24 : Colors.blueAccent)),
                          error: (e, _) => Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Error: $e', 
                                textAlign: TextAlign.center,
                                style: TextStyle(color: isDark ? Colors.redAccent.withOpacity(0.8) : Colors.red, fontSize: 12)
                              ),
                            ),
                          ),
                        ),
                        const Gap(40),
                        _buildRoleFocusBanner(ref, l10n, subTextColor, isDark),
                        const Gap(16),
                        _buildSectionHeader(l10n.quickOperations, subTextColor),
                        const Gap(16),
                        _buildQuickActions(context, ref, l10n, cardColor, textColor),
                        const Gap(40),
                        if (PermissionUtils.hasAccess(ref, [UserRole.moderator])) ...[
                          _buildSectionHeader(l10n.recentApplications, subTextColor),
                          const Gap(16),
                          appsAsync.when(
                            data: (apps) => _buildPendingList(context, apps, l10n, cardColor, textColor, subTextColor),
                            loading: () => Center(child: CircularProgressIndicator(color: isDark ? Colors.white24 : Colors.blueAccent)),
                            error: (e, _) => Center(child: Text('Apps Error: $e', style: TextStyle(color: isDark ? Colors.redAccent : Colors.red, fontSize: 12))),
                          ),
                          const Gap(40),
                        ],
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

  Widget _buildAppBar(BuildContext context, WidgetRef ref, GlobalKey<ScaffoldState> scaffoldKey, bool isDark) {
    final userAsync = ref.watch(currentUserProvider);

    return SliverAppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      pinned: true,
      floating: true,
      centerTitle: false,
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.blueAccent.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.blueAccent.withOpacity(0.2)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.shield_rounded, color: Colors.blueAccent, size: 14),
                const Gap(8),
                TranslatedText(
                  AppLocalizations.of(context)!.adminPanel,
                  style: const TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.w900, fontSize: 10, letterSpacing: 1),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        userAsync.when(
          data: (user) => Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Row(
              children: [
                InkWell(
                  onTap: () => scaffoldKey.currentState?.openEndDrawer(),
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.blueAccent.withOpacity(0.3), width: 1.5),
                    ),
                    child: ProfileAvatar(
                      user: user ?? const UserModel(uid: '', name: '', email: '', role: UserRole.admin),
                      size: 32,
                    ),
                  ),
                ),
                const Gap(8),
              ],
            ),
          ),
          loading: () => const SizedBox.shrink(),
          error: (_, __) => const SizedBox.shrink(),
        ),
      ],
    );
  }

  Widget _buildWelcomeSection(WidgetRef ref, AppLocalizations l10n, Color textColor) {
    final userAsync = ref.watch(currentUserProvider);
    final user = userAsync.valueOrNull;
    final name = user?.name ?? 'Admin';
    final canExport = user?.role == UserRole.admin || user?.role == UserRole.finance_manager;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TranslatedText(
                l10n.commandCenter,
                style: TextStyle(color: Colors.blueAccent.withOpacity(0.8), fontWeight: FontWeight.w800, fontSize: 14, letterSpacing: 1.5),
              ),
              const Gap(4),
              TranslatedText(
                l10n.helloAdmin(name),
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: textColor),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        if (canExport)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: IconButton(
              onPressed: () => _handleExport(ref),
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.greenAccent.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.greenAccent.withOpacity(0.2)),
                ),
                child: const Icon(Icons.explicit_rounded, color: Colors.greenAccent, size: 20),
              ),
              tooltip: l10n.exportReport,
            ),
          ),
      ],
    );
  }

  Future<void> _handleExport(WidgetRef ref) async {
    final stats = ref.read(adminDashboardStatsProvider).valueOrNull;
    if (stats == null) return;

    final rows = [
      ['Total Users', stats.totalUsers],
      ['Active Jobs', stats.activeJobs],
      ['Revenue', stats.revenue],
      ['Pending Approvals', stats.pendingApprovals],
      ['', ''],
      ['Weekly Revenue', ''],
      ...stats.weeklyRevenue.entries.map((e) => [e.key, e.value]),
      ['', ''],
      ['Job Distribution', ''],
      ...stats.jobDistribution.entries.map((e) => [e.key, e.value]),
    ];

    await ExportUtils.exportToExcel(
      fileName: 'FixIt_Dashboard_Report',
      headers: ['Metric/Date', 'Value'],
      rows: rows,
    );
  }

  Widget _buildStatsGrid(AdminStats stats, AppLocalizations l10n, Color cardColor, Color textColor, Color subTextColor, UserRole role) {
    final currencyFormat = NumberFormat.compactSimpleCurrency(locale: 'en_US');
    
    // Luôn hiện 4 chỉ số nhưng có thể làm mờ/khóa các mục không thuộc quyền
    final canSeeRevenue = role == UserRole.admin || role == UserRole.finance_manager;
    final canSeeApps = role == UserRole.admin || role == UserRole.moderator;

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 1.15, // Tăng nhẹ tỉ lệ chiều cao (từ 1.3 về 1.15) để chứa text dài
      children: [
        _buildStatCard(
          l10n.revenue, 
          canSeeRevenue ? currencyFormat.format(stats.revenue) : '***', 
          Icons.account_balance_wallet_rounded, 
          Colors.greenAccent, 
          cardColor, textColor, subTextColor, 
          isLocked: !canSeeRevenue
        ),
        _buildStatCard(l10n.activeJobs, stats.activeJobs.toString(), Icons.rocket_launch_rounded, Colors.orangeAccent, cardColor, textColor, subTextColor),
        _buildStatCard(l10n.newUsers, stats.totalUsers.toString(), Icons.person_add_rounded, Colors.blueAccent, cardColor, textColor, subTextColor),
        _buildStatCard(
          l10n.pendingApps, 
          canSeeApps ? stats.pendingApprovals.toString() : '***', 
          Icons.gpp_maybe_rounded, 
          Colors.redAccent, 
          cardColor, textColor, subTextColor,
          isLocked: !canSeeApps
        ),
      ],
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color, Color cardColor, Color textColor, Color subTextColor, {bool isLocked = false}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Opacity(
          opacity: isLocked ? 0.5 : 1.0,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(28),
              border: Border.all(
                color: cardColor == Colors.white.withValues(alpha: 0.85)
                    ? Colors.white.withOpacity(0.5)
                    : textColor.withValues(alpha: 0.08),
                width: 1.5,
              ),
              boxShadow: [
                 if (cardColor != Colors.white.withValues(alpha: 0.06)) // Light mode
                  BoxShadow(
                    color: color.withValues(alpha: 0.15),
                    blurRadius: 30,
                    offset: const Offset(0, 12),
                    spreadRadius: -5,
                  )
              ]
            ),
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween, // Phân bổ đều không gian
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8), // Giảm padding từ 10 xuống 8
                          decoration: BoxDecoration(
                            color: color.withValues(alpha: 0.12), 
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: color.withValues(alpha: 0.1)),
                          ),
                          child: Icon(icon, color: color, size: 20),
                        ),
                        if (!isLocked) Icon(Icons.trending_up_rounded, color: color.withValues(alpha: 0.6), size: 16),
                      ],
                    ),
                    const Gap(8),
                    Text(value, style: TextStyle(
                      color: textColor, 
                      fontSize: 24, // Giảm nhẹ từ 26 xuống 24
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.5,
                    )),
                    TranslatedText(label, 
                      maxLines: 2, // Cho phép xuống dòng
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: subTextColor, 
                        fontSize: 9, // Giảm nhẹ từ 10 xuống 9
                        fontWeight: FontWeight.w800, 
                        letterSpacing: 1.0,
                        height: 1.1,
                      )
                    ),
                  ],
                ),
                if (isLocked)
                  const Positioned(
                    top: 0, right: 0,
                    child: Icon(Icons.lock_outline_rounded, size: 14, color: Colors.white24),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRoleFocusBanner(WidgetRef ref, AppLocalizations l10n, Color subTextColor, bool isDark) {
    final user = ref.watch(currentUserProvider).valueOrNull;
    if (user == null || user.role == UserRole.admin) return const SizedBox.shrink();

    String focusText = '';
    IconData focusIcon = Icons.info_outline_rounded;
    Color focusColor = Colors.blueAccent;

    switch (user.role) {
      case UserRole.moderator:
        focusText = l10n.focusModerator;
        focusIcon = Icons.verified_user_rounded;
        focusColor = Colors.orangeAccent;
        break;
      case UserRole.finance_manager:
        focusText = l10n.focusFinance;
        focusIcon = Icons.account_balance_rounded;
        focusColor = Colors.greenAccent;
        break;
      case UserRole.support_staff:
        focusText = l10n.focusSupport;
        focusIcon = Icons.support_agent_rounded;
        focusColor = Colors.purpleAccent;
        break;
      default:
        return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: focusColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: focusColor.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Icon(focusIcon, color: focusColor, size: 20),
          const Gap(12),
          Expanded(
            child: TranslatedText(
              focusText,
              style: TextStyle(
                color: isDark ? focusColor.withOpacity(0.9) : focusColor.withOpacity(0.8),
                fontSize: 12,
                fontWeight: FontWeight.w900,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, Color subTextColor) {
    return Row(
      children: [
        Container(width: 4, height: 16, decoration: BoxDecoration(color: Colors.blueAccent, borderRadius: BorderRadius.circular(2))),
        const Gap(12),
        TranslatedText(
          title,
          style: TextStyle(color: subTextColor, fontWeight: FontWeight.w900, letterSpacing: 2, fontSize: 11),
        ),
      ],
    );
  }

  Widget _buildQuickActions(BuildContext context, WidgetRef ref, AppLocalizations l10n, Color cardColor, Color textColor) {
    final actions = [
      _AdminAction(icon: Icons.verified_user_rounded, label: l10n.approvals, route: AppRoutes.adminApprovals, color: Colors.blueAccent, allowedRoles: [UserRole.moderator]),
      _AdminAction(icon: Icons.people_alt_rounded, label: l10n.users, route: AppRoutes.adminUsers, color: Colors.purpleAccent, allowedRoles: [UserRole.support_staff]),
      _AdminAction(icon: Icons.rocket_launch_rounded, label: l10n.jobs, route: AppRoutes.adminBookings, color: Colors.greenAccent, allowedRoles: [UserRole.support_staff]),
      _AdminAction(icon: Icons.grid_view_rounded, label: l10n.services, route: AppRoutes.adminServices, color: Colors.orangeAccent, allowedRoles: [UserRole.moderator]),
      _AdminAction(icon: Icons.photo_library_rounded, label: l10n.banners, route: AppRoutes.adminBanners, color: Colors.pinkAccent, allowedRoles: [UserRole.moderator]),
      _AdminAction(icon: Icons.settings_suggest_rounded, label: l10n.config, route: AppRoutes.adminConfig, color: Colors.blueGrey, allowedRoles: []),
      _AdminAction(icon: Icons.campaign_rounded, label: l10n.broadcast, route: AppRoutes.adminBroadcast, color: Colors.indigoAccent, allowedRoles: [UserRole.support_staff]),
      _AdminAction(icon: Icons.inventory_2_rounded, label: l10n.products, route: AppRoutes.adminProducts, color: Colors.tealAccent, allowedRoles: [UserRole.finance_manager]),
      _AdminAction(icon: Icons.account_balance_rounded, label: l10n.ledger, route: AppRoutes.adminFinance, color: Colors.amberAccent, allowedRoles: [UserRole.finance_manager]),
      _AdminAction(icon: Icons.reviews_rounded, label: l10n.feedback, route: AppRoutes.adminReviews, color: Colors.deepOrangeAccent, allowedRoles: [UserRole.moderator]),
      _AdminAction(icon: Icons.discount_rounded, label: l10n.coupons, route: AppRoutes.adminCoupons, color: Colors.orangeAccent, allowedRoles: [UserRole.finance_manager]),
      _AdminAction(icon: Icons.map_rounded, label: l10n.liveMap, route: AppRoutes.adminLiveMap, color: Colors.cyanAccent, allowedRoles: [UserRole.support_staff]),
      _AdminAction(icon: Icons.analytics_rounded, label: l10n.reports, route: AppRoutes.adminReports, color: Colors.greenAccent, allowedRoles: [UserRole.finance_manager]),
      _AdminAction(icon: Icons.assignment_ind_rounded, label: l10n.staff, route: AppRoutes.adminStaffRoles, color: Colors.indigoAccent, allowedRoles: []),
      _AdminAction(icon: Icons.manage_search_rounded, label: l10n.auditLogs, route: AppRoutes.adminAuditLogs, color: Colors.blueGrey, allowedRoles: []),
      _AdminAction(icon: Icons.history_rounded, label: l10n.bcHistory, route: AppRoutes.adminBroadcastHistory, color: Colors.deepPurpleAccent, allowedRoles: [UserRole.support_staff]),
    ];

    // Sắp xếp: quyền được phép (hoặc có dấu chấm) lên đầu
    actions.sort((a, b) {
      final aHasAccess = PermissionUtils.hasAccess(ref, a.allowedRoles);
      final bHasAccess = PermissionUtils.hasAccess(ref, b.allowedRoles);
      
      // Admin luôn có quyền, nhưng ta muốn ưu tiên "vai trò chuyên trách" của moderator/finance/support
      // Nên nếu là admin, giữ nguyên thứ tự mặc định hoặc sắp xếp theo logic khác.
      // Nếu là các role chuyên biệt, đưa các quyền của họ lên trước.
      final user = ref.read(currentUserProvider).valueOrNull;
      if (user != null && user.role != UserRole.admin) {
        final aIsSpecialty = a.allowedRoles.contains(user.role);
        final bIsSpecialty = b.allowedRoles.contains(user.role);
        if (aIsSpecialty && !bIsSpecialty) return -1;
        if (!aIsSpecialty && bIsSpecialty) return 1;
      }

      if (aHasAccess && !bHasAccess) return -1;
      if (!aHasAccess && bHasAccess) return 1;
      return 0;
    });

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 1.6,
      ),
      itemCount: actions.length,
      itemBuilder: (context, index) {
        final action = actions[index];
        return _buildActionButton(
          context, 
          ref, 
          action.icon, 
          action.label, 
          action.route, 
          action.color, 
          cardColor, 
          textColor, 
          action.allowedRoles
        );
      },
    );
  }

  Widget _buildActionButton(BuildContext context, WidgetRef ref, IconData icon, String label, String route, Color color, Color cardColor, Color textColor, List<UserRole> allowedRoles) {
    final hasAccess = PermissionUtils.hasAccess(ref, allowedRoles);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: () {
        if (PermissionUtils.check(context, ref, allowedRoles)) {
          context.push(route);
        }
      },
      borderRadius: BorderRadius.circular(24),
      child: Opacity(
        opacity: hasAccess ? 1.0 : 0.4,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              height: 110,
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: hasAccess 
                    ? color.withValues(alpha: isDark ? 0.3 : 0.2) 
                    : (isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.1)),
                  width: hasAccess ? 1.5 : 1,
                ),
                boxShadow: [
                  if (hasAccess)
                    BoxShadow(
                      color: isDark ? Colors.black.withOpacity(0.3) : color.withOpacity(0.08),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    )
                ],
              ),
              child: Stack(
                children: [
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          icon, 
                          color: hasAccess ? color : (isDark ? Colors.white24 : Colors.black26), 
                          size: 32
                        ),
                        const Gap(10),
                        TranslatedText(
                          label, 
                          style: TextStyle(
                            color: hasAccess ? textColor : (isDark ? Colors.white24 : Colors.black26), 
                            fontSize: 12, 
                            fontWeight: hasAccess ? FontWeight.w800 : FontWeight.w500
                          )
                        ),
                      ],
                    ),
                  ),
                  if (!hasAccess)
                    Positioned(
                      top: 12, right: 12,
                      child: Icon(Icons.lock_outline_rounded, size: 14, color: isDark ? Colors.white24 : Colors.black26),
                    ),
                  if (hasAccess && ref.watch(currentUserProvider).valueOrNull?.role != UserRole.admin)
                     Positioned(
                      top: 12, right: 12,
                      child: Container(
                        width: 6, height: 6,
                        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPendingList(BuildContext context, List<TechApplication> apps, AppLocalizations l10n, Color cardColor, Color textColor, Color subTextColor) {
    if (apps.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Text(l10n.noPendingApps, style: TextStyle(color: subTextColor)),
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: apps.length,
      separatorBuilder: (_, __) => const Gap(16),
      itemBuilder: (context, index) {
        final app = apps[index];
        final name = app.fullName;
        final type = app.specialty;

        return ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: InkWell(
              onTap: () => context.push(AppRoutes.adminApplicationDetail.replaceAll(':id', app.id)),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: textColor.withOpacity(0.05)),
                  boxShadow: [
                    if (cardColor == Colors.white)
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      )
                  ]
                ),
                child: Row(
                  children: [
                    Container(
                      width: 50, height: 50,
                      decoration: BoxDecoration(color: Colors.blueAccent.withOpacity(0.1), borderRadius: BorderRadius.circular(15)),
                      child: const Center(child: Icon(Icons.badge_rounded, color: Colors.blueAccent)),
                    ),
                    const Gap(16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(name, style: TextStyle(color: textColor, fontWeight: FontWeight.w800, fontSize: 16)),
                          Text(l10n.applicationCount(type), style: TextStyle(color: subTextColor, fontSize: 12)),
                        ],
                      ),
                    ),
                    Icon(Icons.arrow_forward_ios_rounded, color: subTextColor, size: 16),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _AdminAction {
  final IconData icon;
  final String label;
  final String route;
  final Color color;
  final List<UserRole> allowedRoles;

  _AdminAction({
    required this.icon,
    required this.label,
    required this.route,
    required this.color,
    required this.allowedRoles,
  });
}

class _RevenueChart extends StatelessWidget {
  final Map<String, double> weeklyRevenue;
  final Color cardColor;
  final bool isDark;
  const _RevenueChart({required this.weeklyRevenue, required this.cardColor, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final values = weeklyRevenue.values.toList();
    final keys = weeklyRevenue.keys.toList();
    final textColor = isDark ? Colors.white38 : Colors.black38;
    double maxVal = 0;
    for (var v in values) { if (v > maxVal) maxVal = v; }
    if (maxVal == 0) maxVal = 100000; 

    return Container(
      height: 220,
      padding: const EdgeInsets.fromLTRB(10, 20, 20, 10),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: (isDark ? Colors.white : Colors.black).withOpacity(0.05)),
      ),
      child: LineChart(
        LineChartData(
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              getTooltipColor: (spot) => Colors.blueAccent.withOpacity(0.8),
              getTooltipItems: (touchedSpots) {
                return touchedSpots.map((spot) {
                  return LineTooltipItem(
                    NumberFormat.compactSimpleCurrency(locale: 'vi_VN').format(spot.y),
                    const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                  );
                }).toList();
              },
            ),
          ),
          gridData: const FlGridData(show: false),
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  int idx = value.toInt();
                  if (idx >= 0 && idx < keys.length) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(keys[idx], style: TextStyle(color: textColor, fontSize: 9)),
                    );
                  }
                  return const SizedBox();
                },
              ),
            ),
            leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: List.generate(values.length, (i) => FlSpot(i.toDouble(), values[i])),
              isCurved: true,
              color: Colors.blueAccent,
              barWidth: 4,
              isStrokeCapRound: true,
              dotData: FlDotData(
                show: true,
                getDotPainter: (spot, percent, barData, index) => FlDotCirclePainter(
                  radius: 4, color: Colors.blueAccent, strokeWidth: 2, strokeColor: isDark ? Colors.white : Colors.blueAccent
                ),
              ),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  begin: Alignment.topCenter, end: Alignment.bottomCenter,
                  colors: [Colors.blueAccent.withOpacity(0.2), Colors.transparent],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _JobDistributionChart extends StatelessWidget {
  final Map<String, int> distribution;
  final Color cardColor;
  final Color textColor;
  final Color subTextColor;
  const _JobDistributionChart({required this.distribution, required this.cardColor, required this.textColor, required this.subTextColor});

  @override
  Widget build(BuildContext context) {
    if (distribution.isEmpty) {
      return Container(
        height: 150,
        decoration: BoxDecoration(color: cardColor, borderRadius: BorderRadius.circular(24)),
        child: Center(child: Text(AppLocalizations.of(context)!.noJobData, style: TextStyle(color: subTextColor))),
      );
    }

    final List<Color> colors = [Colors.blueAccent, Colors.purpleAccent, Colors.orangeAccent, Colors.greenAccent, Colors.redAccent];
    int colorIdx = 0;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: textColor.withOpacity(0.05)),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 130, height: 130,
            child: PieChart(
              PieChartData(
                sectionsSpace: 4,
                centerSpaceRadius: 35,
                sections: distribution.entries.map((e) {
                  final color = colors[colorIdx % colors.length];
                  colorIdx++;
                  return PieChartSectionData(
                    color: color,
                    value: e.value.toDouble(),
                    title: '',
                    radius: 20,
                  );
                }).toList(),
              ),
            ),
          ),
          const Gap(24),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: distribution.entries.map((e) {
                final color = colors[distribution.keys.toList().indexOf(e.key) % colors.length];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
                      const Gap(8),
                      Expanded(child: TranslatedText(e.key, style: TextStyle(color: textColor.withOpacity(0.7), fontSize: 11), overflow: TextOverflow.ellipsis)),
                      Text(e.value.toString(), style: TextStyle(color: subTextColor, fontSize: 11, fontWeight: FontWeight.bold)),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _AmbientOrb extends StatelessWidget {
  final double size;
  final Color color;
  const _AmbientOrb({required this.size, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size, height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [BoxShadow(color: color, blurRadius: 100, spreadRadius: 50)],
      ),
    );
  }
}

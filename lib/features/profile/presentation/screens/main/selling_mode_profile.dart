import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import 'package:fixit/core/router/app_router.dart';
import 'package:fixit/shared/models/user_model.dart';
import 'package:fixit/features/auth/presentation/providers/auth_provider.dart';
import 'package:fixit/l10n/app_localizations.dart';
import '../../providers/current_technician_stats_provider.dart';
import '../../providers/profile_mode_provider.dart';
import '../../widgets/profile_widgets.dart';

class SellingModeProfile extends ConsumerWidget {
  final UserModel user;
  const SellingModeProfile({super.key, required this.user});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(currentTechnicianStatsProvider);
    final authState = ref.watch(authNotifierProvider);
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final sectionTitleColor = isDark ? Colors.white38 : const Color(0xFF666666);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AnimationLimiter(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(24, 60, 24, 120),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: AnimationConfiguration.toStaggeredList(
              duration: const Duration(milliseconds: 500),
              childAnimationBuilder: (w) => SlideAnimation(verticalOffset: 30, child: FadeInAnimation(child: w)),
              children: [
                _buildHeader(l10n, theme),
                const Gap(32),
                
                // 1. Profile Summary (Avatar + Name + Rating)
                _buildProfileSummary(user, statsAsync, theme),
                const Gap(24),
                
                // 2. Stats Section (Earnings, Active, Completed)
                _buildStatsSection(statsAsync),
                const Gap(32),
                
                // 3. Profile Information Section
                _buildSectionTitle(l10n.profileInfo, color: sectionTitleColor),
                const Gap(16),
                ProfileMenuTile(
                  assetPath: 'assets/images/Edit Profile.png',
                  title: l10n.editProfile,
                  onTap: () => context.push('/profile/edit', extra: user),
                ),
                ProfileMenuTile(
                  assetPath: 'assets/images/Profession.png',
                  title: l10n.specialty,
                  onTap: () => context.push(AppRoutes.profession),
                ),
                ProfileMenuTile(
                  assetPath: 'assets/images/Verification.png',
                  title: l10n.verification,
                  onTap: () => context.push(AppRoutes.verification),
                ),
                
                const Gap(24),
                // 4. Subscription & Payments Section
                _buildSectionTitle(l10n.subscriptionAndPayment, color: sectionTitleColor),
                const Gap(16),
                ProfileMenuTile(
                  assetPath: 'assets/images/Payment method.png',
                  title: l10n.paymentMethod,
                  onTap: () => context.push(AppRoutes.wallet),
                ),
                ProfileMenuTile(
                  assetPath: 'assets/images/Upgrade.png',
                  title: l10n.upgradeAccount,
                  onTap: () => context.push(AppRoutes.upgrade),
                ),
                
                const Gap(24),
                // 5. General Preferences Section
                _buildSectionTitle(l10n.generalPreferences, color: sectionTitleColor),
                const Gap(16),
                ProfileMenuTile(
                  assetPath: 'assets/images/Interior.png',
                  title: l10n.interface,
                  onTap: () => SettingsDialogs.showThemeSelector(context, ref),
                ),
                ProfileMenuTile(
                  assetPath: 'assets/images/Active.png',
                  title: l10n.language,
                  onTap: () => SettingsDialogs.showLanguageSelector(context, ref),
                ),
                ProfileMenuTile(
                  assetPath: 'assets/images/Notification.png',
                  title: l10n.notifications,
                  onTap: () => context.push('/notifications'),
                ),
                ProfileMenuTile(
                  assetPath: 'assets/images/Help & support.png',
                  title: l10n.helpSupport,
                  onTap: () => context.push(AppRoutes.helpSupport),
                ),
                ProfileMenuTile(
                  assetPath: 'assets/images/Logout.png',
                  title: authState.isLoading ? l10n.loggingOut : l10n.logout,
                  titleColor: const Color(0xFF0054A5),
                  onTap: authState.isLoading ? null : () => _handleLogout(context, ref),
                ),
                
                const Gap(40),
                // 6. Consolidated Switch Mode & User Info
                _buildConsolidatedSwitchCard(context, ref, isDark),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(AppLocalizations l10n, ThemeData theme) {
    final isDark = theme.brightness == Brightness.dark;
    return Text(
      l10n.myProfile,
      style: TextStyle(
        color: isDark ? Colors.white : theme.colorScheme.primary,
        fontSize: 24,
        fontWeight: FontWeight.w900,
      ),
    );
  }

  Widget _buildProfileSummary(UserModel user, AsyncValue statsAsync, ThemeData theme) {
    final isDark = theme.brightness == Brightness.dark;
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: isDark ? Colors.blueAccent.withValues(alpha: 0.3) : theme.colorScheme.primary.withValues(alpha: 0.2), width: 2),
          ),
          child: ProfileAvatar(user: user, size: 80),
        ),
        const Gap(20),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                user.name,
                style: TextStyle(
                  color: isDark ? Colors.white : theme.colorScheme.onSurface,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                statsAsync.maybeWhen(
                  data: (s) => s.technician?.skills.join(' • ') ?? 'Technician',
                  orElse: () => 'Loading...',
                ),
                style: TextStyle(color: isDark ? Colors.white38 : Colors.grey, fontSize: 15, fontWeight: FontWeight.w500),
              ),
              const Gap(6),
              Row(
                children: [
                  const Icon(Icons.star_rounded, color: Color(0xFF2450A4), size: 18),
                  const Gap(4),
                  Text(
                    statsAsync.maybeWhen(data: (s) => s.technician?.rating.toStringAsFixed(1) ?? '5.0', orElse: () => '5.0'),
                    style: TextStyle(
                      color: isDark ? Colors.white : theme.colorScheme.primary,
                      fontWeight: FontWeight.w900,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatsSection(AsyncValue statsAsync) {
    return statsAsync.when(
      data: (stats) => TechnicianStatsCard(
        earnings: stats.earnings,
        activeOrders: stats.activeOrders,
        completedOrders: stats.completedOrders,
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => const Center(child: Text('Error loading stats')),
    );
  }

  Widget _buildConsolidatedSwitchCard(BuildContext context, WidgetRef ref, bool isDark) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    return Container(
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isDark ? Colors.white.withValues(alpha: 0.1) : Colors.grey.shade200),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _handleSwitchMode(context, ref),
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    Image.asset(
                      'assets/images/Change Profile to selling mode.png',
                      width: 24,
                      height: 24,
                    ),
                    const Gap(12),
                    Expanded(
                      child: Text(
                        l10n.changeProfileToBuying,
                        style: TextStyle(
                          color: isDark ? Colors.white70 : const Color(0xFF666666),
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Icon(Icons.chevron_right_rounded, color: isDark ? Colors.white24 : Colors.grey),
                  ],
                ),
                const Gap(16),
                const Divider(height: 1, color: Colors.white10),
                const Gap(16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    MiniAvatar(user: user),
                    const Gap(12),
                    Text(
                      user.name.trim().isEmpty ? 'Sng Ca' : user.name,
                      style: TextStyle(
                        color: theme.colorScheme.primary,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleSwitchMode(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context)!;
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator(color: Colors.blueAccent)),
    );

    try {
      // Cập nhật role về none để quay lại màn hình chọn vai trò
      await ref.read(authNotifierProvider.notifier).updateRole(UserRole.none);
      
      if (context.mounted) {
        Navigator.of(context, rootNavigator: true).pop(); // Đóng loading dialog an toàn
        context.go(AppRoutes.roleSelection);
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.of(context, rootNavigator: true).pop();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.error(e.toString()))));
      }
    }
  }

  Widget _buildSectionTitle(String title, {Color? color}) {
    return Text(
      title,
      style: TextStyle(
        color: color ?? const Color(0xFF666666),
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  void _handleLogout(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (c) => LogoutDialog(
        onLogout: () {
          Navigator.pop(c);
          ref.read(authNotifierProvider.notifier).signOut();
        },
      ),
    );
  }
}

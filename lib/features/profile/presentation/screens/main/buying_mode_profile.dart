import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import 'package:fixit/shared/widgets/typography/translated_text.dart';
import 'package:fixit/core/router/app_router.dart';
import 'package:fixit/shared/models/user_model.dart';
import 'package:fixit/features/auth/presentation/providers/auth_provider.dart';
import 'package:fixit/l10n/app_localizations.dart';
import '../../providers/profile_mode_provider.dart';
import '../../widgets/profile_widgets.dart';

class BuyingModeProfile extends ConsumerWidget {
  final UserModel user;
  const BuyingModeProfile({super.key, required this.user});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                _buildHeader(l10n, theme, isDark),
                const Gap(32),
                
                // 1. Profile Summary
                _buildProfileSummary(user, theme, ref, isDark, l10n),
                const Gap(32),
                
                // 2. Account Section
                _buildSectionTitle(l10n.account, sectionTitleColor),
                const Gap(16),
                ProfileMenuTile(
                  assetPath: 'assets/images/Edit Profile.png',
                  title: l10n.editProfile,
                  onTap: () => context.push('/profile/edit', extra: user),
                ),
                ProfileMenuTile(
                  assetPath: 'assets/images/Notification.png',
                  title: l10n.notifications,
                  onTap: () => context.push('/notifications'),
                ),
                ProfileMenuTile(
                  assetPath: 'assets/images/Payment method.png',
                  title: l10n.paymentMethod,
                  onTap: () => context.push(AppRoutes.wallet),
                ),
                
                const Gap(24),
                // 3. Preferences Section
                _buildSectionTitle(l10n.preferences, sectionTitleColor),
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
                
                const Gap(24),
                // 4. Support Section
                _buildSectionTitle(l10n.support, sectionTitleColor),
                const Gap(16),
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
                // 5. Consolidated Switch Mode & User Info
                _buildConsolidatedSwitchCard(context, ref, isDark),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(AppLocalizations l10n, ThemeData theme, bool isDark) {
    return TranslatedText(
      'My Profile',
      style: TextStyle(
        color: isDark ? Colors.white : theme.colorScheme.primary,
        fontSize: 24,
        fontWeight: FontWeight.w900,
      ),
    );
  }

  Widget _buildProfileSummary(UserModel user, ThemeData theme, WidgetRef ref, bool isDark, AppLocalizations l10n) {
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
              Row(
                children: [
                  TranslatedText(
                    user.name.isEmpty ? l10n.fixitUser : user.name,
                    style: TextStyle(
                      color: isDark ? Colors.white : theme.colorScheme.onSurface,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (user.uid.isNotEmpty && (ref.watch(authStateProvider).valueOrNull?.emailVerification ?? false))
                    const Padding(
                      padding: EdgeInsets.only(left: 8),
                      child: Icon(Icons.verified, color: Colors.blueAccent, size: 20),
                    ),
                ],
              ),
              Text(
                user.email.isEmpty ? user.phone : user.email,
                style: TextStyle(color: isDark ? Colors.white38 : Colors.grey, fontSize: 14, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ],
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
                        l10n.changeProfileToSelling,
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
                      user.name.trim().isEmpty ? 'Mahrama' : user.name,
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
      await ref.read(authNotifierProvider.notifier).updateRole(UserRole.none);
      
      if (context.mounted) {
        Navigator.of(context, rootNavigator: true).pop();
        context.go(AppRoutes.roleSelection);
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.of(context, rootNavigator: true).pop();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.error(e.toString()))));
      }
    }
  }

  Widget _buildSectionTitle(String title, Color color) {
    return TranslatedText(
      title,
      style: TextStyle(
        color: color,
        fontSize: 16,
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

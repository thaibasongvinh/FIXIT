import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:fixit/shared/models/user_model.dart';
import 'package:fixit/features/auth/presentation/providers/auth_provider.dart';
import 'package:fixit/core/config/locale_provider.dart';
import 'package:fixit/l10n/app_localizations.dart';
import 'package:fixit/core/constants/languages.dart';
import 'package:fixit/shared/widgets/typography/translated_text.dart';
import 'package:fixit/features/profile/presentation/widgets/components/avatar/profile_avatar.dart';
import 'package:fixit/features/profile/presentation/widgets/components/menu/logout_dialog.dart';
import 'package:fixit/core/services/translation_provider.dart';

class AdminSettingsDrawer extends ConsumerWidget {
  const AdminSettingsDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(currentUserProvider);
    final themeMode = ref.watch(themeModeNotifierProvider);
    final locale = ref.watch(localeNotifierProvider);
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Drawer(
      backgroundColor: Colors.transparent,
      width: MediaQuery.of(context).size.width * 0.85,
      child: Stack(
        children: [
          // Glass Effect Background
          Positioned.fill(
            child: ClipRRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                child: Container(
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF010A1A).withOpacity(0.85) : Colors.white.withOpacity(0.9),
                    border: Border(left: BorderSide(color: isDark ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.05), width: 1)),
                  ),
                ),
              ),
            ),
          ),

          Column(
            children: [
              // Premium Header
              userAsync.when(
                data: (user) => _buildHeader(context, user, l10n, isDark, ref),
                loading: () => const SizedBox(height: 250, child: Center(child: CircularProgressIndicator())),
                error: (_, __) => const SizedBox(height: 100),
              ),

              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  physics: const BouncingScrollPhysics(),
                  children: [
                    _buildSectionHeader(l10n.preferences),
                    const Gap(16),
                    _buildSelectionTile(
                      context: context,
                      isDark: isDark,
                      icon: Icons.palette_outlined,
                      label: l10n.themeMode,
                      value: themeMode == ThemeMode.system 
                          ? 'SYSTEM' 
                          : (themeMode == ThemeMode.light ? 'LIGHT MODE' : 'DARK MODE'),
                      onTap: () => _showThemePicker(context, ref, themeMode, l10n, isDark),
                    ),
                    const Gap(12),
                    _buildSelectionTile(
                      context: context,
                      isDark: isDark,
                      icon: Icons.translate_rounded,
                      label: l10n.language,
                      value: locale.languageCode == 'vi' ? 'VIETNAMESE' : 'ENGLISH',
                      onTap: () => _showLanguagePicker(context, ref, locale, l10n, isDark),
                    ),
                    
                    const Gap(32),
                    _buildSectionHeader(l10n.system),
                    const Gap(16),
                    _buildInfoCard([
                      _InfoItem(Icons.info_outline_rounded, l10n.appInfo, '1.0.4 (Stable)'),
                      _InfoItem(Icons.storage_rounded, 'Database', 'Appwrite Cloud'),
                      _InfoItem(Icons.security_rounded, 'Status', 'Encrypted'),
                    ], isDark),

                    const Gap(32),
                    _buildSectionHeader(l10n.quickOperations.toUpperCase()),
                    const Gap(16),
                    _buildMenuButton(Icons.history_rounded, l10n.debugLogs, isDark, () {}),
                    _buildMenuButton(Icons.support_agent_rounded, 'Internal Support', isDark, () {}),
                  ],
                ),
              ),

              // Bottom Brand
              Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  children: [
                    Text('FIXIT INTERNAL', 
                      style: TextStyle(color: isDark ? Colors.white24 : Colors.black26, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 3)),
                    const Gap(4),
                    Text('Bảng điều khiển quản trị v1.0', 
                      style: TextStyle(color: (isDark ? Colors.white : Colors.black).withOpacity(0.05), fontSize: 8, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, UserModel? user, AppLocalizations l10n, bool isDark, WidgetRef ref) {
    final role = user?.role ?? UserRole.none;
    String roleText = 'ADMIN';
    Color roleColor = Colors.blueAccent;
    
    switch (role) {
      case UserRole.admin:
        roleText = 'SUPER ADMIN';
        roleColor = Colors.redAccent;
        break;
      case UserRole.moderator:
        roleText = 'MODERATOR';
        roleColor = Colors.orangeAccent;
        break;
      case UserRole.finance_manager:
        roleText = 'FINANCE';
        roleColor = Colors.greenAccent;
        break;
      case UserRole.support_staff:
        roleText = 'SUPPORT';
        roleColor = Colors.purpleAccent;
        break;
      default:
        roleText = 'STAFF';
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 40, 16, 40),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [roleColor.withOpacity(isDark ? 0.15 : 0.05), Colors.transparent],
        ),
      ),
      child: Column(
        children: [
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
              onPressed: () => showDialog(
                context: context,
                builder: (context) => LogoutDialog(
                  onLogout: () => ref.read(authNotifierProvider.notifier).signOut(),
                ),
              ),
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.redAccent.withOpacity(0.1),
                ),
                child: const Icon(Icons.power_settings_new_rounded, color: Colors.redAccent, size: 20),
              ),
            ),
          ),
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: roleColor.withOpacity(0.5), width: 2),
                ),
                child: ProfileAvatar(
                  user: user ?? const UserModel(uid: '', name: '', email: '', role: UserRole.admin),
                  size: 90,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(color: roleColor, shape: BoxShape.circle),
                child: const Icon(Icons.shield_rounded, size: 12, color: Colors.black),
              ),
            ],
          ),
          const Gap(20),
          Text(user?.name ?? 'FixIt Admin', 
            style: TextStyle(color: isDark ? Colors.white : Colors.black, fontSize: 24, fontWeight: FontWeight.w900, letterSpacing: -0.5)),
          const Gap(4),
          Text(user?.email ?? 'admin@fixit.com', 
            style: TextStyle(color: (isDark ? Colors.white : Colors.black).withOpacity(0.4), fontSize: 13, fontWeight: FontWeight.w500)),
          const Gap(20),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: roleColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: roleColor.withOpacity(0.2)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.verified_user_rounded, color: roleColor, size: 14),
                const Gap(8),
                Text(roleText, style: TextStyle(color: roleColor, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 1)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return TranslatedText(title, 
      style: TextStyle(color: Colors.blueAccent.withOpacity(0.6), fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 2));
  }

  Widget _buildSelectionTile({
    required BuildContext context,
    required bool isDark,
    required IconData icon,
    required String label,
    required String value,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: (isDark ? Colors.white : Colors.black).withOpacity(0.03),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: (isDark ? Colors.white : Colors.black).withOpacity(0.05)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: Colors.blueAccent.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
              child: Icon(icon, color: Colors.blueAccent, size: 20),
            ),
            const Gap(16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TranslatedText(label, style: TextStyle(color: isDark ? Colors.white70 : Colors.black54, fontSize: 12, fontWeight: FontWeight.w600)),
                  const Gap(2),
                  TranslatedText(value, style: TextStyle(color: isDark ? Colors.white : Colors.black, fontSize: 14, fontWeight: FontWeight.w900)),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: (isDark ? Colors.white : Colors.black).withOpacity(0.2)),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(List<_InfoItem> items, bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: (isDark ? Colors.white : Colors.black).withOpacity(0.02),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: (isDark ? Colors.white : Colors.black).withOpacity(0.05)),
      ),
      child: Column(
        children: items.asMap().entries.map((entry) {
          final isLast = entry.key == items.length - 1;
          final item = entry.value;
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(item.icon, color: isDark ? Colors.white24 : Colors.black26, size: 18),
                    const Gap(16),
                    TranslatedText(item.label, style: TextStyle(color: isDark ? Colors.white38 : Colors.black38, fontSize: 13)),
                    const Spacer(),
                    TranslatedText(item.value, style: TextStyle(color: isDark ? Colors.white70 : Colors.black87, fontSize: 13, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              if (!isLast) Divider(color: (isDark ? Colors.white : Colors.black).withOpacity(0.05), height: 1, indent: 50),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildMenuButton(IconData icon, String label, bool isDark, VoidCallback onTap) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 4),
      leading: Icon(icon, color: isDark ? Colors.white38 : Colors.black38, size: 22),
      title: TranslatedText(label, style: TextStyle(color: isDark ? Colors.white70 : Colors.black87, fontSize: 14, fontWeight: FontWeight.w500)),
      trailing: Icon(Icons.open_in_new_rounded, color: isDark ? Colors.white12 : Colors.black12, size: 16),
    );
  }

  void _showThemePicker(BuildContext context, WidgetRef ref, ThemeMode current, AppLocalizations l10n, bool isDark) {
    final Map<ThemeMode, String> themeLabels = {
      ThemeMode.system: "SYSTEM",
      ThemeMode.light: "LIGHT MODE",
      ThemeMode.dark: "DARK MODE",
    };

    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? const Color(0xFF0D47A1) : Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
      builder: (context) => Container(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TranslatedText(l10n.selectTheme, style: TextStyle(color: isDark ? Colors.white : Colors.black, fontWeight: FontWeight.w900, fontSize: 16, letterSpacing: 2)),
            const Gap(24),
            ...ThemeMode.values.map((mode) => ListTile(
              title: TranslatedText(themeLabels[mode] ?? mode.name.toUpperCase(), style: TextStyle(color: current == mode ? (isDark ? Colors.white : Colors.blueAccent) : (isDark ? Colors.white38 : Colors.black38), fontWeight: FontWeight.bold)),
              trailing: current == mode ? const Icon(Icons.check_circle_rounded, color: Colors.greenAccent) : null,
              onTap: () {
                ref.read(themeModeNotifierProvider.notifier).setThemeMode(mode);
                Navigator.pop(context);
              },
            )),
          ],
        ),
      ),
    );
  }

  void _showLanguagePicker(BuildContext context, WidgetRef ref, Locale current, AppLocalizations l10n, bool isDark) {
    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? const Color(0xFF0D47A1) : Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
      builder: (modalContext) => Container(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TranslatedText(l10n.selectLanguage, style: TextStyle(color: isDark ? Colors.white : Colors.black, fontWeight: FontWeight.w900, fontSize: 16, letterSpacing: 2)),
            const Gap(16),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: supportedLanguages.length,
                itemBuilder: (context, index) {
                  final lang = supportedLanguages[index];
                  final isSelected = current.languageCode == lang.code;

                  return ListTile(
                    leading: Text(lang.flag, style: const TextStyle(fontSize: 24)),
                    title: TranslatedText(
                      lang.name.toUpperCase(),
                      style: TextStyle(
                        color: isDark ? Colors.white : Colors.black,
                        fontWeight: isSelected ? FontWeight.w900 : FontWeight.w400,
                      ),
                    ),
                    trailing: isSelected ? const Icon(Icons.check_circle_rounded, color: Colors.greenAccent) : null,
                    onTap: () {
                      ref.read(localeNotifierProvider.notifier).setLocale(Locale(lang.code));
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _languageItem(BuildContext context, WidgetRef ref, String label, Locale locale, bool isSelected, bool isDark) {
    return ListTile(
      title: TranslatedText(label, style: TextStyle(color: isSelected ? (isDark ? Colors.white : Colors.blueAccent) : (isDark ? Colors.white38 : Colors.black38), fontWeight: FontWeight.bold)),
      trailing: isSelected ? const Icon(Icons.check_circle_rounded, color: Colors.greenAccent) : null,
      onTap: () {
        ref.read(localeNotifierProvider.notifier).setLocale(locale);
        Navigator.pop(context);
      },
    );
  }
}

class _InfoItem {
  final IconData icon;
  final String label;
  final String value;
  _InfoItem(this.icon, this.label, this.value);
}

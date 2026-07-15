import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:fixit/core/presentation/widgets/app_background.dart';
import 'package:fixit/features/admin/presentation/providers/admin_provider.dart';
import 'package:fixit/features/admin/domain/models/admin_models.dart';
import 'package:fixit/shared/models/user_model.dart';
import 'package:fixit/features/auth/presentation/providers/auth_provider.dart';
import 'package:fixit/features/profile/presentation/widgets/components/avatar/profile_avatar.dart';
import 'package:fixit/features/home/presentation/widgets/components/shimmer_loading.dart';
import 'package:fixit/shared/utils/snackbar_utils.dart';
import 'package:fixit/l10n/app_localizations.dart';

class AdminUsersScreen extends ConsumerWidget {
  const AdminUsersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filteredUsersAsync = ref.watch(filteredAdminUsersProvider);
    final currentUserAsync = ref.watch(currentUserProvider);
    final currentUserId = currentUserAsync.valueOrNull?.uid;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    final backgroundColor = isDark ? const Color(0xFF010A1A) : const Color(0xFFF5F7FA);
    final cardColor = isDark ? Colors.white.withOpacity(0.02) : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF1A1C1E);
    final subTextColor = isDark ? Colors.white.withOpacity(0.2) : const Color(0xFF74777F);

    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(l10n.userManagement, 
          style: TextStyle(color: textColor, fontWeight: FontWeight.w900, fontSize: 13, letterSpacing: 3)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: textColor, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: AppBackground(
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(ref, isDark, l10n),
              Expanded(
                child: filteredUsersAsync.when(
                  data: (users) => users.isEmpty 
                    ? _buildEmptyState(subTextColor, l10n)
                    : ListView.builder(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 40),
                        itemCount: users.length,
                        itemBuilder: (context, index) => _buildUserCard(context, ref, users[index], currentUserId, isDark, cardColor, textColor, subTextColor, l10n),
                      ),
                  loading: () => _buildLoadingState(cardColor),
                  error: (e, _) => Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.error_outline_rounded, color: Colors.redAccent, size: 40),
                          const Gap(12),
                          Text(l10n.error(e.toString()), 
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.redAccent, fontSize: 12)
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(WidgetRef ref, bool isDark, AppLocalizations l10n) {
    final currentRole = ref.watch(userRoleFilterProvider);

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          Container(
            height: 55,
            decoration: BoxDecoration(
              color: (isDark ? Colors.white : Colors.black).withOpacity(0.04),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: (isDark ? Colors.white : Colors.black).withOpacity(0.08)),
            ),
            child: TextField(
              style: TextStyle(color: isDark ? Colors.white : Colors.black, fontSize: 15),
              cursorColor: Colors.blueAccent,
              onChanged: (val) => ref.read(userSearchQueryProvider.notifier).state = val,
              decoration: InputDecoration(
                hintText: l10n.searchUserHint,
                hintStyle: TextStyle(color: (isDark ? Colors.white : Colors.black).withOpacity(0.15), fontSize: 14),
                prefixIcon: Icon(Icons.search_rounded, color: (isDark ? Colors.white : Colors.black).withOpacity(0.2), size: 22),
                border: InputBorder.none,
                filled: true,
                fillColor: Colors.transparent,
                contentPadding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),
          const Gap(16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: Row(
              children: [
                _buildFilterButton(ref, l10n.all, null, currentRole == null, isDark),
                const Gap(8),
                _buildFilterButton(ref, l10n.admins, UserRole.admin, currentRole == UserRole.admin, isDark),
                const Gap(8),
                _buildFilterButton(ref, l10n.technicians, UserRole.technician, currentRole == UserRole.technician, isDark),
                const Gap(8),
                _buildFilterButton(ref, l10n.customers, UserRole.customer, currentRole == UserRole.customer, isDark),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterButton(WidgetRef ref, String label, UserRole? role, bool isSelected, bool isDark) {
    return InkWell(
      onTap: () => ref.read(userRoleFilterProvider.notifier).state = role,
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blueAccent : (isDark ? Colors.white.withOpacity(0.03) : Colors.black.withOpacity(0.03)),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Colors.blueAccent : (isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.05)),
          ),
          boxShadow: isSelected ? [BoxShadow(color: Colors.blueAccent.withOpacity(0.2), blurRadius: 10, spreadRadius: -2)] : [],
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : (isDark ? Colors.white.withOpacity(0.3) : Colors.black.withOpacity(0.3)),
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.w900 : FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildUserCard(BuildContext context, WidgetRef ref, AppUser user, String? currentUserId, bool isDark, Color cardColor, Color textColor, Color subTextColor, AppLocalizations l10n) {
    final role = user.role.toLowerCase();
    Color roleColor = Colors.blueAccent;
    if (role == 'admin') roleColor = Colors.redAccent;
    else if (role == 'technician') roleColor = Colors.orangeAccent;

    final isMe = user.id == currentUserId;

    final userModel = UserModel(
      uid: user.id,
      name: user.name,
      email: user.email,
      avatar: user.avatar ?? '',
      role: (role == 'admin') ? UserRole.admin : (role == 'technician') ? UserRole.technician : UserRole.customer,
    );

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: (isDark ? Colors.white : Colors.black).withOpacity(0.05)),
        boxShadow: isDark ? [] : [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5))],
      ),
      child: Row(
        children: [
          Container(
            width: 52, height: 52,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: roleColor.withOpacity(0.3), width: 1.5),
              boxShadow: [BoxShadow(color: roleColor.withOpacity(0.1), blurRadius: 10)],
            ),
            child: ClipOval(
              child: MiniAvatarWrapper(user: userModel, size: 52),
            ),
          ),
          const Gap(16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(user.name, 
                  style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 15)),
                Text(user.email, 
                  style: TextStyle(color: isDark ? Colors.white.withOpacity(0.2) : Colors.black38, fontSize: 11)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: roleColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(role.toUpperCase(), 
                  style: TextStyle(color: roleColor, fontSize: 9, fontWeight: FontWeight.w900)),
              ),
              const Gap(4),
              if (isMe)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, right: 4),
                  child: const Text(
                    'YOU',
                    style: TextStyle(
                      color: Colors.blueAccent,
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1,
                    ),
                  ),
                )
              else
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () => _showDeleteDialog(context, ref, user, userModel, l10n, isDark),
                      icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent, size: 18),
                      visualDensity: VisualDensity.compact,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                    const Gap(4),
                    Transform.scale(
                      scale: 0.7,
                      child: Switch(
                        value: user.isActive,
                        onChanged: (val) => _showStatusDialog(context, ref, user, userModel, l10n, isDark),
                        activeColor: Colors.greenAccent,
                        activeTrackColor: Colors.greenAccent.withOpacity(0.2),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, WidgetRef ref, AppUser user, UserModel userModel, AppLocalizations l10n, bool isDark) {
    if (user.isActive) {
      AppSnackbar.showError(context, 'Vui lòng vô hiệu hóa tài khoản này trước khi xóa!');
      return;
    }

    _showConfirmDialog(
      context: context,
      userModel: userModel,
      title: l10n.deleteAccountQuery,
      description: l10n.deleteAccountDesc(user.name),
      buttonText: l10n.deleteNow,
      buttonColor: Colors.redAccent,
      isDark: isDark,
      l10n: l10n,
      onConfirm: () => ref.read(adminUsersProvider.notifier).deleteUser(user.id, user.email),
    );
  }

  void _showStatusDialog(BuildContext context, WidgetRef ref, AppUser user, UserModel userModel, AppLocalizations l10n, bool isDark) {
    final title = user.isActive ? l10n.deactivateUserQuery : l10n.activateUserQuery;
    final desc = user.isActive ? l10n.deactivateDesc : l10n.activateDesc;
    final buttonText = user.isActive ? 'DEACTIVATE' : 'ACTIVATE';

    _showConfirmDialog(
      context: context,
      userModel: userModel,
      title: title,
      description: desc,
      buttonText: '$buttonText NOW',
      buttonColor: user.isActive ? Colors.orangeAccent : Colors.greenAccent,
      isDark: isDark,
      l10n: l10n,
      onConfirm: () => ref.read(adminUsersProvider.notifier).toggleUserStatus(user.id, user.isActive),
    );
  }

  void _showConfirmDialog({
    required BuildContext context,
    required UserModel userModel,
    required String title,
    required String description,
    required String buttonText,
    required Color buttonColor,
    required bool isDark,
    required AppLocalizations l10n,
    required VoidCallback onConfirm,
  }) {
    showDialog(
      context: context,
      builder: (context) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Container(
            padding: const EdgeInsets.all(28.0),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF0D47A1).withOpacity(0.4) : Colors.white.withOpacity(0.9),
              borderRadius: BorderRadius.circular(35),
              border: Border.all(color: isDark ? Colors.white.withOpacity(0.2) : Colors.black.withOpacity(0.05), width: 1.5),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: buttonColor.withOpacity(0.1),
                    boxShadow: [BoxShadow(color: buttonColor.withOpacity(0.2), blurRadius: 20)],
                  ),
                  child: ClipOval(
                    child: MiniAvatarWrapper(user: userModel, size: 100),
                  ),
                ),
                const Gap(24),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: isDark ? Colors.white : Colors.black, letterSpacing: 1),
                ),
                const Gap(12),
                Text(
                  description,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: (isDark ? Colors.white : Colors.black).withOpacity(0.6), height: 1.5),
                  textAlign: TextAlign.center,
                ),
                const Gap(32),
                SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: ElevatedButton(
                    onPressed: () {
                      onConfirm();
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isDark ? Colors.white : buttonColor,
                      foregroundColor: isDark ? buttonColor : Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      elevation: 0,
                    ),
                    child: Text(buttonText, style: const TextStyle(fontWeight: FontWeight.w900)),
                  ),
                ),
                const Gap(12),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(l10n.cancel, style: TextStyle(color: (isDark ? Colors.white : Colors.black).withOpacity(0.3), fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(Color subTextColor, AppLocalizations l10n) {
    return Center(
      child: Text(l10n.noUsersFound, style: TextStyle(color: subTextColor)),
    );
  }

  Widget _buildLoadingState(Color cardColor) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 40),
      itemCount: 6,
      itemBuilder: (context, index) => Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.white.withOpacity(0.05)),
        ),
        child: Row(
          children: [
            const ShimmerBox(width: 52, height: 52, shape: BoxShape.circle),
            const Gap(16),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShimmerBox(width: 120, height: 16, borderRadius: 4),
                  Gap(8),
                  ShimmerBox(width: 180, height: 12, borderRadius: 4),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const ShimmerBox(width: 50, height: 18, borderRadius: 6),
                const Gap(8),
                Row(
                  children: [
                    const ShimmerBox(width: 24, height: 24, borderRadius: 4),
                    const Gap(8),
                    const ShimmerBox(width: 36, height: 20, borderRadius: 10),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class MiniAvatarWrapper extends ConsumerWidget {
  final UserModel user;
  final double size;

  const MiniAvatarWrapper({super.key, required this.user, required this.size});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ProfileAvatar(user: user, size: size);
  }
}

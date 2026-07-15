import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import 'package:fixit/core/router/app_router.dart';
import 'package:fixit/features/auth/presentation/providers/auth_provider.dart';
import 'package:fixit/shared/models/user_model.dart';
import 'package:fixit/features/auth/presentation/providers/login_success_provider.dart';
import 'package:fixit/core/presentation/widgets/app_background.dart';
import 'package:fixit/shared/utils/snackbar_utils.dart';
import 'package:fixit/l10n/app_localizations.dart';

class RoleSelectionScreen extends ConsumerStatefulWidget {
  const RoleSelectionScreen({super.key});

  @override
  ConsumerState<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends ConsumerState<RoleSelectionScreen> {
  UserRole? _selectedRole;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(loginSuccessNotifierProvider.notifier).clear();
    });
  }

  Future<void> _handleNext() async {
    if (_selectedRole == null) return;
    final l10n = AppLocalizations.of(context)!;
    HapticFeedback.mediumImpact();
    
    await ref.read(authNotifierProvider.notifier).updateRole(_selectedRole!);
    if (mounted) {
      await ref.read(currentUserProvider.future);
      if (mounted) {
        if (_selectedRole == UserRole.technician) {
          context.go(AppRoutes.technicianOnboarding);
        } else {
          AppSnackbar.showSuccess(context, l10n.accountSetupSuccess);
          context.go(AppRoutes.home);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // TỐI ƯU: Chỉ watch isLoading thay vì toàn bộ notifier state
    final isLoading = ref.watch(authNotifierProvider.select((s) => s.isLoading));
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AppBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        HapticFeedback.selectionClick();
                        ref.read(authNotifierProvider.notifier).signOut();
                        context.go(AppRoutes.login);
                      },
                      icon: Icon(
                        Icons.arrow_back_ios_new, 
                        color: isDark ? Colors.white : Colors.black87, 
                        size: 22
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    children: [
                      const Gap(10),
                      _buildLogoBadge(isDark),
                      const Gap(32),
                      Text(
                        l10n.iAm,
                        style: TextStyle(
                          fontSize: 40, 
                          fontWeight: FontWeight.w900, 
                          color: isDark ? Colors.white : Colors.blueGrey.shade900, 
                          letterSpacing: -1.5
                        ),
                      ),
                      const Gap(8),
                      Text(
                        l10n.selectRoleToStart,
                        style: TextStyle(
                          fontSize: 16, 
                          color: isDark ? Colors.white.withOpacity(0.6) : Colors.blueGrey.shade600, 
                          fontWeight: FontWeight.w500
                        ),
                      ),
                      const Gap(40),
                      
                      _RoleCard(
                        title: l10n.technician,
                        description: l10n.techRoleDesc,
                        icon: Icons.build_circle_outlined,
                        isSelected: _selectedRole == UserRole.technician,
                        onTap: isLoading ? null : () {
                          HapticFeedback.selectionClick();
                          setState(() => _selectedRole = UserRole.technician);
                        },
                        isDark: isDark,
                      ),
                      const Gap(16),
                      _RoleCard(
                        title: l10n.customer,
                        description: l10n.customerRoleDesc,
                        icon: Icons.home_repair_service_outlined,
                        isSelected: _selectedRole == UserRole.customer,
                        onTap: isLoading ? null : () {
                          HapticFeedback.selectionClick();
                          setState(() => _selectedRole = UserRole.customer);
                        },
                        isDark: isDark,
                      ),
                      
                      const Gap(60),
                      SizedBox(
                        width: double.infinity,
                        height: 60,
                        child: ElevatedButton(
                          onPressed: _selectedRole == null || isLoading ? null : _handleNext,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isDark ? Colors.white : Theme.of(context).primaryColor,
                            foregroundColor: isDark ? const Color(0xFF0D47A1) : Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            elevation: _selectedRole != null && !isDark ? 8 : 0,
                          ),
                          child: isLoading 
                            ? CircularProgressIndicator(color: isDark ? const Color(0xFF0D47A1) : Colors.white)
                            : Text(
                                l10n.startNow, 
                                style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16, letterSpacing: 1)
                              ),
                        ),
                      ),
                      const Gap(30),
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

  Widget _buildLogoBadge(bool isDark) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 1.0, end: 1.05),
      duration: const Duration(seconds: 2),
      curve: Curves.easeInOut,
      builder: (context, value, child) {
        return Container(
          width: 100, height: 100,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.blueAccent.withOpacity(isDark ? 0.3 * value : 0.1), 
                blurRadius: 40, 
                spreadRadius: 5
              )
            ],
          ),
          child: Center(
            child: Container(
              width: 80, height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                border: Border.all(color: Colors.white.withOpacity(0.8), width: 3),
              ),
              child: ClipOval(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Image.asset('assets/images/app_icon.png', fit: BoxFit.contain),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _RoleCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final bool isSelected;
  final VoidCallback? onTap;
  final bool isDark;

  const _RoleCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.isSelected,
    required this.isDark,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: isSelected 
                  ? (isDark ? Colors.white.withOpacity(0.12) : primaryColor.withOpacity(0.08)) 
                  : (isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.02)),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: isSelected 
                    ? (isDark ? Colors.blueAccent : primaryColor) 
                    : (isDark ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.05)),
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isSelected 
                        ? (isDark ? Colors.blueAccent.withOpacity(0.2) : primaryColor.withOpacity(0.1)) 
                        : (isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.03)),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon, 
                    color: isSelected 
                        ? (isDark ? Colors.blueAccent : primaryColor) 
                        : (isDark ? Colors.white60 : Colors.blueGrey), 
                    size: 32
                  ),
                ),
                const Gap(20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                          color: isDark ? Colors.white : Colors.blueGrey.shade900,
                        ),
                      ),
                      const Gap(4),
                      Text(
                        description,
                        style: TextStyle(
                          fontSize: 14,
                          color: isDark ? Colors.white.withOpacity(0.5) : Colors.blueGrey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                if (isSelected)
                  Icon(
                    Icons.check_circle_rounded, 
                    color: isDark ? Colors.blueAccent : primaryColor, 
                    size: 28
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

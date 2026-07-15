import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:fixit/features/auth/presentation/providers/auth_provider.dart';
import 'package:fixit/features/profile/presentation/widgets/components/menu/logout_dialog.dart';
import 'package:fixit/core/presentation/widgets/app_background.dart';
import 'package:fixit/l10n/app_localizations.dart';

class PendingApprovalScreen extends ConsumerStatefulWidget {
  const PendingApprovalScreen({super.key});

  @override
  ConsumerState<PendingApprovalScreen> createState() => _PendingApprovalScreenState();
}

class _PendingApprovalScreenState extends ConsumerState<PendingApprovalScreen> with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TỐI ƯU: Chỉ watch các giá trị cần thiết từ AsyncValue
    final verifiedStatus = ref.watch(currentUserProvider.select((s) => s.value?.verifiedStatus ?? 'pending'));
    final appStatus = ref.watch(currentUserApplicationProvider.select((s) => s.valueOrNull?.status));
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final String currentStatus = appStatus ?? verifiedStatus;

    return AppBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 24.0),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.sizeOf(context).height - 
                             MediaQuery.paddingOf(context).top - 
                             MediaQuery.paddingOf(context).bottom - 48,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      const Spacer(),
                      _buildStatusHeader(currentStatus, isDark),
                      const Gap(40),
                      _buildStatusCard(currentStatus, isDark),
                      const Spacer(),
                      const Gap(32),
                      _buildActionButtons(context, ref, isDark),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusHeader(String status, bool isDark) {
    final l10n = AppLocalizations.of(context)!;
    String title = l10n.pendingApprovalTitle;
    String desc = l10n.pendingApprovalDesc;
    Color glowColor = Colors.cyanAccent;

    if (status == 'approved' || status == 'verified') {
      title = l10n.approved;
      desc = l10n.approvedDesc;
      glowColor = Colors.greenAccent;
    } else if (status == 'rejected') {
      title = l10n.rejected;
      desc = l10n.rejectedDesc;
      glowColor = Colors.redAccent;
    }

    return Column(
      children: [
        _buildAnimatedShield(color: glowColor, isDark: isDark),
        const Gap(32),
        Text(
          title,
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w900,
            color: isDark ? Colors.white : Colors.blueGrey.shade900,
            letterSpacing: 4,
            shadows: isDark ? [Shadow(color: glowColor, blurRadius: 20)] : null,
          ),
          textAlign: TextAlign.center,
        ),
        const Gap(16),
        Text(
          desc,
          style: TextStyle(
            fontSize: 14,
            color: isDark ? Colors.white.withOpacity(0.4) : Colors.blueGrey.shade600,
            fontWeight: FontWeight.w500,
            height: 1.5,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildAnimatedShield({required Color color, required bool isDark}) {
    return SizedBox(
      height: 220,
      width: 220,
      child: AnimatedBuilder(
        animation: _pulseController,
        builder: (context, child) {
          return Stack(
            alignment: Alignment.center,
            children: [
              _buildPulseCircle(1.0 - _pulseController.value, color),
              _buildPulseCircle(0.6 - _pulseController.value, color),
              Container(
                height: 140,
                width: 140,
                decoration: BoxDecoration(
                  color: isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.02),
                  shape: BoxShape.circle,
                  border: Border.all(color: isDark ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.05)),
                  boxShadow: [
                    BoxShadow(
                      color: color.withOpacity(0.1),
                      blurRadius: 40,
                      spreadRadius: 10,
                    )
                  ],
                ),
                child: Icon(
                    color == Colors.redAccent ? Icons.gpp_bad_rounded : Icons.verified_user_rounded,
                    size: 70, color: color),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildPulseCircle(double value, Color color) {
    if (value < 0) value += 1.0;
    return Container(
      width: 220 * value,
      height: 220 * value,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: color.withOpacity(value * 0.3), width: 2),
      ),
    );
  }

  Widget _buildStatusCard(String status, bool isDark) {
    final l10n = AppLocalizations.of(context)!;
    String label = l10n.waitingForApproval;
    Color color = Colors.cyanAccent;
    IconData icon = Icons.bolt_rounded;
    bool showLoading = true;

    if (status == 'approved' || status == 'verified') {
      label = l10n.approved;
      color = Colors.greenAccent;
      icon = Icons.check_circle_rounded;
      showLoading = false;
    } else if (status == 'rejected') {
      label = l10n.rejected;
      color = Colors.redAccent;
      icon = Icons.error_outline_rounded;
      showLoading = false;
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(32),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          decoration: BoxDecoration(
            color: isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.03),
            borderRadius: BorderRadius.circular(32),
            border: Border.all(color: isDark ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.05)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 30,
                offset: const Offset(0, 15),
              )
            ],
          ),
          child: Row(
            children: [
              if (showLoading)
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 48,
                      height: 48,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                            color.withOpacity(0.2)),
                      ),
                    ),
                    SizedBox(
                      width: 32,
                      height: 32,
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                        valueColor: AlwaysStoppedAnimation<Color>(color),
                      ),
                    ),
                  ],
                )
              else
                Container(
                  width: 48, height: 48,
                  decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
                  child: Icon(icon, color: color, size: 28),
                ),
              const Gap(24),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.applicationStatus,
                      style: TextStyle(
                        color: isDark ? Colors.cyanAccent : Colors.cyan.shade700,
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 2,
                      ),
                    ),
                    const Gap(4),
                    Text(
                      label,
                      style: TextStyle(
                        color: isDark ? Colors.white : Colors.blueGrey.shade900,
                        fontWeight: FontWeight.w900,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.bolt_rounded,
                    color: color, size: 20),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, WidgetRef ref, bool isDark) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      children: [
        TextButton.icon(
          onPressed: () {
            HapticFeedback.selectionClick();
            _showLogoutDialog(context, ref);
          },
          icon: Icon(Icons.power_settings_new_rounded,
              color: isDark ? Colors.white24 : Colors.black26, size: 20),
          label: Text(
            l10n.logoutAccount,
            style: TextStyle(
              color: isDark ? Colors.white24 : Colors.black26,
              fontWeight: FontWeight.w900,
              fontSize: 12,
              letterSpacing: 1,
            ),
          ),
        ),
      ],
    );
  }

  void _showLogoutDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => LogoutDialog(
        onLogout: () {
          Navigator.pop(context);
          ref.read(authNotifierProvider.notifier).signOut();
        },
      ),
    );
  }
}

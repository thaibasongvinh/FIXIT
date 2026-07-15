import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:fixit/core/router/app_router.dart';
import 'package:fixit/features/auth/presentation/providers/auth_provider.dart';
import 'package:fixit/shared/models/user_model.dart';
import '../../../providers/profile_mode_provider.dart';

class ModeToggleButton extends ConsumerWidget {
  final ProfileMode mode;
  const ModeToggleButton({super.key, required this.mode});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final targetModeText = mode == ProfileMode.buying ? 'selling' : 'buying';
    const assetPath = 'assets/images/Change Profile to selling mode.png';

    return InkWell(
      onTap: () async {
        // 1. Chuyển đổi dữ liệu vai trò về 'none' để hệ thống yêu cầu chọn lại
        await ref.read(authNotifierProvider.notifier).updateRole(UserRole.none);
        
        // 2. Chuyển hướng ra trang lựa chọn vai trò (I am...)
        if (context.mounted) {
          context.go(AppRoutes.roleSelection);
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            Image.asset(assetPath, width: 24, height: 24),
            const Gap(12),
            Text(
              'Change Profile to $targetModeText mode',
              style: const TextStyle(
                color: Color(0xFF333333),
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

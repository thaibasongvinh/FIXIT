import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fixit/shared/models/user_model.dart';
import 'package:fixit/features/auth/presentation/providers/auth_provider.dart';
import 'package:fixit/shared/utils/snackbar_utils.dart';

class PermissionUtils {
  static bool check(BuildContext context, WidgetRef ref, List<UserRole> allowedRoles) {
    final user = ref.read(currentUserProvider).valueOrNull;
    
    if (user == null) return false;
    
    if (user.role == UserRole.admin) return true;
    
    if (allowedRoles.contains(user.role)) return true;
    
    // Show notification if no permission
    AppSnackbar.showError(context, 'Không đủ quyền, vui lòng cấp quyền');
    
    return false;
  }

  static bool hasAccess(WidgetRef ref, List<UserRole> allowedRoles) {
    final user = ref.watch(currentUserProvider).valueOrNull;
    if (user == null) return false;
    if (user.role == UserRole.admin) return true;
    return allowedRoles.contains(user.role);
  }
}

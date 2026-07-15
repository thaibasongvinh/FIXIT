class AuthRedirectSnapshot {
  const AuthRedirectSnapshot({
    required this.hasCompletedOnboarding,
    required this.isAuthenticated,
    required this.requiresEmailVerification,
    required this.hasPickedRole,
    required this.requiresPhoneVerification,
    required this.hasCompletedTechnicianOnboarding,
    this.isPendingApproval = false,
    required this.canManageGuides,
    required this.isAdmin,
  });

  final bool hasCompletedOnboarding;
  final bool isAuthenticated;
  final bool requiresEmailVerification;
  final bool hasPickedRole;
  final bool requiresPhoneVerification;
  final bool hasCompletedTechnicianOnboarding;
  final bool isPendingApproval;
  final bool canManageGuides;
  final bool isAdmin;
}

String? resolveAppRedirect({
  required String location,
  required AuthRedirectSnapshot snapshot,
  required String splashRoute,
  required String onboardingRoute,
  required String loginRoute,
  required String registerRoute,
  required String forgotPasswordRoute,
  required String forgotPasswordEmailRoute,
  required String forgotPasswordPhoneRoute,
  required String resetPasswordRoute,
  required String roleSelectionRoute,
  required String verifyEmailRoute,
  required String verifyPhoneRoute,
  required String homeRoute,
}) {
  if (!snapshot.hasCompletedOnboarding) {
    return location == onboardingRoute ? null : onboardingRoute;
  }

  if (!snapshot.isAuthenticated) {
    final isAuthPage = location == loginRoute ||
        location == registerRoute ||
        location == forgotPasswordRoute ||
        location == forgotPasswordEmailRoute ||
        location == forgotPasswordPhoneRoute ||
        location == resetPasswordRoute ||
        location == verifyEmailRoute ||
        location == splashRoute;
    return isAuthPage ? null : loginRoute;
  }

  // 0. ƯU TIÊN: Nếu đang ở trang Reset Password, cho phép ở lại đó
  if (location == resetPasswordRoute) {
    return null;
  }

  // 1. Xác thực Email
  if (snapshot.requiresEmailVerification) {
    return location == verifyEmailRoute ? null : verifyEmailRoute;
  }

  // 2. Chọn Role
  if (!snapshot.hasPickedRole) {
    final isAllowed = location == roleSelectionRoute ||
        location == loginRoute ||
        location == registerRoute ||
        location == forgotPasswordRoute ||
        location == forgotPasswordEmailRoute ||
        location == forgotPasswordPhoneRoute ||
        location == resetPasswordRoute ||
        location == verifyEmailRoute ||
        location == '/phone-verification' ||
        location == '/technician-onboarding' ||
        location == splashRoute; // Allow Splash

    if (isAllowed) return null;
    return roleSelectionRoute;
  }

  // 3. Điều hướng từ Role sang Phone (Optional)
  if (location == roleSelectionRoute && snapshot.hasPickedRole) {
    return '/phone-verification';
  }

  // 4. Xác thực Số điện thoại (Chỉ chặn nếu BẮT BUỘC)
  if (snapshot.requiresPhoneVerification) {
    final isVerificationFlow = location == '/phone-verification' ||
        location == verifyPhoneRoute ||
        location == '/technician-onboarding';

    if (isVerificationFlow) return null;
    return '/phone-verification';
  }

  // 5. Technician Onboarding (Chỉ cho thợ chưa xong profile)
  if (!snapshot.hasCompletedTechnicianOnboarding) {
    if (location == '/technician-onboarding') return null;
    return '/technician-onboarding';
  }

  if (snapshot.isPendingApproval) {
    if (location == '/pending-approval') return null;
    return '/pending-approval';
  }

  // 6. Nếu đã đủ tất cả, chặn không cho quay lại các trang gate
  final isPreAppGate = location == splashRoute ||
      location == onboardingRoute ||
      location == loginRoute ||
      location == registerRoute ||
      location == forgotPasswordRoute ||
      location == forgotPasswordEmailRoute ||
      location == forgotPasswordPhoneRoute ||
      location == resetPasswordRoute ||
      location == verifyEmailRoute ||
      location == roleSelectionRoute;
  // Không đưa /phone-verification vào đây để cho phép Skip và không bị redirect ngược lại Home khi đang ở trang Phone

  if (isPreAppGate) {
    // Nếu đang ở trang Role Selection và chưa chọn xong -> giữ ở đó
    if (location == roleSelectionRoute && !snapshot.hasPickedRole) {
      return null;
    }

    // Nếu vừa login/register mà chưa có role -> bắt chọn role
    if ((location == loginRoute || location == registerRoute) &&
        !snapshot.hasPickedRole) {
      return roleSelectionRoute;
    }

    if (snapshot.isAdmin) return '/admin';
    return homeRoute;
  }

  // 5. Route Guard: Technician Only
  if (isTechnicianOnlyRoute(location) && !snapshot.canManageGuides) {
    if (snapshot.isAdmin) return '/admin';
    return homeRoute;
  }

  // 6. Route Guard: Admin Only
  if (isAdminOnlyRoute(location) && !snapshot.isAdmin) {
    if (snapshot.isAdmin) return '/admin';
    return homeRoute;
  }

  return null;
}

bool isTechnicianOnlyRoute(String location) {
  return location == '/guides/create' || location.endsWith('/add-step');
}

bool isAdminOnlyRoute(String location) {
  return location == '/admin' || location.startsWith('/admin/');
}

bool hasPasswordProvider(Iterable<String> providerIds) {
  return providerIds.contains('password');
}

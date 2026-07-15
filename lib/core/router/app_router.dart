import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../features/admin/presentation/screens/reviews/admin_reviews_screen.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';
import '../../features/auth/presentation/screens/login/login_screen.dart';
import '../../features/auth/presentation/screens/forgot_password/forgot_password_email_screen.dart';
import '../../features/auth/presentation/screens/forgot_password/forgot_password_method_screen.dart';
import '../../features/auth/presentation/screens/forgot_password/forgot_password_phone_screen.dart';
import '../../features/auth/presentation/screens/forgot_password/reset_password_screen.dart';
import '../../features/auth/presentation/screens/verification/phone_verification_screen.dart';
import '../../features/auth/presentation/screens/setup/role_selection_screen.dart';
import '../../features/auth/presentation/screens/setup/technician_onboarding_screen.dart';
import '../../features/auth/presentation/screens/setup/account_deactivated_screen.dart';
import '../../features/auth/presentation/screens/setup/pending_approval_screen.dart';
import '../../features/auth/presentation/screens/register/register_screen.dart';
import '../../features/auth/presentation/screens/verification/verify_email_screen.dart';
import '../../features/auth/presentation/screens/verification/verify_phone_screen.dart';
import '../../features/booking/presentation/screens/details/booking_detail_screen.dart';
import '../../features/booking/presentation/screens/create/booking_success_screen.dart';
import '../../features/booking/presentation/screens/create/create_booking_screen.dart';
import '../../features/booking/presentation/screens/main/my_bookings_screen.dart';
import '../../features/marketplace/domain/models/technician_model.dart';
import '../../features/marketplace/presentation/screens/service_issues_screen.dart';
import '../../features/marketplace/presentation/screens/service_solution_screen.dart';
import '../../features/marketplace/presentation/screens/city_search_screen.dart';
import '../../features/marketplace/presentation/screens/location_access_screen.dart';
import '../../features/marketplace/presentation/screens/booking_summary_screen.dart';
import '../../features/marketplace/presentation/screens/location_details_screen.dart';
import '../../features/marketplace/presentation/screens/schedule_selection_screen.dart';
import '../../features/marketplace/presentation/screens/selected_service_screen.dart';
import '../../features/marketplace/presentation/screens/service_selection_screen.dart';
import '../../features/marketplace/presentation/screens/technician_profile_screen.dart';
import '../../features/payment/presentation/screens/add_payment_card_screen.dart';
import '../../features/payment/presentation/screens/payment_method_screen.dart';
import '../../features/marketplace/presentation/screens/technician_map_screen.dart';
import '../../features/onboarding/presentation/providers/onboarding_provider.dart';
import '../../features/onboarding/presentation/screens/onboarding_screen.dart';
import '../../features/profile/presentation/screens/edit/edit_profile_screen.dart';
import '../../features/profile/presentation/screens/settings/notifications_screen.dart';
import '../../features/profile/presentation/screens/main/profile_screen.dart';
import '../../features/profile/presentation/screens/settings/profession_screen.dart';
import '../../features/profile/presentation/screens/settings/verification_screen.dart';
import '../../features/profile/presentation/screens/settings/upgrade_screen.dart';
import '../../features/profile/presentation/screens/settings/help_support_screen.dart';
import '../../features/wallet/presentation/screens/wallet_screen.dart';
import '../../shared/models/user_model.dart';
import '../../features/chat/presentation/screens/chat_list_screen.dart';
import '../../features/chat/presentation/screens/chat_screen.dart';
import '../../features/guides/presentation/screens/guides_screen.dart';
import '../../features/notifications/presentation/screens/notifications_screen.dart';
import '../../features/search/presentation/screens/results/search_results_screen.dart';
import '../../features/search/presentation/screens/filter/search_filter_screen.dart';
import '../../features/home/presentation/screens/calls/voice_call_screen.dart';
import '../../features/home/presentation/screens/explore/all_providers_screen.dart';
import '../../features/home/presentation/screens/explore/all_services_screen.dart';
import '../../features/home/presentation/screens/explore/category_technicians_screen.dart';
import '../../features/home/presentation/screens/main/home_screen.dart';
import '../../features/main/presentation/screens/main_shell.dart';
import '../../features/auth/presentation/screens/splash/splash_screen.dart';
import '../../features/admin/presentation/screens/dashboard/admin_dashboard_screen.dart';
import '../../features/admin/presentation/screens/approvals/admin_approvals_screen.dart';
import '../../features/admin/presentation/screens/users/admin_users_screen.dart';
import '../../features/admin/presentation/screens/services/admin_services_screen.dart';
import '../../features/admin/presentation/screens/bookings/admin_bookings_screen.dart';
import '../../features/admin/presentation/screens/approvals/admin_application_detail_screen.dart';
import '../analytics/analytics_service.dart';
import '../logging/log_service.dart';
import 'auth_redirect.dart';
import 'app_navigator_observer.dart';

import '../../features/admin/presentation/screens/banners/admin_banners_screen.dart';
import '../../features/admin/presentation/screens/config/admin_config_screen.dart';
import '../../features/admin/presentation/screens/broadcast/admin_broadcast_screen.dart';
import '../../features/admin/presentation/screens/products/admin_products_screen.dart';
import '../../features/admin/presentation/screens/finance/admin_finance_screen.dart';
import '../../features/admin/presentation/screens/coupons/admin_coupons_screen.dart';
import '../../features/admin/presentation/screens/audit/admin_audit_logs_screen.dart';
import '../../features/admin/presentation/screens/map/admin_live_tech_map_screen.dart';
import '../../features/admin/presentation/screens/reports/admin_reports_screen.dart';
import '../../features/admin/presentation/screens/roles/admin_staff_roles_screen.dart';
import '../../features/admin/presentation/screens/broadcast/admin_broadcast_history_screen.dart';

part 'app_router.g.dart';

abstract class AppRoutes {
  static const splash = '/splash';
  static const onboarding = '/onboarding';
  static const login = '/login';
  static const register = '/register';
  static const roleSelection = '/role-selection';
  static const phoneVerification = '/phone-verification';
  static const technicianOnboarding = '/technician-onboarding';
  static const pendingApproval = '/pending-approval';
  static const accountDeactivated = '/account-deactivated';
  static const verifyEmail = '/verify-email';
  static const verifyPhone = '/verify-phone';
  static const forgotPassword = '/forgot-password';
  static const forgotPasswordEmail = '/forgot-password-email';
  static const forgotPasswordPhone = '/forgot-password-phone';
  static const resetPassword = '/reset-password';
  static const home = '/home';
  static const voiceCall = '/voice-call';
  static const search = '/search';
  static const allServices = '/all-services';
  static const allProviders = '/all-providers';
  static const guides = '/guides';
  static const chat = '/chat';
  static const marketplace = '/marketplace';
  static const serviceIssues = '/service-flow/issues';
  static const serviceSolution = '/service-flow/solution';
  static const marketplaceProviders = '$marketplace/providers';
  static const marketplaceLocationAccess = '$marketplace/location-access';
  static const marketplaceLocationDetails = '$marketplace/location-details';
  static const profile = '/profile';
  static const editProfile = '/profile/edit';
  static const notifications = '/notifications';
  static const profession = '/profile/profession';
  static const verification = '/profile/verification';
  static const upgrade = '/profile/upgrade';
  static const helpSupport = '/profile/help-support';
  static const paymentMethods = '/profile/payment-methods';
  static const wallet = '/wallet';
  static const bookings = '/booking/my';
  static const technicianMap = '/marketplace/map';
  static const addPaymentCard = '/payment-methods/new-card';
  static const adminDashboard = '/admin';
  static const adminApprovals = '/admin/approvals';
  static const adminUsers = '/admin/users';
  static const adminServices = '/admin/services';
  static const adminBookings = '/admin/bookings';
  static const adminBanners = '/admin/banners';
  static const adminConfig = '/admin/config';
  static const adminBroadcast = '/admin/broadcast';
  static const adminBroadcastHistory = '/admin/broadcast-history';
  static const adminProducts = '/admin/products';
  static const adminFinance = '/admin/finance';
  static const adminReviews = '/admin/reviews';
  static const adminApplicationDetail = '/admin/approvals/:id';
  static const adminCoupons = '/admin/coupons';
  static const adminAuditLogs = '/admin/audit-logs';
  static const adminLiveMap = '/admin/live-map';
  static const adminReports = '/admin/reports';
  static const adminStaffRoles = '/admin/staff-roles';
}

@riverpod
GoRouter appRouter(Ref ref) {
  final log = ref.watch(logServiceProvider);
  final analytics = ref.watch(analyticsServiceProvider.notifier);
  
  final router = GoRouter(
    initialLocation: AppRoutes.splash,
    debugLogDiagnostics: false,
    observers: [AppNavigatorObserver(log, analytics)],
    restorationScopeId: 'router',
    redirect: (context, state) {
      final location = state.uri.path;

      // ƯU TIÊN TUYỆT ĐỐI CAO NHẤT:
      // Nếu đường dẫn chứa 'reset-password' hoặc là trang 'verify-email', 
      // dừng tất cả các logic redirect khác. Không cho phép tự động chuyển hướng.
      if (location.contains('reset-password') || location.contains('verify-email')) {
        return null;
      }

      final onboardingState = ref.read(onboardingNotifierProvider);
      final authState = ref.read(authStateProvider);
      final userState = ref.read(currentUserProvider);

      if (location == AppRoutes.splash) return null;

      // 1. ONBOARDING (Giữ nguyên)
      final hasOnboarded = onboardingState.valueOrNull ?? false;
      if (!hasOnboarded) {
        if (location == AppRoutes.onboarding) return null;
        return AppRoutes.onboarding;
      }

      if (authState.isLoading || userState.isLoading) return null;

      final authUser = authState.valueOrNull;
      
      // 2. CHỐT CHẶN AUTH
      if (authUser == null) {
        final isAuthPage = location == AppRoutes.login || 
                          location == AppRoutes.register ||
                          location == AppRoutes.forgotPassword ||
                          location == AppRoutes.forgotPasswordEmail ||
                          location == AppRoutes.forgotPasswordPhone ||
                          location == AppRoutes.verifyEmail;
        return isAuthPage ? null : AppRoutes.login;
      }

      // Nếu đã login mà đang ở verify-email thì cho phép ở lại để thực hiện chuyển hướng thủ công
      if (location == AppRoutes.verifyEmail) return null;

      // 3. CHỐT CHẶN EMAIL
      if (!authUser.emailVerification) {
        return AppRoutes.verifyEmail;
      }

      // 4. CHỐT CHẶN PROFILE
      final user = userState.valueOrNull;
      if (user == null) return null;

      // 4.1. CHỐT CHẶN VÔ HIỆU HÓA
      if (!user.isActive) {
        if (location == AppRoutes.accountDeactivated) return null;
        return AppRoutes.accountDeactivated;
      }
      
      // 5. CHỐT CHẶN ADMIN
      if (user.isAdmin) {
        if (!location.startsWith('/admin')) return AppRoutes.adminDashboard;
        return null;
      }

      // 6. CHỐT CHẶN ROLE & ONBOARDING
      if (user.role == UserRole.none) {
        if (location == AppRoutes.roleSelection) return null;
        return AppRoutes.roleSelection;
      }

      // Nếu là Thợ mà chưa có thông tin chuyên môn (chưa Onboard xong)
      if (user.role == UserRole.technician && user.skills.isEmpty) {
        if (location == AppRoutes.technicianOnboarding) return null;
        return AppRoutes.technicianOnboarding;
      }

      // Nếu là Thợ mà chưa được duyệt (trạng thái pending)
      if (user.role == UserRole.technician && user.verifiedStatus == 'pending') {
        if (location == AppRoutes.pendingApproval) return null;
        return AppRoutes.pendingApproval;
      }

      // 7. VÀO APP
      final isAtGate = location == AppRoutes.login || 
                       location == AppRoutes.register || 
                       location == AppRoutes.roleSelection ||
                       location == AppRoutes.technicianOnboarding ||
                       location == AppRoutes.pendingApproval ||
                       location == AppRoutes.splash;
      
      if (isAtGate) {
        if (user.isAdmin) return AppRoutes.adminDashboard;
        return AppRoutes.home;
      }

      return null;
    },
    routes: [
      GoRoute(path: AppRoutes.splash, builder: (_, __) => const SplashScreen()),
      GoRoute(path: AppRoutes.onboarding, builder: (_, __) => const OnboardingScreen()),
      GoRoute(path: AppRoutes.login, builder: (_, __) => const LoginScreen()),
      GoRoute(path: AppRoutes.register, builder: (_, __) => const RegisterScreen()),
      GoRoute(path: AppRoutes.forgotPassword, builder: (_, __) => const ForgotPasswordMethodScreen()),
      GoRoute(path: AppRoutes.forgotPasswordEmail, builder: (_, __) => const ForgotPasswordEmailScreen()),
      GoRoute(path: AppRoutes.forgotPasswordPhone, builder: (_, __) => const ForgotPasswordPhoneScreen()),
      GoRoute(
        path: AppRoutes.resetPassword,
        builder: (_, state) {
          final extra = state.extra as Map<String, dynamic>? ?? {};
          return ResetPasswordScreen(
            userId: state.uri.queryParameters['userId'] ?? extra['userId'],
            secret: state.uri.queryParameters['secret'] ?? extra['secret'],
            email: state.uri.queryParameters['email'] ?? extra['email'],
          );
        },
      ),
      GoRoute(path: AppRoutes.roleSelection, builder: (_, __) => const RoleSelectionScreen()),
      GoRoute(
        path: AppRoutes.phoneVerification,
        builder: (_, state) => PhoneVerificationScreen(role: state.extra as UserRole?),
      ),
      GoRoute(path: AppRoutes.technicianOnboarding, builder: (_, __) => const TechnicianOnboardingScreen()),
      GoRoute(path: AppRoutes.pendingApproval, builder: (_, __) => const PendingApprovalScreen()),
      GoRoute(path: AppRoutes.accountDeactivated, builder: (_, __) => const AccountDeactivatedScreen()),
      GoRoute(
        path: AppRoutes.verifyEmail,
        builder: (_, state) {
          final extra = state.extra as Map<String, dynamic>? ?? {};
          final isForgotPassword = state.uri.queryParameters['isForgotPassword'] == 'true' || (extra['isForgotPassword'] ?? false);
          final email = state.uri.queryParameters['email'] ?? extra['email'];
          
          return VerifyEmailScreen(
            isForgotPassword: isForgotPassword,
            email: email,
          );
        },
      ),
      GoRoute(
        path: AppRoutes.verifyPhone,
        builder: (_, state) {
          final extras = state.extra as Map<String, dynamic>? ?? {};
          return VerifyPhoneScreen(
            phoneNumber: extras['phoneNumber'] ?? '',
            verificationId: extras['verificationId'] ?? '',
            isForgotPassword: extras['isForgotPassword'] ?? false,
          );
        },
      ),
      GoRoute(
        path: AppRoutes.allServices,
        builder: (context, state) => AllServicesScreen(initialCategory: state.uri.queryParameters['category']),
      ),
      GoRoute(
        path: AppRoutes.allProviders,
        builder: (context, state) => const AllProvidersScreen(),
        routes: [
          GoRoute(
            path: 'category',
            builder: (_, state) => CategoryTechniciansScreen(
              categoryTitle: state.uri.queryParameters['title'] ?? 'Providers',
            ),
          ),
        ],
      ),
      GoRoute(
        path: '${AppRoutes.serviceIssues}/:serviceId',
        builder: (context, state) => ServiceIssuesScreen(
          serviceId: state.pathParameters['serviceId'] ?? '',
          serviceTitle: state.uri.queryParameters['title'] ?? '',
        ),
      ),
      GoRoute(
        path: '${AppRoutes.serviceSolution}/:issueId',
        builder: (context, state) => ServiceSolutionScreen(
          issueId: state.pathParameters['issueId'] ?? '',
          issueTitle: state.uri.queryParameters['title'] ?? '',
          serviceTitle: state.uri.queryParameters['serviceTitle'] ?? '',
        ),
      ),
      GoRoute(
        path: '/marketplace/:techId',
        builder: (context, state) => TechnicianProfileScreen(techId: state.pathParameters['techId']!),
      ),
      GoRoute(
        path: '/marketplace/service-selection',
        builder: (_, state) => ServiceSelectionScreen(
          categoryTitle: state.uri.queryParameters['title'] ?? 'Electrician service',
          imageAsset: state.uri.queryParameters['image'] ?? 'assets/images/Electricity Meter.png',
        ),
      ),
      GoRoute(
        path: '/marketplace/selected-service',
        builder: (_, state) => SelectedServiceScreen(
          serviceTitle: state.uri.queryParameters['serviceTitle'] ?? 'Wiring Installation',
          categoryName: state.uri.queryParameters['categoryName'] ?? 'Electrician',
          imageAsset: state.uri.queryParameters['image'] ?? 'assets/images/Electricity Meter.png',
        ),
      ),
      ShellRoute(
        builder: (_, __, child) => MainShell(child: child),
        routes: [
          GoRoute(path: AppRoutes.home, builder: (_, __) => const HomeScreen()),
          GoRoute(path: AppRoutes.marketplace, builder: (_, __) => const CitySearchScreen()),
          GoRoute(path: AppRoutes.technicianMap, builder: (_, __) => const TechnicianMapScreen()),
          GoRoute(path: AppRoutes.profile, builder: (_, __) => const ProfileScreen()),
          GoRoute(path: AppRoutes.profession, builder: (_, __) => const ProfessionScreen()),
          GoRoute(path: AppRoutes.verification, builder: (_, __) => const VerificationScreen()),
          GoRoute(path: AppRoutes.upgrade, builder: (_, __) => const UpgradeScreen()),
          GoRoute(path: AppRoutes.helpSupport, builder: (_, __) => const HelpSupportScreen()),
          GoRoute(path: '/wallet', builder: (_, __) => const WalletScreen()),
          GoRoute(path: AppRoutes.bookings, builder: (_, __) => const MyBookingsScreen()),
          GoRoute(path: AppRoutes.guides, builder: (_, __) => const GuidesScreen()),
          GoRoute(
              path: AppRoutes.search,
              builder: (_, state) => SearchResultsScreen(query: state.uri.queryParameters['query'] ?? '')),
          GoRoute(path: '/message-notifications', builder: (_, __) => const NotificationsScreen()),
        ],
      ),
      GoRoute(
          path: AppRoutes.chat,
          builder: (_, __) => const ChatListScreen(),
          routes: [
            GoRoute(
              path: ':chatId',
              builder: (_, state) {
                final extras = state.extra as Map<String, dynamic>? ?? {};
                return ChatScreen(
                  roomId: state.pathParameters['chatId']!,
                  otherUserName: extras['otherUserName'] ?? 'Hỗ trợ kỹ thuật',
                  bookingId: extras['bookingId'] ?? '',
                  participants: List<String>.from(extras['participants'] ?? []),
                );
              },
            ),
          ]),
      GoRoute(
          path: AppRoutes.voiceCall,
          builder: (_, state) {
            final extra = state.extra as Map<String, dynamic>? ?? {};
            return VoiceCallScreen(
              name: state.uri.queryParameters['name'] ?? extra['name'],
              avatar: state.uri.queryParameters['avatar'] ?? extra['avatar'],
              callId: extra['callId'],
              isIncoming: extra['isIncoming'] ?? false,
            );
          }),
      GoRoute(path: '/search/filter', builder: (_, __) => const SearchFilterScreen()),
      GoRoute(path: '/notifications', builder: (_, __) => const NotificationsScreen()),
      GoRoute(path: '/settings/notifications', builder: (_, __) => const NotificationSettingsScreen()),
      GoRoute(
          path: '/profile/edit',
          builder: (_, state) {
            final extra = state.extra;
            if (extra is UserModel) return EditProfileScreen(user: extra);
            if (extra is Map<String, dynamic>) return EditProfileScreen(user: UserModel.fromJson(extra));
            return Consumer(builder: (context, ref, child) {
              final user = ref.watch(currentUserProvider).valueOrNull;
              if (user != null) return EditProfileScreen(user: user);
              return const Scaffold(body: Center(child: CircularProgressIndicator()));
            });
          }),
      GoRoute(
          path: '/booking/create',
          builder: (_, state) {
            final extra = state.extra;
            if (extra is TechnicianModel) return CreateBookingScreen(tech: extra);
            if (extra is Map<String, dynamic>) return CreateBookingScreen(tech: TechnicianModel.fromJson(extra));
            return const Scaffold(body: Center(child: Text('Invalid booking data')));
          }),
      GoRoute(path: '/booking/success', builder: (_, state) => BookingSuccessScreen(bookingId: state.extra as String?)),
      GoRoute(path: '/booking/:id/payment', builder: (_, state) => PaymentMethodScreen(bookingId: state.pathParameters['id']!)),
      GoRoute(path: AppRoutes.addPaymentCard, builder: (_, __) => const AddPaymentCardScreen()),
      GoRoute(path: '/booking/:id', builder: (_, state) => BookingDetailScreen(bookingId: state.pathParameters['id']!)),
      GoRoute(path: AppRoutes.adminDashboard, builder: (_, __) => const AdminDashboardScreen()),
      GoRoute(path: AppRoutes.adminApprovals, builder: (_, __) => const AdminApprovalsScreen()),
      GoRoute(path: AppRoutes.adminUsers, builder: (_, __) => const AdminUsersScreen()),
      GoRoute(path: AppRoutes.adminServices, builder: (_, __) => const AdminServicesScreen()),
      GoRoute(path: AppRoutes.adminBookings, builder: (_, __) => const AdminBookingsScreen()),
      GoRoute(path: AppRoutes.adminBanners, builder: (_, __) => const AdminBannersScreen()),
      GoRoute(path: AppRoutes.adminConfig, builder: (_, __) => const AdminConfigScreen()),
      GoRoute(path: AppRoutes.adminBroadcast, builder: (_, __) => const AdminBroadcastScreen()),
      GoRoute(path: AppRoutes.adminProducts, builder: (_, __) => const AdminProductsScreen()),
      GoRoute(path: AppRoutes.adminFinance, builder: (_, __) => const AdminFinanceScreen()),
      GoRoute(path: AppRoutes.adminReviews, builder: (_, __) => const AdminReviewsScreen()),
      GoRoute(path: AppRoutes.adminApplicationDetail, builder: (_, state) => AdminApplicationDetailScreen(applicationId: state.pathParameters['id']!)),
      GoRoute(path: AppRoutes.adminCoupons, builder: (_, __) => const AdminCouponsScreen()),
      GoRoute(path: AppRoutes.adminAuditLogs, builder: (_, __) => const AdminAuditLogsScreen()),
      GoRoute(path: AppRoutes.adminLiveMap, builder: (_, __) => const AdminLiveTechMapScreen()),
      GoRoute(path: AppRoutes.adminReports, builder: (_, __) => const AdminReportsScreen()),
      GoRoute(path: AppRoutes.adminStaffRoles, builder: (_, __) => const AdminStaffRolesScreen()),
      GoRoute(path: AppRoutes.adminBroadcastHistory, builder: (_, __) => const AdminBroadcastHistoryScreen()),
      GoRoute(
        path: AppRoutes.adminApplicationDetail, 
        builder: (_, state) => AdminApplicationDetailScreen(applicationId: state.pathParameters['id']!),
      ),
    ],
  );

  ref.listen(onboardingNotifierProvider, (prev, next) => router.refresh());
  ref.listen(authStateProvider, (prev, next) => router.refresh());
  ref.listen(currentUserProvider, (prev, next) => router.refresh());

  return router;
}

bool hasPasswordProvider(Iterable<String> providerIds) => providerIds.contains('password');

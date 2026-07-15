import 'package:fixit/core/router/app_router.dart';
import 'package:fixit/core/router/auth_redirect.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';


void main() {
  group('Phase 1 route gates', () {
    testWidgets('onboarding first launch redirects to onboarding',
        (tester) async {
      final router = _buildRouter(
        initialLocation: AppRoutes.home,
        snapshot: const AuthRedirectSnapshot(
          hasCompletedOnboarding: false,
          isAuthenticated: false,
          hasPickedRole: false,
          requiresEmailVerification: false,
          requiresPhoneVerification: false,
          hasCompletedTechnicianOnboarding: true,
          canManageGuides: false,
          isAdmin: false,
        ),
      );

      await tester.pumpWidget(_TestApp(router: router));
      await tester.pumpAndSettle();

      expect(find.text('onboarding'), findsOneWidget);
    });

    testWidgets('email login redirects to verify-email when email is pending',
        (tester) async {
      final router = _buildRouter(
        initialLocation: AppRoutes.home,
        snapshot: const AuthRedirectSnapshot(
          hasCompletedOnboarding: true,
          isAuthenticated: true,
          hasPickedRole: false, // Redirect to verify-email happens before role selection
          requiresEmailVerification: true,
          requiresPhoneVerification: false,
          hasCompletedTechnicianOnboarding: true,
          canManageGuides: false,
          isAdmin: false,
        ),
      );

      await tester.pumpWidget(_TestApp(router: router));
      await tester.pumpAndSettle();

      expect(find.text('verify-email'), findsOneWidget);
    });

    testWidgets(
        'signed in user without role redirects to role selection',
        (tester) async {
      final router = _buildRouter(
        initialLocation: AppRoutes.home,
        snapshot: const AuthRedirectSnapshot(
          hasCompletedOnboarding: true,
          isAuthenticated: true,
          hasPickedRole: false,
          requiresEmailVerification: false,
          requiresPhoneVerification: false,
          hasCompletedTechnicianOnboarding: true,
          canManageGuides: false,
          isAdmin: false,
        ),
      );

      await tester.pumpWidget(_TestApp(router: router));
      await tester.pumpAndSettle();

      expect(find.text('role-selection'), findsOneWidget);
    });

    testWidgets('verified user reaches home shell', (tester) async {
      final router = _buildRouter(
        initialLocation: AppRoutes.home,
        snapshot: const AuthRedirectSnapshot(
          hasCompletedOnboarding: true,
          isAuthenticated: true,
          hasPickedRole: true,
          requiresEmailVerification: false,
          requiresPhoneVerification: false,
          hasCompletedTechnicianOnboarding: true,
          canManageGuides: true,
          isAdmin: false,
        ),
      );

      await tester.pumpWidget(_TestApp(router: router));
      await tester.pumpAndSettle();

      expect(find.text('home'), findsOneWidget);
    });
  });
}

class _TestApp extends StatelessWidget {
  const _TestApp({required this.router});

  final GoRouter router;

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: router,
    );
  }
}

GoRouter _buildRouter({
  required String initialLocation,
  required AuthRedirectSnapshot snapshot,
}) {
  return GoRouter(
    initialLocation: initialLocation,
    redirect: (_, state) {
      return resolveAppRedirect(
        location: state.matchedLocation,
        splashRoute: AppRoutes.splash,
        onboardingRoute: AppRoutes.onboarding,
        loginRoute: AppRoutes.login,
        registerRoute: AppRoutes.register,
        forgotPasswordRoute: AppRoutes.forgotPassword,
        forgotPasswordEmailRoute: AppRoutes.forgotPasswordEmail,
        forgotPasswordPhoneRoute: AppRoutes.forgotPasswordPhone,
        resetPasswordRoute: AppRoutes.resetPassword,
        roleSelectionRoute: AppRoutes.roleSelection,
        verifyEmailRoute: AppRoutes.verifyEmail,
        verifyPhoneRoute: AppRoutes.verifyPhone,
        homeRoute: AppRoutes.home,
        snapshot: snapshot,
      );
    },
    routes: [
      _route(AppRoutes.splash, 'splash'),
      _route(AppRoutes.onboarding, 'onboarding'),
      _route(AppRoutes.login, 'login'),
      _route(AppRoutes.register, 'register'),
      _route(AppRoutes.roleSelection, 'role-selection'),
      _route(AppRoutes.verifyEmail, 'verify-email'),
      _route(AppRoutes.verifyPhone, 'verify-phone'),
      _route(AppRoutes.phoneVerification, 'phone-verification'),
      _route(AppRoutes.home, 'home'),
    ],
  );
}

GoRoute _route(String path, String label) {
  return GoRoute(
    path: path,
    builder: (_, __) => Scaffold(
      body: Center(
        child: Text(label),
      ),
    ),
  );
}

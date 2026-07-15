import 'package:fixit/core/router/app_router.dart';
import 'package:fixit/core/router/auth_redirect.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const splashRoute = AppRoutes.splash;
  const onboardingRoute = AppRoutes.onboarding;
  const loginRoute = AppRoutes.login;
  const registerRoute = AppRoutes.register;
  const roleSelectionRoute = AppRoutes.roleSelection;
  const verifyEmailRoute = AppRoutes.verifyEmail;
  const verifyPhoneRoute = AppRoutes.verifyPhone;
  const homeRoute = AppRoutes.home;
  const forgotPasswordRoute = AppRoutes.forgotPassword;
  const forgotPasswordEmailRoute = AppRoutes.forgotPasswordEmail;
  const forgotPasswordPhoneRoute = AppRoutes.forgotPasswordPhone;
  const resetPasswordRoute = AppRoutes.resetPassword;

  group('resolveAppRedirect', () {
    test('redirects first launch users to onboarding', () {
      final redirect = resolveAppRedirect(
        location: homeRoute,
        splashRoute: splashRoute,
        onboardingRoute: onboardingRoute,
        loginRoute: loginRoute,
        registerRoute: registerRoute,
        forgotPasswordRoute: forgotPasswordRoute,
        forgotPasswordEmailRoute: forgotPasswordEmailRoute,
        forgotPasswordPhoneRoute: forgotPasswordPhoneRoute,
        resetPasswordRoute: resetPasswordRoute,
        roleSelectionRoute: roleSelectionRoute,
        verifyEmailRoute: verifyEmailRoute,
        verifyPhoneRoute: verifyPhoneRoute,
        homeRoute: homeRoute,
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

      expect(redirect, onboardingRoute);
    });

    test('redirects unauthenticated users to login', () {
      final redirect = resolveAppRedirect(
        location: homeRoute,
        splashRoute: splashRoute,
        onboardingRoute: onboardingRoute,
        loginRoute: loginRoute,
        registerRoute: registerRoute,
        forgotPasswordRoute: forgotPasswordRoute,
        forgotPasswordEmailRoute: forgotPasswordEmailRoute,
        forgotPasswordPhoneRoute: forgotPasswordPhoneRoute,
        resetPasswordRoute: resetPasswordRoute,
        roleSelectionRoute: roleSelectionRoute,
        verifyEmailRoute: verifyEmailRoute,
        verifyPhoneRoute: verifyPhoneRoute,
        homeRoute: homeRoute,
        snapshot: const AuthRedirectSnapshot(
          hasCompletedOnboarding: true,
          isAuthenticated: false,
          hasPickedRole: false,
          requiresEmailVerification: false,
          requiresPhoneVerification: false,
          hasCompletedTechnicianOnboarding: true,
          canManageGuides: false,
          isAdmin: false,
        ),
      );

      expect(redirect, loginRoute);
    });

    test('redirects authenticated users without role to role selection', () {
      final redirect = resolveAppRedirect(
        location: homeRoute,
        splashRoute: splashRoute,
        onboardingRoute: onboardingRoute,
        loginRoute: loginRoute,
        registerRoute: registerRoute,
        forgotPasswordRoute: forgotPasswordRoute,
        forgotPasswordEmailRoute: forgotPasswordEmailRoute,
        forgotPasswordPhoneRoute: forgotPasswordPhoneRoute,
        resetPasswordRoute: resetPasswordRoute,
        roleSelectionRoute: roleSelectionRoute,
        verifyEmailRoute: verifyEmailRoute,
        verifyPhoneRoute: verifyPhoneRoute,
        homeRoute: homeRoute,
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

      expect(redirect, roleSelectionRoute);
    });

    test('redirects signed in email users to verify-email first', () {
      final redirect = resolveAppRedirect(
        location: homeRoute,
        splashRoute: splashRoute,
        onboardingRoute: onboardingRoute,
        loginRoute: loginRoute,
        registerRoute: registerRoute,
        forgotPasswordRoute: forgotPasswordRoute,
        forgotPasswordEmailRoute: forgotPasswordEmailRoute,
        forgotPasswordPhoneRoute: forgotPasswordPhoneRoute,
        resetPasswordRoute: resetPasswordRoute,
        roleSelectionRoute: roleSelectionRoute,
        verifyEmailRoute: verifyEmailRoute,
        verifyPhoneRoute: verifyPhoneRoute,
        homeRoute: homeRoute,
        snapshot: const AuthRedirectSnapshot(
          hasCompletedOnboarding: true,
          isAuthenticated: true,
          hasPickedRole: false,
          requiresEmailVerification: true,
          requiresPhoneVerification: false,
          hasCompletedTechnicianOnboarding: true,
          canManageGuides: false,
          isAdmin: false,
        ),
      );

      expect(redirect, verifyEmailRoute);
    });

    test('redirects from role selection to phone verification after picking role', () {
      final redirect = resolveAppRedirect(
        location: roleSelectionRoute,
        splashRoute: splashRoute,
        onboardingRoute: onboardingRoute,
        loginRoute: loginRoute,
        registerRoute: registerRoute,
        forgotPasswordRoute: forgotPasswordRoute,
        forgotPasswordEmailRoute: forgotPasswordEmailRoute,
        forgotPasswordPhoneRoute: forgotPasswordPhoneRoute,
        resetPasswordRoute: resetPasswordRoute,
        roleSelectionRoute: roleSelectionRoute,
        verifyEmailRoute: verifyEmailRoute,
        verifyPhoneRoute: verifyPhoneRoute,
        homeRoute: homeRoute,
        snapshot: const AuthRedirectSnapshot(
          hasCompletedOnboarding: true,
          isAuthenticated: true,
          hasPickedRole: true,
          requiresEmailVerification: false,
          requiresPhoneVerification: false,
          hasCompletedTechnicianOnboarding: true,
          canManageGuides: false,
          isAdmin: false,
        ),
      );

      expect(redirect, '/phone-verification');
    });

    test('allows staying on reset password page if authenticated', () {
      final redirect = resolveAppRedirect(
        location: resetPasswordRoute,
        splashRoute: splashRoute,
        onboardingRoute: onboardingRoute,
        loginRoute: loginRoute,
        registerRoute: registerRoute,
        forgotPasswordRoute: forgotPasswordRoute,
        forgotPasswordEmailRoute: forgotPasswordEmailRoute,
        forgotPasswordPhoneRoute: forgotPasswordPhoneRoute,
        resetPasswordRoute: resetPasswordRoute,
        roleSelectionRoute: roleSelectionRoute,
        verifyEmailRoute: verifyEmailRoute,
        verifyPhoneRoute: verifyPhoneRoute,
        homeRoute: homeRoute,
        snapshot: const AuthRedirectSnapshot(
          hasCompletedOnboarding: true,
          isAuthenticated: true,
          hasPickedRole: false, // Even without role, we can reset password
          requiresEmailVerification: false,
          requiresPhoneVerification: false,
          hasCompletedTechnicianOnboarding: true,
          canManageGuides: false,
          isAdmin: false,
        ),
      );

      expect(redirect, isNull);
    });

    test('redirects technicians to onboarding if profile incomplete', () {
      final redirect = resolveAppRedirect(
        location: homeRoute,
        splashRoute: splashRoute,
        onboardingRoute: onboardingRoute,
        loginRoute: loginRoute,
        registerRoute: registerRoute,
        forgotPasswordRoute: forgotPasswordRoute,
        forgotPasswordEmailRoute: forgotPasswordEmailRoute,
        forgotPasswordPhoneRoute: forgotPasswordPhoneRoute,
        resetPasswordRoute: resetPasswordRoute,
        roleSelectionRoute: roleSelectionRoute,
        verifyEmailRoute: verifyEmailRoute,
        verifyPhoneRoute: verifyPhoneRoute,
        homeRoute: homeRoute,
        snapshot: const AuthRedirectSnapshot(
          hasCompletedOnboarding: true,
          isAuthenticated: true,
          hasPickedRole: true,
          requiresEmailVerification: false,
          requiresPhoneVerification: false,
          hasCompletedTechnicianOnboarding: false,
          canManageGuides: true,
          isAdmin: false,
        ),
      );

      expect(redirect, '/technician-onboarding');
    });

    test('redirects authenticated pre-app gates to home', () {
      final redirect = resolveAppRedirect(
        location: loginRoute,
        splashRoute: splashRoute,
        onboardingRoute: onboardingRoute,
        loginRoute: loginRoute,
        registerRoute: registerRoute,
        forgotPasswordRoute: forgotPasswordRoute,
        forgotPasswordEmailRoute: forgotPasswordEmailRoute,
        forgotPasswordPhoneRoute: forgotPasswordPhoneRoute,
        resetPasswordRoute: resetPasswordRoute,
        roleSelectionRoute: roleSelectionRoute,
        verifyEmailRoute: verifyEmailRoute,
        verifyPhoneRoute: verifyPhoneRoute,
        homeRoute: homeRoute,
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

      expect(redirect, homeRoute);
    });

    test('blocks technician-only routes for customers', () {
      final redirect = resolveAppRedirect(
        location: '/guides/create',
        splashRoute: splashRoute,
        onboardingRoute: onboardingRoute,
        loginRoute: loginRoute,
        registerRoute: registerRoute,
        forgotPasswordRoute: forgotPasswordRoute,
        forgotPasswordEmailRoute: forgotPasswordEmailRoute,
        forgotPasswordPhoneRoute: forgotPasswordPhoneRoute,
        resetPasswordRoute: resetPasswordRoute,
        roleSelectionRoute: roleSelectionRoute,
        verifyEmailRoute: verifyEmailRoute,
        verifyPhoneRoute: verifyPhoneRoute,
        homeRoute: homeRoute,
        snapshot: const AuthRedirectSnapshot(
          hasCompletedOnboarding: true,
          isAuthenticated: true,
          hasPickedRole: true,
          requiresEmailVerification: false,
          requiresPhoneVerification: false,
          hasCompletedTechnicianOnboarding: true,
          canManageGuides: false,
          isAdmin: false,
        ),
      );

      expect(redirect, homeRoute);
    });

    test('allows in-app routes for verified users', () {
      final redirect = resolveAppRedirect(
        location: '/marketplace',
        splashRoute: splashRoute,
        onboardingRoute: onboardingRoute,
        loginRoute: loginRoute,
        registerRoute: registerRoute,
        forgotPasswordRoute: forgotPasswordRoute,
        forgotPasswordEmailRoute: forgotPasswordEmailRoute,
        forgotPasswordPhoneRoute: forgotPasswordPhoneRoute,
        resetPasswordRoute: resetPasswordRoute,
        roleSelectionRoute: roleSelectionRoute,
        verifyEmailRoute: verifyEmailRoute,
        verifyPhoneRoute: verifyPhoneRoute,
        homeRoute: homeRoute,
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

      expect(redirect, isNull);
    });

    test('blocks admin routes for non-admin users', () {
      final redirect = resolveAppRedirect(
        location: '/admin',
        splashRoute: splashRoute,
        onboardingRoute: onboardingRoute,
        loginRoute: loginRoute,
        registerRoute: registerRoute,
        forgotPasswordRoute: forgotPasswordRoute,
        forgotPasswordEmailRoute: forgotPasswordEmailRoute,
        forgotPasswordPhoneRoute: forgotPasswordPhoneRoute,
        resetPasswordRoute: resetPasswordRoute,
        roleSelectionRoute: roleSelectionRoute,
        verifyEmailRoute: verifyEmailRoute,
        verifyPhoneRoute: verifyPhoneRoute,
        homeRoute: homeRoute,
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

      expect(redirect, homeRoute);
    });

    test('allows admin routes for admin users', () {
      final redirect = resolveAppRedirect(
        location: '/admin',
        splashRoute: splashRoute,
        onboardingRoute: onboardingRoute,
        loginRoute: loginRoute,
        registerRoute: registerRoute,
        forgotPasswordRoute: forgotPasswordRoute,
        forgotPasswordEmailRoute: forgotPasswordEmailRoute,
        forgotPasswordPhoneRoute: forgotPasswordPhoneRoute,
        resetPasswordRoute: resetPasswordRoute,
        roleSelectionRoute: roleSelectionRoute,
        verifyEmailRoute: verifyEmailRoute,
        verifyPhoneRoute: verifyPhoneRoute,
        homeRoute: homeRoute,
        snapshot: const AuthRedirectSnapshot(
          hasCompletedOnboarding: true,
          isAuthenticated: true,
          hasPickedRole: true,
          requiresEmailVerification: false,
          requiresPhoneVerification: false,
          hasCompletedTechnicianOnboarding: true,
          canManageGuides: true,
          isAdmin: true,
        ),
      );

      expect(redirect, isNull);
    });
  });

  group('isTechnicianOnlyRoute', () {
    test('detects guide creation and step authoring routes', () {
      expect(isTechnicianOnlyRoute('/guides/create'), isTrue);
      expect(isTechnicianOnlyRoute('/guides/detail/abc/add-step'), isTrue);
      expect(isTechnicianOnlyRoute('/guides'), isFalse);
    });
  });

  group('isAdminOnlyRoute', () {
    test('detects admin routes', () {
      expect(isAdminOnlyRoute('/admin'), isTrue);
      expect(isAdminOnlyRoute('/admin/content'), isTrue);
      expect(isAdminOnlyRoute('/guides'), isFalse);
    });
  });
}

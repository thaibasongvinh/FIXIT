import 'dart:ui'; 
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:fixit/features/auth/presentation/providers/auth_provider.dart';
import 'package:fixit/features/auth/presentation/providers/login_success_provider.dart';
import 'package:fixit/features/profile/presentation/widgets/components/avatar/profile_avatar.dart';
import 'package:fixit/shared/services/notification_service.dart';
import 'package:fixit/shared/utils/snackbar_utils.dart';
import 'package:fixit/l10n/app_localizations.dart';

import 'package:fixit/features/home/presentation/providers/call_provider.dart';
import 'package:fixit/features/notifications/presentation/providers/notification_provider.dart';
import 'package:fixit/shared/models/user_model.dart';

import 'package:fixit/features/home/presentation/providers/services_provider.dart';
import 'package:fixit/features/search/presentation/providers/filter_provider.dart';
import 'package:fixit/features/main/presentation/providers/ui_state_provider.dart';

import 'package:fixit/shared/utils/seed_sample_data.dart';

import '../../../../core/router/app_router.dart';

class MainShell extends ConsumerStatefulWidget {
  final Widget child;
  const MainShell({super.key, required this.child});

  @override
  ConsumerState<MainShell> createState() => _MainShellState();
}

class _MainShellState extends ConsumerState<MainShell> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Tự động tạo dữ liệu mẫu khi vào app (chỉ chạy 1 lần nếu cần)
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          seedSampleData(ref);
        }
      });

      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) {
          NotificationService.requestPermission();
        }
      });

      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted && ref.read(loginSuccessNotifierProvider)) {
          AppSnackbar.showSuccess(context, 'Đăng nhập thành công!');
          ref.read(loginSuccessNotifierProvider.notifier).clear();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final loc = GoRouterState.of(context).matchedLocation;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final userAsync = ref.watch(currentUserProvider);
    final authStateAsync = ref.watch(authStateProvider);
    final l10n = AppLocalizations.of(context)!;

    // Lắng nghe thông báo Real-time
    ref.listen(notificationsStreamProvider, (prev, next) {
      // Logic đã được xử lý bên trong StreamProvider (hiển thị Local Notification)
      // Ở đây ta chỉ cần ensure provider được active.
    });

    // Lắng nghe cuộc gọi đến
    ref.listen(incomingCallProvider, (prev, next) {
      final call = next.valueOrNull;
      if (call != null) {
        context.push(
          AppRoutes.voiceCall,
          extra: {
            'name': call.callerName,
            'avatar': call.callerAvatar,
            'callId': call.id,
            'isIncoming': true,
          },
        );
      }
    });

    final user = userAsync.valueOrNull;
    final authUser = authStateAsync.valueOrNull;

    final authName = (authUser?.name.isNotEmpty ?? false) ? authUser!.name : 'FixIt User';
    final effectiveUser = user?.copyWith(
          name: user.name.isEmpty ? authName : user.name,
        ) ??
        UserModel(
          uid: authUser?.$id ?? '',
          name: authName,
          email: authUser?.email ?? '',
          role: UserRole.customer,
        );

    ref.listen(loginSuccessNotifierProvider, (previous, next) {
      if (next == true) {
        AppSnackbar.showSuccess(context, 'Đăng nhập thành công!');
        ref.read(loginSuccessNotifierProvider.notifier).clear();
      }
    });

    final displayName = effectiveUser.name.isEmpty ? l10n.profile : effectiveUser.name;
    final profileLabel = displayName.split(' ').first;

    final tabs = [
      (
        activeIcon: 'assets/images/Home(1).png',
        inactiveIcon: 'assets/images/Home.png',
        label: l10n.home,
        route: '/home',
        customIcon: null as Widget?,
      ),
      (
        activeIcon: 'assets/images/City(1).png',
        inactiveIcon: 'assets/images/City.png',
        label: l10n.city,
        route: '/marketplace',
        customIcon: null as Widget?,
      ),
      (
        activeIcon: 'assets/images/Order(1).png',
        inactiveIcon: 'assets/images/Order.png',
        label: l10n.order,
        route: '/booking/my',
        customIcon: null as Widget?,
      ),
      (
        activeIcon: '',
        inactiveIcon: '',
        label: profileLabel,
        route: '/profile',
        customIcon: (user != null || authUser != null) 
            ? MiniAvatar(user: effectiveUser)
            : null,
      ),
    ];

    final searchQuery = ref.watch(searchQueryProvider);
    final searchFilter = ref.watch(searchFilterProvider);
    final bool isSearching = searchQuery.isNotEmpty || 
                             searchFilter.serviceCategory != 'ALL' || 
                             searchFilter.minRating > 3.0 || 
                             searchFilter.minPrice > 0;

    int idx = tabs.indexWhere((t) => loc.startsWith(t.route));
    if (idx < 0) idx = 0;

    final navBgColor = isDark ? Colors.black.withValues(alpha: 0.7) : Colors.white.withValues(alpha: 0.7);
    final activeColor = theme.colorScheme.primary;
    final inactiveColor = isDark ? Colors.white38 : const Color(0xFF757575);

    final isDrawerOpen = ref.watch(drawerStateProvider);

    return Scaffold(
      extendBody: true,
      body: RepaintBoundary(child: widget.child),
      bottomNavigationBar: AnimatedSlide(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOutCubic,
        offset: (isSearching || isDrawerOpen) ? const Offset(0, 2) : Offset.zero,
        child: Container(
          margin: EdgeInsets.fromLTRB(
            20,
            0,
            20,
            MediaQuery.paddingOf(context).bottom > 0 
                ? MediaQuery.paddingOf(context).bottom 
                : 20,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                height: 72,
                decoration: BoxDecoration(
                  color: navBgColor,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.08),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(tabs.length, (i) {
                    final isSelected = idx == i;
                    final color = isSelected ? activeColor : inactiveColor;
                    final tab = tabs[i];
                    
                    return Expanded(
                      child: GestureDetector(
                        onTap: () => context.go(tabs[i].route),
                        behavior: HitTestBehavior.opaque,
                        child: AnimatedScale(
                          scale: isSelected ? 1.1 : 1.0,
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.easeOutBack,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (tab.customIcon != null)
                                Container(
                                  decoration: isSelected ? BoxDecoration(
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: color.withValues(alpha: 0.3),
                                        blurRadius: 8,
                                        spreadRadius: 1,
                                      ),
                                    ],
                                  ) : null,
                                  child: tab.customIcon,
                                )
                              else if (tab.activeIcon.isNotEmpty)
                                Image.asset(
                                  isSelected ? tab.activeIcon : tab.inactiveIcon,
                                  width: 22,
                                  height: 22,
                                  color: isSelected ? activeColor : color,
                                ),
                              const Gap(4),
                              Text(
                                tab.label,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: color,
                                  fontSize: 11,
                                  letterSpacing: -0.2,
                                  fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                                ),
                              ),
                              if (isSelected)
                                Container(
                                  margin: const EdgeInsets.only(top: 2),
                                  width: 4,
                                  height: 4,
                                  decoration: BoxDecoration(
                                    color: color,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

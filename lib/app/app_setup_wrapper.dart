import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/services/connectivity_service.dart';
import '../core/services/app_guard_service.dart';
import '../core/services/overlay_service.dart';
import '../core/services/deep_link_service.dart';
import '../core/services/remote_config_service.dart';
import '../shared/widgets/error/global_error_screen.dart';
import '../shared/widgets/debug/debug_menu.dart';

import '../core/services/security_service.dart';
import '../core/services/feedback_service.dart';

class AppSetupWrapper extends ConsumerWidget {
  final Widget? child;

  const AppSetupWrapper({super.key, this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1. Error Boundary
    ErrorWidget.builder = (details) => GlobalErrorScreen(details: details);

    // Kích hoạt Feedback Service (Shake to report)
    ref.watch(feedbackNotifierProvider);

    final connectivity = ref.watch(connectivityNotifierProvider);
    final appGuard = ref.watch(appGuardProvider);
    final overlayMessage = ref.watch(overlayNotifierProvider);
    final config = ref.watch(phase5ConfigProvider).valueOrNull ?? Phase5Config.defaults;
    final securityThreat = ref.watch(securityNotifierProvider).valueOrNull ?? false;

    return Scaffold(
      key: const ValueKey('AppRoot'),
      body: securityThreat 
        ? const Center(child: Text('Thiết bị không an toàn! Ứng dụng đã bị khóa.', style: TextStyle(color: Colors.red)))
        : DeepLinkListener(
          enabled: config.deepLinksEnabled,
          child: Stack(
            children: [
              child ?? const SizedBox.shrink(),
              
              // 2. Connectivity Banner
              if (connectivity == ConnectivityStatus.isDisconnected)
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: SafeArea(
                    child: Container(
                      color: Colors.redAccent,
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: const Text(
                        'Mất kết nối Internet',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),

              // 3. Maintenance / Update Overlay
              appGuard.when(
                data: (status) {
                  if (status == AppGuardStatus.active) return const SizedBox.shrink();
                  
                  return Container(
                    color: Colors.black87,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              status == AppGuardStatus.maintenance ? Icons.build_rounded : Icons.system_update_rounded,
                              color: Colors.orangeAccent,
                              size: 64,
                            ),
                            const SizedBox(height: 24),
                            Text(
                              status == AppGuardStatus.maintenance ? 'Hệ thống đang bảo trì' : 'Yêu cầu cập nhật',
                              style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              status == AppGuardStatus.maintenance 
                                ? 'Chúng tôi sẽ quay lại sớm. Xin lỗi vì sự bất tiện này.'
                                : 'Vui lòng cập nhật ứng dụng lên phiên bản mới nhất để tiếp tục.',
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: Colors.white70),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                loading: () => const SizedBox.shrink(),
                error: (_, __) => const SizedBox.shrink(),
              ),

              // 4. Notification Overlay
              NotificationOverlay(message: overlayMessage),
            ],
          ),
        ),
    );
  }
}

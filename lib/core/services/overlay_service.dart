import 'dart:async';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'overlay_service.g.dart';

class OverlayMessage {
  final String message;
  final IconData icon;
  final Color backgroundColor;

  OverlayMessage({
    required this.message,
    this.icon = Icons.info_outline,
    this.backgroundColor = const Color(0xFF323232),
  });
}

@riverpod
class OverlayNotifier extends _$OverlayNotifier {
  @override
  OverlayMessage? build() => null;

  Timer? _timer;

  void showToast(String message, {IconData? icon, Color? color}) {
    state = OverlayMessage(
      message: message,
      icon: icon ?? Icons.info_outline,
      backgroundColor: color ?? const Color(0xFF323232),
    );

    _timer?.cancel();
    _timer = Timer(const Duration(seconds: 3), () {
      state = null;
    });
  }
}

class NotificationOverlay extends StatelessWidget {
  final OverlayMessage? message;

  const NotificationOverlay({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    if (message == null) return const SizedBox.shrink();

    return SafeArea(
      child: Align(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Material(
            color: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: message!.backgroundColor,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(message!.icon, color: Colors.white, size: 20),
                  const SizedBox(width: 12),
                  Flexible(
                    child: Text(
                      message!.message,
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

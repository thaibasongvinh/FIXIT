import 'package:flutter/material.dart';
import 'package:shake/shake.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'overlay_service.dart';

part 'feedback_service.g.dart';

@riverpod
class FeedbackNotifier extends _$FeedbackNotifier {
  late ShakeDetector _detector;

  @override
  void build() {
    _detector = ShakeDetector.autoStart(
      onPhoneShake: (_) {
        ref.read(overlayNotifierProvider.notifier).showToast(
          'Đã ghi nhận yêu cầu phản hồi! Vui lòng mô tả lỗi...',
          icon: Icons.feedback_outlined,
        );
        // Ở đây có thể mở một dialog chụp ảnh màn hình và gửi báo cáo
      },
    );

    ref.onDispose(() => _detector.stopListening());
  }
}

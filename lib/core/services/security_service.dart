import 'package:flutter/foundation.dart';
import 'package:flutter_jailbreak_detection/flutter_jailbreak_detection.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'security_service.g.dart';

@riverpod
class SecurityNotifier extends _$SecurityNotifier {
  @override
  Future<bool> build() async {
    if (kIsWeb || kDebugMode) return false; // Skip for web or debug
    
    try {
      final isJailbroken = await FlutterJailbreakDetection.jailbroken;
      final isDeveloperMode = await FlutterJailbreakDetection.developerMode;
      return isJailbroken || isDeveloperMode;
    } catch (_) {
      return false;
    }
  }
}

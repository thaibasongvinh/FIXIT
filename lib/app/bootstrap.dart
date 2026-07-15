import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:appwrite/appwrite.dart' as aw;

import '../core/config/app_environment_provider.dart';
import '../core/config/app_flavor.dart';
import '../shared/services/notification_service.dart';
import '../shared/utils/vietnam_address_provider.dart';
import 'fixit_app.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

Future<void> bootstrap(AppEnvironment environment) async {
  if (environment.flavor.isDev) {
    HttpOverrides.global = MyHttpOverrides();
  }
  WidgetsFlutterBinding.ensureInitialized();

  // Nạp dữ liệu địa giới hành chính Việt Nam
  await VietnamAddressProvider.loadData();

  // Khởi tạo Appwrite
  final client = aw.Client()
      .setEndpoint(environment.appwriteEndpoint)
      .setProject(environment.appwriteProjectId)
      .setSelfSigned(status: environment.flavor.isDev);

  /* 
  // TỰ ĐỘNG ĐĂNG XUẤT KHI KHỞI CHẠY (Để phục vụ testing luồng Onboarding)
  try {
    await aw.Account(client).deleteSessions();
    debugPrint('AppBootstrap: Tự động đăng xuất thành công.');
  } catch (_) {
    debugPrint('AppBootstrap: Không có phiên làm việc cũ để đăng xuất.');
  }
  */

  // 1. Chạy các dịch vụ không thiết yếu sau khi App đã khởi động để giảm thời gian Splash
  _initDelayedServices(environment);

  PlatformDispatcher.instance.onError = (error, stack) {
    debugPrint('Global Error: $error');
    return true;
  };

  runApp(
    ProviderScope(
      overrides: [
        appEnvironmentProvider.overrideWithValue(environment),
      ],
      child: const FixitApp(),
    ),
  );
}

Future<void> _initDelayedServices(AppEnvironment environment) async {
  // Đợi 1 frame để UI bắt đầu vẽ rồi mới làm các việc nặng
  WidgetsBinding.instance.addPostFrameCallback((_) async {
    // Khởi tạo thông báo
    await NotificationService.init(isDev: environment.flavor.isDev);
  });
}

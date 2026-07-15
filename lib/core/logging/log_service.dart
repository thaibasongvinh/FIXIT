import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'log_service.g.dart';

@riverpod
LogService logService(LogServiceRef ref) => LogService();

class LogService {
  final _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 0,
      errorMethodCount: 8,
      lineLength: 120,
      colors: true,
      printEmojis: true,
      printTime: true,
    ),
    level: kDebugMode ? Level.all : Level.warning,
  );

  void d(String message) => _logger.d(message);
  void i(String message) => _logger.i(message);
  void w(String message) => _logger.w(message);
  void e(String message, [dynamic error, StackTrace? stackTrace]) =>
      _logger.e(message, error: error, stackTrace: stackTrace);
}

import 'dart:async';
import 'package:appwrite/appwrite.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../logging/log_service.dart';

part 'resilience_service.g.dart';

@riverpod
ResilienceService resilienceService(ResilienceServiceRef ref) => ResilienceService(ref);

class ResilienceService {
  final ResilienceServiceRef _ref;
  late final LogService _log;

  ResilienceService(this._ref) {
    _log = _ref.watch(logServiceProvider);
  }

  /// Thực hiện một tác vụ với cơ chế thử lại (Exponential Backoff)
  Future<T> retry<T>(
    Future<T> Function() task, {
    int maxAttempts = 3,
    Duration delay = const Duration(seconds: 1),
  }) async {
    int attempt = 0;
    while (true) {
      try {
        attempt++;
        return await task();
      } catch (e) {
        if (attempt >= maxAttempts || !_isRetryable(e)) {
          _log.e('Task failed after $attempt attempts: $e');
          rethrow;
        }
        
        final waitTime = delay * attempt; // Exponential backoff
        _log.w('Attempt $attempt failed. Retrying in ${waitTime.inSeconds}s... Error: $e');
        await Future.delayed(waitTime);
      }
    }
  }

  bool _isRetryable(dynamic e) {
    if (e is AppwriteException) {
      // 500: Server error, 503: Service unavailable, 408: Timeout
      return [500, 502, 503, 504, 408].contains(e.code);
    }
    if (e is TimeoutException || e is Exception) return true;
    return false;
  }
}

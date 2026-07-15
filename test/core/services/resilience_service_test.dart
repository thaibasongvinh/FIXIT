import 'package:fixit/core/logging/log_service.dart';
import 'package:fixit/core/services/resilience_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

class MockLogService extends Mock implements LogService {}

void main() {
  late ResilienceService resilienceService;
  late MockLogService mockLog;

  setUp(() {
    final container = ProviderContainer(
      overrides: [
        logServiceProvider.overrideWithValue(MockLogService()),
      ],
    );
    resilienceService = container.read(resilienceServiceProvider);
    mockLog = container.read(logServiceProvider) as MockLogService;
  });

  test('retry should succeed on first attempt', () async {
    final result = await resilienceService.retry(() async => 'success');
    expect(result, 'success');
  });

  test('retry should succeed after failure', () async {
    int attempts = 0;
    final result = await resilienceService.retry(() async {
      attempts++;
      if (attempts == 1) throw Exception('fail');
      return 'success';
    }, delay: Duration.zero);

    expect(result, 'success');
    expect(attempts, 2);
  });
}

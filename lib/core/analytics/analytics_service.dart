import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../logging/log_service.dart';

part 'analytics_service.g.dart';

abstract class AnalyticsProvider {
  void logEvent(String name, Map<String, dynamic>? parameters);
  void logScreenView(String screenName);
  void setUserId(String? id);
}

@riverpod
class AnalyticsService extends _$AnalyticsService {
  final List<AnalyticsProvider> _providers = [];
  late final LogService _log;

  @override
  void build() {
    _log = ref.watch(logServiceProvider);
    // Here you can register real providers, e.g., FirebaseAnalyticsProvider()
  }

  void registerProvider(AnalyticsProvider provider) {
    _providers.add(provider);
  }

  void logEvent(String name, [Map<String, dynamic>? parameters]) {
    _log.i('Analytics Event: $name params: $parameters');
    for (final p in _providers) {
      p.logEvent(name, parameters);
    }
  }

  void logScreenView(String screenName) {
    _log.i('Analytics Screen: $screenName');
    for (final p in _providers) {
      p.logScreenView(screenName);
    }
  }

  void setUserId(String? id) {
    _log.i('Analytics User ID: $id');
    for (final p in _providers) {
      p.setUserId(id);
    }
  }
}

import 'package:flutter/material.dart';
import '../logging/log_service.dart';
import '../analytics/analytics_service.dart';

class AppNavigatorObserver extends NavigatorObserver {
  final LogService _log;
  final AnalyticsService _analytics;

  AppNavigatorObserver(this._log, this._analytics);

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    _logNavigation('PUSH', route, previousRoute);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    _logNavigation('POP', route, previousRoute);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    _logNavigation('REPLACE', newRoute, oldRoute);
  }

  void _logNavigation(String type, Route<dynamic>? route, Route<dynamic>? previousRoute) {
    final name = route?.settings.name ?? route?.settings.arguments?.toString() ?? 'unknown';
    final prevName = previousRoute?.settings.name ?? 'none';
    
    _log.i('Navigation $type: $prevName -> $name');
    _analytics.logScreenView(name);
  }
}

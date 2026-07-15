import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DeepLinkBuilder {
  static const host = 'fixit.app';

  static Uri guideDetail(String guideId) =>
      Uri.https(host, '/guides/detail/$guideId');

  static Uri guideReader(String guideId) =>
      Uri.https(host, '/guides/reader/$guideId');

  static Uri technicianProfile(String technicianId) =>
      Uri.https(host, '/marketplace/$technicianId');
}

class DeepLinkResolver {
  const DeepLinkResolver._();

  static String? locationFor(Uri uri) {
    final segments = uri.pathSegments;
    if (segments.isEmpty) {
      return null;
    }

    if (segments.first == 'reset-password' ||
        segments.first == 'verify-email') {
      return _locationWithQuery(uri);
    }

    if (_isGuideReader(uri, segments)) {
      final guideId = segments.last;
      if (guideId.isEmpty) {
        return null;
      }
      return '/guides/reader/$guideId';
    }

    if (_isGuide(uri, segments)) {
      final guideId = segments.last;
      if (guideId.isEmpty) {
        return null;
      }
      return '/guides/detail/$guideId';
    }

    if (_isTechnician(uri, segments)) {
      final techId = segments.last;
      if (techId.isEmpty) {
        return null;
      }
      return '/marketplace/$techId';
    }

    return null;
  }

  static String _locationWithQuery(Uri uri) {
    final path = uri.path.isEmpty ? '/' : uri.path;
    return uri.hasQuery ? '$path?${uri.query}' : path;
  }

  static bool _isGuide(Uri uri, List<String> segments) {
    return (uri.scheme == 'fixit' && segments.first == 'guide') ||
        (segments.length >= 3 &&
            segments[0] == 'guides' &&
            segments[1] == 'detail') ||
        (segments.length >= 2 && segments[0] == 'guides');
  }

  static bool _isGuideReader(Uri uri, List<String> segments) {
    return (uri.scheme == 'fixit' && segments.first == 'reader') ||
        (segments.length >= 3 &&
            segments[0] == 'guides' &&
            segments[1] == 'reader');
  }

  static bool _isTechnician(Uri uri, List<String> segments) {
    return (uri.scheme == 'fixit' && segments.first == 'technician') ||
        (segments.length >= 2 &&
            (segments[0] == 'technicians' || segments[0] == 'marketplace'));
  }
}

class DeepLinkListener extends StatefulWidget {
  const DeepLinkListener({
    super.key,
    required this.enabled,
    required this.child,
  });

  final bool enabled;
  final Widget child;

  @override
  State<DeepLinkListener> createState() => _DeepLinkListenerState();
}

class _DeepLinkListenerState extends State<DeepLinkListener> {
  final _appLinks = AppLinks();
  StreamSubscription<Uri>? _sub;
  bool _started = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_started && widget.enabled) {
      _started = true;
      _start();
    }
  }

  @override
  void didUpdateWidget(covariant DeepLinkListener oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!oldWidget.enabled && widget.enabled && !_started) {
      _started = true;
      _start();
    }
  }

  Future<void> _start() async {
    try {
      final initial = await _appLinks.getInitialLink();
      if (initial != null && mounted) {
        _open(initial);
      }
    } catch (_) {}

    _sub = _appLinks.uriLinkStream.listen(_open);
  }

  void _open(Uri uri) {
    final location = DeepLinkResolver.locationFor(uri);
    if (location == null || !mounted) {
      return;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        GoRouter.of(context).go(location);
      }
    });
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}

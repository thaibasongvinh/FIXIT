import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'connectivity_service.g.dart';

enum ConnectivityStatus { isConnected, isDisconnected }

@riverpod
class ConnectivityNotifier extends _$ConnectivityNotifier {
  late StreamSubscription<List<ConnectivityResult>> _subscription;

  @override
  ConnectivityStatus build() {
    _subscription = Connectivity().onConnectivityChanged.listen((results) {
      state = _getStatus(results);
    });

    ref.onDispose(() => _subscription.cancel());

    // Initial check
    _checkInitial();
    
    return ConnectivityStatus.isConnected; // Default to connected
  }

  Future<void> _checkInitial() async {
    final results = await Connectivity().checkConnectivity();
    state = _getStatus(results);
  }

  ConnectivityStatus _getStatus(List<ConnectivityResult> results) {
    if (results.isEmpty || results.contains(ConnectivityResult.none)) {
      return ConnectivityStatus.isDisconnected;
    }
    return ConnectivityStatus.isConnected;
  }
}

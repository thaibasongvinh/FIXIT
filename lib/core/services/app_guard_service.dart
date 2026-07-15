import 'package:package_info_plus/package_info_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'remote_config_service.dart';

part 'app_guard_service.g.dart';

enum AppGuardStatus { active, maintenance, updateRequired }

@riverpod
Future<AppGuardStatus> appGuard(AppGuardRef ref) async {
  final config = await ref.watch(phase5ConfigProvider.future);
  
  if (config.maintenanceMode) {
    return AppGuardStatus.maintenance;
  }

  final packageInfo = await PackageInfo.fromPlatform();
  final currentVersion = packageInfo.version;
  
  if (_isUpdateRequired(currentVersion, config.minAppVersion)) {
    return AppGuardStatus.updateRequired;
  }

  return AppGuardStatus.active;
}

bool _isUpdateRequired(String current, String min) {
  final v1 = current.split('.').map(int.parse).toList();
  final v2 = min.split('.').map(int.parse).toList();

  for (var i = 0; i < 3; i++) {
    if (v1[i] < v2[i]) return true;
    if (v1[i] > v2[i]) return false;
  }
  return false;
}

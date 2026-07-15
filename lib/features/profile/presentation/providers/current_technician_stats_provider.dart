import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../marketplace/domain/models/technician_model.dart';
import '../../../marketplace/presentation/providers/technician_provider.dart';

part 'current_technician_stats_provider.g.dart';

class TechnicianStats {
  final TechnicianModel? technician;
  final int earnings;
  final int activeOrders;
  final int completedOrders;

  TechnicianStats({
    this.technician,
    this.earnings = 0,
    this.activeOrders = 0,
    this.completedOrders = 0,
  });
}

@riverpod
Future<TechnicianStats> currentTechnicianStats(CurrentTechnicianStatsRef ref) async {
  final user = ref.watch(currentUserProvider).valueOrNull;
  if (user == null) return TechnicianStats();

  final technicians = await ref.watch(techniciansNotifierProvider.future);
  final tech = technicians.where((t) => t.uid == user.uid).firstOrNull;

  return TechnicianStats(
    technician: tech,
    earnings: 1250, // Mock data
    activeOrders: 3,
    completedOrders: 48,
  );
}

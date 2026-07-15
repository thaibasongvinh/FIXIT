import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:fixit/features/admin/presentation/providers/admin_provider.dart';

class AdminBroadcastHistoryScreen extends ConsumerWidget {
  const AdminBroadcastHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyAsync = ref.watch(broadcastHistoryProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : const Color(0xFF1A1C1E);

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF010A1A) : const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text('BROADCAST HISTORY', style: TextStyle(color: textColor, fontWeight: FontWeight.w900, fontSize: 13, letterSpacing: 2)),
        leading: IconButton(icon: Icon(Icons.arrow_back_ios_new, color: textColor, size: 18), onPressed: () => Navigator.pop(context)),
      ),
      body: Stack(
        children: [
          if (isDark)
            Container(decoration: const BoxDecoration(gradient: LinearGradient(colors: [Color(0xFF0D47A1), Color(0xFF010A1A), Colors.black], begin: Alignment.topLeft, end: Alignment.bottomRight))),
          SafeArea(
            child: historyAsync.when(
              data: (history) => history.isEmpty 
                ? const Center(child: Text('No history available', style: TextStyle(color: Colors.white24)))
                : ListView.separated(
                    padding: const EdgeInsets.all(20),
                    itemCount: history.length,
                    separatorBuilder: (_, __) => const Gap(12),
                    itemBuilder: (context, index) {
                      final item = history[index];
                      final role = item['targetRole'] ?? 'all';
                      
                      return Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.03),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.05)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: (role == 'technician' ? Colors.orangeAccent : Colors.blueAccent).withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(role.toUpperCase(), style: TextStyle(color: (role == 'technician' ? Colors.orangeAccent : Colors.blueAccent), fontSize: 9, fontWeight: FontWeight.w900)),
                                ),
                                Text(item['createdAt'] != null ? DateFormat('dd/MM HH:mm').format(DateTime.parse(item['createdAt'])) : '--', style: TextStyle(color: textColor.withValues(alpha: 0.3), fontSize: 10)),
                              ],
                            ),
                            const Gap(12),
                            Text(item['title'] ?? 'No Title', style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 16)),
                            const Gap(4),
                            Text(item['message'] ?? 'No message', style: TextStyle(color: textColor.withValues(alpha: 0.6), fontSize: 13, height: 1.4)),
                          ],
                        ),
                      );
                    },
                  ),
              loading: () => const Center(child: CircularProgressIndicator(color: Colors.blueAccent)),
              error: (e, _) => Center(child: Text('Error: $e', style: const TextStyle(color: Colors.redAccent))),
            ),
          ),
        ],
      ),
    );
  }
}

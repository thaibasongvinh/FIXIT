import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:fixit/features/admin/presentation/providers/admin_provider.dart';
import 'package:fixit/shared/utils/export_utils.dart';

class AdminAuditLogsScreen extends ConsumerWidget {
  const AdminAuditLogsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final logsAsync = ref.watch(filteredAuditLogsProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : const Color(0xFF1A1C1E);

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF010A1A) : const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text('SYSTEM AUDIT LOGS', style: TextStyle(color: textColor, fontWeight: FontWeight.w900, fontSize: 13, letterSpacing: 2)),
        leading: IconButton(icon: Icon(Icons.arrow_back_ios_new, color: textColor, size: 18), onPressed: () => Navigator.pop(context)),
        actions: [
          IconButton(
            onPressed: () => _exportLogs(logsAsync.valueOrNull),
            icon: Icon(Icons.download_rounded, color: textColor, size: 20),
            tooltip: 'Export Logs',
          ),
        ],
      ),
      body: Stack(
        children: [
          if (isDark)
            Container(decoration: const BoxDecoration(gradient: LinearGradient(colors: [Color(0xFF0D47A1), Color(0xFF010A1A), Colors.black], begin: Alignment.topLeft, end: Alignment.bottomRight))),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: TextField(
                  onChanged: (val) => ref.read(auditSearchQueryProvider.notifier).state = val,
                  style: TextStyle(color: textColor, fontSize: 14),
                  decoration: InputDecoration(
                    hintText: 'Search by Admin, Action or Target...',
                    hintStyle: TextStyle(color: textColor.withOpacity(0.3)),
                    prefixIcon: Icon(Icons.search_rounded, color: Colors.blueAccent.withOpacity(0.5)),
                    filled: true,
                    fillColor: (isDark ? Colors.white : Colors.black).withOpacity(0.05),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
              Expanded(
                child: SafeArea(
                  child: logsAsync.when(
                    data: (logs) => logs.isEmpty
                    ? const Center(child: Text('No activities recorded', style: TextStyle(color: Colors.white24)))
                    : ListView.separated(
                      padding: const EdgeInsets.all(20),
                      itemCount: logs.length,
                      separatorBuilder: (_, __) => const Gap(12),
                      itemBuilder: (context, index) {
                        final log = logs[index];
                        final hasMetadata = log.metadata != null && log.metadata!.isNotEmpty;

                        return Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: (isDark ? Colors.white : Colors.black).withOpacity(0.03),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: (isDark ? Colors.white : Colors.black).withOpacity(0.05)),
                          ),
                          child: Column(
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(color: Colors.blueAccent.withOpacity(0.1), shape: BoxShape.circle),
                                    child: const Icon(Icons.history_toggle_off_rounded, color: Colors.blueAccent, size: 20),
                                  ),
                                  const Gap(16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(log.adminName, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13, color: Colors.blueAccent)),
                                            Text(DateFormat('HH:mm - dd/MM').format(log.createdAt), style: TextStyle(color: textColor.withOpacity(0.3), fontSize: 10)),
                                          ],
                                        ),
                                        const Gap(4),
                                        Text(log.action, style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 14)),
                                        const Gap(2),
                                        Text('Target: ${log.target}', style: TextStyle(color: textColor.withOpacity(0.5), fontSize: 12)),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              if (hasMetadata) ...[
                                const Gap(12),
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text('CHANGE DETAILS:', style: TextStyle(color: Colors.white24, fontSize: 9, fontWeight: FontWeight.bold, letterSpacing: 1)),
                                      const Gap(4),
                                      Text(
                                        _formatMetadata(log.metadata!),
                                        style: TextStyle(color: textColor.withOpacity(0.7), fontSize: 11, fontFamily: 'monospace'),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ],
                          ),
                        );
                      },
                    ),
                    loading: () => const Center(child: CircularProgressIndicator(color: Colors.blueAccent)),
                    error: (e, _) => Center(child: Text('Error: $e', style: const TextStyle(color: Colors.redAccent))),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatMetadata(Map<String, dynamic> metadata) {
    if (metadata.containsKey('before') || metadata.containsKey('after')) {
      final before = metadata['before'];
      final after = metadata['after'];
      return 'FROM: $before\nTO: $after';
    }
    return metadata.entries.map((e) => '${e.key}: ${e.value}').join('\n');
  }

  Future<void> _exportLogs(List<dynamic>? logs) async {
    if (logs == null || logs.isEmpty) return;
    
    final rows = logs.map((log) => [
      DateFormat('yyyy-MM-dd HH:mm:ss').format(log.createdAt),
      log.adminName,
      log.action,
      log.target,
      log.metadata?.toString() ?? 'N/A'
    ]).toList();

    await ExportUtils.exportToExcel(
      fileName: 'FixIt_System_Audit_Logs',
      headers: ['Timestamp', 'Admin', 'Action', 'Target', 'Details'],
      rows: rows,
      sheetName: 'Audit Logs'
    );
  }
}

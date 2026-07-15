import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:fixit/features/admin/presentation/providers/admin_provider.dart';
import 'package:fixit/shared/utils/snackbar_utils.dart';

import 'package:fixit/features/home/presentation/widgets/components/shimmer_loading.dart';

class AdminFinanceScreen extends ConsumerWidget {
  const AdminFinanceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionsAsync = ref.watch(adminTransactionsProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark ? const Color(0xFF010A1A) : const Color(0xFFF5F7FA);
    final textColor = isDark ? Colors.white : const Color(0xFF1A1C1E);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text('FINANCIAL LEDGER', 
          style: TextStyle(color: textColor, fontWeight: FontWeight.w900, fontSize: 13, letterSpacing: 2)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: textColor, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          if (isDark)
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft, end: Alignment.bottomRight,
                  colors: [Color(0xFF0D47A1), Color(0xFF010A1A), Color(0xFF000000)],
                ),
              ),
            ),
          SafeArea(
            child: transactionsAsync.when(
              data: (txs) => txs.isEmpty 
                ? _buildEmptyState(textColor, ref)
                : RefreshIndicator(
                    onRefresh: () => ref.refresh(adminTransactionsProvider.future),
                    child: ListView.builder(
                      padding: const EdgeInsets.all(20),
                      itemCount: txs.length,
                      itemBuilder: (context, index) => _buildTransactionCard(context, ref, txs[index], isDark, textColor),
                    ),
                  ),
              loading: () => _buildShimmerList(isDark),
              error: (e, _) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline_rounded, color: Colors.redAccent, size: 40),
                    const Gap(16),
                    Text('Connection Error: $e', style: const TextStyle(color: Colors.redAccent, fontSize: 12)),
                  ],
                )
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerList(bool isDark) {
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: 5,
      itemBuilder: (context, index) => Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.03),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          children: [
            const ShimmerBox(width: 44, height: 44, shape: BoxShape.circle),
            const Gap(16),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShimmerBox(width: 150, height: 16),
                  Gap(8),
                  ShimmerBox(width: 100, height: 10),
                ],
              ),
            ),
            const ShimmerBox(width: 80, height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionCard(BuildContext context, WidgetRef ref, Map<String, dynamic> tx, bool isDark, Color textColor) {
    final currencyFormat = NumberFormat.simpleCurrency(locale: 'vi_VN');
    
    // Logic lấy dữ liệu linh hoạt
    final String type = tx['type']?.toString().toLowerCase() ?? 'payment';
    final double amount = (tx['amount'] ?? tx['total'] ?? tx['value'] ?? 0).toDouble();
    final String status = tx['status']?.toString().toLowerCase() ?? 'completed';
    final String dateStr = tx['createdAt'] ?? tx['systemCreatedAt'] ?? DateTime.now().toIso8601String();
    final DateTime date = DateTime.parse(dateStr);

    Color typeColor = Colors.blueAccent;
    if (type == 'withdrawal') typeColor = Colors.orangeAccent;
    if (type == 'payment' || type == 'deposit') typeColor = Colors.greenAccent;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.05)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: typeColor.withValues(alpha: 0.1), shape: BoxShape.circle),
                child: Icon(
                  type == 'withdrawal' ? Icons.account_balance_wallet_rounded : Icons.payments_rounded,
                  color: typeColor, size: 20
                ),
              ),
              const Gap(16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(tx['description'] ?? tx['title'] ?? 'Transaction', 
                      style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 15)),
                    Text(DateFormat('MMM dd, HH:mm').format(date), 
                      style: TextStyle(color: textColor.withValues(alpha: 0.3), fontSize: 11)),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${type == 'withdrawal' ? '-' : '+'}${currencyFormat.format(amount)}',
                    style: TextStyle(
                      color: type == 'withdrawal' ? Colors.redAccent : Colors.greenAccent, 
                      fontWeight: FontWeight.w900, fontSize: 16
                    ),
                  ),
                  Text(status.toUpperCase(), 
                    style: TextStyle(color: _getStatusColor(status), fontSize: 8, fontWeight: FontWeight.w900)),
                ],
              ),
            ],
          ),
          if (type == 'withdrawal' && status == 'pending') ...[
            const Gap(20),
            Divider(color: textColor.withValues(alpha: 0.05)),
            const Gap(12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => _handleUpdate(ref, tx['\$id'], 'cancelled'),
                  child: const Text('DECLINE', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
                ),
                const Gap(12),
                ElevatedButton(
                  onPressed: () => _handleUpdate(ref, tx['\$id'], 'completed'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.greenAccent, 
                    foregroundColor: Colors.black, 
                    minimumSize: const Size(100, 40),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                  child: const Text('APPROVE', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 12)),
                ),
              ],
            ),
          ]
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'completed': return Colors.greenAccent;
      case 'pending': return Colors.orangeAccent;
      case 'cancelled': return Colors.redAccent;
      default: return Colors.grey;
    }
  }

  void _handleUpdate(WidgetRef ref, String id, String status) {
    ref.read(adminTransactionsProvider.notifier).updateStatus(id, status);
  }

  Widget _buildEmptyState(Color textColor, WidgetRef ref) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.account_balance_rounded, size: 80, color: textColor.withValues(alpha: 0.1)),
          const Gap(16),
          Text('No transactions yet', style: TextStyle(color: textColor.withValues(alpha: 0.2))),
          const Gap(32),
          ElevatedButton.icon(
            onPressed: () => ref.read(adminTransactionsProvider.notifier).seedSampleData(),
            icon: const Icon(Icons.auto_awesome),
            label: const Text('GENERATE SAMPLE DATA'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent.withValues(alpha: 0.1),
              foregroundColor: Colors.blueAccent,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ],
      ),
    );
  }
}

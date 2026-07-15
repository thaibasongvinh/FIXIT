import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import 'package:fixit/core/presentation/widgets/app_background.dart';
import '../../../../core/router/app_router.dart';
import 'package:fixit/l10n/app_localizations.dart';
import '../providers/wallet_provider.dart';
import '../widgets/wallet_widgets.dart';

class WalletScreen extends ConsumerStatefulWidget {
  const WalletScreen({super.key});

  @override
  ConsumerState<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends ConsumerState<WalletScreen> {
  final _amountController = TextEditingController();

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final walletAsync = ref.watch(userWalletProvider);
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        leadingWidth: 64,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Center(
            child: Container(
              decoration: BoxDecoration(
                color: isDark ? Colors.white.withOpacity(0.05) : Colors.white,
                shape: BoxShape.circle,
                boxShadow: isDark ? [] : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: IconButton(
                icon: Icon(Icons.arrow_back_ios_new_rounded, color: isDark ? Colors.white : const Color(0xFF1A1D1E), size: 16),
                onPressed: () => context.pop(),
              ),
            ),
          ),
        ),
        title: Text(
          l10n.wallet,
          style: TextStyle(
            color: isDark ? Colors.white : const Color(0xFF1A1D1E),
            fontSize: 20,
            fontWeight: FontWeight.w900,
            letterSpacing: -0.5,
          ),
        ),
      ),
      body: AppBackground(
        child: SafeArea(
          child: _buildContent(context, null, l10n, isDark),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, dynamic wallet, AppLocalizations l10n, bool isDark) {
    final currencyFormat = NumberFormat.currency(locale: 'vi_VN', symbol: '₫');
    
    // MOCK DATA FOR REPORT (CUSTOMER FOCUS)
    final balance = 1500000; // 1.5 triệu đồng
    final totalSpent = 2850000; // 2.85 triệu đã chi tiêu

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Balance Card
          _buildBalanceCard(balance, totalSpent, currencyFormat, l10n),
          const Gap(32),
          
          Text(
            l10n.transactionHistory,
            style: TextStyle(
              fontSize: 18, 
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
          const Gap(16),
          
          // 2. Transaction List (MOCK CUSTOMER TX)
          _buildMockTransactionList(isDark, currencyFormat),
          
          const Gap(32),
          _buildActionButtons(l10n),
        ],
      ),
    );
  }

  Widget _buildMockTransactionList(bool isDark, NumberFormat format) {
    final List<Map<String, dynamic>> mockTx = [
      {'desc': 'Nạp tiền vào ví', 'amount': 1000000, 'date': 'Hôm nay, 10:24', 'neg': false},
      {'desc': 'Thanh toán Sửa máy giặt', 'amount': -450000, 'date': 'Hôm qua, 15:30', 'neg': true},
      {'desc': 'Thanh toán Sửa điện', 'amount': -250000, 'date': '12/07/2026, 09:15', 'neg': true},
      {'desc': 'Hoàn tiền từ hệ thống', 'amount': 150000, 'date': '10/07/2026, 14:00', 'neg': false},
    ];

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: mockTx.length,
      separatorBuilder: (_, __) => const Gap(12),
      itemBuilder: (context, index) {
        final tx = mockTx[index];
        final isNegative = tx['neg'] as bool;
        return ListTile(
          contentPadding: EdgeInsets.zero,
          leading: CircleAvatar(
            backgroundColor: (isNegative ? Colors.red : Colors.green).withOpacity(0.1),
            child: Icon(
              isNegative ? Icons.remove_rounded : Icons.add_rounded,
              color: isNegative ? Colors.red : Colors.green,
            ),
          ),
          title: Text(tx['desc'], style: TextStyle(fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black)),
          subtitle: Text(tx['date'], style: TextStyle(color: isDark ? Colors.white38 : Colors.grey)),
          trailing: Text(
            '${isNegative ? "" : "+"}${format.format(tx['amount'])}',
            style: TextStyle(
              color: isNegative ? Colors.red : Colors.green,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      },
    );
  }

  Widget _buildBalanceCard(int balance, int totalSpent, NumberFormat format, AppLocalizations l10n) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1565C0), Color(0xFF0D47A1)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0D47A1).withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.currentBalance,
            style: const TextStyle(color: Colors.white70, fontSize: 14),
          ),
          const Gap(8),
          Text(
            format.format(balance),
            style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w900),
          ),
          const Gap(24),
          Row(
            children: [
              _buildMiniStat("Tổng chi tiêu", format.format(totalSpent)),
              const Spacer(),
              const Icon(Icons.account_balance_wallet_outlined, color: Colors.white24, size: 48),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMiniStat(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white60, fontSize: 12)),
        const Gap(4),
        Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildTransactionList(String walletId, bool isDark) {
    final transactionsAsync = ref.watch(walletTransactionsProvider(walletId));
    
    return transactionsAsync.when(
      data: (list) => list.isEmpty 
        ? Center(child: Padding(
            padding: const EdgeInsets.all(40),
            child: Text('Chưa có giao dịch nào', style: TextStyle(color: isDark ? Colors.white24 : Colors.grey)),
          ))
        : ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: list.length,
            separatorBuilder: (_, __) => const Gap(12),
            itemBuilder: (context, index) {
              final tx = list[index];
              final isNegative = tx.amount < 0;
              return ListTile(
                contentPadding: EdgeInsets.zero,
                leading: CircleAvatar(
                  backgroundColor: (isNegative ? Colors.red : Colors.green).withOpacity(0.1),
                  child: Icon(
                    isNegative ? Icons.remove_rounded : Icons.add_rounded,
                    color: isNegative ? Colors.red : Colors.green,
                  ),
                ),
                title: Text(tx.description, style: TextStyle(fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black)),
                subtitle: Text(
                  DateFormat('dd/MM/yyyy HH:mm').format(tx.createdAt),
                  style: TextStyle(color: isDark ? Colors.white38 : Colors.grey),
                ),
                trailing: Text(
                  '${isNegative ? "" : "+"}${NumberFormat.currency(locale: 'vi_VN', symbol: '₫').format(tx.amount)}',
                  style: TextStyle(
                    color: isNegative ? Colors.red : Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            },
          ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Text('Error: $e'),
    );
  }

  Widget _buildActionButtons(AppLocalizations l10n) {
    return Row(
      children: [
        Expanded(
          child: _buildActionButton(
            l10n.deposit, 
            Icons.add_circle_outline, 
            () => _showTopUpDialog(l10n),
          ),
        ),
        const Gap(16),
        Expanded(
          child: _buildActionButton(
            l10n.withdraw, 
            Icons.outbound_outlined, 
            () => _showWithdrawDialog(l10n),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(String label, IconData icon, VoidCallback onTap) {
    return ElevatedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 18),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF0056D2),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _showTopUpDialog(AppLocalizations l10n) {
    _amountController.clear();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.deposit),
        content: TextField(
          controller: _amountController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Số tiền nạp',
            suffixText: 'VND',
          ),
        ),
        actions: [
          TextButton(onPressed: () => context.pop(), child: Text(l10n.cancel)),
          ElevatedButton(
            onPressed: () {
              final amount = int.tryParse(_amountController.text) ?? 0;
              if (amount > 0) {
                ref.read(walletNotifierProvider.notifier).topUp(amount, 'Manual');
                context.pop();
              }
            },
            child: const Text('Xác nhận'),
          ),
        ],
      ),
    );
  }

  void _showWithdrawDialog(AppLocalizations l10n) {
    _amountController.clear();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.withdraw),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Tiền sẽ được gửi về tài khoản ngân hàng đã liên kết.', style: TextStyle(fontSize: 12, color: Colors.grey)),
            const Gap(16),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Số tiền rút',
                suffixText: 'VND',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => context.pop(), child: Text(l10n.cancel)),
          ElevatedButton(
            onPressed: () {
              final amount = int.tryParse(_amountController.text) ?? 0;
              if (amount > 0) {
                ref.read(walletNotifierProvider.notifier).requestWithdrawal(amount, {'bankName': 'Liên kết'});
                context.pop();
              }
            },
            child: Text(l10n.withdraw),
          ),
        ],
      ),
    );
  }
}

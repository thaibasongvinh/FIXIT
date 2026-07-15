import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:fixit/shared/utils/permission_utils.dart';
import 'package:fixit/shared/models/user_model.dart';
import 'package:fixit/features/admin/presentation/providers/admin_provider.dart';
import 'package:fixit/features/admin/domain/models/admin_models.dart';
import 'package:fixit/shared/widgets/inputs/app_text_field.dart';
import 'package:fixit/shared/utils/snackbar_utils.dart';

import '../../../../auth/presentation/providers/auth_provider.dart';

class AdminCouponsScreen extends ConsumerWidget {
  const AdminCouponsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Permission check for Finance Manager or Admin
    final hasPermission = ref.watch(currentUserProvider).valueOrNull?.hasPermission([UserRole.finance_manager]) ?? false;
    
    if (!hasPermission) {
      return Scaffold(
        appBar: AppBar(title: const Text('PROMO CODES')),
        body: const Center(child: Text('Không đủ quyền, vui lòng cấp quyền')),
      );
    }

    final couponsAsync = ref.watch(adminCouponsProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : const Color(0xFF1A1C1E);

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF010A1A) : const Color(0xFFF5F7FA),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showCreateDialog(context, ref, isDark),
        backgroundColor: Colors.orangeAccent,
        icon: const Icon(Icons.add_circle_outline_rounded, color: Colors.black),
        label: const Text('CREATE COUPON', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w900)),
      ),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text('PROMO CODES', style: TextStyle(color: textColor, fontWeight: FontWeight.w900, fontSize: 13, letterSpacing: 2)),
        leading: IconButton(icon: Icon(Icons.arrow_back_ios_new, color: textColor, size: 18), onPressed: () => Navigator.pop(context)),
      ),
      body: Stack(
        children: [
          if (isDark)
            Container(decoration: const BoxDecoration(gradient: LinearGradient(colors: [Color(0xFF0D47A1), Color(0xFF010A1A), Colors.black], begin: Alignment.topLeft, end: Alignment.bottomRight))),
          SafeArea(
            child: couponsAsync.when(
              data: (coupons) => coupons.isEmpty 
                ? _buildEmptyState(textColor)
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                    itemCount: coupons.length,
                    itemBuilder: (context, index) => _buildCouponCard(coupons[index], isDark, textColor),
                  ),
              loading: () => const Center(child: CircularProgressIndicator(color: Colors.orangeAccent)),
              error: (e, _) => Center(child: Text('Error: $e', style: const TextStyle(color: Colors.redAccent))),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCouponCard(CouponModel coupon, bool isDark, Color textColor) {
    final currencyFormat = NumberFormat.simpleCurrency(locale: 'vi_VN');
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(color: Colors.orangeAccent.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.orangeAccent.withValues(alpha: 0.2))),
                child: Text(coupon.code.isNotEmpty ? coupon.code : 'NO CODE', style: const TextStyle(color: Colors.orangeAccent, fontWeight: FontWeight.w900, fontSize: 18, letterSpacing: 1)),
              ),
              const Spacer(),
              Text(coupon.type == 'percent' ? '-${coupon.value.toInt()}%' : '-${currencyFormat.format(coupon.value)}', 
                style: TextStyle(color: textColor, fontWeight: FontWeight.w900, fontSize: 20)),
            ],
          ),
          const Gap(16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildSmallInfo('EXPIRES', DateFormat('dd/MM/yy').format(coupon.expiry), textColor),
              _buildSmallInfo('USAGE', '${coupon.usedCount}/${coupon.usageLimit}', textColor),
              _buildSmallInfo('MIN ORDER', currencyFormat.format(coupon.minOrder), textColor),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSmallInfo(String label, String value, Color textColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: textColor.withValues(alpha: 0.3), fontSize: 9, fontWeight: FontWeight.w900)),
        Text(value, style: TextStyle(color: textColor, fontSize: 12, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildEmptyState(Color textColor) => Center(child: Text('No active coupons', style: TextStyle(color: textColor.withValues(alpha: 0.2))));

  void _showCreateDialog(BuildContext context, WidgetRef ref, bool isDark) {
    final codeController = TextEditingController();
    final valueController = TextEditingController();
    final limitController = TextEditingController();
    final minOrderController = TextEditingController();
    String type = 'percent';

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Dialog(
            backgroundColor: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(color: (isDark ? const Color(0xFF0D47A1) : Colors.white).withValues(alpha: 0.9), borderRadius: BorderRadius.circular(35)),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('NEW PROMO CODE', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 20)),
                    const Gap(32),
                    AppTextField(controller: codeController, hint: 'e.g. FIXIT2024', label: 'CODE', icon: Icons.qr_code, darkTheme: isDark),
                    const Gap(20),
                    Row(
                      children: [
                        Expanded(child: AppTextField(controller: valueController, hint: 'Value', label: 'VALUE', icon: Icons.discount, darkTheme: isDark, keyboardType: TextInputType.number)),
                        const Gap(12),
                        ToggleButtons(
                          isSelected: [type == 'percent', type == 'fixed'],
                          onPressed: (idx) => setState(() => type = idx == 0 ? 'percent' : 'fixed'),
                          borderRadius: BorderRadius.circular(12),
                          children: const [Padding(padding: EdgeInsets.symmetric(horizontal: 12), child: Text('%')), Padding(padding: EdgeInsets.symmetric(horizontal: 12), child: Text('\$'))],
                        ),
                      ],
                    ),
                    const Gap(20),
                    AppTextField(controller: limitController, hint: 'e.g. 100', label: 'USAGE LIMIT', icon: Icons.group, darkTheme: isDark, keyboardType: TextInputType.number),
                    const Gap(20),
                    AppTextField(controller: minOrderController, hint: 'Min order to apply', label: 'MIN ORDER', icon: Icons.payments, darkTheme: isDark, keyboardType: TextInputType.number),
                    const Gap(32),
                    SizedBox(
                      width: double.infinity, height: 60,
                      child: ElevatedButton(
                        onPressed: () {
                          final data = {
                            'code': codeController.text.toUpperCase().trim(),
                            'type': type,
                            'value': double.tryParse(valueController.text) ?? 0,
                            'usageLimit': int.tryParse(limitController.text) ?? 1,
                            'minOrder': double.tryParse(minOrderController.text) ?? 0,
                            'expiry': DateTime.now().add(const Duration(days: 30)).toIso8601String(),
                            'isActive': true, 'usedCount': 0
                          };
                          ref.read(adminCouponsProvider.notifier).addCoupon(data);
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.orangeAccent, foregroundColor: Colors.black, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
                        child: const Text('ACTIVATE CODE', style: TextStyle(fontWeight: FontWeight.w900)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

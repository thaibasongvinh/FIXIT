import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:fixit/features/admin/presentation/providers/admin_provider.dart';
import 'package:fixit/shared/widgets/inputs/app_text_field.dart';
import 'package:fixit/shared/utils/snackbar_utils.dart';

class AdminConfigScreen extends ConsumerStatefulWidget {
  const AdminConfigScreen({super.key});

  @override
  ConsumerState<AdminConfigScreen> createState() => _AdminConfigScreenState();
}

class _AdminConfigScreenState extends ConsumerState<AdminConfigScreen> {
  final _hotlineController = TextEditingController();
  final _emailController = TextEditingController();
  final _commissionController = TextEditingController();
  final _minAppVersionController = TextEditingController();
  final _maintenanceMsgController = TextEditingController();
  final _minWithdrawController = TextEditingController();
  bool _maintenanceMode = false;
  bool _isInitialized = false;

  @override
  void dispose() {
    _hotlineController.dispose();
    _emailController.dispose();
    _commissionController.dispose();
    _minAppVersionController.dispose();
    _maintenanceMsgController.dispose();
    _minWithdrawController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final configAsync = ref.watch(adminConfigProvider);

    // Lắng nghe dữ liệu mới để điền vào form khi lần đầu load hoặc khi cập nhật thành công
    ref.listen(adminConfigProvider, (previous, next) {
      next.whenData((config) {
        if (config != null && (!_isInitialized || previous?.value == null)) {
          _hotlineController.text = config['supportPhone'] ?? '';
          _emailController.text = config['supportEmail'] ?? '';
          _commissionController.text = (config['commissionRate'] ?? 0).toString();
          _maintenanceMode = config['isMaintenance'] ?? false;
          _minAppVersionController.text = config['minVersion'] ?? '1.0.0';
          _maintenanceMsgController.text = config['maintenanceMessage'] ?? '';
          _minWithdrawController.text = (config['minWithdrawal'] ?? 50000).toString();
          setState(() {
            _isInitialized = true;
          });
        }
      });
    });

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark ? const Color(0xFF010A1A) : const Color(0xFFF5F7FA);
    final textColor = isDark ? Colors.white : const Color(0xFF1A1C1E);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text('SYSTEM CONFIGURATION', 
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
            child: configAsync.when(
              data: (config) {
                return SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionTitle('OPERATIONAL STATUS', textColor),
                      const Gap(16),
                      _buildCard(isDark, [
                        SwitchListTile(
                          title: Text('Maintenance Mode', style: TextStyle(color: textColor, fontWeight: FontWeight.bold)),
                          subtitle: Text('Prevent users from accessing the app', style: TextStyle(color: textColor.withValues(alpha: 0.4), fontSize: 12)),
                          value: _maintenanceMode,
                          activeColor: Colors.redAccent,
                          onChanged: (val) => setState(() => _maintenanceMode = val),
                        ),
                        if (_maintenanceMode) ...[
                          const Gap(12),
                          AppTextField(
                            controller: _maintenanceMsgController,
                            label: 'MAINTENANCE MESSAGE',
                            hint: 'e.g. Back online at 5 AM',
                            icon: Icons.message_rounded,
                            darkTheme: isDark,
                          ),
                        ]
                      ]),
                      const Gap(32),
                      _buildSectionTitle('APP VERSION CONTROL', textColor),
                      const Gap(16),
                      _buildCard(isDark, [
                        AppTextField(
                          controller: _minAppVersionController,
                          label: 'MINIMUM REQUIRED VERSION',
                          hint: 'e.g. 1.0.5',
                          icon: Icons.system_update_rounded,
                          darkTheme: isDark,
                        ),
                        const Gap(8),
                        Text('Users below this version will be forced to update.', style: TextStyle(color: textColor.withValues(alpha: 0.3), fontSize: 10, fontStyle: FontStyle.italic)),
                      ]),
                      const Gap(32),
                      _buildSectionTitle('FINANCIAL & WITHDRAWAL', textColor),
                      const Gap(16),
                      _buildCard(isDark, [
                        AppTextField(
                          controller: _commissionController, 
                          label: 'SYSTEM COMMISSION (%)', 
                          hint: 'e.g. 10', 
                          icon: Icons.percent_rounded, 
                          darkTheme: isDark,
                          keyboardType: TextInputType.number,
                        ),
                        const Gap(20),
                        AppTextField(
                          controller: _minWithdrawController, 
                          label: 'MIN WITHDRAWAL LIMIT', 
                          hint: 'e.g. 200000', 
                          icon: Icons.account_balance_wallet_rounded, 
                          darkTheme: isDark,
                          keyboardType: TextInputType.number,
                        ),
                      ]),
                      const Gap(32),
                      _buildSectionTitle('SUPPORT CONTACTS', textColor),
                      const Gap(16),
                      _buildCard(isDark, [
                        AppTextField(controller: _hotlineController, label: 'HOTLINE', hint: 'e.g. 1900 xxxx', icon: Icons.phone_android, darkTheme: isDark),
                        const Gap(20),
                        AppTextField(controller: _emailController, label: 'SUPPORT EMAIL', hint: 'e.g. help@fixit.vn', icon: Icons.email_outlined, darkTheme: isDark),
                      ]),
                      const Gap(48),
                      SizedBox(
                        width: double.infinity,
                        height: 60,
                        child: ElevatedButton(
                          onPressed: () => _handleSave(config?['\$id']),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          ),
                          child: const Text('APPLY GLOBAL CHANGES', style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1)),
                        ),
                      ),
                      const Gap(40),
                    ],
                  ),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator(color: Colors.blueAccent)),
              error: (e, _) => Center(child: Text('Error: $e', style: const TextStyle(color: Colors.redAccent))),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, Color textColor) {
    return Text(title, style: TextStyle(color: textColor.withValues(alpha: 0.4), fontSize: 11, fontWeight: FontWeight.w900, letterSpacing: 2));
  }

  Widget _buildCard(bool isDark, List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.05)),
      ),
      child: Column(children: children),
    );
  }

  void _handleSave(String? id) async {
    if (id == null) return;
    final data = {
      'supportPhone': _hotlineController.text.trim(),
      'supportEmail': _emailController.text.trim(),
      'commissionRate': double.tryParse(_commissionController.text) ?? 0,
      'isMaintenance': _maintenanceMode,
      'minVersion': _minAppVersionController.text.trim(),
      'maintenanceMessage': _maintenanceMsgController.text.trim(),
      'minWithdrawal': double.tryParse(_minWithdrawController.text) ?? 50000,
    };
    await ref.read(adminConfigProvider.notifier).updateConfig(id, data);
    if (mounted) AppSnackbar.showSuccess(context, 'Configuration updated globally');
  }
}

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:fixit/features/admin/presentation/providers/admin_provider.dart';
import 'package:fixit/shared/widgets/inputs/app_text_field.dart';
import 'package:fixit/shared/utils/snackbar_utils.dart';

class AdminBroadcastScreen extends ConsumerStatefulWidget {
  const AdminBroadcastScreen({super.key});

  @override
  ConsumerState<AdminBroadcastScreen> createState() => _AdminBroadcastScreenState();
}

class _AdminBroadcastScreenState extends ConsumerState<AdminBroadcastScreen> {
  final _titleController = TextEditingController();
  final _messageController = TextEditingController();
  final _routeController = TextEditingController();
  String _targetRole = 'all'; // all, technician, customer
  String _notifType = 'info'; // info, warning, promo

  @override
  void dispose() {
    _titleController.dispose();
    _messageController.dispose();
    _routeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark ? const Color(0xFF010A1A) : const Color(0xFFF5F7FA);
    final textColor = isDark ? Colors.white : const Color(0xFF1A1C1E);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text('BROADCAST CENTER', 
          style: TextStyle(color: textColor, fontWeight: FontWeight.w900, fontSize: 13, letterSpacing: 2)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: textColor, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            onPressed: _resetForm,
            icon: Icon(Icons.refresh_rounded, color: textColor.withValues(alpha: 0.5)),
          ),
          const Gap(8),
        ],
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
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle('1. TARGET AUDIENCE', textColor),
                  const Gap(16),
                  _buildRoleSelector(isDark),
                  
                  const Gap(32),
                  _buildSectionTitle('2. NOTIFICATION TYPE', textColor),
                  const Gap(16),
                  _buildTypeSelector(isDark),

                  const Gap(32),
                  _buildSectionTitle('3. MESSAGE CONTENT', textColor),
                  const Gap(16),
                  _buildMessageForm(isDark),

                  const Gap(48),
                  SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: ElevatedButton.icon(
                      onPressed: _handleSend,
                      icon: const Icon(Icons.send_rounded),
                      label: const Text('EMIT BROADCAST NOW', style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        elevation: 8,
                        shadowColor: Colors.blueAccent.withValues(alpha: 0.5),
                      ),
                    ),
                  ),
                  const Gap(24),
                  _buildWarningBox(isDark),
                  const Gap(40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _resetForm() {
    _titleController.clear();
    _messageController.clear();
    _routeController.clear();
    setState(() {
      _targetRole = 'all';
      _notifType = 'info';
    });
    AppSnackbar.showSuccess(context, 'Form cleared');
  }

  Widget _buildSectionTitle(String title, Color textColor) {
    return Text(title, style: TextStyle(color: textColor.withValues(alpha: 0.4), fontSize: 11, fontWeight: FontWeight.w900, letterSpacing: 2));
  }

  Widget _buildRoleSelector(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.05)),
      ),
      child: Row(
        children: [
          _buildSelectBtn('all', 'Everybody', Icons.groups_rounded, isDark, isRole: true),
          _buildSelectBtn('technician', 'Techs', Icons.handyman_rounded, isDark, isRole: true),
          _buildSelectBtn('customer', 'Customers', Icons.person_rounded, isDark, isRole: true),
        ],
      ),
    );
  }

  Widget _buildTypeSelector(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.05)),
      ),
      child: Row(
        children: [
          _buildSelectBtn('info', 'General', Icons.info_outline_rounded, isDark, isRole: false, color: Colors.blueAccent),
          _buildSelectBtn('warning', 'Important', Icons.warning_amber_rounded, isDark, isRole: false, color: Colors.orangeAccent),
          _buildSelectBtn('promo', 'Promotion', Icons.stars_rounded, isDark, isRole: false, color: Colors.purpleAccent),
        ],
      ),
    );
  }

  Widget _buildSelectBtn(String value, String label, IconData icon, bool isDark, {required bool isRole, Color? color}) {
    final bool isSelected = isRole ? _targetRole == value : _notifType == value;
    final activeColor = color ?? Colors.blueAccent;

    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() {
          if (isRole) _targetRole = value;
          else _notifType = value;
        }),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? activeColor : Colors.transparent,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            children: [
              Icon(icon, color: isSelected ? Colors.white : (isDark ? Colors.white24 : Colors.black26), size: 20),
              const Gap(4),
              Text(label, style: TextStyle(color: isSelected ? Colors.white : (isDark ? Colors.white24 : Colors.black26), fontSize: 10, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMessageForm(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.05)),
      ),
      child: Column(
        children: [
          AppTextField(controller: _titleController, label: 'NOTIFICATION TITLE', hint: 'Short & catchy (max 50 chars)', icon: Icons.title_rounded, darkTheme: isDark),
          const Gap(24),
          TextFormField(
            controller: _messageController,
            maxLines: 4,
            style: TextStyle(color: isDark ? Colors.white : Colors.black, fontSize: 15),
            decoration: InputDecoration(
              labelText: 'MESSAGE BODY',
              labelStyle: TextStyle(color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.6), fontSize: 12, fontWeight: FontWeight.bold),
              hintText: 'What is the announcement about?',
              hintStyle: TextStyle(color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.2), fontSize: 14),
              filled: true,
              fillColor: Colors.transparent,
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.05))),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: Colors.blueAccent.withValues(alpha: 0.5))),
            ),
          ),
          const Gap(24),
          AppTextField(
            controller: _routeController, 
            label: 'ACTION LINK / ROUTE (OPTIONAL)', 
            hint: 'e.g. /home, /wallet, /booking/my', 
            icon: Icons.ads_click_rounded, 
            darkTheme: isDark,
          ),
        ],
      ),
    );
  }

  Widget _buildWarningBox(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orangeAccent.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.orangeAccent.withValues(alpha: 0.1)),
      ),
      child: Row(
        children: [
          const Icon(Icons.warning_amber_rounded, color: Colors.orangeAccent, size: 20),
          const Gap(16),
          Expanded(child: Text('Note: This will be delivered as an in-app notification. Ensure the route link is correct to avoid app crashes.', style: TextStyle(color: Colors.orangeAccent.withValues(alpha: 0.8), fontSize: 11))),
        ],
      ),
    );
  }

  void _handleSend() async {
    if (_titleController.text.isEmpty || _messageController.text.isEmpty) {
      AppSnackbar.showError(context, 'Please fill in Title and Body');
      return;
    }
    
    try {
      await ref.read(adminBroadcastProvider.notifier).sendBroadcast(
        title: _titleController.text.trim(),
        message: _messageController.text.trim(),
        targetRole: _targetRole,
        // (Note: Currently the repository only supports title, message, targetRole. 
        // I will update it if more fields are needed in the future)
      );
      
      if (mounted) {
        AppSnackbar.showSuccess(context, 'Broadcast emitted successfully!');
        _resetForm();
      }
    } catch (e) {
      if (mounted) AppSnackbar.showError(context, 'Failed to send: $e');
    }
  }
}

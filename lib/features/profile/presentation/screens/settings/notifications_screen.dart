import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class NotificationSettingsScreen extends ConsumerStatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  ConsumerState<NotificationSettingsScreen> createState() => _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState extends ConsumerState<NotificationSettingsScreen> with SingleTickerProviderStateMixin {
  bool _generalNotification = true;
  bool _sound = false;
  bool _vibrate = true;
  bool _newService = false;
  bool _payment = true;
  late AnimationController _animController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF1A1D1E), size: 20),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Notifications',
          style: TextStyle(
            color: Color(0xFF1A1D1E),
            fontSize: 20,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.5,
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFFFFFFF), Color(0xFFF8FAFF)],
          ),
        ),
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionTitle('PREFERENCES'),
                const Gap(16),
                _buildModernSwitch('General Notification', _generalNotification, (v) => setState(() => _generalNotification = v), icon: Icons.notifications_none_rounded),
                _buildModernSwitch('Sound Effects', _sound, (v) => setState(() => _sound = v), icon: Icons.volume_up_rounded),
                _buildModernSwitch('Haptic Feedback', _vibrate, (v) => setState(() => _vibrate = v), icon: Icons.vibration_rounded),
                const Gap(32),
                _buildSectionTitle('UPDATES'),
                const Gap(16),
                _buildModernSwitch('New Services', _newService, (v) => setState(() => _newService = v), icon: Icons.auto_awesome_rounded),
                _buildModernSwitch('Payments & Invoices', _payment, (v) => setState(() => _payment = v), icon: Icons.account_balance_wallet_rounded),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: const LinearGradient(
                        colors: [Color(0xFF0054A5), Color(0xFF007BFF)],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF0054A5).withOpacity(0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: () => context.pop(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      child: const Text('Save Preferences', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Colors.white)),
                    ),
                  ),
                ),
                const Gap(40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        color: const Color(0xFF0054A5).withOpacity(0.8),
        fontSize: 12,
        fontWeight: FontWeight.w800,
        letterSpacing: 1.2,
      ),
    );
  }

  Widget _buildModernSwitch(String title, bool value, ValueChanged<bool> onChanged, {required IconData icon}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE0E9FF), width: 1),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF0054A5).withOpacity(0.04),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFF0F5FF),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: const Color(0xFF0054A5), size: 20),
            ),
            const Gap(16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: Color(0xFF1A1D1E),
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Switch.adaptive(
              value: value,
              onChanged: onChanged,
              activeColor: const Color(0xFF0054A5),
              activeTrackColor: const Color(0xFF0054A5).withOpacity(0.3),
            ),
          ],
        ),
      ),
    );
  }
}

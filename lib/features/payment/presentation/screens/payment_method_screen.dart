import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class PaymentMethodScreen extends ConsumerStatefulWidget {
  const PaymentMethodScreen({super.key, required this.bookingId});

  final String bookingId;

  @override
  ConsumerState<PaymentMethodScreen> createState() =>
      _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends ConsumerState<PaymentMethodScreen> with SingleTickerProviderStateMixin {
  String _selectedMethod = 'Easypaisa';
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
          'Payment Method',
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
                _buildSectionTitle('SELECT METHOD'),
                const Gap(16),
                _buildMethodTile(
                  id: 'Easypaisa',
                  title: 'Easypaisa Wallet',
                  assetPath: 'assets/images/Easypaisa.png',
                  icon: Icons.account_balance_wallet_rounded,
                ),
                _buildMethodTile(
                  id: 'Bank account',
                  title: 'Secure Bank Transfer',
                  assetPath: 'assets/images/Bank account.png',
                  icon: Icons.account_balance_rounded,
                ),
                _buildMethodTile(
                  id: 'Jazz cash',
                  title: 'JazzCash Mobile',
                  assetPath: 'assets/images/Jazz cash.png',
                  icon: Icons.payments_rounded,
                ),
                _buildMethodTile(
                  id: 'PayPal',
                  title: 'Global PayPal',
                  assetPath: 'assets/images/PayPal.png',
                  icon: Icons.language_rounded,
                ),
                const Gap(24),
                _buildSectionTitle('CREDIT/DEBIT CARDS'),
                const Gap(16),
                InkWell(
                  onTap: () => context.push('/payment-methods/new-card'),
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFF0054A5), width: 1.5, style: BorderStyle.solid),
                      color: const Color(0xFFF0F5FF).withOpacity(0.5),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add_circle_outline_rounded, color: Color(0xFF0054A5), size: 22),
                        Gap(10),
                        Text(
                          'Add New Card',
                          style: TextStyle(
                            color: Color(0xFF0054A5),
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
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
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Method $_selectedMethod selected')),
                        );
                        context.pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      child: const Text('Confirm Payment', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Colors.white)),
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

  Widget _buildMethodTile({
    required String id,
    required String title,
    String? assetPath,
    required IconData icon,
  }) {
    final isSelected = _selectedMethod == id;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => setState(() => _selectedMethod = id),
        borderRadius: BorderRadius.circular(16),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.white.withOpacity(0.7),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected ? const Color(0xFF0054A5) : const Color(0xFFE0E9FF),
              width: isSelected ? 2 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: isSelected 
                  ? const Color(0xFF0054A5).withOpacity(0.1) 
                  : const Color(0xFF0054A5).withOpacity(0.04),
                blurRadius: isSelected ? 20 : 15,
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
                child: assetPath != null && assetPath.isNotEmpty
                  ? Image.asset(assetPath, width: 28, height: 28, errorBuilder: (_, __, ___) => Icon(icon, color: const Color(0xFF0054A5), size: 24))
                  : Icon(icon, color: const Color(0xFF0054A5), size: 24),
              ),
              const Gap(16),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: const Color(0xFF1A1D1E),
                    fontSize: 16,
                    fontWeight: isSelected ? FontWeight.w800 : FontWeight.w700,
                  ),
                ),
              ),
              if (isSelected)
                const Icon(Icons.check_circle_rounded, color: Color(0xFF0054A5), size: 24)
              else
                Icon(Icons.circle_outlined, color: const Color(0xFF1A1D1E).withOpacity(0.2), size: 24),
            ],
          ),
        ),
      ),
    );
  }
}

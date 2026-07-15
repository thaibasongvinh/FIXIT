import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class UpgradeScreen extends ConsumerWidget {
  const UpgradeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8F9FB),
        elevation: 0,
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF2450A4)),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Upgrade',
          style: TextStyle(
            color: Color(0xFF2450A4),
            fontSize: 20,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        child: Column(
          children: [
            const Gap(20),
            Center(
              child: Image.asset(
                'assets/images/Upgrade to get full access to.png',
                height: 200,
                width: 200,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => const Icon(Icons.verified_rounded, size: 120, color: Colors.amber),
              ),
            ),
            const Gap(40),
            const Text(
              'Upgrade to get full access to',
              style: TextStyle(
                color: Color(0xFF5C5C5C),
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
            const Gap(32),
            _buildBenefitItem('Access to three Services'),
            _buildBenefitItem('Featured Listings'),
            _buildBenefitItem('Gallery Showcase'),
            _buildBenefitItem('Extended Service Area'),
            _buildBenefitItem('Premium Badge'),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Upgrade plan coming soon')),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0056D2),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Upgrade',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
            const Gap(30),
          ],
        ),
      ),
    );
  }

  Widget _buildBenefitItem(String text) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: Row(
            children: [
              const Icon(Icons.check_rounded, color: Color(0xFF0056D2), size: 24),
              const Gap(16),
              Expanded(
                child: Text(
                  text,
                  style: const TextStyle(
                    color: Color(0xFF5C5C5C),
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
        const Divider(height: 1, color: Color(0xFFE0E0E0), thickness: 1),
      ],
    );
  }
}

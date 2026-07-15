import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class AddPaymentCardScreen extends ConsumerStatefulWidget {
  const AddPaymentCardScreen({super.key});

  @override
  ConsumerState<AddPaymentCardScreen> createState() =>
      _AddPaymentCardScreenState();
}

class _AddPaymentCardScreenState extends ConsumerState<AddPaymentCardScreen> {
  final _cardNumberController = TextEditingController();
  final _holderNameController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvvController = TextEditingController();
  final String _selectedCardType = 'Credit card';

  @override
  void dispose() {
    _cardNumberController.dispose();
    _holderNameController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
          'Add new card',
          style: TextStyle(
            color: Color(0xFF2450A4),
            fontSize: 20,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select your payment method',
              style: TextStyle(
                color: Color(0xFF5C5C5C),
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            const Gap(24),
            _buildFieldLabel('Card'),
            const Gap(8),
            _buildTextField(
              controller: TextEditingController(text: _selectedCardType),
              suffix: const Icon(Icons.keyboard_arrow_down_rounded, color: Color(0xFF5C5C5C), size: 28),
            ),
            const Gap(16),
            _buildFieldLabel('Card number'),
            const Gap(8),
            _buildTextField(
              controller: _cardNumberController,
              hint: 'Enter 14 digit number',
            ),
            const Gap(16),
            _buildFieldLabel('Card holder name'),
            const Gap(8),
            _buildTextField(
              controller: _holderNameController,
              hint: 'Enter name',
            ),
            const Gap(16),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildFieldLabel('Card expiry date'),
                      const Gap(8),
                      _buildTextField(
                        controller: _expiryController,
                        hint: 'DD/MM/YYYY',
                      ),
                    ],
                  ),
                ),
                const Gap(16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildFieldLabel('CVV'),
                      const Gap(8),
                      _buildTextField(
                        controller: _cvvController,
                        hint: '0000',
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Gap(120), // Increased gap to push button down as per image
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Card added successfully')),
                  );
                  context.pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0056D2),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Save',
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

  Widget _buildFieldLabel(String label) {
    return Text(
      label,
      style: const TextStyle(
        color: Color(0xFF6E6E6E),
        fontSize: 15,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _buildTextField({required TextEditingController controller, String? hint, Widget? suffix}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Color(0xFFB0B0B0), fontSize: 15),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          border: InputBorder.none,
          suffixIcon: suffix,
          suffixIconConstraints: const BoxConstraints(minHeight: 0, minWidth: 40),
        ),
        style: const TextStyle(
          color: Color(0xFF4D4D4D),
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

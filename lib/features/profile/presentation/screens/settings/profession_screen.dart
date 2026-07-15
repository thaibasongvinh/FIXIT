import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class ProfessionScreen extends ConsumerStatefulWidget {
  const ProfessionScreen({super.key});

  @override
  ConsumerState<ProfessionScreen> createState() => _ProfessionScreenState();
}

class _ProfessionScreenState extends ConsumerState<ProfessionScreen> {
  final _serviceNameController = TextEditingController(text: 'Cleaner');
  final _expertInController = TextEditingController(text: 'Home clean, lawn clean, Washing');
  final _fromTimeController = TextEditingController(text: '9:00AM');
  final _toTimeController = TextEditingController(text: '10:00PM');
  final _experienceController = TextEditingController(text: '4');
  final _serviceAreaController = TextEditingController(text: 'Tijuana, Baja California');

  @override
  void dispose() {
    _serviceNameController.dispose();
    _expertInController.dispose();
    _fromTimeController.dispose();
    _toTimeController.dispose();
    _experienceController.dispose();
    _serviceAreaController.dispose();
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
          'Profession',
          style: TextStyle(
            color: Color(0xFF2450A4),
            fontSize: 20,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildFieldLabel('Service name'),
            const Gap(8),
            _buildTextField(_serviceNameController),
            const Gap(16),
            _buildFieldLabel('Expert in'),
            const Gap(8),
            _buildTextField(_expertInController),
            const Gap(16),
            const Text(
              'Service Timing',
              style: TextStyle(
                color: Color(0xFF5C5C5C),
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            const Gap(16),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildFieldLabel('From'),
                      const Gap(8),
                      _buildTextField(_fromTimeController),
                    ],
                  ),
                ),
                const Gap(16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildFieldLabel('TO'),
                      const Gap(8),
                      _buildTextField(_toTimeController),
                    ],
                  ),
                ),
              ],
            ),
            const Gap(16),
            _buildFieldLabel('Experience in years'),
            const Gap(8),
            _buildTextField(
              _experienceController,
              suffix: const Padding(
                padding: EdgeInsets.only(right: 16),
                child: Text(
                  'years',
                  style: TextStyle(
                    color: Color(0xFF5C5C5C),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const Gap(16),
            _buildFieldLabel('Service Area'),
            const Gap(8),
            _buildTextField(_serviceAreaController),
            const Gap(16),
            _buildFieldLabel('Upload your services license'),
            const Gap(8),
            _buildFileUploadField('License.pdf'),
            const Gap(16),
            _buildFieldLabel('Upload your Certification'),
            const Gap(8),
            _buildFileUploadField('Certificate.pdf'),
            const Gap(40),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Profession updated successfully')),
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
        color: Color(0xFF5C5C5C),
        fontSize: 15,
        fontWeight: FontWeight.w700,
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, {Widget? suffix}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF2450A4).withValues(alpha: 0.3)),
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          border: InputBorder.none,
          suffixIcon: suffix,
          suffixIconConstraints: const BoxConstraints(minHeight: 0, minWidth: 0),
        ),
        style: const TextStyle(
          color: Color(0xFF4D4D4D),
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildFileUploadField(String fileName) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF2450A4).withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              fileName,
              style: const TextStyle(
                color: Color(0xFFB0B0B0),
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: const Text(
              'Change',
              style: TextStyle(
                color: Color(0xFF2450A4),
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

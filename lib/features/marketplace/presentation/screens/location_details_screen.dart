import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class LocationDetailsScreen extends StatefulWidget {
  final String title;
  const LocationDetailsScreen({super.key, required this.title});

  @override
  State<LocationDetailsScreen> createState() => _LocationDetailsScreenState();
}

class _LocationDetailsScreenState extends State<LocationDetailsScreen> {
  late final TextEditingController _houseController;
  late final TextEditingController _streetController;
  late final TextEditingController _addressController;

  @override
  void initState() {
    super.initState();
    _houseController = TextEditingController();
    _streetController = TextEditingController();
    _addressController = TextEditingController();
  }

  @override
  void dispose() {
    _houseController.dispose();
    _streetController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF2450A4), size: 22),
          onPressed: () => context.pop(),
        ),
        title: Text(
          widget.title,
          style: const TextStyle(
            color: Color(0xFF2450A4),
            fontSize: 17,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Enter your location address',
                      style: TextStyle(
                        color: Color(0xFF4D4D4D),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Gap(24),
                    _buildInputLabel('House number'),
                    const Gap(8),
                    _buildTextField(_houseController, 'Enter house number'),
                    const Gap(20),
                    _buildInputLabel('Street number'),
                    const Gap(8),
                    _buildTextField(_streetController, 'Enter street number'),
                    const Gap(20),
                    _buildInputLabel('Complete Address'),
                    const Gap(8),
                    _buildTextField(_addressController, 'Enter street number'),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () => context.push(
                  Uri(
                    path: '/marketplace/schedule-selection',
                    queryParameters: {'title': widget.title},
                  ).toString(),
                ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0056D2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Next',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputLabel(String label) {
    return Text(
      label,
      style: const TextStyle(
        color: Color(0xFF5C5C5C),
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFEEEEEE)),
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Color(0xFFBDBDBD), fontSize: 14),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
        style: const TextStyle(fontSize: 14, color: Color(0xFF4D4D4D)),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:fixit/features/auth/presentation/providers/auth_provider.dart';
import 'package:fixit/features/marketplace/domain/models/technician_model.dart';
import '../../../domain/models/booking_model.dart';
import '../../providers/booking_provider.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:fixit/features/auth/presentation/providers/auth_provider.dart';
import 'package:fixit/features/marketplace/domain/models/technician_model.dart';
import 'package:fixit/core/presentation/widgets/app_background.dart';
import '../../../domain/models/booking_model.dart';
import '../../providers/booking_provider.dart';

class CreateBookingScreen extends ConsumerStatefulWidget {
  final TechnicianModel tech;
  const CreateBookingScreen({super.key, required this.tech});

  @override
  ConsumerState<CreateBookingScreen> createState() => _CreateBookingScreenState();
}

class _CreateBookingScreenState extends ConsumerState<CreateBookingScreen> {
  final _addressController = TextEditingController();
  final _deviceController = TextEditingController();
  final _noteController = TextEditingController();

  @override
  void dispose() {
    _addressController.dispose();
    _deviceController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final user = ref.read(currentUserProvider).valueOrNull;
    if (user == null) return;

    final booking = BookingModel(
      id: '',
      customerId: user.uid,
      customerName: user.name,
      customerPhone: user.phone,
      technicianId: widget.tech.uid,
      technicianName: widget.tech.name,
      technicianPhone: widget.tech.phone,
      serviceType: widget.tech.skills.isNotEmpty ? widget.tech.skills.first : 'General Repair',
      address: _addressController.text,
      deviceInfo: _deviceController.text,
      estimatedPrice: widget.tech.pricePerHour,
      status: BookingStatus.pending,
      createdAt: DateTime.now(),
    );

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      await ref.read(createBookingNotifierProvider.notifier).create(booking);
      if (mounted) {
        Navigator.pop(context);
        context.push('/booking/success');
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return AppBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_new, color: isDark ? Colors.white : Colors.black),
            onPressed: () => context.pop(),
          ),
          title: Text(
            'Đặt lịch sửa chữa',
            style: TextStyle(
              color: isDark ? Colors.white : Colors.black,
              fontWeight: FontWeight.w900,
              fontSize: 20,
            ),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Technician Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: isDark ? Colors.white.withValues(alpha: 0.1) : Colors.grey.shade200),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: NetworkImage(widget.tech.avatar.isNotEmpty ? widget.tech.avatar : 'https://i.pravatar.cc/150?u=${widget.tech.uid}'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const Gap(16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.tech.name,
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            widget.tech.skills.join(', '),
                            style: TextStyle(color: theme.colorScheme.primary, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '${(widget.tech.pricePerHour / 1000).toInt()}k',
                          style: TextStyle(color: theme.colorScheme.primary, fontSize: 18, fontWeight: FontWeight.w900),
                        ),
                        const Text('/giờ', style: TextStyle(fontSize: 12, color: Colors.grey)),
                      ],
                    ),
                  ],
                ),
              ),
              const Gap(32),
              
              _buildSectionTitle('Thông tin chi tiết'),
              const Gap(16),
              
              _buildTextField(
                controller: _addressController,
                label: 'Địa chỉ sửa chữa',
                hint: 'Số nhà, tên đường, phường/xã...',
                icon: Icons.location_on_rounded,
              ),
              const Gap(20),
              _buildTextField(
                controller: _deviceController,
                label: 'Thiết bị & Tình trạng',
                hint: 'Ví dụ: iPhone 13 Pro Max, nứt màn hình...',
                icon: Icons.phonelink_setup_rounded,
              ),
              const Gap(20),
              _buildTextField(
                controller: _noteController,
                label: 'Ghi chú thêm (không bắt buộc)',
                hint: 'Mô tả chi tiết hơn về vấn đề...',
                icon: Icons.note_alt_rounded,
                maxLines: 3,
              ),
              
              const Gap(40),
              
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 0,
                  ),
                  child: const Text(
                    'XÁC NHẬN ĐẶT LỊCH',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, letterSpacing: 1),
                  ),
                ),
              ),
              const Gap(24),
              const Center(
                child: Text(
                  'Thợ sẽ liên hệ lại với bạn trong vòng 15 phút',
                  style: TextStyle(color: Colors.grey, fontSize: 12, fontStyle: FontStyle.italic),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    int maxLines = 1,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.grey)),
        const Gap(8),
        TextField(
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, color: theme.colorScheme.primary),
            filled: true,
            fillColor: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.grey.shade100,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
        ),
      ],
    );
  }
}

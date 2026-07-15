import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:fixit/features/auth/presentation/providers/auth_provider.dart';
import 'package:fixit/features/booking/domain/models/booking_model.dart';
import 'package:fixit/features/booking/presentation/providers/booking_provider.dart';
import 'package:fixit/shared/models/user_model.dart';

class BookingSummaryScreen extends ConsumerWidget {
  final String serviceTitle;
  final String categoryName;
  final String imageAsset;

  const BookingSummaryScreen({
    super.key,
    required this.serviceTitle,
    required this.categoryName,
    required this.imageAsset,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider).valueOrNull;

    return Scaffold(
      body: Stack(
        children: [
          // 1. Futuristic Background
          _buildBackground(),

          // 2. Main Content
          SafeArea(
            child: Column(
              children: [
                _buildHeader(context),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const _LabelText('XÁC NHẬN THÔNG TIN'),
                        const Gap(16),
                        
                        // Summary Glass Card
                        _buildSummaryCard(),
                        
                        const Gap(48),
                        _buildConfirmButton(context, ref, user),
                        const Gap(24),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // 3. Loading Overlay
          if (ref.watch(createBookingNotifierProvider).isLoading)
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.5),
                child: const Center(child: CircularProgressIndicator(color: Colors.blueAccent)),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBackground() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [Color(0xFF1565C0), Color(0xFF0D47A1), Color(0xFF010A1A)],
        ),
      ),
      child: Stack(
        children: [
          Positioned(top: -50, left: -50, child: _AmbientOrb(size: 300, color: Colors.blue.withOpacity(0.15))),
          Positioned(bottom: -100, right: -100, child: _AmbientOrb(size: 400, color: Colors.blueAccent.withOpacity(0.1))),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
            onPressed: () => context.pop(),
          ),
          const Gap(8),
          const Text(
            'TỔNG QUAN',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w900,
              fontSize: 14,
              letterSpacing: 2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard() {
    return _GlassCard(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    serviceTitle.toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.5,
                    ),
                  ),
                  Text(
                    categoryName,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.5),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              _buildIconWrapper(),
            ],
          ),
          const Gap(24),
          const Divider(color: Colors.white10, thickness: 1),
          const Gap(20),
          _buildDetailRow('Đơn giá', '200.000đ/giờ'),
          const Gap(12),
          _buildDetailRow('Vật tư', 'Chưa bao gồm'),
          const Gap(12),
          _buildDetailRow('Phí di chuyển', 'Miễn phí'),
          const Gap(20),
          const Divider(color: Colors.white10, thickness: 1),
          const Gap(20),
          _buildDetailRow(
            'Địa chỉ sửa chữa',
            'Số 123, Đường Lê Lợi, Quận 1, TP. Hồ Chí Minh',
            isMultiLine: true,
          ),
          const Gap(12),
          _buildDetailRow('Ngày đặt', '25 Tháng 6, 2024'),
          const Gap(12),
          _buildDetailRow('Giờ hẹn', '10:00 AM'),
          const Gap(24),
          const Divider(color: Colors.white10, thickness: 1),
          const Gap(20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'TỔNG CỘNG TẠM TÍNH',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1,
                ),
              ),
              const Text(
                '200.000đ',
                style: TextStyle(
                  color: Colors.greenAccent,
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildIconWrapper() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Image.asset(imageAsset, width: 32, height: 32, fit: BoxFit.contain),
    );
  }

  Widget _buildConfirmButton(BuildContext context, WidgetRef ref, UserModel? user) {
    return Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF00E676).withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, 10),
          )
        ],
      ),
      child: ElevatedButton(
        onPressed: user == null ? null : () async {
          final booking = BookingModel(
            id: '', // Will be generated by repository/backend
            customerId: user.uid,
            customerName: user.name,
            technicianId: 'tech_5', // MOCK ID for Jackson
            technicianName: 'Nguyễn Văn Hùng', 
            serviceType: serviceTitle,
            deviceInfo: 'Thiết bị gia dụng',
            address: 'Số 123, Đường Lê Lợi, Quận 1, TP. Hồ Chí Minh',
            status: BookingStatus.pending,
            estimatedPrice: 200000,
            createdAt: DateTime.now(),
          );

          await ref.read(createBookingNotifierProvider.notifier).create(booking);
          
          final result = ref.read(createBookingNotifierProvider);
          if (result.hasValue && context.mounted) {
            context.go('/booking/success', extra: result.value);
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF00E676),
          foregroundColor: Colors.black,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          elevation: 0,
        ),
        child: const Text(
          'XÁC NHẬN & ĐẶT LỊCH',
          style: TextStyle(
            fontWeight: FontWeight.w900,
            fontSize: 16,
            letterSpacing: 1,
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isMultiLine = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: isMultiLine ? CrossAxisAlignment.start : CrossAxisAlignment.center,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.4),
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
        const Gap(16),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

class _GlassCard extends StatelessWidget {
  final Widget child;
  const _GlassCard({required this.child});
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          child: child,
        ),
      ),
    );
  }
}

class _LabelText extends StatelessWidget {
  final String text;
  const _LabelText(this.text);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white.withOpacity(0.4),
          fontWeight: FontWeight.w900,
          fontSize: 11,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}

class _AmbientOrb extends StatelessWidget {
  final double size;
  final Color color;
  const _AmbientOrb({required this.size, required this.color});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [BoxShadow(color: color, blurRadius: 100, spreadRadius: 50)],
      ),
    );
  }
}

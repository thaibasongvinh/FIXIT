import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class SelectedServiceScreen extends StatelessWidget {
  final String serviceTitle;
  final String categoryName;
  final String imageAsset;

  const SelectedServiceScreen({
    super.key,
    required this.serviceTitle,
    required this.categoryName,
    required this.imageAsset,
  });

  @override
  Widget build(BuildContext context) {
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
                        // Service Summary Glass Card
                        _buildServiceSummaryCard(),
                        
                        const Gap(32),
                        const _LabelText('THÔNG TIN CHI TIẾT & YÊU CẦU RIÊNG'),
                        const Gap(12),
                        _buildInstructionInput(),
                        
                        const Gap(32),
                        const _LabelText('ẢNH CHỤP HIỆN TRẠNG (NẾU CÓ)'),
                        const Gap(12),
                        _buildUploadArea(),
                        
                        const Gap(48),
                        _buildNextButton(context),
                        const Gap(24),
                      ],
                    ),
                  ),
                ),
              ],
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
          Positioned(top: -100, right: -100, child: _AmbientOrb(size: 300, color: Colors.blue.withOpacity(0.2))),
          Positioned(bottom: 50, left: -100, child: _AmbientOrb(size: 400, color: Colors.blueAccent.withOpacity(0.1))),
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
            'LỰA CHỌN DỊCH VỤ',
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

  Widget _buildServiceSummaryCard() {
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
                      fontSize: 20,
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
          const Gap(16),
          _buildDetailRow('Đơn giá ước tính', '200.000đ/giờ'),
          const Gap(12),
          _buildDetailRow('Vật tư', 'Chưa bao gồm'),
          const Gap(12),
          _buildDetailRow('Phí di chuyển', 'Miễn phí'),
        ],
      ),
    );
  }

  Widget _buildIconWrapper() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Image.asset(imageAsset, width: 40, height: 40, fit: BoxFit.contain),
    );
  }

  Widget _buildInstructionInput() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.blueAccent.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          )
        ],
      ),
      child: const TextField(
        maxLines: 5,
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        decoration: InputDecoration(
          hintText: 'Nhập mô tả tình trạng hư hỏng...',
          hintStyle: TextStyle(color: Colors.grey, fontWeight: FontWeight.w400),
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(20),
        ),
      ),
    );
  }

  Widget _buildUploadArea() {
    return Container(
      width: double.infinity,
      height: 100,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.1), style: BorderStyle.solid),
      ),
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.add_a_photo_outlined, color: Colors.blueAccent, size: 28),
            const Gap(8),
            Text(
              'TẢI ẢNH LÊN',
              style: TextStyle(
                color: Colors.white.withOpacity(0.4),
                fontWeight: FontWeight.w900,
                fontSize: 11,
                letterSpacing: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNextButton(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF005CB7).withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          )
        ],
      ),
      child: ElevatedButton(
        onPressed: () {
          context.push(
            Uri(
              path: '/marketplace/location-access',
              queryParameters: {'title': serviceTitle},
            ).toString(),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF005CB7),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          elevation: 0,
        ),
        child: const Text(
          'TIẾP TỤC',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w900,
            fontSize: 16,
            letterSpacing: 1,
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.4),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
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

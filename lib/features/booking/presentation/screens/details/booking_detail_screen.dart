import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:fixit/core/router/app_router.dart';
import 'package:fixit/features/auth/presentation/providers/auth_provider.dart';
import 'package:fixit/features/marketplace/presentation/providers/technician_provider.dart';
import 'package:fixit/shared/models/user_model.dart';
import 'package:fixit/shared/utils/snackbar_utils.dart';
import 'package:fixit/features/booking/domain/models/booking_model.dart';
import 'package:fixit/features/booking/domain/models/review_model.dart';
import '../../providers/booking_provider.dart';

class BookingDetailScreen extends ConsumerStatefulWidget {
  final String bookingId;
  const BookingDetailScreen({super.key, required this.bookingId});

  @override
  ConsumerState<BookingDetailScreen> createState() => _BookingDetailScreenState();
}

class _BookingDetailScreenState extends ConsumerState<BookingDetailScreen> {
  final _reasonController = TextEditingController();
  final _priceController = TextEditingController();

  @override
  void dispose() {
    _reasonController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bookingAsync = ref.watch(bookingDetailProvider(widget.bookingId));
    final user = ref.watch(currentUserProvider).valueOrNull;

    return Scaffold(
      body: Stack(
        children: [
          _buildBackground(),

          bookingAsync.when(
            data: (booking) {
              if (booking == null) return const Center(child: Text('Không tìm thấy đơn hàng', style: TextStyle(color: Colors.white)));
              final isTechnician = user?.uid == booking.technicianId;
              
              return SafeArea(
                child: Column(
                  children: [
                    _buildHeader(context, booking),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(24),
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          children: [
                            _buildStatusStepper(booking),
                            const Gap(32),
                            if (booking.status == BookingStatus.accepted || booking.status == BookingStatus.inProgress) ...[
                              _buildTrackingMap(booking),
                              const Gap(32),
                            ],
                            _buildPartyInfoCard(booking, isTechnician),
                            const Gap(24),
                            _buildJobDetailsCard(booking),
                            const Gap(24),
                            _buildPricingCard(booking),
                            const Gap(120), 
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator(color: Colors.white24)),
            error: (e, _) => Center(child: Text('Lỗi: $e', style: const TextStyle(color: Colors.white))),
          ),
          
          bookingAsync.whenData((booking) {
            if (booking == null) return const SizedBox.shrink();
            return _buildFloatingActions(context, ref, booking, user);
          }).valueOrNull ?? const SizedBox.shrink(),
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
          colors: [Color(0xFF0D47A1), Color(0xFF010A1A), Color(0xFF000000)],
        ),
      ),
      child: Stack(
        children: [
          Positioned(top: 100, right: -100, child: _AmbientOrb(size: 300, color: Colors.blue.withOpacity(0.15))),
          Positioned(bottom: 200, left: -100, child: _AmbientOrb(size: 400, color: Colors.blueAccent.withOpacity(0.1))),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, BookingModel booking) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
            onPressed: () => context.pop(),
          ),
          const Gap(8),
          const Text('CHI TIẾT ĐƠN HÀNG', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 14, letterSpacing: 2)),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
            child: Text('#${booking.id.substring(0, 8).toUpperCase()}', style: const TextStyle(color: Colors.white70, fontSize: 10, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusStepper(BookingModel booking) {
    final status = booking.status;
    return _GlassCard(
      child: Column(
        children: [
          _buildStepItem('Yêu cầu', 'Gửi lúc ${DateFormat('HH:mm').format(booking.createdAt!)}', true, true),
          _buildStepLine(status.index >= 1),
          _buildStepItem('Xác nhận', status.index >= 1 ? 'Thợ đã nhận đơn' : 'Đang chờ thợ...', status.index >= 1, status.index >= 1),
          _buildStepLine(status.index >= 2),
          _buildStepItem('Thực hiện', status.index >= 2 ? 'Đang tiến hành sửa chữa' : 'Chưa bắt đầu', status.index >= 2, status.index >= 2),
          _buildStepLine(status.index >= 3),
          _buildStepItem('Hoàn thành', status.index >= 3 ? 'Công việc đã kết thúc' : 'Chưa hoàn thành', status.index >= 3, status.index >= 3),
        ],
      ),
    );
  }

  Widget _buildTrackingMap(BookingModel booking) {
    return _GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('THEO DÕI VỊ TRÍ THỢ', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13, letterSpacing: 1)),
          const Gap(16),
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: SizedBox(
              height: 200,
              child: Consumer(
                builder: (context, ref, child) {
                  final techAsync = ref.watch(technicianDetailProvider(booking.technicianId));
                  return techAsync.when(
                    data: (tech) {
                      if (tech == null || tech.latitude == null || tech.longitude == null) {
                        return const Center(child: Text('Đang cập nhật vị trí...', style: TextStyle(color: Colors.white54)));
                      }
                      
                      final techPos = LatLng(tech.latitude!, tech.longitude!);
                      return GoogleMap(
                        initialCameraPosition: CameraPosition(target: techPos, zoom: 15),
                        markers: {
                          Marker(
                            markerId: MarkerId('tech_pos'),
                            position: techPos,
                            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
                          ),
                        },
                        zoomControlsEnabled: false,
                        myLocationButtonEnabled: false,
                        scrollGesturesEnabled: false,
                      );
                    },
                    loading: () => const Center(child: CircularProgressIndicator()),
                    error: (_, __) => const Center(child: Icon(Icons.error_outline, color: Colors.redAccent)),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepItem(String title, String subtitle, bool isDone, bool isActive) {
    return Row(
      children: [
        Container(
          width: 24, height: 24,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isDone ? Colors.greenAccent : (isActive ? Colors.blueAccent : Colors.white10),
            border: Border.all(color: Colors.white10),
          ),
          child: isDone ? const Icon(Icons.check, size: 14, color: Colors.black) : null,
        ),
        const Gap(16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(color: isActive ? Colors.white : Colors.white24, fontWeight: FontWeight.bold, fontSize: 15)),
            Text(subtitle, style: TextStyle(color: isActive ? Colors.white54 : Colors.white10, fontSize: 12)),
          ],
        ),
      ],
    );
  }

  Widget _buildStepLine(bool isActive) {
    return Container(
      margin: const EdgeInsets.only(left: 11, top: 4, bottom: 4),
      width: 2, height: 20,
      color: isActive ? Colors.greenAccent.withOpacity(0.5) : Colors.white10,
    );
  }

  Widget _buildPartyInfoCard(BookingModel booking, bool isTechnician) {
    final name = isTechnician ? booking.customerName : booking.technicianName;
    final label = isTechnician ? 'KHÁCH HÀNG' : 'THỢ SỬA CHỮA';
    return _GlassCard(
      child: Row(
        children: [
          CircleAvatar(radius: 30, backgroundColor: Colors.blueAccent.withOpacity(0.1), child: const Icon(Icons.person, color: Colors.blueAccent, size: 30)),
          const Gap(16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                Text(label, style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 11, fontWeight: FontWeight.w900, letterSpacing: 1)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: Colors.greenAccent.withOpacity(0.1), shape: BoxShape.circle),
            child: const Icon(Icons.verified_user, color: Colors.greenAccent, size: 18),
          ),
        ],
      ),
    );
  }

  Widget _buildJobDetailsCard(BookingModel booking) {
    return _GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDetailRow(Icons.build_circle_outlined, 'Dịch vụ', booking.serviceType),
          const Divider(color: Colors.white10, height: 32),
          _buildDetailRow(Icons.devices_outlined, 'Thiết bị', booking.deviceInfo),
          const Divider(color: Colors.white10, height: 32),
          _buildDetailRow(Icons.location_on_outlined, 'Địa chỉ', booking.address),
          if (booking.notes.isNotEmpty) ...[
            const Divider(color: Colors.white10, height: 32),
            _buildDetailRow(Icons.note_alt_outlined, 'Ghi chú', booking.notes),
          ],
        ],
      ),
    );
  }

  Widget _buildPricingCard(BookingModel booking) {
    return _GlassCard(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Tổng chi phí', style: TextStyle(color: Colors.white.withOpacity(0.5), fontWeight: FontWeight.bold)),
              Text(booking.priceText, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 20)),
            ],
          ),
          const Gap(12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Thanh toán', style: TextStyle(color: Colors.white.withOpacity(0.5))),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: booking.paymentStatus == PaymentStatus.paid ? Colors.green.withOpacity(0.2) : Colors.orange.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  booking.paymentStatus.label.toUpperCase(),
                  style: TextStyle(color: booking.paymentStatus == PaymentStatus.paid ? Colors.greenAccent : Colors.orangeAccent, fontSize: 10, fontWeight: FontWeight.w900),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Colors.blueAccent, size: 20),
        const Gap(16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: TextStyle(color: Colors.white.withOpacity(0.3), fontSize: 11)),
              const Gap(2),
              Text(value, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFloatingActions(BuildContext context, WidgetRef ref, BookingModel booking, UserModel? user) {
    final isTechnician = user?.uid == booking.technicianId;
    final canUpdate = isTechnician && !booking.status.isCompleted && !booking.status.isCancelled;
    final canCancel = !isTechnician && booking.status.canBeCancelled;

    return Positioned(
      bottom: 0, left: 0, right: 0,
      child: Container(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 40),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter, end: Alignment.bottomCenter,
            colors: [Colors.black.withOpacity(0), Colors.black.withOpacity(0.9), Colors.black],
          ),
        ),
        child: Row(
          children: [
            _buildCircleAction(Icons.phone_in_talk_rounded, Colors.greenAccent, () {
              context.push(AppRoutes.voiceCall, extra: {
                'name': isTechnician ? booking.customerName : booking.technicianName,
                'avatar': '',
              });
            }),
            const Gap(16),
            _buildCircleAction(Icons.chat_bubble_rounded, Colors.blueAccent, () {
              context.push('${AppRoutes.chat}/${booking.id}', extra: {
                'otherUserName': isTechnician ? booking.customerName : booking.technicianName,
                'participants': [booking.customerId, booking.technicianId],
                'bookingId': booking.id,
              });
            }),
            const Gap(16),
            if (canUpdate)
              Expanded(child: _buildMainAction('CẬP NHẬT', () => _handleStatusUpdate(booking)))
            else if (canCancel)
              Expanded(child: _buildMainAction('HỦY ĐƠN', () => _handleCancel(booking), color: Colors.redAccent))
            else if (booking.status.isCompleted && !booking.isReviewed && !isTechnician)
              Expanded(child: _buildMainAction('ĐÁNH GIÁ', () => _showReviewDialog(booking)))
            else
              Expanded(child: _buildMainAction('LIÊN HỆ TRỢ GIÚP', () {}, color: Colors.white10)),
          ],
        ),
      ),
    );
  }

  Widget _buildCircleAction(IconData icon, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        width: 56, height: 56,
        decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle, border: Border.all(color: color.withOpacity(0.3))),
        child: Icon(icon, color: color, size: 24),
      ),
    );
  }

  Widget _buildMainAction(String label, VoidCallback onTap, {Color? color}) {
    return SizedBox(
      height: 56,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: color ?? const Color(0xFF005CB7),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 0,
        ),
        child: Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 13, letterSpacing: 1)),
      ),
    );
  }

  Future<void> _handleStatusUpdate(BookingModel booking) async {
    final notifier = ref.read(bookingActionsNotifierProvider.notifier);
    if (booking.status == BookingStatus.pending) {
      await notifier.accept(booking.id);
    } else if (booking.status == BookingStatus.accepted) {
      await notifier.start(booking.id);
    } else if (booking.status == BookingStatus.inProgress) {
      _showCompleteDialog(booking);
    }
  }

  void _showCompleteDialog(BookingModel booking) {
    _priceController.text = booking.estimatedPrice.toString();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF0D47A1),
        title: const Text('Hoàn thành công việc', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        content: TextField(
          controller: _priceController,
          keyboardType: TextInputType.number,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(labelText: 'Giá cuối cùng (VND)', labelStyle: TextStyle(color: Colors.white70)),
        ),
        actions: [
          TextButton(onPressed: () => context.pop(), child: const Text('Hủy', style: TextStyle(color: Colors.white54))),
          ElevatedButton(
            onPressed: () {
              final price = int.tryParse(_priceController.text) ?? booking.estimatedPrice;
              ref.read(bookingActionsNotifierProvider.notifier).complete(booking.id, price);
              context.pop();
            },
            child: const Text('Xác nhận'),
          ),
        ],
      ),
    );
  }

  void _showReviewDialog(BookingModel booking) {
    int rating = 5;
    final contentController = TextEditingController();

    showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
      backgroundColor: const Color(0xFF0D47A1),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 24, right: 24, top: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Đánh giá dịch vụ', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
              const Gap(16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  return IconButton(
                    icon: Icon(
                      index < rating ? Icons.star_rounded : Icons.star_outline_rounded,
                      color: Colors.amber,
                      size: 40,
                    ),
                    onPressed: () => setModalState(() => rating = index + 1),
                  );
                }),
              ),
              const Gap(16),
              TextField(
                controller: contentController,
                maxLines: 3,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: 'Cảm nhận của bạn về thợ sửa chữa...',
                  hintStyle: TextStyle(color: Colors.white24),
                  enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white10)),
                  focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.blueAccent)),
                ),
              ),
              const Gap(24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () async {
                    final review = ReviewModel(
                      id: '',
                      bookingId: booking.id,
                      customerId: booking.customerId,
                      customerName: booking.customerName,
                      technicianId: booking.technicianId,
                      rating: rating,
                      content: contentController.text,
                      photos: [],
                      createdAt: DateTime.now(),
                    );
                    await ref.read(reviewNotifierProvider.notifier).submit(review);
                    if (context.mounted) {
                      Navigator.pop(context);
                      AppSnackbar.showSuccess(context, 'Cảm ơn bạn đã đánh giá!');
                    }
                  },
                  child: const Text('GỬI ĐÁNH GIÁ'),
                ),
              ),
              const Gap(24),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleCancel(BookingModel booking) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF0D47A1),
        title: const Text('Hủy đơn hàng', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        content: TextField(
          controller: _reasonController,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(hintText: 'Lý do hủy...', hintStyle: TextStyle(color: Colors.white24)),
        ),
        actions: [
          TextButton(onPressed: () => context.pop(), child: const Text('Không', style: TextStyle(color: Colors.white54))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () {
              ref.read(bookingActionsNotifierProvider.notifier).cancel(booking.id, _reasonController.text);
              context.pop();
            },
            child: const Text('Xác nhận Hủy'),
          ),
        ],
      ),
    );
  }
}

class _GlassCard extends StatelessWidget {
  final Widget child;
  const _GlassCard({required this.child});
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          width: double.infinity, padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(24), border: Border.all(color: Colors.white.withOpacity(0.1))),
          child: child,
        ),
      ),
    );
  }
}

class _AmbientOrb extends StatelessWidget {
  final double size; final Color color;
  const _AmbientOrb({required this.size, required this.color});
  @override
  Widget build(BuildContext context) {
    return Container(width: size, height: size, decoration: BoxDecoration(shape: BoxShape.circle, boxShadow: [BoxShadow(color: color, blurRadius: 100, spreadRadius: 50)]));
  }
}

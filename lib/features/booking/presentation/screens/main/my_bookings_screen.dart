import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:fixit/core/presentation/widgets/app_background.dart';
import 'package:fixit/features/auth/presentation/providers/auth_provider.dart';
import '../../../../../shared/models/user_model.dart';
import '../../providers/booking_provider.dart';
import '../../widgets/booking_card.dart';

class MyBookingsScreen extends ConsumerStatefulWidget {
  const MyBookingsScreen({super.key});

  @override
  ConsumerState<MyBookingsScreen> createState() => _MyBookingsScreenState();
}

class _MyBookingsScreenState extends ConsumerState<MyBookingsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider).valueOrNull;
    if (user == null) return const Center(child: Text('Vui lòng đăng nhập', style: TextStyle(color: Colors.white)));

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: AppBackground(
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(isDark),
              _buildTabBar(isDark),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildMockActiveList(isDark),
                    _buildMockHistoryList(isDark),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMockActiveList(bool isDark) {
    return _buildBookingList([
      _createMockBooking('tech_1', 'Nguyễn Văn Nam', 'Sửa máy lạnh', 'Đang đến', 350000),
    ], 'Chưa có đơn hàng nào đang chạy', isDark);
  }

  Widget _buildMockHistoryList(bool isDark) {
    return _buildBookingList([
      _createMockBooking('tech_2', 'Trần Minh Tâm', 'Sửa ống nước', 'Hoàn thành', 200000),
      _createMockBooking('tech_3', 'Lê Hoàng Long', 'Vệ sinh nhà cửa', 'Hoàn thành', 150000),
    ], 'Lịch sử đơn hàng trống', isDark);
  }

  Widget _buildHeader(bool isDark) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 10),
      child: Row(
        children: [
          Text(
            'LỊCH HẸN CỦA TÔI',
            style: TextStyle(
              color: isDark ? Colors.white : const Color(0xFF1A1D1E),
              fontWeight: FontWeight.w900,
              fontSize: 20,
              letterSpacing: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar(bool isDark) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.03),
        borderRadius: BorderRadius.circular(16),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          color: const Color(0xFF005CB7),
          borderRadius: BorderRadius.circular(14),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        labelStyle: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13, letterSpacing: 1),
        unselectedLabelColor: isDark ? Colors.white24 : Colors.black26,
        tabs: const [
          Tab(text: 'ĐANG CHẠY'),
          Tab(text: 'LỊCH SỬ'),
        ],
      ),
    );
  }

  dynamic _createMockBooking(String id, String name, String service, String status, int price) {
    // Trả về một object giả lập cấu trúc BookingModel
    return {
      'id': id,
      'technicianName': name,
      'serviceType': service,
      'statusLabel': status,
      'price': price,
      'createdAt': DateTime.now().subtract(const Duration(days: 1)),
    };
  }

  Widget _buildBookingList(List<dynamic> list, String emptyMsg, bool isDark) {
    if (list.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.calendar_today_outlined, size: 64, color: isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.05)),
            const Gap(16),
            Text(emptyMsg, style: TextStyle(color: (isDark ? Colors.white : Colors.black).withOpacity(0.2))),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 110),
      itemCount: list.length,
      separatorBuilder: (_, __) => const Gap(16),
      itemBuilder: (context, index) => _buildMockBookingCard(list[index], isDark),
    );
  }

  Widget _buildMockBookingCard(dynamic booking, bool isDark) {
    final priceFormat = NumberFormat.currency(locale: 'vi_VN', symbol: '₫');
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(0.05) : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: isDark ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.05)),
        boxShadow: isDark ? [] : [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 20, offset: const Offset(0, 10))
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 48, height: 48,
                decoration: BoxDecoration(color: Colors.blueAccent.withOpacity(0.1), borderRadius: BorderRadius.circular(16)),
                child: const Icon(Icons.handyman_rounded, color: Colors.blueAccent),
              ),
              const Gap(16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(booking['technicianName'], style: TextStyle(fontWeight: FontWeight.w900, color: isDark ? Colors.white : Colors.black87, fontSize: 16)),
                    Text(booking['serviceType'], style: TextStyle(color: isDark ? Colors.white38 : Colors.grey, fontSize: 13)),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: booking['statusLabel'] == 'Hoàn thành' ? Colors.green.withOpacity(0.1) : Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  booking['statusLabel'],
                  style: TextStyle(
                    color: booking['statusLabel'] == 'Hoàn thành' ? Colors.green : Colors.orange,
                    fontWeight: FontWeight.w900,
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ),
          const Gap(20),
          const Divider(height: 1, color: Colors.white10),
          const Gap(16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Tổng thanh toán', style: TextStyle(color: isDark ? Colors.white38 : Colors.grey, fontSize: 12, fontWeight: FontWeight.w500)),
              Text(
                priceFormat.format(booking['price']),
                style: const TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.w900, fontSize: 18),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

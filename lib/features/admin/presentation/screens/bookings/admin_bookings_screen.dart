import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:fixit/core/presentation/widgets/app_background.dart';
import 'package:fixit/features/admin/presentation/providers/admin_provider.dart';
import 'package:fixit/features/admin/domain/models/admin_models.dart';
import 'package:fixit/l10n/app_localizations.dart';

class AdminBookingsScreen extends ConsumerWidget {
  const AdminBookingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const AdminBookingsView();
  }
}

class AdminBookingsView extends ConsumerWidget {
  const AdminBookingsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookingsAsync = ref.watch(adminBookingsProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;
    final textColor = isDark ? Colors.white : const Color(0xFF1A1C1E);
    final cardColor = isDark ? Colors.white.withValues(alpha: 0.05) : Colors.white;

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(l10n.jobs.toUpperCase(), 
          style: TextStyle(color: textColor, fontWeight: FontWeight.w900, fontSize: 13, letterSpacing: 2)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: textColor, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: AppBackground(
        child: bookingsAsync.when(
          data: (bookings) => RefreshIndicator(
            onRefresh: () => ref.read(adminBookingsProvider.notifier).refresh(),
            child: bookings.isEmpty
                ? Center(child: Text(l10n.noJobData, style: TextStyle(color: textColor.withValues(alpha: 0.3))))
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(24, 10, 24, 40),
                    itemCount: bookings.length,
                    separatorBuilder: (_, __) => const Gap(16),
                    itemBuilder: (context, index) => _buildBookingCard(bookings[index], isDark, cardColor, textColor, l10n),
                  ),
          ),
          loading: () => Center(child: CircularProgressIndicator(color: isDark ? Colors.white : Colors.blueAccent)),
          error: (e, _) => Center(child: Text(l10n.error(e.toString()), style: TextStyle(color: textColor))),
        ),
      ),
    );
  }

  Widget _buildBookingCard(BookingRecord booking, bool isDark, Color cardColor, Color textColor, AppLocalizations l10n) {
    final currencyFormat = NumberFormat.simpleCurrency(locale: 'vi_VN');
    
    Color statusColor;
    switch (booking.status.toLowerCase()) {
      case 'completed': statusColor = Colors.greenAccent; break;
      case 'ongoing': statusColor = Colors.blueAccent; break;
      case 'cancelled': statusColor = Colors.redAccent; break;
      default: statusColor = Colors.orangeAccent;
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: textColor.withValues(alpha: 0.05)),
            boxShadow: isDark ? [] : [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 5))],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(color: statusColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
                    child: Text(booking.status.toUpperCase(), style: TextStyle(color: statusColor, fontSize: 10, fontWeight: FontWeight.w900)),
                  ),
                  Text(
                    DateFormat('MMM dd, HH:mm').format(booking.createdAt),
                    style: TextStyle(color: textColor.withValues(alpha: 0.3), fontSize: 11),
                  ),
                ],
              ),
              const Gap(16),
              Text(booking.serviceTitle, style: TextStyle(color: textColor, fontSize: 18, fontWeight: FontWeight.bold)),
              const Gap(12),
              Row(
                children: [
                  _buildUserMinimalInfo(l10n.customer, booking.customerName, Icons.person_outline, textColor),
                  const Gap(24),
                  _buildUserMinimalInfo(l10n.technicianSmall, booking.technicianName, Icons.handyman_outlined, textColor),
                ],
              ),
              const Gap(20),
              Divider(color: textColor.withValues(alpha: 0.05)),
              const Gap(12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(l10n.revenue, style: TextStyle(color: textColor.withValues(alpha: 0.4), fontSize: 13)),
                  Text(
                    currencyFormat.format(booking.totalPrice),
                    style: const TextStyle(color: Colors.greenAccent, fontSize: 18, fontWeight: FontWeight.w900),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserMinimalInfo(String label, String name, IconData icon, Color textColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: textColor.withValues(alpha: 0.3), fontSize: 11)),
        const Gap(4),
        Row(
          children: [
            Icon(icon, size: 14, color: Colors.blueAccent),
            const Gap(6),
            Text(name, style: TextStyle(color: textColor, fontSize: 13, fontWeight: FontWeight.w500)),
          ],
        ),
      ],
    );
  }
}

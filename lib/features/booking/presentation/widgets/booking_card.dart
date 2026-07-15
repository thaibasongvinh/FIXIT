import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import '../../domain/models/booking_model.dart';

class BookingCard extends StatelessWidget {
  final BookingModel booking;
  const BookingCard({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? Colors.white.withOpacity(0.05) : Colors.white;
    final borderColor = isDark ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.05);
    final primaryTextColor = isDark ? Colors.white : const Color(0xFF1A1C1E);
    final secondaryTextColor = isDark ? Colors.white.withOpacity(0.5) : const Color(0xFF666666);
    final tertiaryTextColor = isDark ? Colors.white.withOpacity(0.3) : const Color(0xFF999999);

    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: InkWell(
          onTap: () => context.push('/booking/${booking.id}'),
          borderRadius: BorderRadius.circular(24),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: borderColor),
              boxShadow: isDark ? [] : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'MÃ ĐƠN #${booking.id.substring(0, 6).toUpperCase()}',
                      style: TextStyle(
                        color: tertiaryTextColor,
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1,
                      ),
                    ),
                    _StatusBadge(status: booking.status),
                  ],
                ),
                const Gap(16),
                Text(
                  booking.serviceType.toUpperCase(),
                  style: TextStyle(
                    color: primaryTextColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.5,
                  ),
                ),
                const Gap(4),
                Text(
                  booking.deviceInfo,
                  style: TextStyle(
                    color: secondaryTextColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Gap(20),
                Divider(color: isDark ? Colors.white10 : Colors.black.withOpacity(0.05), height: 1),
                const Gap(16),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.blueAccent.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.location_on_rounded, size: 14, color: Colors.blueAccent),
                    ),
                    const Gap(12),
                    Expanded(
                      child: Text(
                        booking.address,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: secondaryTextColor,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const Gap(16),
                    Text(
                      booking.priceText,
                      style: TextStyle(
                        color: primaryTextColor,
                        fontWeight: FontWeight.w900,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final BookingStatus status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final color = _getStatusColor(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        status.name.toUpperCase(),
        style: TextStyle(
          color: color,
          fontSize: 9,
          fontWeight: FontWeight.w900,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Color _getStatusColor(BookingStatus status) {
    switch (status) {
      case BookingStatus.pending:
        return const Color(0xFFFFB800);
      case BookingStatus.accepted:
        return const Color(0xFF00B2FF);
      case BookingStatus.inProgress:
        return const Color(0xFF0056D2);
      case BookingStatus.completed:
        return const Color(0xFF27AE60);
      case BookingStatus.cancelled:
        return const Color(0xFFEB5757);
    }
  }
}

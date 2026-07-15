import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:fixit/core/presentation/widgets/app_background.dart';
import 'package:fixit/core/router/app_router.dart';
import 'package:fixit/features/notifications/presentation/providers/notification_provider.dart';
import 'package:fixit/features/notifications/domain/notification_model.dart';
import 'package:fixit/l10n/app_localizations.dart';
import 'package:fixit/shared/utils/snackbar_utils.dart';
import 'package:intl/intl.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationsAsync = ref.watch(notificationsStreamProvider);
    final filteredNotifications = ref.watch(filteredNotificationsProvider);
    final currentFilter = ref.watch(notificationFilterProvider);
    
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: isDark ? Colors.white : const Color(0xFF1A1D1E), size: 20),
          onPressed: () => context.pop(),
        ),
        title: Text(
          l10n.notifications,
          style: TextStyle(
            color: isDark ? Colors.white : const Color(0xFF1A1D1E),
            fontSize: 20,
            fontWeight: FontWeight.w900,
            letterSpacing: -0.5,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.done_all_rounded, color: isDark ? Colors.white70 : const Color(0xFF1A1D1E)),
            onPressed: () {
              final notifications = ref.read(notificationsStreamProvider).valueOrNull ?? [];
              for (var n in notifications) {
                if (!n.isRead) {
                  ref.read(notificationRepositoryProvider).markAsRead(n.id);
                }
              }
            },
            tooltip: 'Đánh dấu tất cả đã đọc',
          ),
          const Gap(10),
        ],
        centerTitle: true,
      ),
      body: AppBackground(
        child: SafeArea(
          child: Column(
            children: [
              _buildFilterBar(ref, currentFilter, isDark),
              Expanded(
                child: notificationsAsync.when(
                  data: (notifications) => filteredNotifications.isEmpty
                      ? _buildEmptyState(isDark, currentFilter != 'all')
                      : ListView.separated(
                          padding: const EdgeInsets.fromLTRB(24, 8, 24, 40),
                          itemCount: filteredNotifications.length,
                          separatorBuilder: (_, __) => const Gap(12),
                          itemBuilder: (context, index) {
                            final item = filteredNotifications[index];
                            return _buildDismissibleCard(context, ref, item, isDark);
                          },
                        ),
                  loading: () => Center(child: CircularProgressIndicator(color: isDark ? Colors.white24 : Colors.black12)),
                  error: (e, _) => Center(child: Text('Error: $e')),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterBar(WidgetRef ref, String currentFilter, bool isDark) {
    final filters = [
      {'id': 'all', 'label': 'Tất cả'},
      {'id': 'application_status', 'label': 'Hồ sơ'},
      {'id': 'booking_update', 'label': 'Đơn hàng'},
      {'id': 'payment_success', 'label': 'Tài chính'},
    ];

    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        separatorBuilder: (_, __) => const Gap(8),
        itemBuilder: (context, index) {
          final filter = filters[index];
          final isSelected = currentFilter == filter['id'];
          
          return ChoiceChip(
            label: Text(filter['label']!),
            selected: isSelected,
            onSelected: (selected) {
              if (selected) {
                ref.read(notificationFilterProvider.notifier).state = filter['id']!;
              }
            },
            selectedColor: const Color(0xFF2450A4),
            labelStyle: TextStyle(
              color: isSelected ? Colors.white : (isDark ? Colors.white70 : Colors.black87),
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              fontSize: 12,
            ),
            backgroundColor: isDark ? Colors.white.withOpacity(0.05) : Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            showCheckmark: false,
          );
        },
      ),
    );
  }

  Widget _buildDismissibleCard(BuildContext context, WidgetRef ref, NotificationModel item, bool isDark) {
    return Dismissible(
      key: Key(item.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: Colors.redAccent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.delete_sweep_rounded, color: Colors.white, size: 28),
      ),
      onDismissed: (direction) {
        ref.read(notificationRepositoryProvider).deleteNotification(item.id);
        AppSnackbar.showInfo(context, 'Đã xóa thông báo');
      },
      child: _buildNotificationCard(context, ref, item, isDark),
    );
  }

  Widget _buildEmptyState(bool isDark, bool isFiltered) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isFiltered ? Icons.filter_list_off_rounded : Icons.notifications_none_rounded, 
            size: 80, 
            color: isDark ? Colors.white24 : Colors.grey.shade300
          ),
          const Gap(16),
          Text(
            isFiltered ? 'Không có thông báo nào trong mục này' : 'Chưa có thông báo nào',
            style: TextStyle(color: isDark ? Colors.white38 : Colors.grey, fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationCard(BuildContext context, WidgetRef ref, NotificationModel item, bool isDark) {
    IconData icon;
    Color iconColor;

    switch (item.type) {
      case 'application_status':
        icon = Icons.verified_user_rounded;
        iconColor = const Color(0xFF00C853);
        break;
      case 'booking_update':
        icon = Icons.calendar_today_rounded;
        iconColor = const Color(0xFF2979FF);
        break;
      case 'payment_success':
        icon = Icons.account_balance_wallet_rounded;
        iconColor = const Color(0xFFFFAB00);
        break;
      default:
        icon = Icons.notifications_rounded;
        iconColor = const Color(0xFF6200EA);
    }

    final timeStr = _formatDateTime(item.createdAt);

    return InkWell(
      onTap: () => _handleNotificationTap(context, ref, item),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? Colors.white.withOpacity(0.05) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            if (!isDark)
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
          ],
          border: item.isRead 
            ? Border.all(color: isDark ? Colors.white10 : Colors.black.withOpacity(0.05))
            : Border.all(color: const Color(0xFF0056D2).withOpacity(0.3), width: 1.5),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor, size: 24),
            ),
            const Gap(16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          item.title,
                          style: TextStyle(
                            color: isDark ? Colors.white : const Color(0xFF4D4D4D),
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        timeStr,
                        style: TextStyle(
                          color: isDark ? Colors.white38 : const Color(0xFF8E8E8E),
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const Gap(8),
                  Text(
                    item.body,
                    style: TextStyle(
                      color: isDark ? Colors.white70 : const Color(0xFF5C5C5C),
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleNotificationTap(BuildContext context, WidgetRef ref, NotificationModel item) {
    // 1. Mark as read
    if (!item.isRead) {
      ref.read(notificationRepositoryProvider).markAsRead(item.id);
    }

    // 2. Smart Navigation
    if (item.relatedId != null && item.relatedId!.isNotEmpty) {
      switch (item.type) {
        case 'application_status':
          // If the user is an admin, they might want to see the application.
          // However, for a technician, we take them to their profile/status.
          // For now, let's assume we navigate to a relevant detail page if possible.
          // context.push(AppRoutes.adminApplicationDetail.replaceAll(':id', item.relatedId!));
          break;
          
        case 'booking_update':
          context.push('/booking/${item.relatedId}');
          break;
          
        case 'payment_success':
          context.push('/wallet');
          break;
          
        default:
          // General notification, just stay on screen or go to home
          break;
      }
    }
  }

  String _formatDateTime(DateTime dt) {
    final now = DateTime.now();
    final difference = now.difference(dt);

    if (difference.inMinutes < 1) return 'Vừa xong';
    if (difference.inMinutes < 60) return '${difference.inMinutes} phút trước';
    if (difference.inHours < 24) return '${difference.inHours} giờ trước';
    if (difference.inDays < 7) return '${difference.inDays} ngày trước';
    return DateFormat('dd/MM/yyyy').format(dt);
  }
}

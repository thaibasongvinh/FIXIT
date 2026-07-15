import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fixit/core/config/appwrite_provider.dart';
import 'package:fixit/core/config/app_environment_provider.dart';
import 'package:fixit/features/auth/presentation/providers/auth_provider.dart';
import 'package:fixit/features/notifications/data/notification_repository.dart';
import 'package:fixit/features/notifications/domain/notification_model.dart';
import 'package:fixit/shared/services/notification_service.dart';
import 'package:appwrite/models.dart' as models;

final notificationRepositoryProvider = Provider<NotificationRepository>((ref) {
  final databases = ref.watch(appwriteDatabasesProvider);
  final realtime = ref.watch(appwriteRealtimeProvider);
  final env = ref.watch(appEnvironmentProvider);
  return NotificationRepository(
    databases: databases,
    realtime: realtime,
    databaseId: env.appwriteDatabaseId,
  );
});

final notificationsStreamProvider =
    StreamProvider<List<NotificationModel>>((ref) async* {
  final user = ref.watch(currentUserProvider).valueOrNull;
  if (user == null) {
    yield [];
    return;
  }

  final repo = ref.watch(notificationRepositoryProvider);
  final env = ref.watch(appEnvironmentProvider);
  final realtime = ref.watch(appwriteRealtimeProvider);

  // 1. Fetch ban đầu
  List<NotificationModel> notifications = await repo.getNotifications(user.uid);
  yield notifications;

  // 2. Lắng nghe Realtime và NỐI THÊM (Append) thay vì refetch
  final subscription = realtime.subscribe([
    'databases.${env.appwriteDatabaseId}.collections.notifications.documents'
  ]);

  await for (final event in subscription.stream) {
    if (event.payload['userId'] == user.uid) {
      if (event.events.contains(
          'databases.*.collections.notifications.documents.*.create')) {
        final newNotif =
            NotificationModel.fromMap(event.payload, event.payload['\$id']);

        // Hiện thông báo cục bộ
        NotificationService.showLocalNotification(
          title: newNotif.title,
          body: newNotif.body,
        );

        // Nối vào danh sách hiện tại
        if (!notifications.any((n) => n.id == newNotif.id)) {
          notifications = [newNotif, ...notifications];
          yield notifications;
        }
      } else if (event.events.contains(
          'databases.*.collections.notifications.documents.*.update')) {
        final updatedNotif =
            NotificationModel.fromMap(event.payload, event.payload['\$id']);
        final index = notifications.indexWhere((n) => n.id == updatedNotif.id);
        if (index != -1) {
          notifications[index] = updatedNotif;
          yield List.from(
              notifications); // Yield a new list to trigger UI update
        }
      } else if (event.events.contains(
          'databases.*.collections.notifications.documents.*.delete')) {
        final deletedNotifId = event.payload['\$id'];
        notifications.removeWhere((n) => n.id == deletedNotifId);
        yield List.from(notifications);
      } else {
        // Với các event khác (update/delete), ta vẫn nên fetch lại để đảm bảo đồng bộ
        notifications = await repo
            .getNotifications(user.uid); // Giữ lại như một fallback an toàn
        yield notifications;
      }
    }
  }
});

final notificationFilterProvider = StateProvider<String>((ref) => 'all');

final filteredNotificationsProvider = Provider<List<NotificationModel>>((ref) {
  final notifications =
      ref.watch(notificationsStreamProvider).valueOrNull ?? [];
  final filter = ref.watch(notificationFilterProvider);

  if (filter == 'all') return notifications;
  return notifications.where((n) => n.type == filter).toList();
});

final unreadNotificationsCountProvider = Provider<int>((ref) {
  final notifications =
      ref.watch(notificationsStreamProvider).valueOrNull ?? [];
  return notifications.where((n) => !n.isRead).length;
});

import 'package:appwrite/appwrite.dart';
import 'package:fixit/core/constants/app_constants.dart';
import '../domain/notification_model.dart';

class NotificationRepository {
  final Databases _databases;
  final Realtime _realtime;
  final String _databaseId;

  NotificationRepository({
    required Databases databases,
    required Realtime realtime,
    String? databaseId,
  })  : _databases = databases,
        _realtime = realtime,
        _databaseId = databaseId ?? AppwriteConstants.databaseId;

  Future<List<NotificationModel>> getNotifications(String userId) async {
    final result = await _databases.listDocuments(
      databaseId: _databaseId,
      collectionId: 'notifications',
      queries: [
        Query.equal('userId', userId),
        Query.orderDesc('createdAt'),
      ],
    );
    return result.documents.map((e) => NotificationModel.fromMap(e.data, e.$id)).toList();
  }

  Future<void> markAsRead(String notificationId) async {
    await _databases.updateDocument(
      databaseId: _databaseId,
      collectionId: 'notifications',
      documentId: notificationId,
      data: {'isRead': true},
    );
  }

  Future<void> deleteNotification(String notificationId) async {
    await _databases.deleteDocument(
      databaseId: _databaseId,
      collectionId: 'notifications',
      documentId: notificationId,
    );
  }

  RealtimeSubscription subscribeToNotifications(String userId) {
    return _realtime.subscribe([
      'databases.$_databaseId.collections.notifications.documents'
    ]);
  }
}

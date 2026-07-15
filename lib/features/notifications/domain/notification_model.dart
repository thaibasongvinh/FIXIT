class NotificationModel {
  final String id;
  final String userId;
  final String title;
  final String body;
  final String type;
  final String? relatedId; // Field to store bookingId, appId, etc.
  final bool isRead;
  final DateTime createdAt;

  NotificationModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
    required this.type,
    this.relatedId,
    required this.isRead,
    required this.createdAt,
  });

  factory NotificationModel.fromMap(Map<String, dynamic> map, String id) {
    return NotificationModel(
      id: id,
      userId: map['userId'] ?? '',
      title: map['title'] ?? '',
      body: map['body'] ?? map['message'] ?? '',
      type: map['type'] ?? 'general',
      relatedId: map['relatedId'],
      isRead: map['isRead'] ?? false,
      createdAt: DateTime.tryParse(map['createdAt'] ?? '') ?? DateTime.now(),
    );
  }
}

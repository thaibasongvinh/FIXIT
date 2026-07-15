import 'dart:io';
import 'dart:async';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as models;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../../core/config/appwrite_provider.dart';
import '../../../../core/config/app_environment_provider.dart';
import '../../domain/models/chat_room_model.dart';
import '../../domain/models/message_model.dart';

part 'chat_provider.g.dart';

@riverpod
Stream<List<ChatRoom>> chatRooms(Ref ref) {
  final user = ref.watch(authStateProvider).valueOrNull;
  if (user == null) return Stream.value([]);

  final env = ref.watch(appEnvironmentProvider);
  final db = ref.watch(appwriteDatabasesProvider);
  final realtime = ref.watch(appwriteRealtimeProvider);
  final String uid = user.$id;

  final controller = StreamController<List<ChatRoom>>();
  List<ChatRoom> currentRooms = [];
  
  void fetch() async {
    try {
      final snap = await db.listDocuments(
        databaseId: env.appwriteDatabaseId,
        collectionId: 'chat_rooms',
        queries: [
          Query.contains('participants', uid),
          Query.orderDesc('lastMessageAt'),
        ],
      );
      print('ChatRooms found: ${snap.documents.length}');
      currentRooms = snap.documents.map((doc) => ChatRoom.fromAppwrite(doc)).toList();
      if (!controller.isClosed) controller.add(currentRooms);
    } catch (e) {
      print('Error fetching chat rooms: $e');
    }
  }
  
  fetch();

  final subscription = realtime.subscribe(['databases.${env.appwriteDatabaseId}.collections.chat_rooms.documents']);
  
  subscription.stream.listen((event) {
    // Tối ưu: Chỉ fetch lại nếu payload liên quan đến user
    if (event.payload['participants']?.contains(uid) == true) {
      fetch(); 
    }
  });

  ref.onDispose(() {
    subscription.close();
    controller.close();
  });

  return controller.stream;
}

final unreadChatCountProvider = Provider<int>((ref) {
  final rooms = ref.watch(chatRoomsProvider).valueOrNull ?? [];
  final user = ref.watch(authStateProvider).valueOrNull;
  if (user == null) return 0;

  int total = 0;
  for (final room in rooms) {
    total += room.unreadCount[user.$id] ?? 0;
  }
  return total;
});

@riverpod
class ChatMessages extends _$ChatMessages {
  @override
  Future<List<ChatMessage>> build(String roomId) async {
    final env = ref.read(appEnvironmentProvider);
    final db = ref.read(appwriteDatabasesProvider);
    final realtime = ref.read(appwriteRealtimeProvider);

    final snap = await db.listDocuments(
      databaseId: env.appwriteDatabaseId,
      collectionId: 'chat_messages',
      queries: [
        Query.equal('roomId', roomId),
        Query.orderDesc('createdAt'),
        Query.limit(50),
      ],
    );

    final messages = snap.documents.map((doc) => ChatMessage.fromAppwrite(doc)).toList();

    final subscription = realtime.subscribe(['databases.${env.appwriteDatabaseId}.collections.chat_messages.documents']);
    
    final sub = subscription.stream.listen((event) {
      if (event.payload['roomId'] == roomId && 
          event.events.contains('databases.*.collections.chat_messages.documents.*.create')) {
        
        final newMessage = ChatMessage.fromAppwrite(models.Document.fromMap(event.payload));
        
        final currentData = state.valueOrNull ?? [];
        if (!currentData.any((m) => m.id == newMessage.id)) {
          state = AsyncValue.data([newMessage, ...currentData]);
        }
      }
    });

    ref.onDispose(() {
      sub.cancel();
      subscription.close();
    });

    return messages;
  }
}

@riverpod
Stream<Map<String, dynamic>> typingStatus(Ref ref, String roomId) {
  final env = ref.watch(appEnvironmentProvider);
  final realtime = ref.watch(appwriteRealtimeProvider);
  final controller = StreamController<Map<String, dynamic>>();

  final subscription = realtime.subscribe([
    'databases.${env.appwriteDatabaseId}.collections.chat_rooms.documents.$roomId'
  ]);

  final sub = subscription.stream.listen((event) {
    if (event.payload['typing'] != null) {
      controller.add(Map<String, dynamic>.from(event.payload['typing']));
    }
  });

  ref.onDispose(() {
    sub.cancel();
    subscription.close();
    controller.close();
  });

  return controller.stream;
}

// Giữ nguyên các hàm helper và notifier khác
@riverpod
class ChatNotifier extends _$ChatNotifier {
  @override
  FutureOr<void> build() {}

  Future<void> setTypingStatus(String roomId, String userId, bool isTyping) async {
    final env = ref.read(appEnvironmentProvider);
    final db = ref.read(appwriteDatabasesProvider);

    try {
      final room = await db.getDocument(
        databaseId: env.appwriteDatabaseId,
        collectionId: 'chat_rooms',
        documentId: roomId,
      );
      
      final Map<String, dynamic> typingMap = Map<String, dynamic>.from(room.data['typing'] ?? {});
      typingMap[userId] = isTyping;

      await db.updateDocument(
        databaseId: env.appwriteDatabaseId,
        collectionId: 'chat_rooms',
        documentId: roomId,
        data: {'typing': typingMap},
      );
    } catch (_) {}
  }

  Future<void> sendMessage(String roomId, String senderId, String text,
      String bookingId, List<String> participants,
      {ChatMessageType type = ChatMessageType.text,
      String imageUrl = ''}) async {
    final env = ref.read(appEnvironmentProvider);
    final db = ref.read(appwriteDatabasesProvider);

    final messageData = {
      'roomId': roomId,
      'senderId': senderId,
      'text': text,
      'type': type.name,
      'imageUrl': imageUrl,
      'createdAt': DateTime.now().toIso8601String(),
      'isRead': false,
    };

    await db.createDocument(
      databaseId: env.appwriteDatabaseId,
      collectionId: 'chat_messages',
      documentId: ID.unique(),
      data: messageData,
    );

    try {
      final roomDoc = await db.getDocument(
        databaseId: env.appwriteDatabaseId,
        collectionId: 'chat_rooms',
        documentId: roomId,
      );

      final Map<String, dynamic> unreadMap =
          Map<String, dynamic>.from(roomDoc.data['unreadCount'] ?? {});

      // Increment unread count for other participants
      for (final participantId in participants) {
        if (participantId != senderId) {
          unreadMap[participantId] = (unreadMap[participantId] ?? 0) + 1;
        }
      }

      await db.updateDocument(
        databaseId: env.appwriteDatabaseId,
        collectionId: 'chat_rooms',
        documentId: roomId,
        data: {
          'lastMessage': type == ChatMessageType.image ? '📷 Hình ảnh' : text,
          'lastMessageAt': DateTime.now().toIso8601String(),
          'participants': participants,
          'bookingId': bookingId,
          'unreadCount': unreadMap,
        },
      );
    } catch (_) {
      // If room doesn't exist, create it
      final Map<String, dynamic> unreadMap = {};
      for (final participantId in participants) {
        if (participantId != senderId) {
          unreadMap[participantId] = 1;
        }
      }

      await db.createDocument(
        databaseId: env.appwriteDatabaseId,
        collectionId: 'chat_rooms',
        documentId: roomId,
        data: {
          'lastMessage': type == ChatMessageType.image ? '📷 Hình ảnh' : text,
          'lastMessageAt': DateTime.now().toIso8601String(),
          'participants': participants,
          'bookingId': bookingId,
          'unreadCount': unreadMap,
        },
      );
    }
  }

  Future<void> sendImage(String roomId, String senderId, File imageFile,
      String bookingId, List<String> participants) async {
    final env = ref.read(appEnvironmentProvider);
    final storage = ref.read(appwriteStorageProvider);

    final result = await storage.createFile(
      bucketId: 'fixit_assets', // Dùng bucket hiện có
      fileId: ID.unique(),
      file: InputFile.fromPath(path: imageFile.path),
    );

    final url = _appwriteFileUrl(
      endpoint: env.appwriteEndpoint,
      projectId: env.appwriteProjectId,
      bucketId: 'fixit_assets',
      fileId: result.$id,
    );

    await sendMessage(roomId, senderId, '', bookingId, participants,
        type: ChatMessageType.image, imageUrl: url);
  }

  Future<void> markAsRead(String roomId, String userId) async {
    final env = ref.read(appEnvironmentProvider);
    final db = ref.read(appwriteDatabasesProvider);

    try {
      final roomDoc = await db.getDocument(
        databaseId: env.appwriteDatabaseId,
        collectionId: 'chat_rooms',
        documentId: roomId,
      );

      final Map<String, dynamic> unreadMap =
          Map<String, dynamic>.from(roomDoc.data['unreadCount'] ?? {});
      unreadMap[userId] = 0;

      await db.updateDocument(
        databaseId: env.appwriteDatabaseId,
        collectionId: 'chat_rooms',
        documentId: roomId,
        data: {'unreadCount': unreadMap},
      );

      // Also mark individual messages as read for this room (optional but good for UI consistency)
      final unreadMessages = await db.listDocuments(
        databaseId: env.appwriteDatabaseId,
        collectionId: 'chat_messages',
        queries: [
          Query.equal('roomId', roomId),
          Query.equal('isRead', false),
          Query.notEqual('senderId', userId),
        ],
      );

      for (final doc in unreadMessages.documents) {
        await db.updateDocument(
          databaseId: env.appwriteDatabaseId,
          collectionId: 'chat_messages',
          documentId: doc.$id,
          data: {'isRead': true},
        );
      }
    } catch (_) {}
  }
}

String _appwriteFileUrl({
  required String endpoint,
  required String projectId,
  required String bucketId,
  required String fileId,
}) {
  final cleanEndpoint = endpoint.replaceFirst(RegExp(r'/$'), '');
  return Uri.parse(
    '$cleanEndpoint/storage/buckets/${Uri.encodeComponent(bucketId)}'
    '/files/${Uri.encodeComponent(fileId)}/view',
  ).replace(queryParameters: {'project': projectId}).toString();
}

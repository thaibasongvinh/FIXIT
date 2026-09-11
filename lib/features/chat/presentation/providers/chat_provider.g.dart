// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$chatRoomsHash() => r'd674c5c88760091a6127a8be5f76182d878e8eff';

/// See also [chatRooms].
@ProviderFor(chatRooms)
final chatRoomsProvider = AutoDisposeStreamProvider<List<ChatRoom>>.internal(
  chatRooms,
  name: r'chatRoomsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$chatRoomsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef ChatRoomsRef = AutoDisposeStreamProviderRef<List<ChatRoom>>;
String _$typingStatusHash() => r'0aa4a9abfffb0af6ed5a275d8161fad0a19491bd';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [typingStatus].
@ProviderFor(typingStatus)
const typingStatusProvider = TypingStatusFamily();

/// See also [typingStatus].
class TypingStatusFamily extends Family<AsyncValue<Map<String, dynamic>>> {
  /// See also [typingStatus].
  const TypingStatusFamily();

  /// See also [typingStatus].
  TypingStatusProvider call(
    String roomId,
  ) {
    return TypingStatusProvider(
      roomId,
    );
  }

  @override
  TypingStatusProvider getProviderOverride(
    covariant TypingStatusProvider provider,
  ) {
    return call(
      provider.roomId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'typingStatusProvider';
}

/// See also [typingStatus].
class TypingStatusProvider
    extends AutoDisposeStreamProvider<Map<String, dynamic>> {
  /// See also [typingStatus].
  TypingStatusProvider(
    String roomId,
  ) : this._internal(
          (ref) => typingStatus(
            ref as TypingStatusRef,
            roomId,
          ),
          from: typingStatusProvider,
          name: r'typingStatusProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$typingStatusHash,
          dependencies: TypingStatusFamily._dependencies,
          allTransitiveDependencies:
              TypingStatusFamily._allTransitiveDependencies,
          roomId: roomId,
        );

  TypingStatusProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.roomId,
  }) : super.internal();

  final String roomId;

  @override
  Override overrideWith(
    Stream<Map<String, dynamic>> Function(TypingStatusRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: TypingStatusProvider._internal(
        (ref) => create(ref as TypingStatusRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        roomId: roomId,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<Map<String, dynamic>> createElement() {
    return _TypingStatusProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TypingStatusProvider && other.roomId == roomId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, roomId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin TypingStatusRef on AutoDisposeStreamProviderRef<Map<String, dynamic>> {
  /// The parameter `roomId` of this provider.
  String get roomId;
}

class _TypingStatusProviderElement
    extends AutoDisposeStreamProviderElement<Map<String, dynamic>>
    with TypingStatusRef {
  _TypingStatusProviderElement(super.provider);

  @override
  String get roomId => (origin as TypingStatusProvider).roomId;
}

String _$chatMessagesHash() => r'0a91e91d7eaedaae6909bcc63a315fe08b18c8e7';

abstract class _$ChatMessages
    extends BuildlessAutoDisposeAsyncNotifier<List<ChatMessage>> {
  late final String roomId;

  FutureOr<List<ChatMessage>> build(
    String roomId,
  );
}

/// See also [ChatMessages].
@ProviderFor(ChatMessages)
const chatMessagesProvider = ChatMessagesFamily();

/// See also [ChatMessages].
class ChatMessagesFamily extends Family<AsyncValue<List<ChatMessage>>> {
  /// See also [ChatMessages].
  const ChatMessagesFamily();

  /// See also [ChatMessages].
  ChatMessagesProvider call(
    String roomId,
  ) {
    return ChatMessagesProvider(
      roomId,
    );
  }

  @override
  ChatMessagesProvider getProviderOverride(
    covariant ChatMessagesProvider provider,
  ) {
    return call(
      provider.roomId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'chatMessagesProvider';
}

/// See also [ChatMessages].
class ChatMessagesProvider extends AutoDisposeAsyncNotifierProviderImpl<
    ChatMessages, List<ChatMessage>> {
  /// See also [ChatMessages].
  ChatMessagesProvider(
    String roomId,
  ) : this._internal(
          () => ChatMessages()..roomId = roomId,
          from: chatMessagesProvider,
          name: r'chatMessagesProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$chatMessagesHash,
          dependencies: ChatMessagesFamily._dependencies,
          allTransitiveDependencies:
              ChatMessagesFamily._allTransitiveDependencies,
          roomId: roomId,
        );

  ChatMessagesProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.roomId,
  }) : super.internal();

  final String roomId;

  @override
  FutureOr<List<ChatMessage>> runNotifierBuild(
    covariant ChatMessages notifier,
  ) {
    return notifier.build(
      roomId,
    );
  }

  @override
  Override overrideWith(ChatMessages Function() create) {
    return ProviderOverride(
      origin: this,
      override: ChatMessagesProvider._internal(
        () => create()..roomId = roomId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        roomId: roomId,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<ChatMessages, List<ChatMessage>>
      createElement() {
    return _ChatMessagesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ChatMessagesProvider && other.roomId == roomId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, roomId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin ChatMessagesRef
    on AutoDisposeAsyncNotifierProviderRef<List<ChatMessage>> {
  /// The parameter `roomId` of this provider.
  String get roomId;
}

class _ChatMessagesProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<ChatMessages,
        List<ChatMessage>> with ChatMessagesRef {
  _ChatMessagesProviderElement(super.provider);

  @override
  String get roomId => (origin as ChatMessagesProvider).roomId;
}

String _$chatNotifierHash() => r'33880d8852d4e1fe99f66beef2bd1d9b9c4c74a7';

/// See also [ChatNotifier].
@ProviderFor(ChatNotifier)
final chatNotifierProvider =
    AutoDisposeAsyncNotifierProvider<ChatNotifier, void>.internal(
  ChatNotifier.new,
  name: r'chatNotifierProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$chatNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ChatNotifier = AutoDisposeAsyncNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member

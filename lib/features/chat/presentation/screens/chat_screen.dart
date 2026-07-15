import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fixit/features/auth/presentation/providers/auth_provider.dart';
import 'package:fixit/core/presentation/widgets/app_background.dart';
import 'package:fixit/l10n/app_localizations.dart';
import '../providers/chat_provider.dart';
import '../widgets/chat_widgets.dart';

class ChatScreen extends ConsumerStatefulWidget {
  final String roomId;
  final String otherUserName;
  final String bookingId;
  final List<String> participants;

  const ChatScreen({
    super.key,
    required this.roomId,
    required this.otherUserName,
    this.bookingId = '',
    required this.participants,
  });

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final ImagePicker _picker = ImagePicker();
  Timer? _typingTimer;

  @override
  void initState() {
    super.initState();
    _markMessagesAsRead();
  }

  void _markMessagesAsRead() async {
    final currentUser = ref.read(currentUserProvider).valueOrNull;
    if (currentUser == null) return;

    await ref.read(chatNotifierProvider.notifier).markAsRead(widget.roomId, currentUser.uid);
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _typingTimer?.cancel();
    super.dispose();
  }

  void _onType() {
    final currentUser = ref.read(currentUserProvider).valueOrNull;
    if (currentUser == null) return;

    if (_typingTimer == null || !_typingTimer!.isActive) {
      ref.read(chatNotifierProvider.notifier).setTypingStatus(widget.roomId, currentUser.uid, true);
    }

    _typingTimer?.cancel();
    _typingTimer = Timer(const Duration(seconds: 2), () {
      ref.read(chatNotifierProvider.notifier).setTypingStatus(widget.roomId, currentUser.uid, false);
    });
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;
    
    final currentUser = ref.read(currentUserProvider).valueOrNull;
    if (currentUser == null) return;

    ref.read(chatNotifierProvider.notifier).sendMessage(
      widget.roomId,
      currentUser.uid,
      text,
      widget.bookingId,
      widget.participants,
    );
    _messageController.clear();
  }

  Future<void> _sendImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image == null) return;
    
    final currentUser = ref.read(currentUserProvider).valueOrNull;
    if (currentUser == null) return;

    await ref.read(chatNotifierProvider.notifier).sendImage(
      widget.roomId,
      currentUser.uid,
      File(image.path),
      widget.bookingId,
      widget.participants,
    );
  }

  @override
  Widget build(BuildContext context) {
    final messagesAsync = ref.watch(chatMessagesProvider(widget.roomId));
    final currentUser = ref.watch(currentUserProvider).valueOrNull;
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Listen for new messages to mark as read if the screen is active
    ref.listen(chatMessagesProvider(widget.roomId), (prev, next) {
      if (next.hasValue && next.value!.isNotEmpty) {
        final lastMessage = next.value!.first; 
        if (lastMessage.senderId != currentUser?.uid) {
          _markMessagesAsRead();
        }
      }
    });

    final appBarTitle = widget.otherUserName == 'User' ? 'Khách hàng' : widget.otherUserName;

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        centerTitle: true,
        title: Column(
          children: [
            Text(
              appBarTitle, 
              style: TextStyle(color: isDark ? Colors.white : const Color(0xFF1A1D1E), fontWeight: FontWeight.w900, fontSize: 17, letterSpacing: -0.5)
            ),
            const SizedBox(height: 2),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(width: 6, height: 6, decoration: const BoxDecoration(color: Colors.greenAccent, shape: BoxShape.circle)),
                const SizedBox(width: 4),
                Text('Đang trực tuyến', style: TextStyle(color: isDark ? Colors.white38 : Colors.grey, fontSize: 11, fontWeight: FontWeight.w500)),
              ],
            ),
          ],
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: isDark ? Colors.white : const Color(0xFF1A1D1E), size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.more_horiz_rounded, color: isDark ? Colors.white70 : Colors.grey),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: AppBackground(
        child: Column(
          children: [
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(top: 100), // Khoảng cách cho AppBar trong suốt
                decoration: BoxDecoration(
                  color: isDark ? Colors.black.withOpacity(0.2) : Colors.white.withOpacity(0.4),
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
                  border: Border.all(color: (isDark ? Colors.white : Colors.black).withOpacity(0.05)),
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                    child: messagesAsync.when(
                      data: (messages) => ListView.builder(
                        controller: _scrollController,
                        reverse: true,
                        padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
                        itemCount: messages.length,
                        itemBuilder: (context, index) {
                          final message = messages[index];
                          final isMe = message.senderId == currentUser?.uid;
                          return MessageBubble(message: message, isMe: isMe);
                        },
                      ),
                      loading: () => const Center(child: CircularProgressIndicator()),
                      error: (e, _) => Center(child: Text('Lỗi: $e')),
                    ),
                  ),
                ),
              ),
            ),
            _buildInputArea(l10n, isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildInputArea(AppLocalizations l10n, bool isDark) {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          padding: EdgeInsets.only(
            left: 16, 
            right: 16, 
            top: 12, 
            bottom: MediaQuery.of(context).padding.bottom + 12
          ),
          decoration: BoxDecoration(
            color: isDark ? Colors.black.withOpacity(0.4) : Colors.white.withOpacity(0.8), 
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            border: Border(top: BorderSide(color: (isDark ? Colors.white : Colors.black).withOpacity(0.05))),
          ),
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF005CB7).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(Icons.add_rounded, color: Color(0xFF005CB7), size: 24), 
                  onPressed: _sendImage
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: _messageController,
                  onChanged: (_) => _onType(),
                  style: TextStyle(color: isDark ? Colors.white : Colors.black, fontSize: 14),
                  decoration: InputDecoration(
                    hintText: 'Viết tin nhắn...',
                    hintStyle: TextStyle(color: isDark ? Colors.white24 : Colors.grey.shade400, fontSize: 14),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24), 
                      borderSide: BorderSide.none
                    ),
                    filled: true,
                    fillColor: isDark ? Colors.white.withOpacity(0.05) : const Color(0xFFF3F4F6),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  ),
                  onSubmitted: (_) => _sendMessage(),
                ),
              ),
              const SizedBox(width: 12),
              GestureDetector(
                onTap: _sendMessage,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                    color: Color(0xFF005CB7),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.send_rounded, color: Colors.white, size: 20),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gap/gap.dart';
import 'package:fixit/core/router/app_router.dart';
import 'package:fixit/features/auth/presentation/providers/auth_provider.dart';
import 'package:fixit/core/presentation/widgets/app_background.dart';
import '../providers/chat_provider.dart';

class ChatListScreen extends ConsumerWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chatRoomsAsync = ref.watch(chatRoomsProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Tin nhắn',
          style: TextStyle(
            color: isDark ? Colors.white : const Color(0xFF1A1D1E),
            fontSize: 20,
            fontWeight: FontWeight.w900,
            letterSpacing: -0.5,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: isDark ? Colors.white : const Color(0xFF1A1D1E), size: 20),
          onPressed: () => context.pop(),
        ),
      ),
      body: AppBackground(
        child: SafeArea(
          child: chatRoomsAsync.when(
            data: (rooms) {
              if (rooms.isEmpty) {
                return _buildEmptyState(isDark);
              }
              return ListView.separated(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
                itemCount: rooms.length,
                separatorBuilder: (_, __) => const Gap(12),
                itemBuilder: (context, index) {
                  final room = rooms[index];
                  final currentUser = ref.read(currentUserProvider).valueOrNull;
                  final unreadCount = room.unreadCount[currentUser?.uid] ?? 0;
                  
                  // Lấy thông tin hiển thị dựa trên dữ liệu mẫu
                  String displayName = 'Hỗ trợ kỹ thuật';
                  if (room.id.contains('nam')) displayName = 'Thợ Điện - Nguyễn Văn Nam';
                  else if (room.id.contains('tam')) displayName = 'Thợ Nước - Trần Minh Tâm';
                  else if (room.id.contains('hoang')) displayName = 'Thợ Lạnh - Lê Hoàng Long';
                  else if (room.id.contains('dung')) displayName = 'Thợ Mộc - Phạm Văn Dũng';
                  else if (room.id.contains('lan')) displayName = 'Vệ Sinh - Chị Lan';

                  return _buildChatCard(context, room, displayName, unreadCount, isDark);
                },
              );
            },
            loading: () => Center(child: CircularProgressIndicator(color: isDark ? Colors.white24 : Colors.black12)),
            error: (e, _) => Center(child: Text('Error: $e')),
          ),
        ),
      ),
    );
  }

  Widget _buildChatCard(BuildContext context, dynamic room, String displayName, int unreadCount, bool isDark) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: InkWell(
          onTap: () => context.push(
            '${AppRoutes.chat}/${room.id}', 
            extra: {
              'otherUserName': displayName,
              'participants': room.participants
            }
          ),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? Colors.white.withOpacity(0.05) : Colors.white.withOpacity(0.8),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: (isDark ? Colors.white : Colors.black).withOpacity(0.05),
              ),
              boxShadow: [
                if (!isDark)
                  BoxShadow(
                    color: Colors.black.withOpacity(0.02),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
              ],
            ),
            child: Row(
              children: [
                Stack(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFF005CB7).withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        displayName.contains('Thợ') ? Icons.engineering_rounded : Icons.support_agent_rounded, 
                        color: const Color(0xFF005CB7),
                        size: 26,
                      ),
                    ),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: Colors.greenAccent,
                          shape: BoxShape.circle,
                          border: Border.all(color: isDark ? const Color(0xFF010A1A) : Colors.white, width: 2),
                        ),
                      ),
                    ),
                  ],
                ),
                const Gap(16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        displayName,
                        style: TextStyle(
                          color: isDark ? Colors.white : const Color(0xFF1A1D1E),
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const Gap(4),
                      Text(
                        room.lastMessage,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: isDark ? Colors.white38 : Colors.grey.shade600,
                          fontSize: 13,
                          fontWeight: unreadCount > 0 ? FontWeight.w700 : FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                if (unreadCount > 0)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF005CB7),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      unreadCount.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                else
                  Icon(Icons.chevron_right_rounded, color: (isDark ? Colors.white : Colors.black).withOpacity(0.1)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.chat_bubble_outline_rounded, size: 80, color: (isDark ? Colors.white : Colors.black).withOpacity(0.05)),
          const Gap(16),
          Text(
            'Chưa có tin nhắn nào',
            style: TextStyle(color: (isDark ? Colors.white : Colors.black).withOpacity(0.2), fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

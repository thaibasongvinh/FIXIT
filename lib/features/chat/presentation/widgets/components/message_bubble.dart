import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../domain/models/message_model.dart';

class MessageBubble extends StatelessWidget {
  final ChatMessage message;
  final bool isMe;

  const MessageBubble({
    super.key, 
    required this.message, 
    required this.isMe
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      child: Column(
        crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (!isMe) ...[
                CircleAvatar(
                  radius: 14,
                  backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
                  child: Icon(Icons.person, size: 16, color: theme.colorScheme.primary),
                ),
                const SizedBox(width: 8),
              ],
              Flexible(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    gradient: isMe 
                      ? const LinearGradient(
                          colors: [Color(0xFF005CB7), Color(0xFF2450A4)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        )
                      : null,
                    color: isMe ? null : (isDark ? Colors.white.withOpacity(0.08) : const Color(0xFFF1F4F8)),
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(20),
                      topRight: const Radius.circular(20),
                      bottomLeft: Radius.circular(isMe ? 20 : 4),
                      bottomRight: Radius.circular(isMe ? 4 : 20),
                    ),
                    boxShadow: [
                      if (!isDark)
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 5,
                          offset: const Offset(0, 2),
                        ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                    children: [
                      if (message.type == ChatMessageType.image)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: CachedNetworkImage(
                            imageUrl: message.imageUrl, 
                            placeholder: (_, __) => Container(
                              width: 200, 
                              height: 200, 
                              color: Colors.black12,
                              child: const Center(child: CircularProgressIndicator(strokeWidth: 2))
                            ),
                            width: 220, 
                            fit: BoxFit.cover
                          ),
                        )
                      else
                        Text(
                          message.text,
                          style: TextStyle(
                            color: isMe ? Colors.white : (isDark ? const Color(0xFFE0E0E0) : Colors.black87),
                            fontSize: 14,
                            height: 1.4,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              if (isMe) const SizedBox(width: 4),
            ],
          ),
          const SizedBox(height: 4),
          Padding(
            padding: EdgeInsets.only(left: isMe ? 0 : 40, right: isMe ? 8 : 0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  DateFormat('HH:mm').format(message.createdAt),
                  style: TextStyle(
                    fontSize: 10,
                    color: isDark ? Colors.white38 : Colors.grey.shade500,
                  ),
                ),
                if (isMe) ...[
                  const SizedBox(width: 4),
                  Icon(
                    message.isRead ? Icons.done_all_rounded : Icons.done_rounded,
                    size: 14,
                    color: message.isRead ? Colors.blueAccent : Colors.grey.shade400,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

extension on Color {
  static const Color whiteee = Color(0xFFE0E0E0);
}

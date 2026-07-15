import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../../core/config/app_environment_provider.dart';
import '../../../../../../shared/models/user_model.dart';
import '../../../../../auth/presentation/providers/auth_provider.dart';

class ProfileAvatar extends ConsumerWidget {
  final UserModel user;
  final double size;

  const ProfileAvatar({super.key, required this.user, this.size = 110});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final env = ref.watch(appEnvironmentProvider);
    final authUser = ref.watch(authStateProvider).valueOrNull;
    
    // Chỉ sử dụng avatar từ Database, không lấy từ Prefs để tránh ảnh mặc định của hệ thống
    String effectiveAvatar = user.avatar;
    
    final initialsUrl = '${env.appwriteEndpoint}/avatars/initials?name=${Uri.encodeComponent(user.name.isEmpty ? '?' : user.name)}&project=${env.appwriteProjectId}';

    return Stack(
      alignment: Alignment.center,
      children: [
        // Glowing Background Circle
        Container(
          width: size + 16,
          height: size + 16,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                const Color(0xFF0054A5).withOpacity(0.15),
                const Color(0xFF0054A5).withOpacity(0.0),
              ],
            ),
          ),
        ),
        // Main Avatar Container
        Hero(
          tag: 'profile_avatar_${user.uid}',
          child: Container(
            width: size,
            height: size,
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF0054A5).withOpacity(0.12),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
              border: Border.all(
                color: const Color(0xFFE0E9FF),
                width: 2,
              ),
            ),
            child: ClipOval(
              child: effectiveAvatar.isNotEmpty 
                ? CachedNetworkImage(
                    imageUrl: effectiveAvatar,
                    fit: BoxFit.cover,
                    placeholder: (_, __) => _InitialPlaceholder(size: size, name: user.name, uid: user.uid),
                    errorWidget: (_, __, ___) => _InitialPlaceholder(size: size, name: user.name, uid: user.uid),
                  )
                : _InitialPlaceholder(size: size, name: user.name, uid: user.uid),
            ),
          ),
        ),
      ],
    );
  }
}

class MiniAvatar extends ConsumerWidget {
  final UserModel user;

  const MiniAvatar({super.key, required this.user});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final env = ref.watch(appEnvironmentProvider);
    
    // Chỉ sử dụng avatar từ Database
    String effectiveAvatar = user.avatar;
    
    final initialsUrl = '${env.appwriteEndpoint}/avatars/initials?name=${Uri.encodeComponent(user.name.isEmpty ? '?' : user.name)}&project=${env.appwriteProjectId}';

    return SizedBox(
      width: 28,
      height: 28,
      child: ClipOval(
        child: effectiveAvatar.isNotEmpty
          ? CachedNetworkImage(
              imageUrl: effectiveAvatar,
              fit: BoxFit.cover,
              placeholder: (_, __) => _InitialPlaceholder(size: 28, fontSize: 13, name: user.name, uid: user.uid),
              errorWidget: (_, __, ___) => _InitialPlaceholder(size: 28, fontSize: 13, name: user.name, uid: user.uid),
            )
          : _InitialPlaceholder(size: 28, fontSize: 13, name: user.name, uid: user.uid),
      ),
    );
  }
}

class _InitialPlaceholder extends StatelessWidget {
  final double size;
  final double? fontSize;
  final String? name;
  final String? uid;

  const _InitialPlaceholder({
    required this.size, 
    this.fontSize,
    this.name,
    this.uid,
  });

  List<Color> _getGradientColors(String? displayName) {
    // Siêu bảng màu Gradient (30+ phong cách cực phẩm, chuyên nghiệp)
    final gradients = [
      [const Color(0xFF0054A5), const Color(0xFF007BFF)], // Electric Blue
      [const Color(0xFF6A11CB), const Color(0xFF2575FC)], // Deep Purple-Blue
      [const Color(0xFF00B09B), const Color(0xFF96C93D)], // Mint Green
      [const Color(0xFFF093FB), const Color(0xFFF5576C)], // Soft Pink
      [const Color(0xFFFAD961), const Color(0xFFF76B1C)], // Sunset Orange
      [const Color(0xFF43E97B), const Color(0xFF38F9D7)], // Spring Green
      [const Color(0xFFFA709A), const Color(0xFFFEE140)], // Rose Gold
      [const Color(0xFF12C2E9), const Color(0xFFF64F59)], // JShine (Blue-Pink)
      [const Color(0xFF614385), const Color(0xFF516395)], // Man of Steel
      [const Color(0xFF02AAB0), const Color(0xFF00CDAC)], // Green Beach
      [const Color(0xFFFF5F6D), const Color(0xFFFFC371)], // Sweet Morning
      [const Color(0xFF2193B0), const Color(0xFF6DD5ED)], // Cool Sky
      [const Color(0xFFEE0979), const Color(0xFFFF6A00)], // Fire
      [const Color(0xFF4568DC), const Color(0xFFB06AB3)], // Deep Space
      [const Color(0xFF00C6FF), const Color(0xFF0072FF)], // Azure
      [const Color(0xFF91EAE4), const Color(0xFF7F7FD5)], // Sea Blue
      [const Color(0xFFDA22FF), const Color(0xFF9733EE)], // Violet
      [const Color(0xFF348F50), const Color(0xFF56B4D3)], // Forest
      [const Color(0xFF3CA55C), const Color(0xFFB5AC49)], // Moss
      [const Color(0xFFCC2B5E), const Color(0xFF753A88)], // Plum
      [const Color(0xFF2196F3), const Color(0xFFF44336)], // Red-Blue Mix
      [const Color(0xFF00F260), const Color(0xFF0575E6)], // Rainbow Blue
      [const Color(0xFFFF0099), const Color(0xFF493240)], // Cyberpunk
      [const Color(0xFF1D2671), const Color(0xFFC33764)], // Midnight City
      [const Color(0xFF000046), const Color(0xFF1CB5E0)], // Deep Ocean
      [const Color(0xFFFBD3E9), const Color(0xFFBB377D)], // Cherry Blossom
      [const Color(0xFF833AB4), const Color(0xFFFD1D1D)], // Instagram-ish
      [const Color(0xFF30CFD0), const Color(0xFF330867)], // Blue Diamond
      [const Color(0xFFFFE259), const Color(0xFFFFA751)], // Mango
      [const Color(0xFF74EBD5), const Color(0xFF9FACE6)], // Fresh Air
      [const Color(0xFF667EEA), const Color(0xFF764BA2)], // Premium Dark
      [const Color(0xFFB721FF), const Color(0xFF21D4FD)], // Neon soul
      [const Color(0xFF08203E), const Color(0xFF557C93)], // Dark Night
      [const Color(0xFF8E2DE2), const Color(0xFF4A00E0)], // Purple Love
    ];
    
    // Sử dụng hash code của Tên (hoặc UID làm dự phòng) để chọn màu cố định
    final seed = (displayName != null && displayName.trim().isNotEmpty) 
        ? displayName.trim() 
        : (uid == null || uid!.isEmpty ? '?' : uid!);
        
    final index = seed.hashCode.abs() % gradients.length;
    return gradients[index];
  }

  @override
  Widget build(BuildContext context) {
    String initials = '?';
    if (name != null && name!.trim().isNotEmpty) {
      final parts = name!.trim().split(' ');
      if (parts.length >= 2) {
        initials = (parts[0][0] + parts[parts.length - 1][0]).toUpperCase();
      } else {
        initials = parts[0][0].toUpperCase();
      }
    }

    final colors = _getGradientColors(name);

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: colors,
        ),
      ),
      child: Center(
        child: Text(
          initials,
          style: TextStyle(
            color: Colors.white,
            fontSize: fontSize ?? (size * 0.4),
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }
}

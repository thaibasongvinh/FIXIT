import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:fixit/features/admin/presentation/providers/admin_provider.dart';
import 'package:fixit/shared/models/user_model.dart';

import '../../../domain/models/admin_models.dart';

class AdminStaffRolesScreen extends ConsumerWidget {
  const AdminStaffRolesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final staffAsync = ref.watch(adminStaffProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : const Color(0xFF1A1C1E);

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF010A1A) : const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text('STAFF & PERMISSIONS', style: TextStyle(color: textColor, fontWeight: FontWeight.w900, fontSize: 13, letterSpacing: 2)),
        leading: IconButton(icon: Icon(Icons.arrow_back_ios_new, color: textColor, size: 18), onPressed: () => Navigator.pop(context)),
      ),
      body: Stack(
        children: [
          if (isDark)
            Container(decoration: const BoxDecoration(gradient: LinearGradient(colors: [Color(0xFF0D47A1), Color(0xFF010A1A), Colors.black], begin: Alignment.topLeft, end: Alignment.bottomRight))),
          SafeArea(
            child: staffAsync.when(
              data: (staff) => ListView.builder(
                padding: const EdgeInsets.all(20),
                itemCount: staff.length,
                itemBuilder: (context, index) => _buildStaffCard(staff[index], isDark, textColor),
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Error: $e')),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStaffCard(AppUser user, bool isDark, Color textColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.05)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 25,
            backgroundImage: NetworkImage(user.avatarUrl),
          ),
          const Gap(16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(user.name, style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 16)),
                Text(user.email, style: TextStyle(color: textColor.withValues(alpha: 0.4), fontSize: 12)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: _getRoleColor(user.role).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: _getRoleColor(user.role).withValues(alpha: 0.2)),
            ),
            child: Text(user.role.toUpperCase(), style: TextStyle(color: _getRoleColor(user.role), fontSize: 10, fontWeight: FontWeight.w900)),
          ),
        ],
      ),
    );
  }

  Color _getRoleColor(String role) {
    switch (role) {
      case 'admin': return Colors.redAccent;
      case 'moderator': return Colors.orangeAccent;
      case 'finance_manager': return Colors.greenAccent;
      case 'support_staff': return Colors.blueAccent;
      default: return Colors.blueGrey;
    }
  }
}

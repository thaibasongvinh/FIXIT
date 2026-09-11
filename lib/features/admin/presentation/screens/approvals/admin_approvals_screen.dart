import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:fixit/core/router/app_router.dart';
import 'package:fixit/shared/widgets/typography/translated_text.dart';
import 'package:fixit/core/services/translation_provider.dart';
import 'package:fixit/features/admin/presentation/providers/admin_provider.dart';
import 'package:fixit/features/admin/domain/models/admin_models.dart';
import 'package:fixit/shared/utils/snackbar_utils.dart';
import 'package:fixit/l10n/app_localizations.dart';

class AdminApprovalsScreen extends ConsumerWidget {
  const AdminApprovalsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appsAsync = ref.watch(pendingApplicationsProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;
    final textColor = isDark ? Colors.white : const Color(0xFF1A1C1E);
    final cardColor = isDark ? Colors.white.withValues(alpha: 0.05) : Colors.white;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF010A1A) : const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: TranslatedText(l10n.approvals.toUpperCase(), 
          style: TextStyle(color: textColor, fontWeight: FontWeight.w900, fontSize: 13, letterSpacing: 2)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: textColor, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          if (isDark)
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topRight, end: Alignment.bottomLeft,
                  colors: [Color(0xFF1565C0), Color(0xFF0D47A1), Color(0xFF010A1A)],
                ),
              ),
            ),
          
          appsAsync.when(
            data: (apps) => apps.isEmpty 
              ? _buildEmptyState(isDark)
              : ListView.separated(
                  padding: const EdgeInsets.fromLTRB(24, 10, 24, 40),
                  itemCount: apps.length,
                  separatorBuilder: (_, __) => const Gap(16),
                  itemBuilder: (context, index) => _buildApprovalCard(context, ref, apps[index], isDark, cardColor, textColor),
                ),
            loading: () => Center(child: CircularProgressIndicator(color: isDark ? Colors.white : Colors.blueAccent)),
            error: (e, _) => Center(child: Text('Error: $e', style: TextStyle(color: textColor))),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.verified_user_outlined, size: 80, color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.1)),
          const Gap(16),
          TranslatedText('All caught up!', style: TextStyle(color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.5), fontSize: 18, fontWeight: FontWeight.bold)),
          TranslatedText('No pending technician applications', style: TextStyle(color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.3))),
        ],
      ),
    );
  }

  Widget _buildApprovalCard(BuildContext context, WidgetRef ref, TechApplication app, bool isDark, Color cardColor, Color textColor) {
    final name = app.fullName;
    final service = app.specialty;
    final exp = app.experience;
    final docId = app.id;

    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: InkWell(
          onTap: () => context.push(AppRoutes.adminApplicationDetail.replaceAll(':id', docId)),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: textColor.withValues(alpha: 0.05)),
              boxShadow: isDark ? [] : [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 5))],
            ),
            child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 25,
                    backgroundColor: Colors.blueAccent.withValues(alpha: 0.1),
                    child: const Icon(Icons.person, color: Colors.blueAccent),
                  ),
                  const Gap(16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(name, style: TextStyle(color: textColor, fontSize: 18, fontWeight: FontWeight.bold)),
                        Text('$service • $exp years exp', style: TextStyle(color: textColor.withValues(alpha: 0.5), fontSize: 13)),
                      ],
                    ),
                  ),
                ],
              ),
              const Gap(20),
              Divider(color: textColor.withValues(alpha: 0.05)),
              const Gap(20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => _handleAction(context, ref, docId, 'rejected'),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.redAccent, width: 1.5),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: TranslatedText('REJECT', style: const TextStyle(color: Colors.redAccent, fontWeight: FontWeight.w900, fontSize: 12, letterSpacing: 1)),
                    ),
                  ),
                  const Gap(16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => _handleAction(context, ref, docId, 'approved'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.greenAccent,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        elevation: 0,
                      ),
                      child: TranslatedText('APPROVE', style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 12, letterSpacing: 1)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

  void _handleAction(BuildContext context, WidgetRef ref, String docId, String status) async {
    try {
      await ref.read(adminApplicationsProvider.notifier).updateStatus(docId, status);
      if (context.mounted) AppSnackbar.showSuccess(context, 'Application $status successfully');
    } catch (e) {
      if (context.mounted) AppSnackbar.showError(context, 'Error updating application: $e');
    }
  }
}

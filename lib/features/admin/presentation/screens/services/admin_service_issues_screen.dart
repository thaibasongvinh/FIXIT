import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:fixit/features/admin/presentation/providers/admin_provider.dart';
import 'package:fixit/features/marketplace/domain/models/service_issue_model.dart';
import 'package:fixit/shared/widgets/inputs/app_text_field.dart';
import 'package:fixit/shared/utils/snackbar_utils.dart';
import 'package:fixit/features/home/presentation/widgets/components/shimmer_loading.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fixit/core/config/app_environment_provider.dart';
import 'package:fixit/core/constants/app_constants.dart';
import 'package:fixit/features/admin/presentation/screens/services/admin_guide_steps_screen.dart';

class AdminServiceIssuesScreen extends ConsumerWidget {
  final String serviceId;
  final String serviceTitle;

  const AdminServiceIssuesScreen({
    super.key,
    required this.serviceId,
    required this.serviceTitle,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final issuesAsync = ref.watch(adminIssuesProvider(serviceId));
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark ? const Color(0xFF010A1A) : const Color(0xFFF5F7FA);
    final textColor = isDark ? Colors.white : const Color(0xFF1A1C1E);

    return Scaffold(
      backgroundColor: backgroundColor,
      extendBodyBehindAppBar: true,
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showEditDialog(context, ref, isDark),
        backgroundColor: Colors.blueAccent,
        child: const Icon(Icons.add_task_rounded, color: Colors.white),
      ),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(serviceTitle.toUpperCase(), 
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
                  begin: Alignment.topLeft, end: Alignment.bottomRight,
                  colors: [Color(0xFF0D47A1), Color(0xFF010A1A), Color(0xFF000000)],
                ),
              ),
            ),
          SafeArea(
            child: issuesAsync.when(
              data: (issues) => issues.isEmpty 
                ? _buildEmptyState(isDark)
                : ListView.builder(
                    padding: const EdgeInsets.all(20),
                    itemCount: issues.length,
                    itemBuilder: (context, index) => _buildIssueCard(context, ref, issues[index], isDark, textColor),
                  ),
              loading: () => _buildLoadingList(),
              error: (e, _) => Center(child: Text('Error: $e', style: const TextStyle(color: Colors.redAccent))),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIssueCard(BuildContext context, WidgetRef ref, ServiceIssueModel issue, bool isDark, Color textColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.05)),
        boxShadow: isDark ? [] : [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10)],
      ),
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: () => Navigator.push(
                context, 
                MaterialPageRoute(builder: (_) => AdminGuideStepsScreen(issueId: issue.id, issueTitle: issue.title))
              ),
              borderRadius: BorderRadius.circular(16),
              child: Row(
                children: [
                  Container(
                    width: 70, height: 70,
                    decoration: BoxDecoration(
                      color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: _buildIssueImage(ref, issue.imagePath),
                  ),
                  const Gap(16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(issue.title, 
                          style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 16)),
                        const Gap(4),
                        Text(issue.description, 
                          maxLines: 2, overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: textColor.withValues(alpha: 0.4), fontSize: 12)),
                      ],
                    ),
                  ),
                  Icon(Icons.chevron_right_rounded, color: textColor.withValues(alpha: 0.2), size: 24),
                  const Gap(8),
                ],
              ),
            ),
          ),
          const Gap(8),
          Column(
            children: [
              IconButton(
                onPressed: () => _showEditDialog(context, ref, isDark, issue: issue),
                icon: const Icon(Icons.edit_rounded, color: Colors.blueAccent, size: 20),
              ),
              IconButton(
                onPressed: () => _handleDelete(context, ref, issue, isDark),
                icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent, size: 20),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildIssueImage(WidgetRef ref, String path) {
    if (path.isEmpty) return const Icon(Icons.help_outline_rounded, color: Colors.white24);
    final env = ref.read(appEnvironmentProvider);
    final imageUrl = '${env.appwriteEndpoint}/storage/buckets/${AppwriteConstants.fixitAssetsBucketId}/files/${Uri.encodeComponent(path)}/view?project=${env.appwriteProjectId}';
    return CachedNetworkImage(
      imageUrl: imageUrl,
      fit: BoxFit.contain,
      placeholder: (context, url) => const ShimmerBox(width: 40, height: 40),
      errorWidget: (context, url, error) => Image.asset('assets/images/$path.png', 
        errorBuilder: (_, __, ___) => const Icon(Icons.image_not_supported_rounded, color: Colors.white10),
      ),
    );
  }

  void _showEditDialog(BuildContext context, WidgetRef ref, bool isDark, {ServiceIssueModel? issue}) {
    final titleController = TextEditingController(text: issue?.title ?? '');
    final descController = TextEditingController(text: issue?.description ?? '');
    final imageController = TextEditingController(text: issue?.imagePath ?? '');

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Dialog(
            backgroundColor: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                color: (isDark ? const Color(0xFF0D47A1) : Colors.white).withValues(alpha: isDark ? 0.4 : 0.95),
                borderRadius: BorderRadius.circular(35),
                border: Border.all(color: (isDark ? Colors.white : Colors.blueAccent).withValues(alpha: 0.2), width: 1.5),
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(issue == null ? 'ADD ISSUE' : 'EDIT ISSUE', 
                      style: TextStyle(color: isDark ? Colors.white : Colors.black, fontWeight: FontWeight.w900, fontSize: 20, letterSpacing: 1)),
                    const Gap(32),
                    AppTextField(controller: titleController, hint: 'Issue Title', label: 'TITLE', icon: Icons.title, darkTheme: isDark),
                    const Gap(20),
                    AppTextField(controller: descController, hint: 'Quick description', label: 'DESCRIPTION', icon: Icons.description, darkTheme: isDark),
                    const Gap(20),
                    AppTextField(controller: imageController, hint: 'File ID or Asset name', label: 'IMAGE', icon: Icons.image, darkTheme: isDark),
                    const Gap(32),
                    SizedBox(
                      width: double.infinity, height: 60,
                      child: ElevatedButton(
                        onPressed: () {
                          final data = {
                            'serviceId': serviceId,
                            'title': titleController.text.trim(),
                            'description': descController.text.trim(),
                            'imagePath': imageController.text.trim(),
                          };
                          if (issue == null) {
                            ref.read(adminIssuesProvider(serviceId).notifier).createIssue(data);
                          } else {
                            ref.read(adminIssuesProvider(serviceId).notifier).updateIssue(issue.id, data);
                          }
                          Navigator.pop(context);
                          AppSnackbar.showSuccess(context, 'Issue saved successfully');
                        },
                        style: ElevatedButton.styleFrom(backgroundColor: isDark ? Colors.white : Colors.blueAccent, foregroundColor: isDark ? Colors.blueAccent : Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
                        child: const Text('SAVE ISSUE', style: TextStyle(fontWeight: FontWeight.w900)),
                      ),
                    ),
                    const Gap(12),
                    TextButton(onPressed: () => Navigator.pop(context), child: Text('Cancel', style: TextStyle(color: isDark ? Colors.white30 : Colors.black26))),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _handleDelete(BuildContext context, WidgetRef ref, ServiceIssueModel issue, bool isDark) {
    showDialog(
      context: context,
      builder: (context) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(color: (isDark ? const Color(0xFF0D47A1) : Colors.white).withValues(alpha: isDark ? 0.4 : 0.95), borderRadius: BorderRadius.circular(35), border: Border.all(color: (isDark ? Colors.white : Colors.blueAccent).withValues(alpha: 0.2))),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.warning_amber_rounded, color: Colors.redAccent, size: 50),
                const Gap(24),
                Text('DELETE ISSUE?', style: TextStyle(color: isDark ? Colors.white : Colors.black, fontWeight: FontWeight.w900, fontSize: 20)),
                const Gap(12),
                Text('Are you sure you want to delete "${issue.title}"? This will also delete ALL related guides.', textAlign: TextAlign.center, style: TextStyle(color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.6))),
                const Gap(32),
                SizedBox(
                  width: double.infinity, height: 60,
                  child: ElevatedButton(
                    onPressed: () {
                      ref.read(adminIssuesProvider(serviceId).notifier).deleteIssue(issue.id);
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: isDark ? Colors.white : Colors.redAccent, foregroundColor: isDark ? Colors.redAccent : Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
                    child: const Text('DELETE NOW', style: TextStyle(fontWeight: FontWeight.w900)),
                  ),
                ),
                TextButton(onPressed: () => Navigator.pop(context), child: Text('Cancel', style: TextStyle(color: isDark ? Colors.white30 : Colors.black26))),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(bool isDark) => Center(child: Text('No issues found for this service', style: TextStyle(color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.2))));
  Widget _buildLoadingList() => const Center(child: CircularProgressIndicator(color: Colors.blueAccent));
}

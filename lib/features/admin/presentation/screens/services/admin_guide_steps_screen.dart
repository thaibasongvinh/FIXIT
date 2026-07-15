import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:fixit/features/admin/presentation/providers/admin_provider.dart';
import 'package:fixit/shared/widgets/inputs/app_text_field.dart';
import 'package:fixit/shared/utils/snackbar_utils.dart';
import 'package:fixit/l10n/app_localizations.dart';

class AdminGuideStepsScreen extends ConsumerWidget {
  final String issueId;
  final String issueTitle;

  const AdminGuideStepsScreen({
    super.key,
    required this.issueId,
    required this.issueTitle,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final guideAsync = ref.watch(adminGuideProvider(issueId));
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark ? const Color(0xFF010A1A) : const Color(0xFFF5F7FA);
    final textColor = isDark ? Colors.white : const Color(0xFF1A1C1E);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: isDark ? const Color(0xFF0D47A1) : Colors.white,
        elevation: isDark ? 0 : 1,
        centerTitle: true,
        title: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('MANAGE GUIDE', 
              style: TextStyle(color: isDark ? Colors.white : Colors.black, fontWeight: FontWeight.w900, fontSize: 13, letterSpacing: 2)),
            Text(issueTitle.toUpperCase(), 
              style: TextStyle(color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.6), fontSize: 10, fontWeight: FontWeight.bold)),
          ],
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: isDark ? Colors.white : Colors.black, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: isDark ? const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0D47A1), Color(0xFF010A1A), Color(0xFF000000)],
          ) : null,
        ),
        child: guideAsync.when(
          data: (guide) {
            if (guide == null) {
              return _buildNoGuideState(context, ref, isDark, textColor);
            }
            return _buildStepsList(context, ref, guide.id, isDark, textColor);
          },
          loading: () => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(color: isDark ? Colors.white : Colors.blueAccent),
                const Gap(20),
                Text('LOADING GUIDE DATA...', 
                  style: TextStyle(color: textColor.withValues(alpha: 0.7), fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1)),
              ],
            ),
          ),
          error: (e, st) => Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline_rounded, color: Colors.redAccent, size: 48),
                  const Gap(16),
                  Text('System Error: $e', 
                    textAlign: TextAlign.center,
                    style: TextStyle(color: textColor.withValues(alpha: 0.7), fontSize: 14)),
                  const Gap(24),
                  ElevatedButton(
                    onPressed: () => ref.invalidate(adminGuideProvider(issueId)),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: Colors.blueAccent),
                    child: const Text('RETRY'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNoGuideState(BuildContext context, WidgetRef ref, bool isDark, Color textColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.03),
              shape: BoxShape.circle,
              border: Border.all(color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.05)),
            ),
            child: Icon(Icons.menu_book_rounded, size: 80, color: Colors.blueAccent.withValues(alpha: 0.4)),
          ),
          const Gap(32),
          Text('No Instructions Yet', 
            textAlign: TextAlign.center,
            style: TextStyle(color: textColor, fontWeight: FontWeight.w900, fontSize: 22)),
          const Gap(12),
          Text('"$issueTitle" currently doesn\'t have any step-by-step repair guide.', 
            textAlign: TextAlign.center,
            style: TextStyle(color: textColor.withValues(alpha: 0.4), fontSize: 14, height: 1.5)),
          const Gap(48),
          SizedBox(
            width: double.infinity,
            height: 60,
            child: ElevatedButton.icon(
              onPressed: () => _handleCreateGuide(context, ref),
              icon: const Icon(Icons.add_circle_outline_rounded),
              label: const Text('CREATE GUIDE NOW', style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepsList(BuildContext context, WidgetRef ref, String guideId, bool isDark, Color textColor) {
    final stepsAsync = ref.watch(adminStepsProvider(guideId));

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(issueTitle, style: TextStyle(color: textColor, fontWeight: FontWeight.w900, fontSize: 18)),
                    const Gap(4),
                    Text('Manage Repair Instructions', style: TextStyle(color: textColor.withValues(alpha: 0.3), fontSize: 12)),
                  ],
                ),
              ),
              ElevatedButton.icon(
                onPressed: () => _showStepDialog(context, ref, guideId, isDark),
                icon: const Icon(Icons.add, size: 18),
                label: const Text('STEP'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent, 
                  foregroundColor: Colors.white, 
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  minimumSize: const Size(0, 40),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: stepsAsync.when(
            data: (steps) => steps.isEmpty 
              ? Center(child: Text('No steps added yet', style: TextStyle(color: textColor.withValues(alpha: 0.15))))
              : ListView.builder(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 40),
                  itemCount: steps.length,
                  itemBuilder: (context, index) {
                    final step = steps[index];
                    return _buildStepCard(context, ref, guideId, step, index, isDark, textColor);
                  },
                ),
            loading: () => Center(child: CircularProgressIndicator(color: isDark ? Colors.white : Colors.blueAccent)),
            error: (e, _) => Center(child: Text('Steps error: $e', style: const TextStyle(color: Colors.redAccent))),
          ),
        ),
      ],
    );
  }

  Widget _buildStepCard(BuildContext context, WidgetRef ref, String guideId, Map<String, dynamic> step, int index, bool isDark, Color textColor) {
    final String content = step['content'] ?? step['instruction'] ?? step['title'] ?? 'Empty step content';
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.025),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.05)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32, height: 32,
            decoration: BoxDecoration(
              color: Colors.blueAccent.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(child: Text('${index + 1}', style: const TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.w900))),
          ),
          const Gap(16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(content, style: TextStyle(color: textColor, fontSize: 15, height: 1.6)),
                if (step['warningNote'] != null && step['warningNote'].toString().isNotEmpty)
                  Container(
                    margin: const EdgeInsets.only(top: 12),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.redAccent.withValues(alpha: 0.05), 
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.redAccent.withValues(alpha: 0.1)),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.warning_amber_rounded, color: Colors.redAccent, size: 16),
                        const Gap(10),
                        Expanded(child: Text(step['warningNote'], style: const TextStyle(color: Colors.redAccent, fontSize: 11, height: 1.4))),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          const Gap(12),
          Column(
            children: [
              _buildActionButton(Icons.edit_rounded, isDark ? Colors.white24 : Colors.black26, () => _showStepDialog(context, ref, guideId, isDark, step: step)),
              const Gap(12),
              _buildActionButton(Icons.delete_outline_rounded, Colors.redAccent.withValues(alpha: 0.2), () => _handleDeleteStep(context, ref, guideId, step['\$id'])),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(IconData icon, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: color.withValues(alpha: 0.05), borderRadius: BorderRadius.circular(8)),
        child: Icon(icon, color: color, size: 18),
      ),
    );
  }

  void _handleCreateGuide(BuildContext context, WidgetRef ref) async {
    final data = {
      'issueId': issueId,
      'title': 'How to fix $issueTitle',
      'description': 'A detailed guide for repairing $issueTitle',
      'device': 'All related',
      'category': 'General',
      'difficulty': 'medium',
      'authorId': 'admin',
      'authorName': 'FixIt Admin',
      'coverImage': '',
      'slug': 'fix-${issueId.substring(0, 5)}',
      'estimatedTime': 15,
    };
    try {
      await ref.read(adminGuideProvider(issueId).notifier).createGuide(data);
      AppSnackbar.showSuccess(context, 'Guide base created successfully!');
    } catch (e) {
      AppSnackbar.showError(context, 'Failed to create guide: $e');
    }
  }

  void _showStepDialog(BuildContext context, WidgetRef ref, String guideId, bool isDark, {Map<String, dynamic>? step}) {
    final contentController = TextEditingController(text: step?['content'] ?? step?['instruction'] ?? '');
    final warningController = TextEditingController(text: step?['warningNote'] ?? '');

    showDialog(
      context: context,
      builder: (context) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: (isDark ? const Color(0xFF0D47A1) : Colors.white).withValues(alpha: isDark ? 0.8 : 0.95), 
              borderRadius: BorderRadius.circular(35), 
              border: Border.all(color: (isDark ? Colors.white : Colors.blueAccent).withValues(alpha: 0.2), width: 1.5)
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(step == null ? 'ADD NEW STEP' : 'EDIT STEP', 
                    style: TextStyle(color: isDark ? Colors.white : Colors.black, fontWeight: FontWeight.w900, fontSize: 18, letterSpacing: 0.5)),
                  const Gap(32),
                  AppTextField(controller: contentController, hint: 'Describe this step...', label: 'INSTRUCTION CONTENT', icon: Icons.text_fields, darkTheme: isDark),
                  const Gap(24),
                  AppTextField(controller: warningController, hint: 'Any safety warnings?', label: 'SAFETY WARNING (OPTIONAL)', icon: Icons.warning_amber, darkTheme: isDark),
                  const Gap(40),
                  SizedBox(
                    width: double.infinity, height: 62,
                    child: ElevatedButton(
                      onPressed: () {
                        if (contentController.text.isEmpty) return;
                        final data = {
                          'guideId': guideId,
                          'content': contentController.text.trim(),
                          'instruction': contentController.text.trim(),
                          'warningNote': warningController.text.trim(),
                          'stepNumber': step?['stepNumber'] ?? 1,
                        };
                        if (step == null) {
                          ref.read(adminStepsProvider(guideId).notifier).createStep(data);
                        } else {
                          ref.read(adminStepsProvider(guideId).notifier).updateStep(step['\$id'], data);
                        }
                        Navigator.pop(context);
                        AppSnackbar.showSuccess(context, 'Step saved');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isDark ? Colors.white : Colors.blueAccent, 
                        foregroundColor: isDark ? Colors.blueAccent : Colors.white, 
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      child: const Text('CONFIRM & SAVE', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 15)),
                    ),
                  ),
                  const Gap(12),
                  TextButton(onPressed: () => Navigator.pop(context), child: Text('Cancel', style: TextStyle(color: isDark ? Colors.white30 : Colors.black26, fontWeight: FontWeight.bold))),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _handleDeleteStep(BuildContext context, WidgetRef ref, String guideId, String? stepId) {
    if (stepId == null) return;
    ref.read(adminStepsProvider(guideId).notifier).deleteStep(stepId);
    AppSnackbar.showSuccess(context, 'Step removed');
  }
}

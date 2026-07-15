import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:fixit/core/utils/appwrite_utils.dart';
import 'package:fixit/features/admin/presentation/providers/admin_provider.dart';
import 'package:fixit/features/admin/domain/models/admin_models.dart';
import 'package:fixit/shared/utils/snackbar_utils.dart';
import 'package:fixit/l10n/app_localizations.dart';
import 'package:fixit/core/utils/service_translation_helper.dart';
import 'package:intl/intl.dart';

final applicationDetailProvider = FutureProvider.family<TechApplication, String>((ref, id) {
  return ref.watch(adminRepositoryProvider).getApplicationById(id);
});

class AdminApplicationDetailScreen extends ConsumerWidget {
  final String applicationId;
  const AdminApplicationDetailScreen({super.key, required this.applicationId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appAsync = ref.watch(applicationDetailProvider(applicationId));
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : const Color(0xFF1A1C1E);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF010A1A) : const Color(0xFFF5F7FA),
      body: appAsync.when(
        data: (app) => _buildContent(context, ref, app, isDark, textColor, l10n),
        loading: () => Center(child: CircularProgressIndicator(color: isDark ? Colors.white : Colors.blueAccent)),
        error: (e, _) => Center(child: Text(l10n.error(e.toString()), style: TextStyle(color: textColor))),
      ),
    );
  }

  Widget _buildContent(BuildContext context, WidgetRef ref, TechApplication app, bool isDark, Color textColor, AppLocalizations l10n) {
    return Stack(
      children: [
        if (isDark)
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight, end: Alignment.bottomLeft,
                colors: [Color(0xFF0D47A1), Color(0xFF010A1A), Color(0xFF000000)],
              ),
            ),
          ),
        
        CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            _buildSliverAppBar(context, app, isDark),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(24, 32, 24, 150), // Tăng padding bottom để tránh đè nút
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  _buildSectionTitle(l10n.systemMode, isDark, textColor), // Dùng systemMode làm THÔNG TIN CƠ BẢN (tạm thời nếu ko có key khớp)
                  const Gap(16),
                  _buildInfoCard([
                    _buildInfoRow(Icons.person_rounded, l10n.fullName, app.fullName, isDark, textColor),
                    const Divider(height: 32, color: Colors.white10),
                    _buildInfoRow(Icons.work_rounded, l10n.skills, app.specialty.translateService(context), isDark, textColor),
                    const Divider(height: 32, color: Colors.white10),
                    _buildInfoRow(Icons.history_edu_rounded, l10n.experience, app.experience.replaceAll('năm', l10n.years), isDark, textColor),
                    const Divider(height: 32, color: Colors.white10),
                    _buildInfoRow(Icons.calendar_today_rounded, 'Ngày đăng ký', DateFormat('dd MMMM, yyyy').format(app.createdAt), isDark, textColor),
                  ], isDark, textColor),
                  const Gap(40),
                  
                  _buildSectionTitle('CHI TIẾT CHUYÊN MÔN', isDark, textColor),
                  const Gap(16),
                  _buildInfoCard([
                    _buildInfoRow(Icons.business_rounded, 'Tên doanh nghiệp', app.businessName ?? 'N/A', isDark, textColor),
                    const Divider(height: 32, color: Colors.white10),
                    _buildInfoRow(Icons.location_on_rounded, l10n.serviceArea, app.businessAddress ?? 'N/A', isDark, textColor),
                    const Divider(height: 32, color: Colors.white10),
                    _buildInfoRow(Icons.radar_rounded, l10n.serviceRadius, '${app.serviceRadius.toInt()} km', isDark, textColor),
                    const Divider(height: 32, color: Colors.white10),
                    _buildInfoRow(Icons.access_time_filled_rounded, l10n.workSchedule, 
                      app.workSchedule == 'allWeek' ? l10n.allWeek : 
                      app.workSchedule == 'officeHours' ? l10n.officeHours : 
                      app.workSchedule == 'weekendsOnly' ? l10n.weekendsOnly : (app.workSchedule ?? 'N/A'), 
                      isDark, textColor),
                    const Divider(height: 32, color: Colors.white10),
                    _buildInfoRow(Icons.payments_rounded, l10n.hourlyRate, '${NumberFormat('#,###').format(app.hourlyRate)} VND/giờ', isDark, textColor),
                  ], isDark, textColor),
                  const Gap(40),

                  _buildSectionTitle(l10n.identityVerification.toUpperCase(), isDark, textColor),
                  const Gap(16),
                  _buildInfoCard([
                    _buildInfoRow(Icons.badge_rounded, l10n.idNumber, app.identityNumber ?? 'N/A', isDark, textColor),
                  ], isDark, textColor),
                  const Gap(16),
                  Row(
                    children: [
                      Expanded(child: _buildIdCardPreview('MẶT TRƯỚC', app.identityCardFront, isDark, textColor)),
                      const Gap(16),
                      Expanded(child: _buildIdCardPreview('MẶT SAU', app.identityCardBack, isDark, textColor)),
                    ],
                  ),
                  const Gap(40),

                  _buildSectionTitle(l10n.aboutMe.toUpperCase(), isDark, textColor),
                  const Gap(16),
                  _buildInfoCard([
                    Text(app.additionalInfo ?? 'Không có thông tin bổ sung.', 
                      style: TextStyle(color: textColor, height: 1.5)),
                  ], isDark, textColor),
                  const Gap(40),

                  _buildSectionTitle('CHỨNG CHỈ & TÀI LIỆU', isDark, textColor),
                  const Gap(16),
                  _buildDocumentsGrid(app.documents, isDark, textColor),
                ]),
              ),
            ),
          ],
        ),

        if (app.status == 'pending')
        Positioned(
          bottom: 0, left: 0, right: 0,
          child: _buildActionButtons(context, ref, app, isDark, l10n),
        ),
      ],
    );
  }

  Widget _buildSliverAppBar(BuildContext context, TechApplication app, bool isDark) {
    return SliverAppBar(
      expandedHeight: 280,
      backgroundColor: Colors.transparent,
      pinned: true,
      stretch: true,
      elevation: 0,
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CircleAvatar(
          backgroundColor: Colors.black26,
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 16),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        stretchModes: const [StretchMode.zoomBackground, StretchMode.blurBackground],
        background: Stack(
          fit: StackFit.expand,
          children: [
            if (app.profileImage != null && app.profileImage!.isNotEmpty)
              Image.network(app.profileImage!, fit: BoxFit.cover)
            else
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft, end: Alignment.bottomRight,
                    colors: [Colors.blueAccent.withValues(alpha: 0.2), Colors.blueAccent.withValues(alpha: 0.05)],
                  ),
                ),
                child: Icon(Icons.person_rounded, size: 120, color: Colors.blueAccent.withValues(alpha: 0.2)),
              ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter, end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.4),
                    Colors.transparent,
                    isDark ? const Color(0xFF010A1A) : const Color(0xFFF5F7FA),
                  ],
                  stops: const [0.0, 0.5, 1.0],
                ),
              ),
            ),
          ],
        ),
        title: Text(app.fullName.toUpperCase(), 
          style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: Colors.white, letterSpacing: 1)),
        centerTitle: true,
      ),
    );
  }

  Widget _buildSectionTitle(String title, bool isDark, Color textColor) {
    return Text(
      title,
      style: TextStyle(color: textColor.withValues(alpha: 0.3), fontWeight: FontWeight.w900, letterSpacing: 1.5, fontSize: 10),
    );
  }

  Widget _buildIdCardPreview(String label, String? url, bool isDark, Color textColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: textColor.withValues(alpha: 0.3), fontWeight: FontWeight.bold, fontSize: 10)),
        const Gap(8),
        Container(
          height: 120,
          width: double.infinity,
          decoration: BoxDecoration(
            color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: textColor.withValues(alpha: 0.05)),
          ),
          child: url != null && url.isNotEmpty
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    url,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => _buildPlaceholderIcon(isDark),
                  ),
                )
              : _buildPlaceholderIcon(isDark),
        ),
      ],
    );
  }

  Widget _buildPlaceholderIcon(bool isDark) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          'assets/images/Verification.png',
          width: 48,
          height: 48,
        ),
        const Gap(8),
        const Text(
          'CHƯA CÓ ẢNH',
          style: TextStyle(
            color: Colors.white24,
            fontSize: 10,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard(List<Widget> children, bool isDark, Color textColor) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.03) : Colors.white,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.05)),
        boxShadow: isDark ? [] : [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 20, offset: const Offset(0, 10))],
      ),
      child: Column(children: children),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value, bool isDark, Color textColor) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.blueAccent.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(icon, color: Colors.blueAccent, size: 22),
        ),
        const Gap(20),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: TextStyle(color: textColor.withValues(alpha: 0.4), fontSize: 11, fontWeight: FontWeight.w500)),
              const Gap(2),
              Text(value, style: TextStyle(color: textColor, fontSize: 16, fontWeight: FontWeight.w800, letterSpacing: -0.2)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDocumentsGrid(List<String>? certs, bool isDark, Color textColor) {
    if (certs == null || certs.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(40),
        width: double.infinity,
        decoration: BoxDecoration(
          color: isDark ? Colors.white.withValues(alpha: 0.02) : Colors.white,
          borderRadius: BorderRadius.circular(32),
          border: Border.all(color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.05), style: BorderStyle.solid),
        ),
        child: Column(
          children: [
            Icon(Icons.folder_off_rounded, color: textColor.withValues(alpha: 0.1), size: 48),
            const Gap(12),
            Text('Không có tài liệu đính kèm', style: TextStyle(color: textColor.withValues(alpha: 0.2), fontWeight: FontWeight.bold, fontSize: 13)),
          ],
        ),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, crossAxisSpacing: 16, mainAxisSpacing: 16, childAspectRatio: 1.2,
      ),
      itemCount: certs.length,
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: textColor.withValues(alpha: 0.05)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.description_rounded, color: Colors.blueAccent.withValues(alpha: 0.5), size: 32),
              const Gap(8),
              Text('Document ${index + 1}', style: TextStyle(color: textColor.withValues(alpha: 0.4), fontSize: 12, fontWeight: FontWeight.bold)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildActionButtons(BuildContext context, WidgetRef ref, TechApplication app, bool isDark, AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 40),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter, end: Alignment.bottomCenter,
          colors: [
            (isDark ? const Color(0xFF010A1A) : const Color(0xFFF5F7FA)).withValues(alpha: 0),
            (isDark ? const Color(0xFF010A1A) : const Color(0xFFF5F7FA)).withValues(alpha: 0.95),
            isDark ? const Color(0xFF010A1A) : const Color(0xFFF5F7FA),
          ],
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 64,
              child: ElevatedButton(
                onPressed: () => _handleAction(context, ref, app.id, 'rejected'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF5252).withValues(alpha: 0.1),
                  foregroundColor: const Color(0xFFFF5252),
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: const BorderSide(color: Color(0xFFFF5252), width: 1.5)),
                ),
                child: Text(l10n.rejected.toUpperCase(), style: const TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1.5, fontSize: 13)),
              ),
            ),
          ),
          const Gap(16),
          Expanded(
            child: SizedBox(
              height: 64,
              child: ElevatedButton(
                onPressed: () => _handleAction(context, ref, app.id, 'approved'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00E676),
                  foregroundColor: Colors.black,
                  elevation: 8,
                  shadowColor: const Color(0xFF00E676).withValues(alpha: 0.3),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                ),
                child: Text(l10n.approved.toUpperCase(), style: const TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1.5, fontSize: 13)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleAction(BuildContext context, WidgetRef ref, String docId, String status) async {
    try {
      await ref.read(adminApplicationsProvider.notifier).updateStatus(docId, status);
      if (context.mounted) {
        AppSnackbar.showSuccess(context, 'Application ${status.toUpperCase()} successfully');
        Navigator.pop(context);
      }
    } catch (e) {
      if (context.mounted) AppSnackbar.showError(context, 'Error: $e');
    }
  }
}

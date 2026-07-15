import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:fixit/features/admin/presentation/providers/admin_provider.dart';
import 'package:fixit/shared/widgets/inputs/app_text_field.dart';
import 'package:fixit/shared/utils/snackbar_utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fixit/core/config/app_environment_provider.dart';
import 'package:fixit/core/constants/app_constants.dart';
import 'package:fixit/features/home/presentation/widgets/components/shimmer_loading.dart';

import 'package:image_picker/image_picker.dart';

class AdminBannersScreen extends ConsumerWidget {
  const AdminBannersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bannersAsync = ref.watch(adminBannersProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark ? const Color(0xFF010A1A) : const Color(0xFFF5F7FA);
    final textColor = isDark ? Colors.white : const Color(0xFF1A1C1E);

    return Scaffold(
      backgroundColor: backgroundColor,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showEditDialog(context, ref, isDark),
        backgroundColor: Colors.blueAccent,
        icon: const Icon(Icons.add_photo_alternate_rounded, color: Colors.white),
        label: const Text('NEW CAMPAIGN', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, letterSpacing: 0.5)),
      ),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text('BANNER CAMPAIGNS', 
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
            child: bannersAsync.when(
              data: (banners) => banners.isEmpty 
                ? _buildEmptyState(textColor)
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                    itemCount: banners.length,
                    itemBuilder: (context, index) => _buildBannerCard(context, ref, banners[index], isDark, textColor),
                  ),
              loading: () => _buildShimmerList(isDark),
              error: (e, _) => Center(child: Text('Error: $e', style: const TextStyle(color: Colors.redAccent))),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerList(bool isDark) {
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: 3,
      itemBuilder: (context, index) => Container(
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.03),
          borderRadius: BorderRadius.circular(28),
        ),
        child: Column(
          children: [
            ShimmerBox(width: double.infinity, height: 140, borderRadius: 28),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const ShimmerBox(width: 150, height: 20),
                  const Spacer(),
                  const ShimmerBox(width: 32, height: 32, borderRadius: 10),
                  const Gap(12),
                  const ShimmerBox(width: 32, height: 32, borderRadius: 10),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBannerCard(BuildContext context, WidgetRef ref, Map<String, dynamic> banner, bool isDark, Color textColor) {
    final bool isActive = banner['isActive'] ?? true;
    final String title = banner['title'] ?? 'Untitled';
    final String subtitle = banner['subtitle'] ?? 'No Description';
    final String? imageId = banner['image'];
    final List<dynamic> colors = banner['colors'] ?? ['#1565C0', '#0D47A1'];
    
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.05)),
      ),
      child: Column(
        children: [
          Container(
            height: 140,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
              gradient: LinearGradient(
                colors: colors.map((c) => Color(int.parse(c.toString().replaceFirst('#', '0xFF')))).toList(),
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
              child: Stack(
                children: [
                  Positioned(
                    right: -20, bottom: -10,
                    child: Opacity(
                      opacity: 0.8,
                      child: _buildBannerImage(ref, imageId, width: 180),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(title.toUpperCase(), 
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 20, letterSpacing: -0.5)),
                        Text(subtitle, 
                          style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 12, fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: (isActive ? Colors.greenAccent : Colors.redAccent).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(isActive ? 'LIVE' : 'INACTIVE', 
                    style: TextStyle(color: isActive ? Colors.greenAccent : Colors.redAccent, fontSize: 9, fontWeight: FontWeight.w900)),
                ),
                const Spacer(),
                _buildSmallActionBtn(Icons.edit_rounded, Colors.blueAccent, () => _showEditDialog(context, ref, isDark, banner: banner)),
                const Gap(12),
                _buildSmallActionBtn(Icons.delete_outline_rounded, Colors.redAccent, () {
                  if (isActive) {
                    AppSnackbar.showError(context, 'Vui lòng vô hiệu hóa banner này trước khi xóa!');
                    return;
                  }
                  _handleDelete(context, ref, banner['\$id'], isDark);
                }),
                const Gap(8),
                Transform.scale(
                  scale: 0.7,
                  child: Switch(
                    value: isActive,
                    onChanged: (val) {
                      ref.read(adminBannersProvider.notifier).updateBanner(banner['\$id'], {'isActive': val});
                    },
                    activeColor: Colors.greenAccent,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSmallActionBtn(IconData icon, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
        child: Icon(icon, color: color, size: 18),
      ),
    );
  }

  Widget _buildBannerImage(WidgetRef ref, String? path, {double? width}) {
    if (path == null || path.isEmpty) return const Icon(Icons.image_rounded, color: Colors.white10, size: 60);
    
    final env = ref.read(appEnvironmentProvider);
    final imageUrl = '${env.appwriteEndpoint}/storage/buckets/${AppwriteConstants.fixitAssetsBucketId}/files/${Uri.encodeComponent(path)}/view?project=${env.appwriteProjectId}';

    return CachedNetworkImage(
      imageUrl: imageUrl,
      width: width,
      fit: BoxFit.contain,
      errorWidget: (context, url, error) {
        String assetPath = path;
        if (!assetPath.startsWith('assets/')) assetPath = 'assets/images/$assetPath';
        if (!assetPath.contains('.')) assetPath = '$assetPath.png';
        return Image.asset(assetPath, width: width, fit: BoxFit.contain, errorBuilder: (_, __, ___) => const Icon(Icons.broken_image_rounded, color: Colors.white10));
      },
    );
  }

  void _showEditDialog(BuildContext context, WidgetRef ref, bool isDark, {Map<String, dynamic>? banner}) {
    final titleController = TextEditingController(text: banner?['title'] ?? '');
    final subtitleController = TextEditingController(text: banner?['subtitle'] ?? '');
    final imageController = TextEditingController(text: banner?['image'] ?? '');
    final colorsController = TextEditingController(text: (banner?['colors'] as List?)?.join(', ') ?? '#1565C0, #0D47A1');

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          void _refresh() => setState(() {});

          return BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Dialog(
              backgroundColor: Colors.transparent,
              insetPadding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: (isDark ? const Color(0xFF0D47A1) : Colors.white).withValues(alpha: isDark ? 0.8 : 0.98),
                  borderRadius: BorderRadius.circular(35),
                  border: Border.all(color: (isDark ? Colors.white : Colors.blueAccent).withValues(alpha: 0.2), width: 1.5),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(banner == null ? 'NEW CAMPAIGN' : 'EDIT CAMPAIGN', 
                        style: TextStyle(color: isDark ? Colors.white : Colors.black, fontWeight: FontWeight.w900, fontSize: 20, letterSpacing: 0.5)),
                      const Gap(24),
                      const Align(alignment: Alignment.centerLeft, child: Text('LIVE PREVIEW:', style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.w900, fontSize: 10))),
                      const Gap(12),
                      _buildPreviewCard(ref, titleController.text, subtitleController.text, imageController.text, colorsController.text),
                      const Gap(32),
                      AppTextField(controller: titleController, hint: 'e.g. Sửa nhà nhanh', label: 'TITLE', icon: Icons.title, darkTheme: isDark),
                      const Gap(20),
                      AppTextField(controller: subtitleController, hint: 'e.g. Sale 20%', label: 'SUBTITLE', icon: Icons.text_snippet, darkTheme: isDark),
                      const Gap(20),
                      Row(
                        children: [
                          Expanded(
                            child: AppTextField(controller: imageController, hint: 'File ID (image_83_21)', label: 'IMAGE ID', icon: Icons.image, darkTheme: isDark),
                          ),
                          const Gap(12),
                          _buildImagePickerButton(context, ref, imageController, setState, isDark),
                        ],
                      ),
                      const Gap(20),
                      AppTextField(controller: colorsController, hint: '#HEX1, #HEX2', label: 'GRADIENT COLORS', icon: Icons.color_lens, darkTheme: isDark),
                      const Gap(40),
                      SizedBox(
                        width: double.infinity, height: 60,
                        child: ElevatedButton(
                          onPressed: () {
                            final List<String> colorList = colorsController.text.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
                            final data = {
                              'title': titleController.text.trim(),
                              'subtitle': subtitleController.text.trim(),
                              'image': imageController.text.trim(),
                              'colors': colorList,
                              'isActive': banner?['isActive'] ?? true,
                            };
                            if (banner == null) {
                              ref.read(adminBannersProvider.notifier).createBanner(data);
                            } else {
                              ref.read(adminBannersProvider.notifier).updateBanner(banner['\$id'], data);
                            }
                            Navigator.pop(context);
                            AppSnackbar.showSuccess(context, 'Campaign synchronized');
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isDark ? Colors.white : Colors.blueAccent, 
                            foregroundColor: isDark ? Colors.blueAccent : Colors.white, 
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          ),
                          child: const Text('CONFIRM & DEPLOY', style: TextStyle(fontWeight: FontWeight.w900)),
                        ),
                      ),
                      const Gap(12),
                      TextButton(onPressed: () => Navigator.pop(context), child: Text('Cancel', style: TextStyle(color: isDark ? Colors.white30 : Colors.black26, fontWeight: FontWeight.bold))),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPreviewCard(WidgetRef ref, String title, String subtitle, String image, String colorStr) {
    List<Color> colors = [const Color(0xFF1565C0), const Color(0xFF0D47A1)];
    try {
      final List<String> parts = colorStr.split(',').map((e) => e.trim()).toList();
      if (parts.length >= 2) {
        colors = parts.map((c) => Color(int.parse(c.replaceFirst('#', '0xFF')))).toList();
      }
    } catch (_) {}

    return Container(
      height: 120,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(colors: colors, begin: Alignment.topLeft, end: Alignment.bottomRight),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            Positioned(right: -10, bottom: -10, child: Opacity(opacity: 0.8, child: _buildBannerImage(ref, image, width: 140))),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title.isEmpty ? 'TITLE' : title.toUpperCase(), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 16)),
                  Text(subtitle.isEmpty ? 'Subtitle goes here' : subtitle, style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 11)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleDelete(BuildContext context, WidgetRef ref, String id, bool isDark) {
    showDialog(
      context: context,
      builder: (context) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Container(
            padding: const EdgeInsets.all(28.0),
            decoration: BoxDecoration(
              color: (isDark ? const Color(0xFF0D47A1) : Colors.white).withValues(alpha: isDark ? 0.4 : 0.95),
              borderRadius: BorderRadius.circular(35),
              border: Border.all(color: (isDark ? Colors.white : Colors.blueAccent).withValues(alpha: 0.2), width: 1.5),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.redAccent.withValues(alpha: 0.1),
                    boxShadow: [BoxShadow(color: Colors.redAccent.withValues(alpha: 0.2), blurRadius: 20)],
                  ),
                  child: const Icon(Icons.delete_forever_rounded, color: Colors.redAccent, size: 50),
                ),
                const Gap(24),
                Text('DELETE BANNER?', 
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: isDark ? Colors.white : Colors.black, letterSpacing: 1)),
                const Gap(12),
                Text('Are you sure you want to permanently delete this banner? This action cannot be undone.', 
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.6), height: 1.5), 
                  textAlign: TextAlign.center),
                const Gap(32),
                SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: ElevatedButton(
                    onPressed: () {
                      ref.read(adminBannersProvider.notifier).deleteBanner(id);
                      Navigator.pop(context);
                      AppSnackbar.showSuccess(context, 'Banner removed');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isDark ? Colors.white : Colors.redAccent,
                      foregroundColor: isDark ? Colors.redAccent : Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    child: const Text('DELETE NOW', style: TextStyle(fontWeight: FontWeight.w900)),
                  ),
                ),
                const Gap(12),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Cancel', style: TextStyle(color: isDark ? Colors.white30 : Colors.black26, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(Color textColor) => Center(child: Text('No banners found', style: TextStyle(color: textColor.withValues(alpha: 0.2))));

  Widget _buildImagePickerButton(BuildContext context, WidgetRef ref, TextEditingController controller, StateSetter setState, bool isDark) {
    bool isUploading = false;
    return StatefulBuilder(
      builder: (context, setLocalState) {
        return Container(
          height: 58, width: 58,
          decoration: BoxDecoration(
            color: Colors.blueAccent.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.blueAccent.withOpacity(0.2)),
          ),
          child: isUploading 
            ? const Center(child: SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.blueAccent)))
            : IconButton(
                icon: const Icon(Icons.add_a_photo_rounded, color: Colors.blueAccent),
                onPressed: () async {
                  try {
                    final picker = ImagePicker();
                    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
                    if (image != null) {
                      setLocalState(() => isUploading = true);
                      final fileId = await ref.read(adminStorageProvider.notifier).uploadImage(image, AppwriteConstants.fixitAssetsBucketId);
                      if (fileId != null) {
                        controller.text = fileId;
                        setState(() {});
                      } else {
                        if (context.mounted) AppSnackbar.showError(context, 'Tải ảnh lên thất bại!');
                      }
                      setLocalState(() => isUploading = false);
                    }
                  } catch (e) {
                    setLocalState(() => isUploading = false);
                    if (context.mounted) AppSnackbar.showError(context, 'Lỗi: $e');
                  }
                },
              ),
        );
      }
    );
  }
}

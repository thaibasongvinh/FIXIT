import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fixit/core/config/app_environment_provider.dart';
import 'package:fixit/core/constants/app_constants.dart';
import 'package:fixit/shared/widgets/inputs/app_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:fixit/core/presentation/widgets/app_background.dart';
import 'package:fixit/features/admin/presentation/providers/admin_provider.dart';
import 'package:fixit/features/admin/domain/models/admin_models.dart';
import 'package:fixit/features/home/presentation/widgets/components/shimmer_loading.dart';
import 'package:fixit/shared/utils/snackbar_utils.dart';
import 'package:fixit/features/admin/presentation/screens/services/admin_service_issues_screen.dart';
import 'package:fixit/l10n/app_localizations.dart';

import 'package:image_picker/image_picker.dart';

class AdminServicesScreen extends ConsumerWidget {
  const AdminServicesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final servicesAsync = ref.watch(filteredAdminServicesProvider);
    final currentFilter = ref.watch(servicePopularFilterProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;
    
    final backgroundColor = isDark ? const Color(0xFF010A1A) : const Color(0xFFF5F7FA);
    final textColor = isDark ? Colors.white : const Color(0xFF1A1C1E);

    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreateDialog(context, ref, isDark, l10n),
        backgroundColor: Colors.blueAccent,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(l10n.serviceCatalog, 
          style: TextStyle(color: textColor, fontWeight: FontWeight.w900, fontSize: 13, letterSpacing: 3)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: textColor, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: AppBackground(
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(ref, isDark, l10n),
              Expanded(
                child: servicesAsync.when(
                  data: (services) {
                    if (services.isEmpty) return _buildEmptyState(isDark);
                    
                    final displayServices = services.where((s) {
                      if (currentFilter == false) return true;
                      if (s.isPopular) return true;
                      if (s.parentId == null) return true;
                      return false;
                    }).toList();

                    return ReorderableListView.builder(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 40),
                      itemCount: displayServices.length,
                      buildDefaultDragHandles: false,
                      onReorder: (oldIndex, newIndex) {
                        if (newIndex > oldIndex) newIndex -= 1;
                        final items = List<ServiceCategory>.from(displayServices);
                        final item = items.removeAt(oldIndex);
                        items.insert(newIndex, item);
                        
                        ref.read(adminServicesProvider.notifier).reorderServices(items);
                      },
                      proxyDecorator: (child, index, animation) {
                        return AnimatedBuilder(
                          animation: animation,
                          builder: (context, child) {
                            final double animValue = Curves.easeInOut.transform(animation.value);
                            final double scale = lerpDouble(1, 1.05, animValue)!;
                            final double elevation = lerpDouble(0, 12, animValue)!;
                            return Material(
                              elevation: elevation,
                              color: isDark ? const Color(0xFF0D47A1).withOpacity(0.6) : Colors.white,
                              shadowColor: Colors.black.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(24),
                              child: Transform.scale(
                                scale: scale,
                                child: child,
                              ),
                            );
                          },
                          child: child,
                        );
                      },
                      itemBuilder: (context, index) {
                        final service = displayServices[index];
                        return _buildServiceItem(
                          context, 
                          ref, 
                          service, 
                          isDark, 
                          l10n, 
                          key: ValueKey(service.id),
                          dragIndex: index,
                        );
                      },
                    );
                  },
                  loading: () => _buildLoadingList(),
                  error: (e, _) => Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.error_outline_rounded, color: Colors.redAccent, size: 40),
                          const Gap(12),
                          Text(l10n.error(e.toString()), 
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.redAccent, fontSize: 12)
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(WidgetRef ref, bool isDark, AppLocalizations l10n) {
    final currentFilter = ref.watch(servicePopularFilterProvider);

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          Container(
            height: 55,
            decoration: BoxDecoration(
              color: (isDark ? Colors.white : Colors.black).withOpacity(0.04),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: (isDark ? Colors.white : Colors.black).withOpacity(0.08)),
            ),
            child: TextField(
              style: TextStyle(color: isDark ? Colors.white : Colors.black, fontSize: 15),
              cursorColor: Colors.blueAccent,
              onChanged: (val) => ref.read(serviceSearchQueryProvider.notifier).state = val,
              decoration: InputDecoration(
                hintText: l10n.searchServicesHint,
                hintStyle: TextStyle(color: (isDark ? Colors.white : Colors.black).withOpacity(0.15), fontSize: 14),
                prefixIcon: Icon(Icons.search_rounded, color: (isDark ? Colors.white : Colors.black).withOpacity(0.2), size: 22),
                border: InputBorder.none,
                filled: true,
                fillColor: Colors.transparent,
                contentPadding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),
          const Gap(16),
          Row(
            children: [
              _buildFilterButton(ref, l10n.popular, true, currentFilter == true, isDark),
              const Gap(8),
              _buildFilterButton(ref, l10n.regular, false, currentFilter == false, isDark),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterButton(WidgetRef ref, String label, bool? value, bool isSelected, bool isDark) {
    return InkWell(
      onTap: () => ref.read(servicePopularFilterProvider.notifier).state = value,
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blueAccent : (isDark ? Colors.white.withOpacity(0.03) : Colors.black.withOpacity(0.03)),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Colors.blueAccent : (isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.05)),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : (isDark ? Colors.white.withOpacity(0.3) : Colors.black.withOpacity(0.3)),
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.w900 : FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildServiceItem(BuildContext context, WidgetRef ref, ServiceCategory service, bool isDark, AppLocalizations l10n, {Key? key, int? dragIndex}) {
    if (service.isPopular) {
      return _buildPopularServiceCard(context, ref, service, isDark, l10n, key: key, dragIndex: dragIndex);
    }
    
    final currentFilter = ref.watch(servicePopularFilterProvider);
    
    if (currentFilter == false || (currentFilter == null && service.parentId == null)) {
      return _buildRegularServiceItem(context, ref, service, isDark, l10n, key: key, dragIndex: dragIndex);
    }

    return SizedBox.shrink(key: key);
  }

  Widget _buildPopularServiceCard(BuildContext context, WidgetRef ref, ServiceCategory service, bool isDark, AppLocalizations l10n, {Key? key, int? dragIndex}) {
    final servicesAsync = ref.watch(adminServicesProvider);
    final isExpanded = ref.watch(expandedServiceIdProvider) == service.id;

    return Container(
      key: key,
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: (isDark ? Colors.white : Colors.black).withOpacity(0.02),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: (isDark ? Colors.white : Colors.black).withOpacity(0.05)),
        boxShadow: isDark ? [] : [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10)],
      ),
      child: Row(
        children: [
          if (dragIndex != null)
            ReorderableDragStartListener(
              index: dragIndex,
              child: Container(
                padding: const EdgeInsets.fromLTRB(16, 20, 8, 20),
                color: Colors.transparent, // Tăng vùng chạm
                child: Icon(Icons.drag_indicator_rounded, color: isDark ? Colors.white24 : Colors.black12, size: 24),
              ),
            ),
          Expanded(
            child: Column(
              children: [
                InkWell(
                  onTap: () {
                    final current = ref.read(expandedServiceIdProvider);
                    ref.read(expandedServiceIdProvider.notifier).state = (current == service.id) ? null : service.id;
                  },
                  borderRadius: const BorderRadius.only(topRight: Radius.circular(24), bottomRight: Radius.circular(24)),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(8, 16, 16, 16),
                    child: Row(
                      children: [
                        Container(
                          width: 60, height: 60,
                          decoration: BoxDecoration(
                            color: service.color != null && service.color!.isNotEmpty
                              ? Color(int.parse(service.color!.replaceFirst('#', '0xFF')))
                              : Colors.blueAccent.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: _buildServiceImage(ref, service.imagePath ?? service.icon, 32, fallbackName: service.title),
                        ),
                        const Gap(16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(service.title, 
                                style: TextStyle(color: isDark ? Colors.white : Colors.black, fontWeight: FontWeight.bold, fontSize: 16)),
                              Container(
                                margin: const EdgeInsets.only(top: 4),
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.orangeAccent.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text('🔥 ${l10n.popular.toUpperCase()}', style: const TextStyle(color: Colors.orangeAccent, fontSize: 8, fontWeight: FontWeight.w900)),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                _buildActionButton(
                                  icon: Icons.edit_note_rounded,
                                  color: Colors.blueAccent,
                                  onTap: () => _showEditDialog(context, ref, service, isDark, l10n),
                                ),
                                const Gap(8),
                                _buildActionButton(
                                  icon: Icons.delete_outline_rounded,
                                  color: Colors.redAccent,
                                  onTap: () => _handleDelete(context, ref, service, isDark, l10n),
                                ),
                                const Gap(4),
                                Transform.scale(
                                  scale: 0.7,
                                  child: Switch(
                                    value: service.isActive,
                                    onChanged: (val) => ref.read(adminServicesProvider.notifier).toggleStatus(service.id, service.isActive, isPopular: true),
                                    activeColor: Colors.greenAccent,
                                  ),
                                ),
                              ],
                            ),
                            Icon(
                              isExpanded ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
                              color: isDark ? Colors.white24 : Colors.black12,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                if (isExpanded)
                  servicesAsync.when(
                    data: (allServices) {
                      final children = allServices.where((s) => s.parentId == service.id).toList();
                      if (children.isEmpty) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: Text('No sub-services found', style: TextStyle(color: isDark ? Colors.white24 : Colors.black12, fontSize: 12)),
                        );
                      }
                      return Column(
                        children: [
                          Divider(color: (isDark ? Colors.white : Colors.black).withOpacity(0.05), height: 1, indent: 16, endIndent: 16),
                          ReorderableListView(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            buildDefaultDragHandles: false,
                            onReorder: (oldIdx, newIdx) {
                              if (newIdx > oldIdx) newIdx -= 1;
                              final items = List<ServiceCategory>.from(children);
                              final item = items.removeAt(oldIdx);
                              items.insert(newIdx, item);
                              ref.read(adminServicesProvider.notifier).reorderServices(items);
                            },
                            proxyDecorator: (child, index, animation) {
                              return AnimatedBuilder(
                                animation: animation,
                                builder: (context, child) {
                                  final double animValue = Curves.easeInOut.transform(animation.value);
                                  final double scale = lerpDouble(1, 1.05, animValue)!;
                                  final double elevation = lerpDouble(0, 10, animValue)!;
                                  return Material(
                                    elevation: elevation,
                                    color: isDark ? const Color(0xFF0D47A1).withOpacity(0.6) : Colors.white,
                                    shadowColor: Colors.black.withOpacity(0.3),
                                    borderRadius: BorderRadius.circular(16),
                                    child: Transform.scale(
                                      scale: scale,
                                      child: child,
                                    ),
                                  );
                                },
                                child: child,
                              );
                            },
                            children: [
                              for (int i = 0; i < children.length; i++)
                                _buildRegularServiceItem(
                                  context, 
                                  ref, 
                                  children[i], 
                                  isDark, 
                                  l10n, 
                                  isSubItem: true, 
                                  key: ValueKey(children[i].id),
                                  dragIndex: i,
                                ),
                            ],
                          ),
                          const Gap(8),
                        ],
                      );
                    },
                    loading: () => const Padding(padding: EdgeInsets.all(16), child: CircularProgressIndicator(strokeWidth: 2)),
                    error: (_, __) => const SizedBox.shrink(),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRegularServiceItem(BuildContext context, WidgetRef ref, ServiceCategory service, bool isDark, AppLocalizations l10n, {bool isSubItem = false, Key? key, int? dragIndex}) {
    return Padding(
      key: key,
      padding: EdgeInsets.symmetric(horizontal: isSubItem ? 16 : 0, vertical: isSubItem ? 4 : 0),
      child: Container(
        margin: EdgeInsets.only(bottom: isSubItem ? 8 : 12),
        decoration: BoxDecoration(
          color: (isDark ? Colors.white : Colors.black).withOpacity(0.02),
          borderRadius: BorderRadius.circular(16),
          border: isSubItem ? null : Border.all(color: (isDark ? Colors.white : Colors.black).withOpacity(0.05)),
          boxShadow: (isDark || isSubItem) ? [] : [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 5)],
        ),
        child: Row(
          children: [
            if (dragIndex != null)
              ReorderableDragStartListener(
                index: dragIndex,
                child: Container(
                  padding: const EdgeInsets.fromLTRB(16, 12, 8, 12),
                  color: Colors.transparent, // Tăng vùng chạm
                  child: Icon(Icons.drag_indicator_rounded, color: isDark ? Colors.white24 : Colors.black12, size: 20),
                ),
              ),
            Expanded(
              child: InkWell(
                onTap: () => Navigator.push(
                  context, 
                  MaterialPageRoute(builder: (_) => AdminServiceIssuesScreen(serviceId: service.id, serviceTitle: service.title))
                ),
                borderRadius: const BorderRadius.only(topRight: Radius.circular(16), bottomRight: Radius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                  child: Row(
                    children: [
                      Container(
                        width: 44, height: 44,
                        decoration: BoxDecoration(
                          color: Colors.blueAccent.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: _buildServiceImage(ref, service.imagePath ?? service.icon, 24, fallbackName: service.title),
                      ),
                      const Gap(12),
                      Expanded(
                        child: Text(service.title, 
                          style: TextStyle(color: isDark ? Colors.white70 : Colors.black87, fontWeight: FontWeight.w600, fontSize: 14)),
                      ),
                      Icon(Icons.chevron_right_rounded, color: isDark ? Colors.white24 : Colors.black12, size: 20),
                      const Gap(8),
                      _buildActionButton(
                        icon: Icons.edit_rounded,
                        color: Colors.blueAccent,
                        size: 16,
                        onTap: () => _showEditDialog(context, ref, service, isDark, l10n),
                      ),
                      const Gap(8),
                      _buildActionButton(
                        icon: Icons.delete_outline_rounded,
                        color: Colors.redAccent,
                        size: 16,
                        onTap: () => _handleDelete(context, ref, service, isDark, l10n),
                      ),
                      const Gap(4),
                      Transform.scale(
                        scale: 0.6,
                        child: Switch(
                          value: service.isActive,
                          onChanged: (val) => ref.read(adminServicesProvider.notifier).toggleStatus(service.id, service.isActive),
                          activeColor: Colors.greenAccent,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({required IconData icon, required Color color, required VoidCallback onTap, double size = 18}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: color, size: size),
      ),
    );
  }

  Widget _buildServiceImage(WidgetRef ref, String? path, double size, {String? fallbackName}) {
    String? effectivePath = (path == null || path.isEmpty) ? fallbackName : path;
    if (effectivePath == null || effectivePath.isEmpty) {
      return Icon(Icons.handyman_rounded, color: Colors.blueAccent, size: size);
    }
    if (effectivePath.startsWith('http')) {
      return _buildNetworkImage(effectivePath, size);
    }
    final env = ref.read(appEnvironmentProvider);
    final String encodedId = Uri.encodeComponent(effectivePath);
    final imageUrl = '${env.appwriteEndpoint}/storage/buckets/${AppwriteConstants.fixitAssetsBucketId}/files/$encodedId/view?project=${env.appwriteProjectId}';

    if (effectivePath.startsWith('assets/')) {
      return Image.asset(
        effectivePath,
        width: size, height: size, fit: BoxFit.contain,
        errorBuilder: (_, __, ___) => Icon(Icons.handyman_rounded, color: Colors.blueAccent, size: size),
      );
    }

    return CachedNetworkImage(
      imageUrl: imageUrl,
      width: size, height: size, fit: BoxFit.contain,
      placeholder: (context, url) => ShimmerBox(width: size, height: size, borderRadius: 12),
      errorWidget: (context, url, error) {
        String assetPath = effectivePath;
        if (!assetPath.startsWith('assets/images/')) {
          assetPath = 'assets/images/$assetPath';
        }
        if (!assetPath.toLowerCase().endsWith('.png') && !assetPath.toLowerCase().endsWith('.jpg')) {
          assetPath = '$assetPath.png';
        }
        return Image.asset(
          assetPath,
          width: size, height: size, fit: BoxFit.contain,
          errorBuilder: (_, __, ___) => Icon(Icons.handyman_rounded, color: Colors.blueAccent, size: size),
        );
      },
    );
  }

  Widget _buildNetworkImage(String url, double size) {
    return CachedNetworkImage(
      imageUrl: url,
      width: size, height: size, fit: BoxFit.contain,
      placeholder: (context, url) => ShimmerBox(width: size, height: size, borderRadius: 12),
      errorWidget: (context, url, error) => Icon(Icons.handyman_rounded, color: Colors.blueAccent, size: size),
    );
  }

  void _showEditDialog(BuildContext context, WidgetRef ref, ServiceCategory service, bool isDark, AppLocalizations l10n) {
    final nameController = TextEditingController(text: service.title);
    final imageController = TextEditingController(text: service.imagePath ?? '');
    final colorController = TextEditingController(text: service.color ?? '#F2C94C');

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          void _onChanged() => setState(() {});
          return BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Dialog(
              backgroundColor: Colors.transparent,
              insetPadding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(
                  color: (isDark ? const Color(0xFF0D47A1) : Colors.white).withOpacity(isDark ? 0.4 : 0.95),
                  borderRadius: BorderRadius.circular(35),
                  border: Border.all(color: (isDark ? Colors.white : Colors.blueAccent).withOpacity(0.2), width: 1.5),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.blueAccent.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.edit_document, color: Colors.blueAccent, size: 28),
                          ),
                          const Gap(16),
                          Text(l10n.editService, 
                            style: TextStyle(color: isDark ? Colors.white : Colors.black, fontWeight: FontWeight.w900, fontSize: 22, letterSpacing: 0.5)),
                        ],
                      ),
                      const Gap(32),
                      AppTextField(controller: nameController, hint: 'Enter service name', label: 'SERVICE NAME', icon: Icons.title_rounded, darkTheme: isDark),
                      const Gap(24),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: imageController,
                              onChanged: (_) => _onChanged(),
                              style: TextStyle(color: isDark ? Colors.white : Colors.black, fontSize: 15),
                              decoration: _buildInputDecoration('IMAGE ID / ASSET', Icons.image_search_rounded, 'Enter ID or Asset name', isDark),
                            ),
                          ),
                          const Gap(12),
                          _buildImagePickerButton(context, ref, imageController, setState, isDark),
                        ],
                      ),
                      const Gap(24),
                      TextFormField(
                        controller: colorController,
                        onChanged: (_) => _onChanged(),
                        style: TextStyle(color: isDark ? Colors.white : Colors.black, fontSize: 15),
                        decoration: _buildInputDecoration('BRAND COLOR (HEX)', Icons.color_lens_rounded, 'e.g. #F2C94C', isDark),
                      ),
                      const Gap(20),
                      Center(child: Text('LIVE PREVIEW:', style: TextStyle(color: isDark ? Colors.white30 : Colors.black26, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 1.5))),
                      const Gap(12),
                      Builder(builder: (context) {
                        Color previewColor = Colors.blueAccent.withOpacity(0.1);
                        try {
                          if (colorController.text.isNotEmpty) {
                            String hex = colorController.text.replaceFirst('#', '');
                            if (hex.length == 6) hex = 'FF$hex';
                            previewColor = Color(int.parse('0x$hex'));
                          }
                        } catch (_) {}
                        return Center(
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(color: previewColor, shape: BoxShape.circle, border: Border.all(color: Colors.white.withOpacity(0.05))),
                            child: _buildServiceImage(ref, imageController.text, 60, fallbackName: nameController.text),
                          ),
                        );
                      }),
                      const Gap(32),
                      SizedBox(
                        height: 60,
                        child: ElevatedButton(
                          onPressed: () {
                            final Map<String, dynamic> updateData = {'title': nameController.text.trim()};
                            if (imageController.text.isNotEmpty) updateData['imagePath'] = imageController.text.trim();
                            if (colorController.text.isNotEmpty) updateData['color'] = colorController.text.trim();
                            ref.read(adminServicesProvider.notifier).updateService(service.id, updateData, isPopular: service.isPopular);
                            Navigator.pop(context);
                            AppSnackbar.showSuccess(context, 'Service updated successfully');
                          },
                          style: ElevatedButton.styleFrom(backgroundColor: isDark ? Colors.white : Colors.blueAccent, foregroundColor: isDark ? Colors.blueAccent : Colors.white, elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
                          child: Text(l10n.saveChanges.toUpperCase(), style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
                        ),
                      ),
                      const Gap(12),
                      TextButton(onPressed: () => Navigator.pop(context), child: Text(l10n.cancel, style: TextStyle(color: isDark ? Colors.white30 : Colors.black26, fontWeight: FontWeight.bold))),
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

  InputDecoration _buildInputDecoration(String label, IconData icon, String hint, bool isDark) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: (isDark ? Colors.white : Colors.black).withOpacity(0.7), fontSize: 14, fontWeight: FontWeight.w600),
      hintText: hint,
      hintStyle: TextStyle(color: (isDark ? Colors.white : Colors.black).withOpacity(0.5), fontSize: 15),
      prefixIcon: Icon(icon, color: isDark ? Colors.white : Colors.black54, size: 22),
      filled: true,
      fillColor: (isDark ? Colors.white : Colors.black).withOpacity(0.05),
      contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: (isDark ? Colors.white : Colors.black).withOpacity(0.1))),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: isDark ? Colors.white : Colors.blueAccent, width: 1.5)),
    );
  }

  Widget _buildLoadingList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: 8,
      itemBuilder: (context, index) => Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: Colors.white.withOpacity(0.02), borderRadius: BorderRadius.circular(24)),
        child: const Row(
          children: [
            ShimmerBox(width: 52, height: 52, shape: BoxShape.circle),
            Gap(16),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [ShimmerBox(width: 140, height: 16, borderRadius: 4), Gap(8), ShimmerBox(width: 60, height: 10, borderRadius: 4)]),
            ),
            CircularProgressIndicator(color: Colors.blueAccent, strokeWidth: 2),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(bool isDark) {
    return Center(child: Text('No services found', style: TextStyle(color: (isDark ? Colors.white : Colors.black).withOpacity(0.1))));
  }

  void _showCreateDialog(BuildContext context, WidgetRef ref, bool isDark, AppLocalizations l10n) {
    final nameController = TextEditingController();
    final imageController = TextEditingController();
    final colorController = TextEditingController(text: '#F2C94C');
    bool isPopular = ref.read(servicePopularFilterProvider) ?? false;
    String? selectedParentId;
    final allServices = ref.read(adminServicesProvider).asData?.value ?? [];
    final popularServices = allServices.where((s) => s.isPopular).toList();

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          void _onChanged() => setState(() {});
          return BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Dialog(
              backgroundColor: Colors.transparent,
              insetPadding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(
                  color: (isDark ? const Color(0xFF0D47A1) : Colors.white).withOpacity(isDark ? 0.4 : 0.95),
                  borderRadius: BorderRadius.circular(35),
                  border: Border.all(color: (isDark ? Colors.white : Colors.blueAccent).withOpacity(0.2), width: 1.5),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: Colors.greenAccent.withOpacity(0.1), shape: BoxShape.circle), child: const Icon(Icons.add_business_rounded, color: Colors.greenAccent, size: 28)),
                          const Gap(16),
                          Text(l10n.addService, style: TextStyle(color: isDark ? Colors.white : Colors.black, fontWeight: FontWeight.w900, fontSize: 22, letterSpacing: 0.5)),
                        ],
                      ),
                      const Gap(32),
                      AppTextField(controller: nameController, hint: 'Enter service name', label: 'SERVICE NAME', icon: Icons.title_rounded, darkTheme: isDark),
                      const Gap(24),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: imageController, 
                              onChanged: (_) => _onChanged(), 
                              style: TextStyle(color: isDark ? Colors.white : Colors.black, fontSize: 15), 
                              decoration: _buildInputDecoration('IMAGE ID / ASSET', Icons.image_search_rounded, 'Enter ID or Asset name', isDark)
                            ),
                          ),
                          const Gap(12),
                          _buildImagePickerButton(context, ref, imageController, setState, isDark),
                        ],
                      ),
                      const Gap(24),
                      TextFormField(controller: colorController, onChanged: (_) => _onChanged(), style: TextStyle(color: isDark ? Colors.white : Colors.black, fontSize: 15), decoration: _buildInputDecoration('BRAND COLOR (HEX)', Icons.color_lens_rounded, 'e.g. #F2C94C', isDark)),
                      const Gap(24),
                      SwitchListTile(title: Text('${l10n.popular} Service?', style: TextStyle(color: isDark ? Colors.white70 : Colors.black87, fontSize: 14, fontWeight: FontWeight.bold)), subtitle: Text('Featured on home screen', style: TextStyle(color: isDark ? Colors.white30 : Colors.black26, fontSize: 11)), value: isPopular, activeColor: Colors.orangeAccent, onChanged: (val) => setState(() => isPopular = val)),
                      if (!isPopular) ...[const Gap(16), Text('PARENT SERVICE (REQUIRED)', style: TextStyle(color: isDark ? Colors.white60 : Colors.black54, fontSize: 12)), const Gap(8), Container(padding: const EdgeInsets.symmetric(horizontal: 16), decoration: BoxDecoration(color: (isDark ? Colors.white : Colors.black).withOpacity(0.05), borderRadius: BorderRadius.circular(16), border: Border.all(color: (isDark ? Colors.white : Colors.black).withOpacity(0.1))), child: DropdownButtonHideUnderline(child: DropdownButton<String>(value: selectedParentId, dropdownColor: isDark ? const Color(0xFF0D47A1) : Colors.white, hint: Text(popularServices.isEmpty ? 'No popular services available' : 'Select a parent category', style: TextStyle(color: isDark ? Colors.white24 : Colors.black26, fontSize: 13)), isExpanded: true, icon: Icon(Icons.keyboard_arrow_down, color: isDark ? Colors.white38 : Colors.black38), items: popularServices.map((s) => DropdownMenuItem(value: s.id, child: Text(s.title, style: TextStyle(color: isDark ? Colors.white : Colors.black)))).toList(), onChanged: popularServices.isEmpty ? null : (val) => setState(() => selectedParentId = val))))],
                      const Gap(20),
                      Center(child: Text('PREVIEW:', style: TextStyle(color: isDark ? Colors.white30 : Colors.black26, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 1.5))),
                      const Gap(12),
                      Builder(builder: (context) {
                        Color previewColor = Colors.blueAccent.withOpacity(0.1);
                        try {
                          if (colorController.text.isNotEmpty) {
                            String hex = colorController.text.replaceFirst('#', '');
                            if (hex.length == 6) hex = 'FF$hex';
                            previewColor = Color(int.parse('0x$hex'));
                          }
                        } catch (_) {}
                        return Center(child: Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: previewColor, shape: BoxShape.circle, border: Border.all(color: Colors.white.withOpacity(0.05))), child: _buildServiceImage(ref, imageController.text, 60, fallbackName: nameController.text)));
                      }),
                      const Gap(32),
                      SizedBox(height: 60, child: ElevatedButton(onPressed: () {
                        if (nameController.text.isEmpty) { AppSnackbar.showError(context, 'Vui lòng nhập tên dịch vụ!'); return; }
                        if (!isPopular && selectedParentId == null) { AppSnackbar.showError(context, 'Vui lòng chọn dịch vụ cha (Parent)!'); return; }
                        final Map<String, dynamic> data = {'title': nameController.text.trim(), 'isActive': true};
                        if (imageController.text.isNotEmpty) data['imagePath'] = imageController.text.trim();
                        if (colorController.text.isNotEmpty) data['color'] = colorController.text.trim();
                        if (!isPopular && selectedParentId != null) data['parentId'] = selectedParentId;
                        ref.read(adminServicesProvider.notifier).createService(data, isPopular: isPopular);
                        Navigator.pop(context);
                        AppSnackbar.showSuccess(context, 'Service created successfully');
                      }, style: ElevatedButton.styleFrom(backgroundColor: isDark ? Colors.white : Colors.blueAccent, foregroundColor: isDark ? Colors.blueAccent : Colors.white, elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))), child: Text(l10n.createService.toUpperCase(), style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16)))),
                      const Gap(12),
                      TextButton(onPressed: () => Navigator.pop(context), child: Text(l10n.cancel, style: TextStyle(color: isDark ? Colors.white30 : Colors.black26, fontWeight: FontWeight.bold))),
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

  void _handleDelete(BuildContext context, WidgetRef ref, ServiceCategory service, bool isDark, AppLocalizations l10n) {
    if (service.isActive) { AppSnackbar.showError(context, 'Vui lòng vô hiệu hóa dịch vụ này trước khi xóa!'); return; }
    showDialog(
      context: context,
      builder: (context) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Container(
            padding: const EdgeInsets.all(28.0),
            decoration: BoxDecoration(color: (isDark ? const Color(0xFF0D47A1) : Colors.white).withOpacity(isDark ? 0.4 : 0.95), borderRadius: BorderRadius.circular(35), border: Border.all(color: (isDark ? Colors.white : Colors.blueAccent).withOpacity(0.2), width: 1.5)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(padding: const EdgeInsets.all(20), decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.redAccent.withOpacity(0.1), boxShadow: [BoxShadow(color: Colors.redAccent.withOpacity(0.2), blurRadius: 20)]), child: _buildServiceImage(ref, service.imagePath ?? service.icon, 80, fallbackName: service.title)),
                const Gap(24),
                Text(l10n.deleteServiceQuery, style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: isDark ? Colors.white : Colors.black, letterSpacing: 1)),
                const Gap(12),
                Text(l10n.deleteServiceDesc(service.title), style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: (isDark ? Colors.white : Colors.black).withOpacity(0.6), height: 1.5), textAlign: TextAlign.center),
                const Gap(32),
                SizedBox(width: double.infinity, height: 60, child: ElevatedButton(onPressed: () { ref.read(adminServicesProvider.notifier).deleteService(service.id); Navigator.pop(context); AppSnackbar.showSuccess(context, 'Service deleted successfully'); }, style: ElevatedButton.styleFrom(backgroundColor: isDark ? Colors.white : Colors.redAccent, foregroundColor: isDark ? Colors.redAccent : Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))), child: Text(l10n.deleteEverything, style: const TextStyle(fontWeight: FontWeight.w900)))),
                const Gap(12),
                TextButton(onPressed: () => Navigator.pop(context), child: Text(l10n.cancel, style: TextStyle(color: isDark ? Colors.white30 : Colors.black26, fontWeight: FontWeight.bold))),
              ],
            ),
          ),
        ),
      ),
    );
  }

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
                        setState(() {}); // Cập nhật Dialog tổng
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

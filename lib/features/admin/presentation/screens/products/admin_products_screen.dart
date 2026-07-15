import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:fixit/features/admin/presentation/providers/admin_provider.dart';
import 'package:fixit/shared/widgets/inputs/app_text_field.dart';
import 'package:fixit/shared/utils/snackbar_utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fixit/core/config/app_environment_provider.dart';
import 'package:fixit/core/constants/app_constants.dart';

import 'package:image_picker/image_picker.dart';

class AdminProductsScreen extends ConsumerWidget {
  const AdminProductsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(adminProductsProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark ? const Color(0xFF010A1A) : const Color(0xFFF5F7FA);
    final textColor = isDark ? Colors.white : const Color(0xFF1A1C1E);

    return Scaffold(
      backgroundColor: backgroundColor,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showEditDialog(context, ref, isDark),
        backgroundColor: Colors.blueAccent,
        icon: const Icon(Icons.add_shopping_cart_rounded, color: Colors.white),
        label: const Text('ADD PART', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text('PARTS INVENTORY', 
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
            child: productsAsync.when(
              data: (products) => products.isEmpty 
                ? _buildEmptyState(textColor)
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                    itemCount: products.length,
                    itemBuilder: (context, index) => _buildProductCard(context, ref, products[index], isDark, textColor),
                  ),
              loading: () => const Center(child: CircularProgressIndicator(color: Colors.blueAccent)),
              error: (e, _) => Center(child: Text('Error: $e', style: const TextStyle(color: Colors.redAccent))),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(BuildContext context, WidgetRef ref, Map<String, dynamic> product, bool isDark, Color textColor) {
    final currencyFormat = NumberFormat.simpleCurrency(locale: 'vi_VN');
    final String title = product['name'] ?? 'Unknown Part';
    final double price = (product['price'] ?? 0).toDouble();
    final int stock = product['stock'] ?? 0;
    final String? imageId = product['imagePath'];

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
          Container(
            width: 80, height: 80,
            decoration: BoxDecoration(
              color: Colors.blueAccent.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(18),
            ),
            child: _buildProductImage(ref, imageId),
          ),
          const Gap(16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 16)),
                const Gap(4),
                Text(currencyFormat.format(price), style: const TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.w900, fontSize: 14)),
                const Gap(8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: (stock > 0 ? Colors.blueAccent : Colors.redAccent).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(stock > 0 ? 'STOCK: $stock' : 'OUT OF STOCK', 
                    style: TextStyle(color: stock > 0 ? Colors.blueAccent : Colors.redAccent, fontSize: 9, fontWeight: FontWeight.w900)),
                ),
              ],
            ),
          ),
          Column(
            children: [
              IconButton(
                onPressed: () => _showEditDialog(context, ref, isDark, product: product),
                icon: const Icon(Icons.edit_rounded, color: Colors.blueAccent, size: 20),
              ),
              IconButton(
                onPressed: () => _handleDelete(context, ref, product['\$id']),
                icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent, size: 20),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProductImage(WidgetRef ref, String? path) {
    if (path == null || path.isEmpty) return const Icon(Icons.settings_suggest_rounded, color: Colors.blueAccent, size: 30);
    final env = ref.read(appEnvironmentProvider);
    final imageUrl = '${env.appwriteEndpoint}/storage/buckets/${AppwriteConstants.fixitAssetsBucketId}/files/${Uri.encodeComponent(path)}/view?project=${env.appwriteProjectId}';
    return CachedNetworkImage(
      imageUrl: imageUrl, fit: BoxFit.contain,
      placeholder: (_, __) => const Center(child: CircularProgressIndicator(strokeWidth: 2)),
      errorWidget: (_, __, ___) => const Icon(Icons.broken_image_rounded, color: Colors.white24),
    );
  }

  void _showEditDialog(BuildContext context, WidgetRef ref, bool isDark, {Map<String, dynamic>? product}) {
    final nameController = TextEditingController(text: product?['name'] ?? '');
    final priceController = TextEditingController(text: (product?['price'] ?? '').toString());
    final stockController = TextEditingController(text: (product?['stock'] ?? '').toString());
    final imageController = TextEditingController(text: product?['imagePath'] ?? '');

    showDialog(
      context: context,
      builder: (context) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: (isDark ? const Color(0xFF0D47A1) : Colors.white).withValues(alpha: isDark ? 0.4 : 0.95),
              borderRadius: BorderRadius.circular(35),
              border: Border.all(color: (isDark ? Colors.white : Colors.blueAccent).withValues(alpha: 0.2)),
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(product == null ? 'NEW PART' : 'EDIT PART', style: TextStyle(color: isDark ? Colors.white : Colors.black, fontWeight: FontWeight.w900, fontSize: 20)),
                  const Gap(32),
                  AppTextField(controller: nameController, hint: 'Part name', label: 'NAME', icon: Icons.title, darkTheme: isDark),
                  const Gap(20),
                  AppTextField(controller: priceController, hint: 'Price in VND', label: 'PRICE', icon: Icons.payments_rounded, darkTheme: isDark, keyboardType: TextInputType.number),
                  const Gap(20),
                  AppTextField(controller: stockController, hint: 'Quantity available', label: 'STOCK', icon: Icons.inventory_2_rounded, darkTheme: isDark, keyboardType: TextInputType.number),
                  const Gap(20),
                  Row(
                    children: [
                      Expanded(
                        child: AppTextField(controller: imageController, hint: 'Appwrite File ID', label: 'IMAGE ID', icon: Icons.image, darkTheme: isDark),
                      ),
                      const Gap(12),
                      _buildImagePickerButton(context, ref, imageController, isDark),
                    ],
                  ),
                  const Gap(32),
                  SizedBox(
                    width: double.infinity, height: 60,
                    child: ElevatedButton(
                      onPressed: () {
                        final data = {
                          'name': nameController.text.trim(),
                          'price': double.tryParse(priceController.text) ?? 0,
                          'stock': int.tryParse(stockController.text) ?? 0,
                          'imagePath': imageController.text.trim(),
                        };
                        if (product == null) {
                          ref.read(adminProductsProvider.notifier).createProduct(data);
                        } else {
                          ref.read(adminProductsProvider.notifier).updateProduct(product['\$id'], data);
                        }
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: isDark ? Colors.white : Colors.blueAccent, foregroundColor: isDark ? Colors.blueAccent : Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
                      child: const Text('SAVE INVENTORY', style: TextStyle(fontWeight: FontWeight.w900)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _handleDelete(BuildContext context, WidgetRef ref, String id) {
    ref.read(adminProductsProvider.notifier).deleteProduct(id);
    AppSnackbar.showSuccess(context, 'Part removed');
  }

  Widget _buildEmptyState(Color textColor) => Center(child: Text('Inventory is empty', style: TextStyle(color: textColor.withValues(alpha: 0.2))));

  Widget _buildImagePickerButton(BuildContext context, WidgetRef ref, TextEditingController controller, bool isDark) {
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
                        // Vì Products screen không truyền setState từ ngoài vào, ta cần tự quản lý
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

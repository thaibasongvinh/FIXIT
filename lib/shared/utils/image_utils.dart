import 'dart:io';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:path/path.dart' as p;

class ImageUtils {
  /// Nén ảnh xuống dung lượng thấp hơn (mục tiêu ~300KB)
  static Future<File?> compressImage(String path) async {
    final file = File(path);
    if (!file.existsSync()) return null;

    // Nếu ảnh đã nhỏ hơn 500KB thì không cần nén sâu
    final int sizeInBytes = await file.length();
    if (sizeInBytes < 500 * 1024) return file;

    final tempDir = await path_provider.getTemporaryDirectory();
    final targetPath = p.join(tempDir.path, '${DateTime.now().millisecondsSinceEpoch}_compressed.jpg');

    final compressedFile = await FlutterImageCompress.compressAndGetFile(
      path,
      targetPath,
      quality: 70, // Nén khoảng 70% chất lượng
      minWidth: 1024,
      minHeight: 1024,
      format: CompressFormat.jpeg,
    );

    if (compressedFile == null) return file;
    return File(compressedFile.path);
  }

  /// Nén danh sách ảnh
  static Future<List<String>> compressImages(List<String> paths) async {
    final List<String> compressedPaths = [];
    for (final path in paths) {
      final compressed = await compressImage(path);
      if (compressed != null) {
        compressedPaths.add(compressed.path);
      }
    }
    return compressedPaths;
  }
}

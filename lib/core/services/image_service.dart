import 'dart:io';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:path/path.dart' as p;

class ImageService {
  /// Nén ảnh và kiểm tra chất lượng cơ bản
  static Future<File?> compressAndValidate(File file, {int minWidth = 1024, int minHeight = 1024, int quality = 80}) async {
    final String targetPath = p.join(
      (await path_provider.getTemporaryDirectory()).path,
      'compressed_${DateTime.now().millisecondsSinceEpoch}${p.extension(file.path)}',
    );

    // 1. Nén ảnh
    final XFile? compressedFile = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      quality: quality,
      minWidth: minWidth,
      minHeight: minHeight,
    );

    if (compressedFile == null) return null;

    // 2. Kiểm tra dung lượng (nếu sau khi nén vẫn quá nhỏ < 20KB -> Có thể là ảnh lỗi hoặc quá mờ)
    final int length = await compressedFile.length();
    if (length < 20 * 1024) {
      return null; // Trả về null để báo hiệu ảnh chất lượng quá kém
    }

    return File(compressedFile.path);
  }
}

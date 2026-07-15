import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import '../../core/config/app_environment_provider.dart';

class ImageService {
  ImageService({
    required String endpoint,
    required String projectId,
  })  : _endpoint = endpoint.replaceFirst(RegExp(r'/$'), ''),
        _projectId = projectId;

  final String _endpoint;
  final String _projectId;

  /// Nén ảnh trước khi upload
  Future<File?> compressImage(File file, {int quality = 80}) async {
    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;
    final fileName = p.basenameWithoutExtension(file.path);
    final targetPath = p.join(path, '${fileName}_compressed.jpg');

    final result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      quality: quality,
      format: CompressFormat.jpeg,
    );

    if (result == null) return null;
    return File(result.path);
  }

  /// Tạo URL ảnh đã tối ưu hóa (nén, resize) từ Appwrite
  String getOptimizedUrl(
    String bucketId,
    String fileId, {
    int? width,
    int? height,
    int quality = 80,
  }) {
    if (fileId.isEmpty) return '';

    // Nếu fileId đã là URL, trả về luôn
    if (fileId.startsWith('http')) return fileId;

    try {
      final query = <String, String>{
        'project': _projectId,
        if (width != null) 'width': '$width',
        if (height != null) 'height': '$height',
        'quality': '$quality',
      };
      final uri = _fileUri(bucketId, fileId, 'preview', query);
      return uri.toString();
    } catch (e) {
      debugPrint('Error generating optimized URL: $e');
      return '';
    }
  }

  /// URL ảnh gốc
  String getOriginalUrl(String bucketId, String fileId) {
    if (fileId.startsWith('http')) return fileId;
    return _fileUri(
      bucketId,
      fileId,
      'view',
      {'project': _projectId},
    ).toString();
  }

  Uri _fileUri(
    String bucketId,
    String fileId,
    String action,
    Map<String, String> queryParameters,
  ) {
    return Uri.parse(
      '$_endpoint/storage/buckets/${Uri.encodeComponent(bucketId)}'
      '/files/${Uri.encodeComponent(fileId)}/$action',
    ).replace(queryParameters: queryParameters);
  }
}

final imageServiceProvider = Provider((ref) {
  final env = ref.watch(appEnvironmentProvider);
  return ImageService(
    endpoint: env.appwriteEndpoint,
    projectId: env.appwriteProjectId,
  );
});

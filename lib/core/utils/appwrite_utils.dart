class AppwriteUtils {
  static const String endpoint = 'https://sgp.cloud.appwrite.io/v1';
  static const String projectId = '6a145b8d001aa82f4dd5';
  static const String bucketId = 'fixit_assets';

  /// Lấy URL hiển thị của ảnh từ Appwrite Storage.
  /// imagePath trong DB hiện đã khớp 100% với File ID trong Storage.
  static String getImageUrl(String pathOrId, {String? bucket}) {
    if (pathOrId.isEmpty) return '';
    
    // 1. Nếu là URL đầy đủ (ví dụ: ảnh từ Google/FB)
    if (pathOrId.startsWith('http')) return pathOrId;
    
    // 2. Nếu là Asset local (ví dụ: 'assets/images/...')
    if (pathOrId.startsWith('assets/')) return pathOrId;
    
    // 3. MẶC ĐỊNH: Lấy từ Appwrite Storage bằng File ID
    final targetBucket = bucket ?? bucketId;
    
    // imagePath hiện nay chính là File ID (Ví dụ: "Plumbers.png", "Electric_Work.png")
    return '$endpoint/storage/buckets/$targetBucket/files/$pathOrId/view?project=$projectId';
  }

  /// Lấy URL xem trước (preview) của ảnh với tùy chọn kích thước
  static String getPreviewUrl(String fileId, {int width = 200, int? height, int quality = 80, String? bucket}) {
    if (fileId.isEmpty) return '';
    if (fileId.startsWith('http') || fileId.contains('assets/')) return fileId;

    final targetBucket = bucket ?? bucketId;
    String url = '$endpoint/storage/buckets/$targetBucket/files/$fileId/preview?project=$projectId&width=$width&quality=$quality';
    if (height != null) url += '&height=$height';
    return url;
  }
}

import 'models/guide_model.dart';
import 'models/step_model.dart';

abstract class GuideRepository {
  // Lấy danh sách guide có filter + pagination
  Future<(List<GuideModel> items, dynamic lastDoc)> getGuides({
    String? category,
    String? device,
    String? searchQuery,
    int limit = 20,
    dynamic lastDocument,
  });

  // Lấy guide của 1 tác giả
  Future<List<GuideModel>> getGuidesByAuthor(String authorId);

  // Lấy chi tiết 1 guide
  Future<GuideModel?> getGuideById(String guideId);

  // Lấy tất cả steps của guide (realtime stream)
  Stream<List<StepModel>> watchSteps(String guideId);

  // Tạo guide mới
  Future<String> createGuide(GuideModel guide);

  // Cập nhật thông tin guide
  Future<void> updateGuide(GuideModel guide);

  // Upload ảnh bìa guide
  Future<String> uploadGuideCover(
    String guideId,
    List<int> imageBytes,
    String fileName,
  );

  // Cập nhật ảnh bìa guide
  Future<void> updateGuideCover(String guideId, String coverImageUrl);

  // Thêm step vào guide
  Future<String> addStep(String guideId, StepModel step);

  // Cập nhật step
  Future<void> updateStep(String guideId, StepModel step);

  // Upload ảnh step → trả về URL
  Future<String> uploadStepImage(
      String guideId, String stepId, List<int> imageBytes, String fileName);

  // Upload video step → trả về URL
  Future<String> uploadStepVideo(
      String guideId, String stepId, List<int> videoBytes, String fileName);

  // Tăng view count
  Future<void> incrementViews(String guideId);

  // Bookmark / unbookmark
  Future<void> toggleBookmark(String guideId, String userId);

  // Theo doi guide da duoc bookmark boi user chua
  Stream<bool> watchGuideBookmarkStatus(String guideId, String userId);

  // Đánh giá hướng dẫn
  Future<void> rateGuide({
    required String guideId,
    required String userId,
    required double rating,
    String review,
  });

  // Lấy rating hiện tại của user cho guide
  Future<double?> getUserRating(String guideId, String userId);
}

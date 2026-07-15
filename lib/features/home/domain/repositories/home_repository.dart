import '../entities/banner_model.dart';
import '../entities/home_category.dart';

abstract class HomeRepository {
  /// Lấy toàn bộ danh sách dịch vụ (bao gồm cả phổ biến và thường)
  Future<List<HomeCategory>> getServices();

  /// Lấy danh sách Banner quảng cáo
  Future<List<BannerModel>> getBanners();
}

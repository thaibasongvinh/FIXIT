import '../entities/home_category.dart';
import '../entities/banner_model.dart';
import '../repositories/home_repository.dart';

class GetServicesUseCase {
  final HomeRepository repository;
  GetServicesUseCase(this.repository);

  Future<List<HomeCategory>> execute() => repository.getServices();
}

class GetBannersUseCase {
  final HomeRepository repository;
  GetBannersUseCase(this.repository);

  Future<List<BannerModel>> execute() => repository.getBanners();
}

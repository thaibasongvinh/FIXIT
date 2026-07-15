import '../../domain/entities/banner_model.dart';
import '../../domain/entities/home_category.dart';
import '../../domain/repositories/home_repository.dart';
import '../data_sources/home_remote_data_source.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource remoteDataSource;

  HomeRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<HomeCategory>> getServices() async {
    try {
      final popularDocs = await remoteDataSource.getPopularServicesDocs();
      final regularDocs = await remoteDataSource.getRegularServicesDocs();

      final popular = popularDocs.map((data) {
        String id = data['id'];
        if (!id.startsWith('pop_')) id = 'pop_$id';
        return HomeCategory.fromMap(data, id);
      }).toList();

      final regular = regularDocs.map((data) {
        String id = data['id'];
        if (!id.startsWith('svc_')) id = 'svc_$id';
        return HomeCategory.fromMap(data, id);
      }).toList();

      return [...popular, ...regular];
    } catch (_) {
      return [];
    }
  }

  @override
  Future<List<BannerModel>> getBanners() async {
    try {
      final docs = await remoteDataSource.getBannerDocs();
      return docs.map((data) => BannerModel.fromMap(data, data['id'])).toList();
    } catch (_) {
      return [];
    }
  }
}

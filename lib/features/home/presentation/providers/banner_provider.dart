import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/banner_model.dart';
import '../../domain/use_cases/get_home_data_use_case.dart';
import 'services_provider.dart';

part 'banner_provider.g.dart';

@riverpod
GetBannersUseCase getBannersUseCase(GetBannersUseCaseRef ref) {
  final repo = ref.watch(homeRepositoryProvider);
  return GetBannersUseCase(repo);
}

@riverpod
Stream<List<BannerModel>> homeBanners(HomeBannersRef ref) async* {
  final useCase = ref.watch(getBannersUseCaseProvider);
  final banners = await useCase.execute();
  yield banners;
}

@riverpod
Stream<String> homeBannerText(HomeBannerTextRef ref) {
  return Stream.value('Quality Home Services, Just a Tap Away!');
}

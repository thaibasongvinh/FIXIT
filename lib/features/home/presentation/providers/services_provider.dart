import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/config/app_environment_provider.dart';
import '../../../../core/config/appwrite_provider.dart';
import '../../data/data_sources/home_remote_data_source.dart';
import '../../data/repositories/home_repository_impl.dart';
import '../../domain/entities/home_category.dart';
import '../../domain/repositories/home_repository.dart';
import '../../domain/use_cases/get_home_data_use_case.dart';

part 'services_provider.g.dart';

final searchQueryProvider = StateProvider<String>((ref) => '');

@riverpod
HomeRemoteDataSource homeRemoteDataSource(HomeRemoteDataSourceRef ref) {
  final db = ref.watch(appwriteDatabasesProvider);
  final env = ref.watch(appEnvironmentProvider);
  return HomeRemoteDataSourceImpl(db, env.appwriteDatabaseId);
}

@riverpod
HomeRepository homeRepository(HomeRepositoryRef ref) {
  final dataSource = ref.watch(homeRemoteDataSourceProvider);
  return HomeRepositoryImpl(dataSource);
}

@riverpod
GetServicesUseCase getServicesUseCase(GetServicesUseCaseRef ref) {
  final repo = ref.watch(homeRepositoryProvider);
  return GetServicesUseCase(repo);
}

@riverpod
Stream<List<HomeCategory>> allServices(AllServicesRef ref) async* {
  final useCase = ref.watch(getServicesUseCaseProvider);
  final services = await useCase.execute();
  yield services;
}

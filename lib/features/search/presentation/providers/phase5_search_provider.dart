import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fixit/core/config/app_environment_provider.dart';
import 'package:fixit/core/config/appwrite_provider.dart';

import '../../data/phase5_search_repository_impl.dart';
import '../../domain/models/phase5_search_result.dart';
import '../../domain/search_repository.dart';

final phase5SearchRepositoryProvider = Provider<Phase5SearchRepository>((ref) {
  final env = ref.watch(appEnvironmentProvider);
  final db = ref.watch(appwriteDatabasesProvider);
  return Phase5SearchRepositoryImpl(
    databases: db,
    databaseId: env.appwriteDatabaseId,
    isDev: env.flavor.isDev,
  );
});

class Phase5SearchNotifier
    extends StateNotifier<AsyncValue<Phase5SearchResult>> {
  Phase5SearchNotifier(this._repository)
      : super(AsyncData(Phase5SearchResult.empty()));

  final Phase5SearchRepository _repository;

  Future<void> search(String query) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) {
      state = AsyncData(Phase5SearchResult.empty());
      return;
    }

    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => _repository.search(query: trimmed, limit: 10),
    );
  }
}

final phase5SearchNotifierProvider =
    StateNotifierProvider<Phase5SearchNotifier, AsyncValue<Phase5SearchResult>>(
        (ref) {
  return Phase5SearchNotifier(ref.watch(phase5SearchRepositoryProvider));
});

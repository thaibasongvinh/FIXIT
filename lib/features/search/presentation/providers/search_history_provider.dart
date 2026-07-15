import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'search_history_provider.g.dart';

@riverpod
class SearchHistory extends _$SearchHistory {
  @override
  List<String> build() {
    // In a real app, load from SharedPreferences/LocalStorage
    return ['Plumber', 'Cloth washer', 'Electrical Repairs', 'House Cleaning'];
  }

  void addSearch(String query) {
    if (query.trim().isEmpty) return;
    final newState = [query, ...state.where((s) => s != query)];
    state = newState.take(10).toList(); // Keep top 10
  }

  void removeSearch(String query) {
    state = state.where((s) => s != query).toList();
  }

  void clear() {
    state = [];
  }
}

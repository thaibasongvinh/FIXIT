import 'models/phase5_search_result.dart';

abstract class Phase5SearchRepository {
  Future<Phase5SearchResult> search({
    required String query,
    List<String> scopes = const ['guides', 'technicians'],
    int limit = 8,
  });
}

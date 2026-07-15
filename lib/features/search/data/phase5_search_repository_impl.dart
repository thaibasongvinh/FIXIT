import 'package:appwrite/appwrite.dart';

import '../../guides/domain/models/guide_model.dart';
import '../../marketplace/domain/models/technician_model.dart';
import '../domain/models/phase5_search_result.dart';
import '../domain/search_repository.dart';

class Phase5SearchRepositoryImpl implements Phase5SearchRepository {
  Phase5SearchRepositoryImpl({
    required Databases databases,
    required String databaseId,
    required bool isDev,
  })  : _db = databases,
        _databaseId = databaseId;

  final Databases _db;
  final String _databaseId;

  @override
  Future<Phase5SearchResult> search({
    required String query,
    List<String> scopes = const ['guides', 'technicians'],
    int limit = 8,
  }) async {
    final normalized = query.trim().toLowerCase();
    if (normalized.isEmpty) {
      return Phase5SearchResult.empty();
    }

    final guides = scopes.contains('guides')
        ? await _searchGuides(normalized, limit)
        : <GuideModel>[];
    final technicians = scopes.contains('technicians')
        ? await _searchTechnicians(normalized, limit)
        : <TechnicianModel>[];

    return Phase5SearchResult(
      guides: guides,
      technicians: technicians,
      source: 'appwrite',
    );
  }

  Future<List<GuideModel>> _searchGuides(String query, int limit) async {
    try {
      final result = await _db.listDocuments(
        databaseId: _databaseId,
        collectionId: 'guides',
        queries: [
          Query.limit(100),
          Query.orderDesc('updatedAt'),
        ],
      );

      return result.documents
          .map(GuideModel.fromAppwrite)
          .where((guide) => _matchesGuide(guide, query))
          .take(limit)
          .toList();
    } catch (_) {
      return const [];
    }
  }

  Future<List<TechnicianModel>> _searchTechnicians(
    String query,
    int limit,
  ) async {
    try {
      final result = await _db.listDocuments(
        databaseId: _databaseId,
        collectionId: 'technicians',
        queries: [
          Query.limit(100),
          Query.orderDesc('rating'),
        ],
      );

      return result.documents
          .map(TechnicianModel.fromAppwrite)
          .where((tech) => _matchesTechnician(tech, query))
          .take(limit)
          .toList();
    } catch (_) {
      return const [];
    }
  }

  bool _matchesGuide(GuideModel guide, String query) {
    final haystack = [
      guide.title,
      guide.description,
      guide.device,
      guide.category,
      guide.difficulty,
      guide.authorName,
      ...guide.tags,
      ...guide.searchKeywords,
    ].join(' ').toLowerCase();

    return haystack.contains(query);
  }

  bool _matchesTechnician(TechnicianModel tech, String query) {
    final haystack = [
      tech.name,
      tech.phone,
      tech.bio,
      tech.serviceArea,
      ...tech.skills,
      ...tech.certifications,
      ...tech.services.map((service) => service.values.join(' ')),
    ].join(' ').toLowerCase();

    return haystack.contains(query);
  }
}

import 'package:appwrite/appwrite.dart';
import 'package:flutter/foundation.dart';
import '../../domain/models/technician_model.dart';
import '../../domain/technician_repository.dart';

class TechnicianRepositoryImpl implements TechnicianRepository {
  TechnicianRepositoryImpl({
    required Databases databases,
    required String databaseId,
  })  : _db = databases,
        _dbId = databaseId;

  final Databases _db;
  final String _dbId;
  static const _collId = 'technicians';

  @override
  Future<List<TechnicianModel>> getTechnicians({
    String? skill,
    bool? isAvailable,
    int limit = 20,
  }) async {
    final queries = [
      Query.limit(limit),
    ];

    if (isAvailable != null) {
      queries.add(Query.equal('isAvailable', isAvailable));
    }

    if (skill != null && skill != 'all') {
      queries.add(Query.equal('skills', skill));
    }

    try {
      final snap = await _db.listDocuments(
        databaseId: _dbId,
        collectionId: _collId,
        queries: queries,
      );

      debugPrint('Appwrite: getTechnicians fetched ${snap.documents.length} docs.');
      return snap.documents.map((d) => TechnicianModel.fromAppwrite(d)).toList();
    } on AppwriteException catch (e) {
      debugPrint('Appwrite: [ERROR] getTechnicians [${e.code}]: ${e.message}');
      // Fallback: fetch without filters and filter client-side (to avoid index issues)
      try {
        final snap = await _db.listDocuments(
          databaseId: _dbId,
          collectionId: _collId,
          queries: [Query.limit(limit)],
        );
        
        return snap.documents
            .map((d) => TechnicianModel.fromAppwrite(d))
            .where((tech) {
                final matchAvailability = isAvailable == null || tech.isAvailable == isAvailable;
                final matchSkill = skill == null || skill == 'all' || tech.skills.contains(skill);
                return matchAvailability && matchSkill;
            })
            .toList();
      } catch (e2) {
        debugPrint('Appwrite: [FATAL] getTechnicians fallback error: $e2');
        return [];
      }
    } catch (e) {
      debugPrint('Appwrite: [FATAL] getTechnicians UNKNOWN error: $e');
      return [];
    }
  }

  @override
  Future<TechnicianModel?> getTechnicianById(String uid) async {
    try {
      final doc = await _db.getDocument(
        databaseId: _dbId,
        collectionId: _collId,
        documentId: uid,
      );
      return TechnicianModel.fromAppwrite(doc);
    } catch (e) {
      debugPrint('Appwrite: [ERROR] getTechnicianById for $uid: $e');
      return null;
    }
  }

  @override
  Future<List<TechnicianModel>> searchTechnicians(String query) async {
    final normalized = query.trim().toLowerCase();
    if (normalized.isEmpty) {
      return getTechnicians(isAvailable: true);
    }

    try {
      final snap = await _db.listDocuments(
        databaseId: _dbId,
        collectionId: _collId,
        queries: [Query.limit(50)],
      );

      return snap.documents
          .map((d) => TechnicianModel.fromAppwrite(d))
          .where((tech) {
        if (!tech.isAvailable) return false;
        final haystack = [
          tech.name,
          tech.bio,
          tech.serviceArea,
          ...tech.skills,
        ].join(' ').toLowerCase();
        return haystack.contains(normalized);
      }).toList();
    } catch (e) {
      debugPrint('Appwrite: searchTechnicians error: $e');
      return [];
    }
  }

  @override
  Future<void> updateAvailability(String uid, bool available) =>
      _db.updateDocument(
        databaseId: _dbId,
        collectionId: _collId,
        documentId: uid,
        data: {'isAvailable': available},
      );

  @override
  Future<void> updateLocation(String uid, double lat, double lng) async {
    await _db.updateDocument(
      databaseId: _dbId,
      collectionId: _collId,
      documentId: uid,
      data: {
        'lat': lat,
        'lng': lng,
      },
    );
  }
}

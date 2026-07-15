import 'package:appwrite/appwrite.dart';
import 'package:flutter/foundation.dart';
import '../../../core/constants/app_constants.dart';
import '../domain/guide_repository.dart';
import '../domain/models/guide_model.dart';
import '../domain/models/step_model.dart';

class AppwriteGuideRepositoryImpl implements GuideRepository {
  AppwriteGuideRepositoryImpl({
    required Databases databases,
    required Storage storage,
    required String databaseId,
    required String endpoint,
    required String projectId,
    String guideAssetsBucketId = AppwriteConstants.guideAssetsBucketId,
  })  : _db = databases,
        _storage = storage,
        _dbId = databaseId,
        _endpoint = endpoint.replaceFirst(RegExp(r'/$'), ''),
        _projectId = projectId,
        _guideAssetsBucketId = guideAssetsBucketId {
    _validateConfig();
  }

  void _validateConfig() {
    if (_dbId.isEmpty || _dbId == 'database-default') {
      debugPrint(
          'Appwrite: [WARNING] databaseId is "$_dbId". Ensure this matches your Appwrite Console.');
    }
    if (_projectId.isEmpty) {
      debugPrint(
          'Appwrite: [CRITICAL] projectId is EMPTY. Requests will fail.');
    }
    debugPrint(
        'Appwrite: [CONFIG] Repository initialized with DB: $_dbId, Project: $_projectId');
  }

  final Databases _db;
  final Storage _storage;
  final String _dbId;
  final String _endpoint;
  final String _projectId;
  final String _guideAssetsBucketId;
  static const _guidesCollId = AppwriteConstants.guidesCollectionId;
  static const _stepsCollId = AppwriteConstants.guideStepsCollectionId;
  static const _bookmarksCollId = AppwriteConstants.guideBookmarksCollectionId;
  static const _ratingsCollId = AppwriteConstants.guideRatingsCollectionId;

  @override
  Future<(List<GuideModel> items, dynamic lastDoc)> getGuides({
    String? category,
    String? difficulty,
    String? device,
    String? searchQuery,
    int limit = 10,
    dynamic lastDocument,
  }) async {
    try {
      final queries = [
        // Query.equal('isPublished', true), // Tạm thời comment do schema chưa có field này
        Query.limit(limit),
        Query.orderDesc('createdAt'),
      ];
      if (category != null) queries.add(Query.equal('category', category));
      if (device != null) queries.add(Query.equal('device', device));
      if (searchQuery != null && searchQuery.trim().isNotEmpty) {
        // queries.add(Query.search('searchKeywords', searchQuery.trim())); // Tạm comment do schema thiếu field
        queries.add(Query.search('title', searchQuery.trim())); // Tìm theo title thay thế
      }
      if (lastDocument is String && lastDocument.isNotEmpty) {
        queries.add(Query.cursorAfter(lastDocument));
      }

      debugPrint('Appwrite: [DEBUG] getGuides starting with queries: $queries');

      final snap = await _db.listDocuments(
        databaseId: _dbId,
        collectionId: _guidesCollId,
        queries: queries,
      );

      debugPrint(
          'Appwrite: [SUCCESS] getGuides fetched ${snap.documents.length} documents.');

      final items =
          snap.documents.map((d) => GuideModel.fromAppwrite(d)).toList();
      final nextCursor =
          snap.documents.length == limit && snap.documents.isNotEmpty
              ? snap.documents.last.$id
              : null;
      return (items, nextCursor);
    } on AppwriteException catch (e) {
      debugPrint('Appwrite: [ERROR] getGuides: [${e.code}] ${e.message}');
      if (e.code == 401 || e.code == 403) {
        debugPrint(
            'Appwrite: [PERMISSION] Check if the collection "$_guidesCollId" has appropriate Read permissions.');
      } else if (e.code == 400) {
        debugPrint(
            'Appwrite: [QUERY] Check if attributes are indexed and searchKeywords has a Search Index.');
      }
      rethrow;
    } catch (e) {
      debugPrint('Appwrite: [FATAL] getGuides: $e');
      rethrow;
    }
  }

  @override
  Future<GuideModel?> getGuideById(String id) async {
    try {
      debugPrint('Appwrite: [DEBUG] getGuideById starting for $id');
      final doc = await _db.getDocument(
        databaseId: _dbId,
        collectionId: _guidesCollId,
        documentId: id,
      );
      debugPrint('Appwrite: [SUCCESS] getGuideById found document $id');
      return GuideModel.fromAppwrite(doc);
    } on AppwriteException catch (e) {
      debugPrint(
          'Appwrite: [ERROR] getGuideById for $id: [${e.code}] ${e.message}');
      return null;
    } catch (e) {
      debugPrint('Appwrite: [FATAL] getGuideById for $id: $e');
      return null;
    }
  }

  @override
  Future<List<GuideModel>> getGuidesByAuthor(String authorId) async {
    try {
      debugPrint('Appwrite: [DEBUG] getGuidesByAuthor for $authorId');
      final snap = await _db.listDocuments(
        databaseId: _dbId,
        collectionId: _guidesCollId,
        queries: [Query.equal('authorId', authorId)],
      );
      return snap.documents.map((d) => GuideModel.fromAppwrite(d)).toList();
    } on AppwriteException catch (e) {
      debugPrint(
          'Appwrite: [ERROR] getGuidesByAuthor for $authorId: [${e.code}] ${e.message}');
      return [];
    } catch (e) {
      debugPrint('Appwrite: [FATAL] getGuidesByAuthor error: $e');
      return [];
    }
  }

  @override
  Stream<List<StepModel>> watchSteps(String guideId) {
    debugPrint('Appwrite: [DEBUG] watchSteps starting for $guideId');
    return Stream.fromFuture(_db.listDocuments(
      databaseId: _dbId,
      collectionId: _stepsCollId,
      queries: [Query.equal('guideId', guideId), Query.orderAsc('order')],
    )).map((snap) {
      debugPrint(
          'Appwrite: [SUCCESS] watchSteps fetched ${snap.documents.length} steps for $guideId');
      return snap.documents
          .map((d) => StepModel.fromJson({...d.data, 'id': d.$id}))
          .toList();
    }).handleError((e) {
      debugPrint('Appwrite: [ERROR] watchSteps for $guideId: $e');
    });
  }

  @override
  Future<String> createGuide(GuideModel guide) async {
    try {
      debugPrint('Appwrite: [DEBUG] createGuide starting for "${guide.title}"');
      final doc = await _db.createDocument(
        databaseId: _dbId,
        collectionId: _guidesCollId,
        documentId: ID.unique(),
        data: {
          'title': guide.title,
          'description': guide.description,
          'device': guide.device,
          'category': guide.category,
          'difficulty': guide.difficulty,
          'authorId': guide.authorId,
          'authorName': guide.authorName,
          'coverImage': guide.coverImage,
          'slug': guide.slug,
          'estimatedTime': guide.estimatedTime,
          'toolsRequired': guide.toolsRequired,
          'tags': guide.tags,
          'searchKeywords': guide.searchKeywords,
          'views': guide.views,
          'bookmarks': guide.bookmarks,
          'rating': guide.rating,
          'reviewCount': guide.reviewCount,
          'ratingCount': guide.ratingCount,
          'isPublished': true, // Sửa thành true để xuất hiện ngay trong feed
          'createdAt': DateTime.now().toIso8601String(),
          'updatedAt': DateTime.now().toIso8601String(),
        },
        permissions: [
          Permission.read(Role.any()),
          Permission.write(Role.any()),
          Permission.update(Role.user(guide.authorId)),
          Permission.delete(Role.user(guide.authorId)),
          Permission.read(Role.users()),
          Permission.write(Role.users()),
          Permission.update(Role.users()),
          Permission.delete(Role.users()),
        ],
      );
      debugPrint('Appwrite: [SUCCESS] createGuide created document ${doc.$id}');
      return doc.$id;
    } on AppwriteException catch (e) {
      debugPrint('Appwrite: [ERROR] createGuide: [${e.code}] ${e.message}');
      rethrow;
    } catch (e) {
      debugPrint('Appwrite: [FATAL] createGuide: $e');
      rethrow;
    }
  }

  @override
  Future<void> updateGuide(GuideModel guide) async {
    try {
      debugPrint('Appwrite: [DEBUG] updateGuide starting for ${guide.id}');
      await _db.updateDocument(
        databaseId: _dbId,
        collectionId: _guidesCollId,
        documentId: guide.id,
        data: {
          'title': guide.title,
          'description': guide.description,
          'device': guide.device,
          'category': guide.category,
          'difficulty': guide.difficulty,
          'coverImage': guide.coverImage,
          'slug': guide.slug,
          'estimatedTime': guide.estimatedTime,
          'toolsRequired': guide.toolsRequired,
          'tags': guide.tags,
          'searchKeywords': guide.searchKeywords,
          'isPublished': guide.isPublished,
          'updatedAt': DateTime.now().toIso8601String(),
        },
      );
      debugPrint(
          'Appwrite: [SUCCESS] updateGuide updated document ${guide.id}');
    } on AppwriteException catch (e) {
      debugPrint(
          'Appwrite: [ERROR] updateGuide for ${guide.id}: [${e.code}] ${e.message}');
      rethrow;
    } catch (e) {
      debugPrint('Appwrite: [FATAL] updateGuide for ${guide.id}: $e');
      rethrow;
    }
  }

  @override
  Future<String> addStep(String guideId, StepModel step) async {
    try {
      debugPrint('Appwrite: [DEBUG] addStep for guide $guideId');
      final doc = await _db.createDocument(
        databaseId: _dbId,
        collectionId: _stepsCollId,
        documentId: ID.unique(),
        data: {
          'order': step.order,
          'title': step.title,
          'content': step.content,
          'imageUrls': step.imageUrls,
          'videoUrl': step.videoUrl,
          'warningNote': step.warningNote,
          'duration': step.duration,
          'guideId': guideId,
        },
        permissions: [
          Permission.read(Role.any()),
        ],
      );
      debugPrint(
          'Appwrite: [SUCCESS] addStep created step document ${doc.$id}');
      return doc.$id;
    } on AppwriteException catch (e) {
      debugPrint('Appwrite: [ERROR] addStep: [${e.code}] ${e.message}');
      rethrow;
    } catch (e) {
      debugPrint('Appwrite: [FATAL] addStep: $e');
      rethrow;
    }
  }

  @override
  Future<void> updateStep(String guideId, StepModel step) async {
    try {
      debugPrint('Appwrite: [DEBUG] updateStep for step ${step.id}');
      await _db.updateDocument(
        databaseId: _dbId,
        collectionId: _stepsCollId,
        documentId: step.id,
        data: {
          'order': step.order,
          'title': step.title,
          'content': step.content,
          'imageUrls': step.imageUrls,
          'videoUrl': step.videoUrl,
          'warningNote': step.warningNote,
          'duration': step.duration,
        },
      );
      debugPrint('Appwrite: [SUCCESS] updateStep updated step ${step.id}');
    } on AppwriteException catch (e) {
      debugPrint(
          'Appwrite: [ERROR] updateStep for ${step.id}: [${e.code}] ${e.message}');
      rethrow;
    } catch (e) {
      debugPrint('Appwrite: [FATAL] updateStep for ${step.id}: $e');
      rethrow;
    }
  }

  @override
  Future<String> uploadGuideCover(
    String guideId,
    List<int> imageBytes,
    String fileName,
  ) async {
    try {
      debugPrint('Appwrite: [DEBUG] uploadGuideCover for guide $guideId');
      final url = await _uploadFile(
        bytes: imageBytes,
        fileName: fileName,
        contentType: _imageContentType(fileName),
      );
      await updateGuideCover(guideId, url);
      return url;
    } catch (e) {
      debugPrint('Appwrite: [ERROR] uploadGuideCover: $e');
      rethrow;
    }
  }

  @override
  Future<void> updateGuideCover(String guideId, String coverImageUrl) async {
    try {
      await _db.updateDocument(
        databaseId: _dbId,
        collectionId: _guidesCollId,
        documentId: guideId,
        data: {
          'coverImage': coverImageUrl,
          'updatedAt': DateTime.now().toIso8601String(),
        },
      );
    } catch (e) {
      debugPrint('Appwrite: [ERROR] updateGuideCover: $e');
      rethrow;
    }
  }

  @override
  Future<String> uploadStepImage(
    String guideId,
    String stepId,
    List<int> imageBytes,
    String fileName,
  ) async {
    try {
      debugPrint('Appwrite: [DEBUG] uploadStepImage for step $stepId');
      final url = await _uploadFile(
        bytes: imageBytes,
        fileName: fileName,
        contentType: _imageContentType(fileName),
      );
      await _appendStepImage(stepId, url);
      return url;
    } catch (e) {
      debugPrint('Appwrite: [ERROR] uploadStepImage: $e');
      rethrow;
    }
  }

  @override
  Future<String> uploadStepVideo(
    String guideId,
    String stepId,
    List<int> videoBytes,
    String fileName,
  ) async {
    try {
      debugPrint('Appwrite: [DEBUG] uploadStepVideo for step $stepId');
      final url = await _uploadFile(
        bytes: videoBytes,
        fileName: fileName,
        contentType: _videoContentType(fileName),
      );
      await _db.updateDocument(
        databaseId: _dbId,
        collectionId: _stepsCollId,
        documentId: stepId,
        data: {'videoUrl': url},
      );
      return url;
    } catch (e) {
      debugPrint('Appwrite: [ERROR] uploadStepVideo: $e');
      rethrow;
    }
  }

  @override
  Future<void> incrementViews(String guideId) async {
    try {
      final guide = await getGuideById(guideId);
      if (guide == null) return;
      await _db.updateDocument(
        databaseId: _dbId,
        collectionId: _guidesCollId,
        documentId: guideId,
        data: {'views': guide.views + 1},
      );
    } catch (e) {
      debugPrint('Appwrite: [ERROR] incrementViews for $guideId: $e');
    }
  }

  @override
  Future<void> toggleBookmark(String guideId, String userId) async {
    try {
      debugPrint('Appwrite: [DEBUG] toggleBookmark for $guideId by $userId');
      final existing = await _findUserBookmark(guideId, userId);
      final guide = await getGuideById(guideId);
      var nextCount = guide?.bookmarks ?? 0;

      if (existing != null) {
        await _db.deleteDocument(
          databaseId: _dbId,
          collectionId: _bookmarksCollId,
          documentId: existing.$id,
        );
        nextCount = nextCount > 0 ? nextCount - 1 : 0;
        debugPrint('Appwrite: [SUCCESS] Removed bookmark for $guideId');
      } else {
        await _db.createDocument(
          databaseId: _dbId,
          collectionId: _bookmarksCollId,
          documentId: ID.unique(),
          data: {
            'guideId': guideId,
            'userId': userId,
            'createdAt': DateTime.now().toIso8601String(),
          },
          permissions: [
            Permission.read(Role.user(userId)),
            Permission.update(Role.user(userId)),
            Permission.delete(Role.user(userId)),
          ],
        );
        nextCount++;
        debugPrint('Appwrite: [SUCCESS] Added bookmark for $guideId');
      }

      await _db.updateDocument(
        databaseId: _dbId,
        collectionId: _guidesCollId,
        documentId: guideId,
        data: {'bookmarks': nextCount},
      );
    } on AppwriteException catch (e) {
      debugPrint('Appwrite: [ERROR] toggleBookmark: [${e.code}] ${e.message}');
    } catch (e) {
      debugPrint('Appwrite: [FATAL] toggleBookmark: $e');
    }
  }

  @override
  Stream<bool> watchGuideBookmarkStatus(String guideId, String userId) {
    return Stream.fromFuture(_findUserBookmark(guideId, userId))
        .map((doc) => doc != null)
        .handleError((e) {
      debugPrint('Appwrite: [ERROR] watchGuideBookmarkStatus: $e');
    });
  }

  @override
  Future<void> rateGuide({
    required String guideId,
    required String userId,
    required double rating,
    String review = '',
  }) async {
    try {
      debugPrint(
          'Appwrite: [DEBUG] rateGuide for $guideId with rating $rating');
      final existing = await _findUserRating(guideId, userId);
      final data = {
        'guideId': guideId,
        'userId': userId,
        'rating': rating,
        'review': review,
        'updatedAt': DateTime.now().toIso8601String(),
      };

      if (existing == null) {
        await _db.createDocument(
          databaseId: _dbId,
          collectionId: _ratingsCollId,
          documentId: ID.unique(),
          data: {...data, 'createdAt': DateTime.now().toIso8601String()},
          permissions: [
            Permission.read(Role.any()),
            Permission.update(Role.user(userId)),
            Permission.delete(Role.user(userId)),
          ],
        );
        debugPrint('Appwrite: [SUCCESS] Created rating for $guideId');
      } else {
        await _db.updateDocument(
          databaseId: _dbId,
          collectionId: _ratingsCollId,
          documentId: existing.$id,
          data: data,
        );
        debugPrint('Appwrite: [SUCCESS] Updated rating for $guideId');
      }

      await _recalculateGuideRating(guideId);
    } on AppwriteException catch (e) {
      debugPrint('Appwrite: [ERROR] rateGuide: [${e.code}] ${e.message}');
    } catch (e) {
      debugPrint('Appwrite: [FATAL] rateGuide: $e');
    }
  }

  @override
  Future<double?> getUserRating(String guideId, String userId) async {
    try {
      final doc = await _findUserRating(guideId, userId);
      final value = doc?.data['rating'];
      return value is num ? value.toDouble() : null;
    } catch (e) {
      debugPrint('Appwrite: [ERROR] getUserRating: $e');
      return null;
    }
  }

  Future<String> _uploadFile({
    required List<int> bytes,
    required String fileName,
    String? contentType,
  }) async {
    final file = await _storage.createFile(
      bucketId: _guideAssetsBucketId,
      fileId: ID.unique(),
      file: InputFile.fromBytes(
        bytes: bytes,
        filename: fileName,
        contentType: contentType,
      ),
      permissions: [Permission.read(Role.any())],
    );
    return _fileUrl(_guideAssetsBucketId, file.$id);
  }

  Future<void> _appendStepImage(String stepId, String imageUrl) async {
    final doc = await _db.getDocument(
      databaseId: _dbId,
      collectionId: _stepsCollId,
      documentId: stepId,
    );
    final existing = List<String>.from(doc.data['imageUrls'] ?? const []);
    await _db.updateDocument(
      databaseId: _dbId,
      collectionId: _stepsCollId,
      documentId: stepId,
      data: {
        'imageUrls': [...existing, imageUrl]
      },
    );
  }

  Future<dynamic> _findUserBookmark(String guideId, String userId) async {
    try {
      final snap = await _db.listDocuments(
        databaseId: _dbId,
        collectionId: _bookmarksCollId,
        queries: [
          Query.equal('guideId', guideId),
          Query.equal('userId', userId),
          Query.limit(1),
        ],
      );
      return snap.documents.isEmpty ? null : snap.documents.first;
    } catch (e) {
      debugPrint('Appwrite: [ERROR] _findUserBookmark: $e');
      return null;
    }
  }

  Future<dynamic> _findUserRating(String guideId, String userId) async {
    try {
      final snap = await _db.listDocuments(
        databaseId: _dbId,
        collectionId: _ratingsCollId,
        queries: [
          Query.equal('guideId', guideId),
          Query.equal('userId', userId),
          Query.limit(1),
        ],
      );
      return snap.documents.isEmpty ? null : snap.documents.first;
    } catch (e) {
      debugPrint('Appwrite: [ERROR] _findUserRating: $e');
      return null;
    }
  }

  Future<void> _recalculateGuideRating(String guideId) async {
    try {
      final snap = await _db.listDocuments(
        databaseId: _dbId,
        collectionId: _ratingsCollId,
        queries: [Query.equal('guideId', guideId), Query.limit(100)],
      );
      final ratings = snap.documents
          .map((doc) => doc.data['rating'])
          .whereType<num>()
          .map((value) => value.toDouble())
          .toList();
      if (ratings.isEmpty) return;

      final average = ratings.reduce((a, b) => a + b) / ratings.length;
      final reviewCount = snap.documents
          .where(
              (doc) => (doc.data['review'] as String? ?? '').trim().isNotEmpty)
          .length;

      await _db.updateDocument(
        databaseId: _dbId,
        collectionId: _guidesCollId,
        documentId: guideId,
        data: {
          'rating': double.parse(average.toStringAsFixed(1)),
          'ratingCount': ratings.length,
          'reviewCount': reviewCount,
        },
      );
    } catch (e) {
      debugPrint('Appwrite: [ERROR] _recalculateGuideRating for $guideId: $e');
    }
  }

  String _fileUrl(String bucketId, String fileId) {
    return Uri.parse(
      '$_endpoint/storage/buckets/${Uri.encodeComponent(bucketId)}'
      '/files/${Uri.encodeComponent(fileId)}/view',
    ).replace(queryParameters: {'project': _projectId}).toString();
  }

  String? _imageContentType(String fileName) {
    final lower = fileName.toLowerCase();
    if (lower.endsWith('.png')) return 'image/png';
    if (lower.endsWith('.webp')) return 'image/webp';
    if (lower.endsWith('.gif')) return 'image/gif';
    return 'image/jpeg';
  }

  String? _videoContentType(String fileName) {
    final lower = fileName.toLowerCase();
    if (lower.endsWith('.mov')) return 'video/quicktime';
    if (lower.endsWith('.webm')) return 'video/webm';
    return 'video/mp4';
  }
}

import 'package:appwrite/appwrite.dart';
import '../../../../core/constants/app_constants.dart';

abstract class HomeRemoteDataSource {
  Future<List<Map<String, dynamic>>> getPopularServicesDocs();
  Future<List<Map<String, dynamic>>> getRegularServicesDocs();
  Future<List<Map<String, dynamic>>> getBannerDocs();
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final Databases _db;
  final String _databaseId;

  HomeRemoteDataSourceImpl(this._db, this._databaseId);

  @override
  Future<List<Map<String, dynamic>>> getPopularServicesDocs() async {
    final snap = await _db.listDocuments(
      databaseId: _databaseId,
      collectionId: AppwriteConstants.popularServicesCollectionId,
      queries: [Query.limit(100)],
    );
    return snap.documents.map((d) => {'id': d.$id, ...d.data}).toList();
  }

  @override
  Future<List<Map<String, dynamic>>> getRegularServicesDocs() async {
    final snap = await _db.listDocuments(
      databaseId: _databaseId,
      collectionId: AppwriteConstants.servicesCollectionId,
      queries: [Query.limit(100)],
    );
    return snap.documents.map((d) => {'id': d.$id, ...d.data}).toList();
  }

  @override
  Future<List<Map<String, dynamic>>> getBannerDocs() async {
    final snap = await _db.listDocuments(
      databaseId: _databaseId,
      collectionId: AppwriteConstants.bannersCollectionId,
      queries: [Query.equal('isActive', true), Query.limit(10)],
    );
    return snap.documents.map((d) => {'id': d.$id, ...d.data}).toList();
  }
}

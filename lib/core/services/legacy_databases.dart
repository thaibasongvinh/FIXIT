// ignore_for_file: implementation_imports

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as models;
import 'package:appwrite/src/enums.dart';

/// Compatibility wrapper for the deprecated Databases document endpoints.
///
/// Appwrite SDK 24.x expects legacy document attributes inside a `data` field,
/// while the current Cloud response for `/databases/.../documents` still returns
/// custom attributes at the top level. This wrapper restores `Document.data`
/// for the rest of the app until the project migrates to TablesDB rows.
class LegacyDatabases extends Databases {
  LegacyDatabases(super.client);

  @override
  Future<models.DocumentList> listDocuments({
    required String databaseId,
    required String collectionId,
    List<String>? queries,
    String? transactionId,
    bool? total,
    int? ttl,
  }) async {
    final path = '/databases/$databaseId/collections/$collectionId/documents';
    final params = <String, dynamic>{
      if (queries != null) 'queries': queries,
      if (transactionId != null) 'transactionId': transactionId,
      if (total != null) 'total': total,
      if (ttl != null) 'ttl': ttl,
    };

    final res = await client.call(
      HttpMethod.get,
      path: path,
      params: params,
      headers: const {},
    );

    return models.DocumentList.fromMap(
        normalizeLegacyDocumentListPayload(res.data));
  }

  @override
  Future<models.Document> createDocument({
    required String databaseId,
    required String collectionId,
    required String documentId,
    required Map data,
    List<String>? permissions,
    String? transactionId,
  }) async {
    final path = '/databases/$databaseId/collections/$collectionId/documents';
    final params = <String, dynamic>{
      'documentId': documentId,
      'data': data,
      'permissions': permissions,
      'transactionId': transactionId,
    };

    final res = await client.call(
      HttpMethod.post,
      path: path,
      params: params,
      headers: const {'content-type': 'application/json'},
    );

    return models.Document.fromMap(normalizeLegacyDocumentPayload(res.data));
  }

  @override
  Future<models.Document> getDocument({
    required String databaseId,
    required String collectionId,
    required String documentId,
    List<String>? queries,
    String? transactionId,
  }) async {
    final path =
        '/databases/$databaseId/collections/$collectionId/documents/$documentId';
    final params = <String, dynamic>{
      if (queries != null) 'queries': queries,
      if (transactionId != null) 'transactionId': transactionId,
    };

    final res = await client.call(
      HttpMethod.get,
      path: path,
      params: params,
      headers: const {},
    );

    return models.Document.fromMap(normalizeLegacyDocumentPayload(res.data));
  }

  @override
  Future<models.Document> upsertDocument({
    required String databaseId,
    required String collectionId,
    required String documentId,
    Map? data,
    List<String>? permissions,
    String? transactionId,
  }) async {
    final path =
        '/databases/$databaseId/collections/$collectionId/documents/$documentId';
    final params = <String, dynamic>{
      if (data != null) 'data': data,
      'permissions': permissions,
      'transactionId': transactionId,
    };

    final res = await client.call(
      HttpMethod.put,
      path: path,
      params: params,
      headers: const {'content-type': 'application/json'},
    );

    return models.Document.fromMap(normalizeLegacyDocumentPayload(res.data));
  }

  @override
  Future<models.Document> updateDocument({
    required String databaseId,
    required String collectionId,
    required String documentId,
    Map? data,
    List<String>? permissions,
    String? transactionId,
  }) async {
    final path =
        '/databases/$databaseId/collections/$collectionId/documents/$documentId';
    final params = <String, dynamic>{
      if (data != null) 'data': data,
      'permissions': permissions,
      'transactionId': transactionId,
    };

    final res = await client.call(
      HttpMethod.patch,
      path: path,
      params: params,
      headers: const {'content-type': 'application/json'},
    );

    return models.Document.fromMap(normalizeLegacyDocumentPayload(res.data));
  }

  @override
  Future<models.Document> decrementDocumentAttribute({
    required String databaseId,
    required String collectionId,
    required String documentId,
    required String attribute,
    double? value,
    double? min,
    String? transactionId,
  }) async {
    final path =
        '/databases/$databaseId/collections/$collectionId/documents/$documentId/$attribute/decrement';
    final params = <String, dynamic>{
      if (value != null) 'value': value,
      'min': min,
      'transactionId': transactionId,
    };

    final res = await client.call(
      HttpMethod.patch,
      path: path,
      params: params,
      headers: const {'content-type': 'application/json'},
    );

    return models.Document.fromMap(normalizeLegacyDocumentPayload(res.data));
  }

  @override
  Future<models.Document> incrementDocumentAttribute({
    required String databaseId,
    required String collectionId,
    required String documentId,
    required String attribute,
    double? value,
    double? max,
    String? transactionId,
  }) async {
    final path =
        '/databases/$databaseId/collections/$collectionId/documents/$documentId/$attribute/increment';
    final params = <String, dynamic>{
      if (value != null) 'value': value,
      'max': max,
      'transactionId': transactionId,
    };

    final res = await client.call(
      HttpMethod.patch,
      path: path,
      params: params,
      headers: const {'content-type': 'application/json'},
    );

    return models.Document.fromMap(normalizeLegacyDocumentPayload(res.data));
  }
}

/// Normalizes a legacy Appwrite document-list payload to the SDK 24.x shape.
Map<String, dynamic> normalizeLegacyDocumentListPayload(dynamic raw) {
  final map = Map<String, dynamic>.from(raw as Map);
  final documents = (map['documents'] as List? ?? const [])
      .map(normalizeLegacyDocumentPayload)
      .toList(growable: false);
  return {
    ...map,
    'documents': documents,
  };
}

/// Normalizes a legacy Appwrite document payload to the SDK 24.x shape.
Map<String, dynamic> normalizeLegacyDocumentPayload(dynamic raw) {
  final map = Map<String, dynamic>.from(raw as Map);
  final data = map['data'];
  if (data is Map && data.isNotEmpty) {
    return {
      ...map,
      'data': Map<String, dynamic>.from(data),
    };
  }

  final legacyData = <String, dynamic>{};
  for (final entry in map.entries) {
    if (entry.key.startsWith(r'$') || entry.key == 'data') continue;
    legacyData[entry.key] = entry.value;
  }

  return {
    ...map,
    'data': legacyData,
  };
}

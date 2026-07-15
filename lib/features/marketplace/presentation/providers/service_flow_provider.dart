import 'package:appwrite/appwrite.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:fixit/core/config/app_environment_provider.dart';
import 'package:fixit/core/config/appwrite_provider.dart';
import '../../domain/models/service_issue_model.dart';
import '../../domain/models/product_model.dart';
import '../../../guides/domain/models/guide_model.dart';

part 'service_flow_provider.g.dart';

@riverpod
Future<List<ServiceIssueModel>> serviceIssues(ServiceIssuesRef ref, String serviceId) async {
  final db = ref.watch(appwriteDatabasesProvider);
  final env = ref.watch(appEnvironmentProvider);

  final response = await db.listDocuments(
    databaseId: env.appwriteDatabaseId,
    collectionId: 'service_issues',
    queries: [
      Query.equal('serviceId', serviceId),
    ],
  );

  return response.documents
      .map((doc) => ServiceIssueModel.fromAppwrite(doc.data, doc.$id))
      .toList();
}

@riverpod
Future<List<ProductModel>> issueProducts(IssueProductsRef ref, String issueId) async {
  final db = ref.watch(appwriteDatabasesProvider);
  final env = ref.watch(appEnvironmentProvider);

  // Lấy toàn bộ sản phẩm rồi lọc thủ công để tránh lỗi index trên Appwrite với Query.contains
  final response = await db.listDocuments(
    databaseId: env.appwriteDatabaseId,
    collectionId: 'products',
  );

  return response.documents
      .map((doc) => ProductModel.fromAppwrite(doc.data, doc.$id))
      .where((p) => p.relatedIssueIds.contains(issueId))
      .toList();
}

@riverpod
Future<GuideModel?> issueGuide(IssueGuideRef ref, String issueId) async {
  final db = ref.watch(appwriteDatabasesProvider);
  final env = ref.watch(appEnvironmentProvider);

  final response = await db.listDocuments(
    databaseId: env.appwriteDatabaseId,
    collectionId: 'guides',
    queries: [
      Query.equal('issueId', issueId),
      Query.limit(1),
    ],
  );

  if (response.documents.isEmpty) return null;
  return GuideModel.fromAppwrite(response.documents.first);
}

@riverpod
Future<List<Map<String, dynamic>>> issueGuideSteps(IssueGuideStepsRef ref, String guideId) async {
  final db = ref.watch(appwriteDatabasesProvider);
  final env = ref.watch(appEnvironmentProvider);

  final response = await db.listDocuments(
    databaseId: env.appwriteDatabaseId,
    collectionId: 'guide_steps',
    queries: [
      Query.equal('guideId', guideId),
      Query.orderAsc('stepNumber'),
    ],
  );

  return response.documents.map((doc) => doc.data).toList();
}

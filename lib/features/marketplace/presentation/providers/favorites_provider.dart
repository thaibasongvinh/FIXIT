import 'package:appwrite/appwrite.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/config/app_environment_provider.dart';
import '../../../../core/config/appwrite_provider.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

part 'favorites_provider.g.dart';

@riverpod
class Favorites extends _$Favorites {
  static const _collectionId = 'favorites';

  @override
  Stream<Set<String>> build() {
    final user = ref.watch(authStateProvider).valueOrNull;
    if (user == null) return Stream.value(const {});

    final env = ref.watch(appEnvironmentProvider);
    final db = ref.watch(appwriteDatabasesProvider);

    return Stream.fromFuture(
      db.listDocuments(
        databaseId: env.appwriteDatabaseId,
        collectionId: _collectionId,
        queries: [
          Query.equal('userId', user.$id),
          Query.limit(100),
        ],
      ),
    ).map((snap) => snap.documents
        .map((doc) => doc.data['technicianId'] as String?)
        .whereType<String>()
        .toSet());
  }

  Future<void> toggleFavorite(String techId) async {
    final user = ref.read(authStateProvider).valueOrNull;
    if (user == null) return;

    final env = ref.read(appEnvironmentProvider);
    final db = ref.read(appwriteDatabasesProvider);
    final existing = await db.listDocuments(
      databaseId: env.appwriteDatabaseId,
      collectionId: _collectionId,
      queries: [
        Query.equal('userId', user.$id),
        Query.equal('technicianId', techId),
        Query.limit(1),
      ],
    );

    if (existing.documents.isNotEmpty) {
      await db.deleteDocument(
        databaseId: env.appwriteDatabaseId,
        collectionId: _collectionId,
        documentId: existing.documents.first.$id,
      );
    } else {
      await db.createDocument(
        databaseId: env.appwriteDatabaseId,
        collectionId: _collectionId,
        documentId: ID.unique(),
        data: {
          'userId': user.$id,
          'technicianId': techId,
          'createdAt': DateTime.now().toIso8601String(),
        },
        permissions: [
          Permission.read(Role.user(user.$id)),
          Permission.update(Role.user(user.$id)),
          Permission.delete(Role.user(user.$id)),
        ],
      );
    }

    ref.invalidateSelf();
  }
}

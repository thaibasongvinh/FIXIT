import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'local_guide.dart';

part 'database_service.g.dart';

@Riverpod(keepAlive: true)
Future<Isar> isarDatabase(IsarDatabaseRef ref) async {
  final dir = await getApplicationDocumentsDirectory();
  return Isar.open(
    [LocalGuideSchema],
    directory: dir.path,
  );
}

@riverpod
class LocalGuideRepository extends _$LocalGuideRepository {
  @override
  Future<List<LocalGuide>> build() async {
    final isar = await ref.watch(isarDatabaseProvider.future);
    return isar.localGuides.where().findAll();
  }

  Future<void> saveGuide(LocalGuide guide) async {
    final isar = await ref.read(isarDatabaseProvider.future);
    await isar.writeTxn(() async {
      await isar.localGuides.put(guide);
    });
    ref.invalidateSelf();
  }

  Future<LocalGuide?> getGuide(String guideId) async {
    final isar = await ref.read(isarDatabaseProvider.future);
    return isar.localGuides.filter().guideIdEqualTo(guideId).findFirst();
  }
}

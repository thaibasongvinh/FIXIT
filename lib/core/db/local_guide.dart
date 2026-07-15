import 'package:isar/isar.dart';

part 'local_guide.g.dart';

@collection
class LocalGuide {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String guideId;

  late String title;
  late String description;
  late String imageUrl;
  late DateTime lastSync;
  
  // Lưu trữ JSON của các bước để đơn giản hóa
  late String stepsJson;
}

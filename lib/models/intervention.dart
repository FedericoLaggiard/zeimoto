import 'package:hive/hive.dart';
import 'enums.dart';

@HiveType(typeId: 12)
class Intervention extends HiveObject {
  @HiveField(0)
  String id;
  @HiveField(1)
  String plantId;
  @HiveField(2)
  InterventionType type;
  @HiveField(3)
  String description;
  @HiveField(4)
  DateTime dateTime;
  @HiveField(5)
  String? photoId;

  Intervention({
    required this.id,
    required this.plantId,
    required this.type,
    required this.description,
    required this.dateTime,
    this.photoId,
  });
}

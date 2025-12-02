import 'package:hive/hive.dart';
import 'enums.dart';

@HiveType(typeId: 11)
class PhotoEntry extends HiveObject {
  @HiveField(0)
  String id;
  @HiveField(1)
  String plantId;
  @HiveField(2)
  String path;
  @HiveField(3)
  DateTime dateTaken;
  @HiveField(4)
  Season season;

  PhotoEntry({
    required this.id,
    required this.plantId,
    required this.path,
    required this.dateTaken,
    required this.season,
  });
}

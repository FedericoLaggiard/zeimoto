import 'package:hive/hive.dart';
import 'enums.dart';

@HiveType(typeId: 10)
class Plant extends HiveObject {
  @HiveField(0)
  String id;
  @HiveField(1)
  String name;
  @HiveField(2)
  String species;
  @HiveField(3)
  WorkStage stage;
  @HiveField(4)
  DateTime createdAt;

  Plant({
    required this.id,
    required this.name,
    required this.species,
    required this.stage,
    required this.createdAt,
  });
}

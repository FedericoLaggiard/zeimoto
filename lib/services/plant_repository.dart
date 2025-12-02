import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import 'package:zeimoto/models/plant.dart';
import 'package:zeimoto/models/enums.dart';

class PlantRepository {
  final _uuid = const Uuid();
  Box get _box => Hive.box('plants');

  Iterable<Plant> all() => _box.values.cast<Plant>().toList()..sort((a, b) => a.name.compareTo(b.name));

  Future<Plant> add({required String name, required String species, required WorkStage stage}) async {
    final plant = Plant(
      id: _uuid.v4(),
      name: name,
      species: species,
      stage: stage,
      createdAt: DateTime.now(),
    );
    await _box.put(plant.id, plant);
    return plant;
  }

  Future<void> delete(String id) async => _box.delete(id);
}

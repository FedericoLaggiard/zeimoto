import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import 'package:zeimoto/models/intervention.dart';
import 'package:zeimoto/models/enums.dart';

class InterventionRepository {
  final _uuid = const Uuid();
  Box get _box => Hive.box('interventions');

  List<Intervention> forPlant(String plantId) {
    return _box.values.cast<Intervention>()
        .where((i) => i.plantId == plantId)
        .toList()
      ..sort((a, b) => b.dateTime.compareTo(a.dateTime));
  }

  Future<Intervention> add({
    required String plantId,
    required InterventionType type,
    required String description,
    String? photoId,
  }) async {
    final i = Intervention(
      id: _uuid.v4(),
      plantId: plantId,
      type: type,
      description: description,
      dateTime: DateTime.now(),
      photoId: photoId,
    );
    await _box.put(i.id, i);
    return i;
  }
}

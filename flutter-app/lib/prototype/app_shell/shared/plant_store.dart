import 'package:flutter/foundation.dart';

import 'plant.dart';

/// In-memory, per-session plant store. No persistence by design — the whole
/// point of the prototype is to inspect flows without a DB.
class PlantStore extends ChangeNotifier {
  PlantStore._();
  static final instance = PlantStore._().._seed();

  final List<Plant> _plants = [];
  List<Plant> get plants => List.unmodifiable(_plants);

  int _counter = 0;

  void _seed() {
    final seeds = <(String, String)>[
      ('Juniperus chinensis', 'shohin del terrazzo'),
      ('Acer palmatum', 'acero rosso'),
      ('Pinus parviflora', 'pino delle nevi'),
      ('Ficus retusa', 'ficus veloce'),
      ('Ulmus parvifolia', 'olmo pigro'),
    ];
    for (final (i, seed) in seeds.indexed) {
      _plants.add(
        Plant(
          id: 'seed_$i',
          species: seed.$1,
          nickname: seed.$2,
          cover: PlaceholderPhoto.random(i * 13),
          createdAt: DateTime.now().subtract(Duration(days: 30 * (i + 1))),
        ),
      );
      _counter++;
    }
  }

  Plant add({
    required String species,
    String? nickname,
    required PlaceholderPhoto cover,
  }) {
    final id = 'p_${DateTime.now().microsecondsSinceEpoch}';
    final resolvedNickname = (nickname == null || nickname.trim().isEmpty)
        ? defaultNickname(species, _counter)
        : nickname.trim();
    final plant = Plant(
      id: id,
      species: species,
      nickname: resolvedNickname,
      cover: cover,
      createdAt: DateTime.now(),
    );
    _plants.insert(0, plant);
    _counter++;
    notifyListeners();
    return plant;
  }
}

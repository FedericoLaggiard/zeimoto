import 'dart:async';
import 'dart:collection';
import 'dart:ui';

import 'package:uuid/uuid.dart';

class Plant {
  const Plant({
    required this.id,
    required this.species,
    required this.nickname,
    required this.cover,
    required this.createdAt,
  });

  final String id;
  final String species;
  final String nickname;
  final PlaceholderPhoto cover;
  final DateTime createdAt;
}

class PlaceholderPhoto {
  const PlaceholderPhoto({
    required this.top,
    required this.bottom,
    required this.glyph,
  });

  final Color top;
  final Color bottom;
  final String glyph;

  static const _palette = <PlaceholderPhoto>[
    PlaceholderPhoto(
      top: Color(0xFF6E8B6A),
      bottom: Color(0xFF2F3F2C),
      glyph: '🌲',
    ),
    PlaceholderPhoto(
      top: Color(0xFFB2A57A),
      bottom: Color(0xFF5A4A2E),
      glyph: '🍁',
    ),
    PlaceholderPhoto(
      top: Color(0xFF9DB7C8),
      bottom: Color(0xFF3A5468),
      glyph: '🌿',
    ),
    PlaceholderPhoto(
      top: Color(0xFFC49A82),
      bottom: Color(0xFF5C382A),
      glyph: '🌳',
    ),
    PlaceholderPhoto(
      top: Color(0xFFA3C4A3),
      bottom: Color(0xFF3D5A3F),
      glyph: '🎋',
    ),
    PlaceholderPhoto(
      top: Color(0xFFD4B896),
      bottom: Color(0xFF6B4423),
      glyph: '🌱',
    ),
  ];

  static PlaceholderPhoto random([int? seed]) {
    final resolvedSeed = seed ?? DateTime.now().microsecondsSinceEpoch;
    return _palette[resolvedSeed.abs() % _palette.length];
  }

  /// All available placeholder photos, in palette order.
  static List<PlaceholderPhoto> get palette => List.unmodifiable(_palette);
}

const kSeedSpecies = <String>[
  'Juniperus chinensis',
  'Acer palmatum',
  'Pinus parviflora',
  'Ficus retusa',
  'Ulmus parvifolia',
  'Carpinus turczaninowii',
  'Prunus mume',
  'Zelkova serrata',
  'Cryptomeria japonica',
  'Punica granatum',
];

String defaultNickname(String species, int existingCount, {String? nickname}) {
  if (nickname != null && nickname.trim().isNotEmpty) {
    return nickname;
  }

  final base = species.trim().split(RegExp(r'\s+')).last.toLowerCase();
  final suffix = (existingCount + 1).toString().padLeft(2, '0');
  return '${base}_$suffix';
}

abstract interface class PlantRepository {
  List<Plant> get plants;

  /// Emits a void event each time a plant is added to the repository.
  Stream<void> get changes;

  Plant add({
    required String species,
    String? nickname,
    required PlaceholderPhoto cover,
  });
}

class InMemoryPlantRepository implements PlantRepository {
  InMemoryPlantRepository({DateTime Function()? now, Uuid? uuid})
    : _now = now ?? DateTime.now,
      _uuid = uuid ?? const Uuid() {
    _seed();
  }

  static const _seedPlants = <(String, String)>[
    ('Juniperus chinensis', 'shohin del terrazzo'),
    ('Acer palmatum', 'acero rosso'),
    ('Pinus parviflora', 'pino delle nevi'),
    ('Ficus retusa', 'ficus veloce'),
    ('Ulmus parvifolia', 'olmo pigro'),
  ];

  final DateTime Function() _now;
  final Uuid _uuid;
  final List<Plant> _plants = <Plant>[];
  final _changesController = StreamController<void>.broadcast();

  @override
  Stream<void> get changes => _changesController.stream;

  @override
  List<Plant> get plants {
    final sortedPlants = List<Plant>.of(_plants)
      ..sort((left, right) => right.createdAt.compareTo(left.createdAt));
    return UnmodifiableListView(sortedPlants);
  }

  @override
  Plant add({
    required String species,
    String? nickname,
    required PlaceholderPhoto cover,
  }) {
    final plant = Plant(
      id: _uuid.v4(),
      species: species,
      nickname: defaultNickname(species, _plants.length, nickname: nickname),
      cover: cover,
      createdAt: _now(),
    );

    _plants.add(plant);
    _changesController.add(null);
    return plant;
  }

  void _seed() {
    final anchor = _now();

    for (final (index, seed) in _seedPlants.indexed) {
      _plants.add(
        Plant(
          id: _uuid.v4(),
          species: seed.$1,
          nickname: seed.$2,
          cover: PlaceholderPhoto.random(index * 13),
          createdAt: anchor.subtract(Duration(days: 30 * (index + 1))),
        ),
      );
    }
  }
}

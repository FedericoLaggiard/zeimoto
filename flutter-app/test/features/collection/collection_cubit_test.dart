import 'package:flutter_test/flutter_test.dart';
import 'package:zeimoto/domain/plants.dart';
import 'package:zeimoto/features/collection/collection_cubit.dart';
import 'package:zeimoto/features/collection/collection_state.dart';

// ---------------------------------------------------------------------------
// Test double
// ---------------------------------------------------------------------------
class _FakeRepo implements PlantRepository {
  final List<Plant> _plants = [];

  @override
  List<Plant> get plants {
    final sorted = List<Plant>.of(_plants)
      ..sort((left, right) => right.createdAt.compareTo(left.createdAt));
    return List.unmodifiable(sorted);
  }

  @override
  Plant add({
    required String species,
    String? nickname,
    required PlaceholderPhoto cover,
  }) {
    final plant = Plant(
      id: 'fake-${_plants.length}',
      species: species,
      nickname: nickname ?? defaultNickname(species, _plants.length),
      cover: cover,
      createdAt: DateTime.now(),
    );
    _plants.insert(0, plant);
    return plant;
  }

  /// Utility to add a plant with explicit createdAt for testing order
  Plant addWithTime({
    required String species,
    required String nickname,
    required PlaceholderPhoto cover,
    required DateTime createdAt,
  }) {
    final plant = Plant(
      id: 'fake-${_plants.length}',
      species: species,
      nickname: nickname,
      cover: cover,
      createdAt: createdAt,
    );
    _plants.add(plant);
    return plant;
  }
}

void main() {
  group('CollectionCubit', () {
    // -------------------------------------------------------------------------
    // SLICE 1: Load plants from repository ordered by createdAt desc
    // -------------------------------------------------------------------------
    test('loads plants from repository sorted by createdAt desc', () {
      final repo = _FakeRepo();

      // Seed with explicit timestamps so we can verify descending order
      final now = DateTime.now();
      final plant1 = repo.addWithTime(
        species: 'Acer palmatum',
        nickname: 'acero_01',
        cover: PlaceholderPhoto.palette.first,
        createdAt: now.subtract(const Duration(hours: 2)),
      );
      final plant2 = repo.addWithTime(
        species: 'Juniperus chinensis',
        nickname: 'ginepro_01',
        cover: PlaceholderPhoto.palette[1],
        createdAt: now.subtract(const Duration(hours: 1)),
      );
      final plant3 = repo.addWithTime(
        species: 'Ficus retusa',
        nickname: 'ficus_01',
        cover: PlaceholderPhoto.palette[2],
        createdAt: now,
      );

      final cubit = CollectionCubit(repo);

      final state = cubit.state as CollectionLoaded;
      expect(state.plants, hasLength(3));
      expect(state.plants[0].id, plant3.id); // most recent first
      expect(state.plants[1].id, plant2.id);
      expect(state.plants[2].id, plant1.id); // oldest last
    });

    test('emits CollectionEmpty when repository has no plants', () {
      final repo = _FakeRepo();
      final cubit = CollectionCubit(repo);

      expect(cubit.state, isA<CollectionEmpty>());
    });
  });
}

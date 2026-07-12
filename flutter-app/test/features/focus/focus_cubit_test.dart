import 'package:flutter_test/flutter_test.dart';
import 'package:zeimoto/domain/plants.dart';
import 'package:zeimoto/features/focus/focus_cubit.dart';
import 'package:zeimoto/features/focus/focus_state.dart';

// ---------------------------------------------------------------------------
// Test double
// ---------------------------------------------------------------------------

class _FakeRepo implements PlantRepository {
  final List<Plant> _plants = [];

  @override
  List<Plant> get plants => List.unmodifiable(_plants);

  @override
  Stream<void> get changes => Stream.empty();

  @override
  Plant add({
    required String species,
    String? nickname,
    required PlaceholderPhoto cover,
  }) {
    throw UnimplementedError('Test fixture only');
  }

  Plant addPlant({
    required String species,
    required String nickname,
    required PlaceholderPhoto cover,
  }) {
    final plant = Plant(
      id: 'fake-${_plants.length}',
      species: species,
      nickname: nickname,
      cover: cover,
      createdAt: DateTime(2026, 1, 10 - _plants.length),
    );
    _plants.add(plant);
    return plant;
  }
}

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  group('FocusCubit', () {
    test('emits FocusEmpty when repository has no plants', () {
      final cubit = FocusCubit(_FakeRepo());
      expect(cubit.state, isA<FocusEmpty>());
    });

    test('emits FocusLoaded with plant at index returned by pickIndex', () {
      final repo = _FakeRepo();
      repo.addPlant(
        species: 'Acer palmatum',
        nickname: 'acero_01',
        cover: PlaceholderPhoto.palette[0],
      );
      repo.addPlant(
        species: 'Juniperus chinensis',
        nickname: 'ginepro_01',
        cover: PlaceholderPhoto.palette[1],
      );

      final cubit = FocusCubit(repo, pickIndex: (_) => 1);

      expect(cubit.state, isA<FocusLoaded>());
      expect((cubit.state as FocusLoaded).plant.nickname, 'ginepro_01');
    });

    test('state does not change after initial selection', () {
      final repo = _FakeRepo();
      repo.addPlant(
        species: 'Acer palmatum',
        nickname: 'acero_01',
        cover: PlaceholderPhoto.palette[0],
      );

      var callCount = 0;
      final cubit = FocusCubit(
        repo,
        pickIndex: (max) {
          callCount += 1;
          return 0;
        },
      );

      final firstState = cubit.state;

      // Simulate multiple reads — state should not change
      expect(cubit.state, same(firstState));
      expect(callCount, 1);
    });

    test('pickIndex receives correct upper bound (plants.length)', () {
      final repo = _FakeRepo();
      for (var i = 0; i < 3; i++) {
        repo.addPlant(
          species: 'Species $i',
          nickname: 'plant_$i',
          cover: PlaceholderPhoto.palette[i % PlaceholderPhoto.palette.length],
        );
      }

      int? receivedMax;
      FocusCubit(
        repo,
        pickIndex: (max) {
          receivedMax = max;
          return 0;
        },
      );

      expect(receivedMax, 3);
    });
  });
}

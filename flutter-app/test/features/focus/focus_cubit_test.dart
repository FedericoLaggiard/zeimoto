import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:zeimoto/domain/plants.dart';
import 'package:zeimoto/features/focus/focus_cubit.dart';
import 'package:zeimoto/features/focus/focus_state.dart';

// ---------------------------------------------------------------------------
// Test double
// ---------------------------------------------------------------------------

class _FakeRepo extends Fake implements PlantRepository {
  final List<Plant> _plants = [];

  @override
  Future<List<Plant>> getAll() async => List.unmodifiable(_plants);

  @override
  Stream<void> get changes => Stream.empty();

  @override
  Future<Plant> add({
    required String species,
    String? nickname,
    required String sourcePhotoPath,
  }) {
    throw UnimplementedError('Test fixture only');
  }

  Plant addPlant({required String species, required String nickname}) {
    final plant = Plant(
      id: 'fake-${_plants.length}',
      species: species,
      nickname: nickname,
      coverPhotoPath: '/fake/photo_${_plants.length}.jpg',
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
    test('emits FocusEmpty when repository has no plants', () async {
      final cubit = FocusCubit(_FakeRepo());
      await Future<void>.microtask(() {});
      expect(cubit.state, isA<FocusEmpty>());
    });

    test('emits FocusLoaded with plant at index returned by pickIndex', () async {
      final repo = _FakeRepo();
      repo.addPlant(species: 'Acer palmatum', nickname: 'acero_01');
      repo.addPlant(species: 'Juniperus chinensis', nickname: 'ginepro_01');

      final cubit = FocusCubit(repo, pickIndex: (_) => 1);
      await Future<void>.microtask(() {});

      expect(cubit.state, isA<FocusLoaded>());
      expect((cubit.state as FocusLoaded).plant.nickname, 'ginepro_01');
    });

    test('state does not change after initial selection', () async {
      final repo = _FakeRepo();
      repo.addPlant(species: 'Acer palmatum', nickname: 'acero_01');

      var callCount = 0;
      final cubit = FocusCubit(
        repo,
        pickIndex: (max) {
          callCount += 1;
          return 0;
        },
      );
      await Future<void>.microtask(() {});

      final firstState = cubit.state;
      expect(cubit.state, same(firstState));
      expect(callCount, 1);
    });

    test('pickIndex receives correct upper bound (plants.length)', () async {
      final repo = _FakeRepo();
      for (var i = 0; i < 3; i++) {
        repo.addPlant(species: 'Species $i', nickname: 'plant_$i');
      }

      int? receivedMax;
      FocusCubit(
        repo,
        pickIndex: (max) {
          receivedMax = max;
          return 0;
        },
      );
      await Future<void>.microtask(() {});

      expect(receivedMax, 3);
    });
  });
}

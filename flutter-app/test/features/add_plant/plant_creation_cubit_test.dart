import 'package:flutter_test/flutter_test.dart';

import 'package:zeimoto/domain/plants.dart';
import 'package:zeimoto/features/add_plant/plant_creation_cubit.dart';
import 'package:zeimoto/features/add_plant/plant_creation_state.dart';

// ---------------------------------------------------------------------------
// Test double
// ---------------------------------------------------------------------------
class _FakeRepo implements PlantRepository {
  final List<Plant> _plants = [];

  @override
  List<Plant> get plants => List.unmodifiable(_plants);

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
}

void main() {
  late _FakeRepo repo;
  late PlantCreationCubit cubit;

  setUp(() {
    repo = _FakeRepo();
    cubit = PlantCreationCubit(repo);
  });

  tearDown(() => cubit.close());

  group('PlantCreationCubit', () {
    // -------------------------------------------------------------------------
    // Initial state
    // -------------------------------------------------------------------------
    test('initial state is PlantCreationCollecting on step Foto', () {
      final state = cubit.state as PlantCreationCollecting;
      expect(state.step, WizardStep.foto);
      expect(state.selectedPhoto, isNull);
      expect(state.species, isEmpty);
      expect(state.nickname, isEmpty);
    });

    // -------------------------------------------------------------------------
    // Step Foto
    // -------------------------------------------------------------------------
    group('step Foto', () {
      test('canAdvance is false when no photo is selected', () {
        expect((cubit.state as PlantCreationCollecting).canAdvance, isFalse);
      });

      test('canAdvance becomes true after selectPhoto', () {
        cubit.selectPhoto(PlaceholderPhoto.palette.first);
        expect((cubit.state as PlantCreationCollecting).canAdvance, isTrue);
      });

      test('advance without a selected photo is a no-op', () {
        cubit.advance();
        expect((cubit.state as PlantCreationCollecting).step, WizardStep.foto);
      });

      test('advance after selecting a photo moves to step Specie', () {
        cubit.selectPhoto(PlaceholderPhoto.palette.first);
        cubit.advance();
        expect(
          (cubit.state as PlantCreationCollecting).step,
          WizardStep.specie,
        );
      });
    });

    // -------------------------------------------------------------------------
    // Step Specie
    // -------------------------------------------------------------------------
    group('step Specie', () {
      setUp(() {
        cubit.selectPhoto(PlaceholderPhoto.palette.first);
        cubit.advance();
      });

      test('canAdvance is false when species is empty', () {
        expect((cubit.state as PlantCreationCollecting).canAdvance, isFalse);
      });

      test(
        'canAdvance becomes true after changeSpecies with a non-blank value',
        () {
          cubit.changeSpecies('Ficus carica');
          expect((cubit.state as PlantCreationCollecting).canAdvance, isTrue);
        },
      );

      test('canAdvance remains false for whitespace-only species', () {
        cubit.changeSpecies('   ');
        expect((cubit.state as PlantCreationCollecting).canAdvance, isFalse);
      });

      test('advance with a valid species moves to step Nickname', () {
        cubit.changeSpecies('Acer palmatum');
        cubit.advance();
        expect(
          (cubit.state as PlantCreationCollecting).step,
          WizardStep.nickname,
        );
      });
    });

    // -------------------------------------------------------------------------
    // Step Nickname
    // -------------------------------------------------------------------------
    group('step Nickname', () {
      setUp(() {
        cubit.selectPhoto(PlaceholderPhoto.palette.first);
        cubit.advance();
        cubit.changeSpecies(kSeedSpecies.first);
        cubit.advance();
      });

      test('canAdvance is always true on the Nickname step', () {
        expect((cubit.state as PlantCreationCollecting).canAdvance, isTrue);
      });
    });

    // -------------------------------------------------------------------------
    // save
    // -------------------------------------------------------------------------
    group('save', () {
      setUp(() {
        cubit.selectPhoto(PlaceholderPhoto.palette.first);
        cubit.advance();
        cubit.changeSpecies(kSeedSpecies.first);
        cubit.advance();
      });

      test('emits PlantCreationSaved with the created plant', () {
        cubit.save();
        expect(cubit.state, isA<PlantCreationSaved>());
        final saved = cubit.state as PlantCreationSaved;
        expect(saved.plant.species, kSeedSpecies.first);
      });

      test('plant appears in the repository after save', () {
        cubit.save();
        expect(repo.plants, hasLength(1));
        expect(repo.plants.first.species, kSeedSpecies.first);
      });

      test(
        'empty nickname triggers repository default nickname generation',
        () {
          cubit.save();
          final saved = cubit.state as PlantCreationSaved;
          expect(saved.plant.nickname, isNotEmpty);
        },
      );

      test('provided nickname is trimmed and used', () {
        cubit.changeNickname('  Momiji  ');
        cubit.save();
        final saved = cubit.state as PlantCreationSaved;
        expect(saved.plant.nickname, 'Momiji');
      });

      test('nickname longer than 100 characters throws ArgumentError', () {
        cubit.changeNickname('a' * 101);
        expect(cubit.save, throwsArgumentError);
      });

      test('nickname with control characters throws ArgumentError', () {
        cubit.changeNickname('bad\x01name');
        expect(cubit.save, throwsArgumentError);
      });
    });
  });
}

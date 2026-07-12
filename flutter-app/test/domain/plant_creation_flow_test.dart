import 'package:flutter_test/flutter_test.dart';
import 'package:zeimoto/domain/plant_creation_flow.dart';
import 'package:zeimoto/domain/plants.dart';

// ---------------------------------------------------------------------------
// Test double — minimal fake that satisfies the PlantRepository interface.
// Inserts plants at the front so `.plants.first` reflects the latest addition.
// ---------------------------------------------------------------------------
class _FakePlantRepository implements PlantRepository {
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
      // Mirror InMemoryPlantRepository: generate the default when
      // nickname is absent (flow already normalised blank → null).
      nickname: nickname ?? defaultNickname(species, _plants.length),
      cover: cover,
      createdAt: DateTime.now(),
    );
    _plants.insert(0, plant);
    return plant;
  }
}

void main() {
  late _FakePlantRepository repository;
  late PlantCreationFlow flow;

  setUp(() {
    repository = _FakePlantRepository();
    flow = PlantCreationFlow(repository);
  });

  group('PlantCreationFlow', () {
    // -------------------------------------------------------------------------
    // Cycle 1 — tracer bullet: happy path end-to-end
    // -------------------------------------------------------------------------
    test(
      'returns the created plant and places it at the front of the repository',
      () {
        final cover = PlaceholderPhoto.random(0);

        final plant = flow.execute(
          cover: cover,
          species: 'Acer palmatum',
          nickname: 'Momiji',
        );

        expect(plant.species, 'Acer palmatum');
        expect(plant.nickname, 'Momiji');
        expect(repository.plants.first, same(plant));
      },
    );

    // -------------------------------------------------------------------------
    // Cycle 2 — missing cover
    // -------------------------------------------------------------------------
    test('throws ArgumentError when cover is null', () {
      expect(
        () => flow.execute(cover: null, species: 'Acer palmatum'),
        throwsA(isA<ArgumentError>()),
      );
    });

    // -------------------------------------------------------------------------
    // Cycle 3 — empty species
    // -------------------------------------------------------------------------
    test('throws ArgumentError when species is empty', () {
      expect(
        () => flow.execute(cover: PlaceholderPhoto.random(0), species: ''),
        throwsA(isA<ArgumentError>()),
      );
    });

    // -------------------------------------------------------------------------
    // Cycle 4 — whitespace-only species
    // -------------------------------------------------------------------------
    test('throws ArgumentError when species is whitespace only', () {
      expect(
        () => flow.execute(cover: PlaceholderPhoto.random(0), species: '   '),
        throwsA(isA<ArgumentError>()),
      );
    });

    // -------------------------------------------------------------------------
    // Cycle 5 — blank nickname → default generated nickname
    // -------------------------------------------------------------------------
    test('uses default nickname when nickname is null', () {
      final plant = flow.execute(
        cover: PlaceholderPhoto.random(0),
        species: 'Acer palmatum',
      );

      expect(plant.nickname, 'palmatum_01');
    });

    test('uses default nickname when nickname is whitespace', () {
      final plant = flow.execute(
        cover: PlaceholderPhoto.random(0),
        species: 'Acer palmatum',
        nickname: '   ',
      );

      expect(plant.nickname, 'palmatum_01');
    });

    // -------------------------------------------------------------------------
    // Nickname normalisation & validation
    // -------------------------------------------------------------------------
    test('trims leading and trailing whitespace from a valid nickname', () {
      final plant = flow.execute(
        cover: PlaceholderPhoto.random(0),
        species: 'Acer palmatum',
        nickname: '  Momiji  ',
      );

      expect(plant.nickname, 'Momiji');
    });

    test('throws ArgumentError when nickname exceeds 100 characters', () {
      expect(
        () => flow.execute(
          cover: PlaceholderPhoto.random(0),
          species: 'Acer palmatum',
          nickname: 'a' * 101,
        ),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('throws ArgumentError when nickname contains a control character', () {
      expect(
        () => flow.execute(
          cover: PlaceholderPhoto.random(0),
          species: 'Acer palmatum',
          nickname: 'Momiji\x00',
        ),
        throwsA(isA<ArgumentError>()),
      );
    });
  });
}

import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:zeimoto/data/db/app_database.dart' as appDb;
import 'package:zeimoto/data/repositories/drift_plant_repository.dart';
import 'package:zeimoto/domain/plants.dart';

void main() {
  late Directory tmpDir;
  late File sourceFile;
  late appDb.AppDatabase db;
  late DriftPlantRepository repo;

  setUp(() async {
    tmpDir = await Directory.systemTemp.createTemp('zeimoto_test_');
    sourceFile = File('${tmpDir.path}/test_source.jpg');
    // Minimal JPEG header — enough for a file to exist and be copyable.
    await sourceFile.writeAsBytes([0xFF, 0xD8, 0xFF, 0xE0, 0x00, 0x10]);

    db = appDb.AppDatabase(NativeDatabase.memory());
    repo = DriftPlantRepository(
      db,
      applicationDocumentsDir: () async => tmpDir,
    );
  });

  tearDown(() async {
    await db.close();
    await tmpDir.delete(recursive: true);
  });

  group('DriftPlantRepository', () {
    test('getAll() returns empty list when no plants exist', () async {
      final plants = await repo.getAll();
      expect(plants, isEmpty);
    });

    test('add() returns the newly created Plant', () async {
      final plant = await repo.add(
        species: 'Acer palmatum',
        sourcePhotoPath: sourceFile.path,
      );

      expect(plant.species, 'Acer palmatum');
      expect(plant.coverPhotoPath, isNotEmpty);
      expect(plant.id, isNotEmpty);
    });

    test('add() uses provided nickname', () async {
      final plant = await repo.add(
        species: 'Ficus carica',
        nickname: 'Fico di nonna',
        sourcePhotoPath: sourceFile.path,
      );

      expect(plant.nickname, 'Fico di nonna');
    });

    test('add() generates a default nickname when none is provided', () async {
      final plant = await repo.add(
        species: 'Juniperus chinensis',
        sourcePhotoPath: sourceFile.path,
      );

      // defaultNickname uses the last word of species (lowercased) + padded count.
      expect(plant.nickname, isNotEmpty);
      expect(plant.nickname, contains('chinensis'));
    });

    test('getAll() returns the added plant after add()', () async {
      await repo.add(
        species: 'Acer palmatum',
        sourcePhotoPath: sourceFile.path,
      );

      final plants = await repo.getAll();
      expect(plants, hasLength(1));
      expect(plants.first.species, 'Acer palmatum');
    });

    test('getAll() returns multiple plants sorted by createdAt descending', () async {
      await repo.add(species: 'Acer palmatum', sourcePhotoPath: sourceFile.path);
      // Drift stores DateTime as Unix epoch in seconds (INTEGER); need >1s gap
      // for distinct timestamps to produce a deterministic ordering.
      await Future<void>.delayed(const Duration(seconds: 1, milliseconds: 100));
      await repo.add(species: 'Juniperus chinensis', sourcePhotoPath: sourceFile.path);

      final plants = await repo.getAll();
      expect(plants, hasLength(2));
      expect(
        plants.map((p) => p.species),
        containsAllInOrder(['Juniperus chinensis', 'Acer palmatum']),
      );
    });

    test('add() copies the source file into the documents directory', () async {
      final plant = await repo.add(
        species: 'Acer palmatum',
        sourcePhotoPath: sourceFile.path,
      );

      final copiedFile = File(plant.coverPhotoPath);
      expect(copiedFile.existsSync(), isTrue);
    });

    test('changes stream emits after add()', () async {
      final emission = repo.changes.first;
      await repo.add(species: 'Acer palmatum', sourcePhotoPath: sourceFile.path);
      await expectLater(emission, completes);
    });
  });
}

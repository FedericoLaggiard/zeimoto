import 'dart:io';

import 'package:drift/drift.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

import '../../domain/plants.dart';
// Use a prefix to disambiguate the Drift-generated `Plant` data class from
// the domain `Plant` entity defined in domain/plants.dart.
import '../db/app_database.dart' as appDb;

/// Drift-backed implementation of [PlantRepository].
///
/// Injected with [AppDatabase] via constructor for full testability:
/// ```dart
/// final db = AppDatabase(NativeDatabase.memory());
/// final repo = DriftPlantRepository(db);
/// ```
///
/// [applicationDocumentsDir] can be overridden in tests to avoid calling
/// [getApplicationDocumentsDirectory] which requires a real app context.
class DriftPlantRepository implements PlantRepository {
  DriftPlantRepository(
    this._db, {
    Future<Directory> Function()? applicationDocumentsDir,
    Uuid? uuid,
  }) : _applicationDocumentsDir =
           applicationDocumentsDir ?? getApplicationDocumentsDirectory,
       _uuid = uuid ?? const Uuid();

  final appDb.AppDatabase _db;
  final Future<Directory> Function() _applicationDocumentsDir;
  final Uuid _uuid;

  @override
  Future<List<Plant>> getAll() async {
    final docsDir = await _applicationDocumentsDir();

    final query = _db.select(_db.plants).join([
      innerJoin(_db.photos, _db.photos.id.equalsExp(_db.plants.coverPhotoId)),
    ])..orderBy([OrderingTerm.desc(_db.plants.createdAt)]);

    final rows = await query.get();
    return rows
        .map(
        (row) => _toPlant(
            row.readTable(_db.plants),
            row.readTable(_db.photos),
            docsDir.path,
          ),
        )
        .toList();
  }

  @override
  Stream<void> get changes =>
      _db.select(_db.plants).watch().map((_) => null);

  /// Creates a new plant, copying [sourcePhotoPath] into the app documents
  /// directory under `photos/<uuid>.jpg` before inserting the DB records.
  ///
  /// The INSERT into `photos` and `plants` is wrapped in a single transaction
  /// to ensure the invariant "no orphan `photos` row in DB" (relaxed on the
  /// filesystem per ticket #35 — stale JPEG files are acceptable for MVP).
  @override
  Future<Plant> add({
    required String species,
    String? nickname,
    required String sourcePhotoPath,
  }) async {
    final docsDir = await _applicationDocumentsDir();
    final photoId = _uuid.v4();
    final plantId = _uuid.v4();
    final relativePath = 'photos/$photoId.jpg';
    final targetPath = '${docsDir.path}/$relativePath';

    // Ensure photos subdirectory exists.
    await Directory('${docsDir.path}/photos').create(recursive: true);

    final copiedFile = await File(sourcePhotoPath).copy(targetPath);
    final stat = await copiedFile.stat();
    final now = DateTime.now();

    // Capture the resolved nickname from inside the transaction.
    late final String resolvedNickname;

    await _db.transaction(() async {
      final count = await _db.select(_db.plants).get().then((l) => l.length);
      resolvedNickname = defaultNickname(species, count, nickname: nickname);

      await _db.into(_db.photos).insert(
        appDb.PhotosCompanion(
          id: Value(photoId),
          relativePath: Value(relativePath),
          mimeType: const Value('image/jpeg'),
          capturedAt: Value(now),
          // width/height: stored as 0 for MVP — proper image metadata
          // extraction is deferred to a follow-up ticket.
          width: const Value(0),
          height: const Value(0),
          byteSize: Value(stat.size),
        ),
      );

      await _db.into(_db.plants).insert(
        appDb.PlantsCompanion(
          id: Value(plantId),
          species: Value(species.trim()),
          nickname: Value(resolvedNickname),
          createdAt: Value(now),
          coverPhotoId: Value(photoId),
        ),
      );
    });

    return Plant(
      id: plantId,
      species: species.trim(),
      nickname: resolvedNickname,
      coverPhotoPath: PhotoPath(targetPath),
      createdAt: now,
    );
  }

  Plant _toPlant(appDb.Plant plantRow, appDb.Photo photoRow, String docsPath) =>
      Plant(
        id: plantRow.id,
        species: plantRow.species,
        nickname: plantRow.nickname,
        coverPhotoPath: PhotoPath('$docsPath/${photoRow.relativePath}'),
        createdAt: plantRow.createdAt,
        category: plantRow.category,
        position: plantRow.position,
        substrate: plantRow.substrate,
      );
}

import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

// ignore: unused_import — EventType and PlantCategory are used in app_database.g.dart (part file)
import '../../domain/events.dart';
// ignore: unused_import — PlantCategory is used in app_database.g.dart (part file)
import '../../domain/plants.dart';
import 'tables/event_photos_table.dart';
import 'tables/events_table.dart';
import 'tables/photos_table.dart';
import 'tables/plants_table.dart';

part 'app_database.g.dart';

/// Main Drift database.
///
/// Opened once at app startup and exposed through the widget tree as
/// `RepositoryProvider<AppDatabase>`.  The InMemoryPlantRepository remains
/// active in the UI until ticket #37 (repository seam) wires Drift to the
/// domain layer.
///
/// Inject [QueryExecutor] directly for tests:
/// ```dart
/// final db = AppDatabase(NativeDatabase.memory());
/// ```
@DriftDatabase(tables: [Plants, Photos, Events, EventPhotos])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (Migrator m) async {
      await m.createAll();
      // plants_created_at_idx requires DESC — @TableIndex doesn't support
      // column ordering, so we create this index explicitly.
      await customStatement(
        'CREATE INDEX IF NOT EXISTS plants_created_at_idx'
        ' ON plants (created_at DESC)',
      );
    },
    onUpgrade: (Migrator m, int from, int to) async {
      // Add future schema migrations here, guarded by version:
      // if (from < 2) await m.addColumn(plants, plants.someNewColumn);
    },
  );
}

/// Opens the SQLite database in the application documents directory.
/// File: `<applicationDocumentsDir>/zeimoto.sqlite`
QueryExecutor _openConnection() => driftDatabase(name: 'zeimoto');

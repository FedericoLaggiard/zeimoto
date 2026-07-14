import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import '../../domain/events.dart';
import 'tables/event_photos_table.dart';
import 'tables/events_table.dart';
import 'tables/photos_table.dart';
import 'tables/plants_table.dart';

part 'app_database.g.dart';

/// Main Drift database.
///
/// Opened once at app startup via [openAppDatabase] and exposed through the
/// widget tree as `RepositoryProvider<AppDatabase>`.  The InMemoryPlantRepository
/// remains active in the UI until ticket #37 (repository seam) wires Drift to
/// the domain layer.
@DriftDatabase(tables: [Plants, Photos, Events, EventPhotos])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (Migrator m) => m.createAll(),
  );
}

/// Opens the SQLite database in the application documents directory.
/// File: `<applicationDocumentsDir>/zeimoto.sqlite`
QueryExecutor _openConnection() => driftDatabase(name: 'zeimoto');

/// Factory used in [main] to obtain the database instance.
AppDatabase openAppDatabase() => AppDatabase();

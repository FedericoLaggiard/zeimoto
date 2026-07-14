import 'package:drift/drift.dart';

/// Unified photo catalogue — covers plant thumbnails and event photos.
///
/// Schema decided in ticket #33 (filesystem strategy) and #34 (plants schema).
/// Every photo is stored as `<id>.jpg` under the application documents directory.
class Photos extends Table {
  /// UUID v4; also used as the filename on disk (`<id>.jpg`).
  TextColumn get id => text()();

  /// Path relative to the application documents directory.
  /// Persisted explicitly so future path-convention changes don't break existing
  /// rows (deducible from id by convention, but not hard-coded).
  TextColumn get relativePath => text().unique()();

  TextColumn get mimeType => text()();
  DateTimeColumn get capturedAt => dateTime()();
  IntColumn get width => integer()();
  IntColumn get height => integer()();
  IntColumn get byteSize => integer()();

  @override
  Set<Column> get primaryKey => {id};
}

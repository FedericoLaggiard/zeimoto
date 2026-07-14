import 'package:drift/drift.dart';

import 'events_table.dart';
import 'photos_table.dart';

/// Join table between Events and Photos.
///
/// Schema decided in ticket #35.
///
/// Invariants:
/// - `UNIQUE (photo_id)` — a photo belongs to exactly one event (or one plant
///   cover, enforced by the UNIQUE on `plants.cover_photo_id`).
/// - `UNIQUE (event_id, sort_order)` — no two photos in the same event share
///   the same display position.
/// - "at least 1 photo per event" is NOT enforceable in DDL; the repository
///   enforces it transactionally (see ticket #37).
@TableIndex(
  name: 'event_photos_event_sort_unique',
  columns: {#eventId, #sortOrder},
  unique: true,
)
class EventPhotos extends Table {
  /// FK to Events.  ON DELETE CASCADE: deleting an event removes its join rows.
  TextColumn get eventId =>
      text().references(Events, #id, onDelete: KeyAction.cascade)();

  /// FK to Photos.  ON DELETE RESTRICT: cannot delete a photo still referenced
  /// by an event.  UNIQUE prevents re-use across events.
  TextColumn get photoId =>
      text().unique().references(Photos, #id, onDelete: KeyAction.restrict)();

  /// 0-based display order within the event.
  IntColumn get sortOrder => integer()();

  @override
  Set<Column> get primaryKey => {eventId, photoId};
}

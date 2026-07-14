import 'package:drift/drift.dart';

import '../../../domain/events.dart';
import 'plants_table.dart';

/// Bidirectional TypeConverter between the [EventType] enum and its TEXT
/// storage representation (the canonical English identifier).
class EventTypeConverter extends TypeConverter<EventType, String> {
  const EventTypeConverter();

  @override
  EventType fromSql(String fromDb) =>
      EventType.values.firstWhere((e) => e.name == fromDb);

  @override
  String toSql(EventType value) => value.name;
}

/// Events table.
///
/// Schema decided in ticket #35.
/// No indexes in MVP (10–50 plants × 20–100 events per plant; SQLite scans in
/// <1ms at this cardinality).  Candidate index for a future ticket:
/// `(plant_id, happened_at DESC)` once real-world profiling warrants it.
class Events extends Table {
  /// UUID v4 generated client-side.
  TextColumn get id => text()();

  /// FK to Plants.  ON DELETE RESTRICT: the repository must delete events
  /// before deleting the plant (hard-delete cascade orchestrated explicitly).
  TextColumn get plantId =>
      text().references(Plants, #id, onDelete: KeyAction.restrict)();

  /// Canonical event type stored as an English text identifier.
  /// TypeConverter bridges DB text ↔ [EventType] enum in Dart.
  TextColumn get type => text()
      .map(const EventTypeConverter())
      .customConstraint(
        "NOT NULL CHECK (type IN ('repotting','pruning','wiring','pinching',"
        "'defoliation','treatment','fertilizing','observation','styling'))",
      )();

  /// When the event happened according to the user (editable after creation).
  DateTimeColumn get happenedAt => dateTime()();

  /// When the record was created (immutable audit timestamp).
  DateTimeColumn get createdAt => dateTime()();

  /// Free-form notes.  In the MVP absorbs any data that may become structured
  /// metadata in a future iteration.
  TextColumn get notes => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

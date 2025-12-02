import 'package:hive/hive.dart';
import 'enums.dart';
import 'plant.dart';
import 'photo.dart';
import 'intervention.dart';

class WorkStageAdapter extends TypeAdapter<WorkStage> {
  @override
  final int typeId = 1;
  @override
  WorkStage read(BinaryReader reader) => WorkStage.values[reader.readInt()];
  @override
  void write(BinaryWriter writer, WorkStage obj) => writer.writeInt(obj.index);
}

class SeasonAdapter extends TypeAdapter<Season> {
  @override
  final int typeId = 2;
  @override
  Season read(BinaryReader reader) => Season.values[reader.readInt()];
  @override
  void write(BinaryWriter writer, Season obj) => writer.writeInt(obj.index);
}

class InterventionTypeAdapter extends TypeAdapter<InterventionType> {
  @override
  final int typeId = 3;
  @override
  InterventionType read(BinaryReader reader) => InterventionType.values[reader.readInt()];
  @override
  void write(BinaryWriter writer, InterventionType obj) => writer.writeInt(obj.index);
}

class PlantAdapter extends TypeAdapter<Plant> {
  @override
  final int typeId = 10;
  @override
  Plant read(BinaryReader reader) {
    return Plant(
      id: reader.readString(),
      name: reader.readString(),
      species: reader.readString(),
      stage: WorkStage.values[reader.readInt()],
      createdAt: DateTime.fromMillisecondsSinceEpoch(reader.readInt()),
    );
  }
  @override
  void write(BinaryWriter writer, Plant obj) {
    writer
      ..writeString(obj.id)
      ..writeString(obj.name)
      ..writeString(obj.species)
      ..writeInt(obj.stage.index)
      ..writeInt(obj.createdAt.millisecondsSinceEpoch);
  }
}

class PhotoEntryAdapter extends TypeAdapter<PhotoEntry> {
  @override
  final int typeId = 11;
  @override
  PhotoEntry read(BinaryReader reader) {
    return PhotoEntry(
      id: reader.readString(),
      plantId: reader.readString(),
      path: reader.readString(),
      dateTaken: DateTime.fromMillisecondsSinceEpoch(reader.readInt()),
      season: Season.values[reader.readInt()],
    );
  }
  @override
  void write(BinaryWriter writer, PhotoEntry obj) {
    writer
      ..writeString(obj.id)
      ..writeString(obj.plantId)
      ..writeString(obj.path)
      ..writeInt(obj.dateTaken.millisecondsSinceEpoch)
      ..writeInt(obj.season.index);
  }
}

class InterventionAdapter extends TypeAdapter<Intervention> {
  @override
  final int typeId = 12;
  @override
  Intervention read(BinaryReader reader) {
    return Intervention(
      id: reader.readString(),
      plantId: reader.readString(),
      type: InterventionType.values[reader.readInt()],
      description: reader.readString(),
      dateTime: DateTime.fromMillisecondsSinceEpoch(reader.readInt()),
      photoId: reader.readBool() ? reader.readString() : null,
    );
  }
  @override
  void write(BinaryWriter writer, Intervention obj) {
    writer
      ..writeString(obj.id)
      ..writeString(obj.plantId)
      ..writeInt(obj.type.index)
      ..writeString(obj.description)
      ..writeInt(obj.dateTime.millisecondsSinceEpoch)
      ..writeBool(obj.photoId != null);
    if (obj.photoId != null) writer.writeString(obj.photoId!);
  }
}

void registerHiveAdapters() {
  if (!Hive.isAdapterRegistered(1)) Hive.registerAdapter(WorkStageAdapter());
  if (!Hive.isAdapterRegistered(2)) Hive.registerAdapter(SeasonAdapter());
  if (!Hive.isAdapterRegistered(3)) Hive.registerAdapter(InterventionTypeAdapter());
  if (!Hive.isAdapterRegistered(10)) Hive.registerAdapter(PlantAdapter());
  if (!Hive.isAdapterRegistered(11)) Hive.registerAdapter(PhotoEntryAdapter());
  if (!Hive.isAdapterRegistered(12)) Hive.registerAdapter(InterventionAdapter());
}

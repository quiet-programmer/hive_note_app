// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cloud_note_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CloudNoteModelAdapter extends TypeAdapter<CloudNoteModel> {
  @override
  final int typeId = 1;

  @override
  CloudNoteModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CloudNoteModel(
      id: fields[0] as String?,
      uuid: fields[1] as String?,
      title: fields[2] as String?,
      notes: fields[3] as String?,
      dateTime: fields[4] as dynamic,
      isTrashed: fields[5] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, CloudNoteModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.uuid)
      ..writeByte(2)
      ..write(obj.title)
      ..writeByte(3)
      ..write(obj.notes)
      ..writeByte(4)
      ..write(obj.dateTime)
      ..writeByte(5)
      ..write(obj.isTrashed);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CloudNoteModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'goal_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GoalEntityAdapter extends TypeAdapter<GoalEntity> {
  @override
  final int typeId = 0;

  @override
  GoalEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GoalEntity(
      endTime: fields[0] as DateTime,
      description: fields[1] as String,
      updated: fields[2] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, GoalEntity obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.endTime)
      ..writeByte(1)
      ..write(obj.description)
      ..writeByte(2)
      ..write(obj.updated);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GoalEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

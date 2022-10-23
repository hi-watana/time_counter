// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'goal_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GoalAdapter extends TypeAdapter<GoalEntity> {
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
    );
  }

  @override
  void write(BinaryWriter writer, GoalEntity obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.endTime)
      ..writeByte(1)
      ..write(obj.description);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GoalAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

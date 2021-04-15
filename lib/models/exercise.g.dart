// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exercise.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ExerciseAdapter extends TypeAdapter<ExerciseModel> {
  @override
  final int typeId = 1;

  @override
  ExerciseModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ExerciseModel(
      exerciseName: fields[1] as String,
      count: fields[2] as int,
      intervalCount: fields[3] as double,
      breakDuration: fields[4] as double,
      series: fields[5] as int,
      addedWeight: fields[6] as double?,
      createdAt: fields[7] as DateTime?,
    ).._id = fields[0] as String;
  }

  @override
  void write(BinaryWriter writer, ExerciseModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj._id)
      ..writeByte(1)
      ..write(obj.exerciseName)
      ..writeByte(2)
      ..write(obj.count)
      ..writeByte(3)
      ..write(obj.intervalCount)
      ..writeByte(4)
      ..write(obj.breakDuration)
      ..writeByte(5)
      ..write(obj.series)
      ..writeByte(6)
      ..write(obj.addedWeight)
      ..writeByte(7)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExerciseAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

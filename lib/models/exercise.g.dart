// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exercise.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ExerciseAdapter extends TypeAdapter<Exercise> {
  @override
  final int typeId = 1;

  @override
  Exercise read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Exercise(
      exerciseName: fields[1] as String,
      count: fields[2] as int,
      intervalCount: fields[3] as double,
      breakDuration: fields[4] as double,
      series: fields[5] as int,
      addedWeight: fields[6] as double,
    )
      .._id = fields[0] as String
      ..createdAt = fields[7] as DateTime
      ..modifiedAt = fields[8] as DateTime;
  }

  @override
  void write(BinaryWriter writer, Exercise obj) {
    writer
      ..writeByte(9)
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
      ..write(obj.createdAt)
      ..writeByte(8)
      ..write(obj.modifiedAt);
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

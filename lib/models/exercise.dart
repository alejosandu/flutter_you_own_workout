import 'package:uuid/uuid.dart';
import 'package:hive/hive.dart';
import 'package:yourownworkout/models/models.dart';

part 'exercise.g.dart';

/// Model for exercise, each exercise make part of a full workout
@HiveType(typeId: 1, adapterName: "ExerciseAdapter")
class ExerciseModel implements BoxModel {
  static String get boxName => 'exercises';

  /// id for the exercise, should be the DB id
  @HiveField(0)
  late String _id;
  String get id => _id;

  /// Exercise name to group all the information
  @HiveField(1)
  String exerciseName;

  /// Description for the exercise
  @HiveField(2)
  String? description;

  /// Amount of repetitions to do for this exercise
  @HiveField(3)
  int count;

  /// The time to wait to add 1 to the `count` in seconds
  @HiveField(4)
  double intervalCount;

  /// time to  wait until the next `serie` in seconds
  @HiveField(5)
  double breakDuration;

  /// the amount of series to repeat
  @HiveField(6)
  int series;

  /// (optional) weight added to this exercise
  @HiveField(7)
  double? addedWeight;

  /// date when the object was created
  @HiveField(8)
  late DateTime _createdAt;
  DateTime get createdAt => _createdAt;

  /// method used to play the exercise
  @HiveField(9)
  ExerciseMethod exerciseMethod;

  /// duration calculation on milliseconds
  Duration get duration {
    return exerciseDuration + breakTimeDuration;
  }

  /// duration calculation on milliseconds
  Duration get exerciseDuration {
    // add 1 to the count to include the last repetition and count it
    final duration = (((count + 1) * intervalCount) * series) * 1000;
    return Duration(milliseconds: duration.toInt());
  }

  /// duration calculation on milliseconds
  Duration get breakTimeDuration {
    // add 1 to the count to include the last repetition and count it
    final duration = ((breakDuration + 1) * series) * 1000;
    return Duration(milliseconds: duration.toInt());
  }

  @override
  String toString() => "$_id: $exerciseName";

  ExerciseModel({
    String? id,
    this.exerciseName = '',
    this.description,
    this.count = 0,
    this.intervalCount = 1,
    this.breakDuration = 0,
    this.series = 0,
    this.addedWeight = 0,
    DateTime? createdAt,
    this.exerciseMethod = ExerciseMethod.increaseByTime,
  }) {
    final uuid = Uuid();
    _id = id ?? uuid.v4();
    this._createdAt = createdAt ?? DateTime.now();
  }
}

import 'package:uuid/uuid.dart';
import 'package:hive/hive.dart';
import 'package:yourownworkout/models/models.dart';

part 'exercise.g.dart';

/// Model for exercise, each exercise make part of a full workout
@HiveType(typeId: 1)
class Exercise implements BoxModel {
  static String get box => 'exercises';

  /// id for the exercise, should be the DB id
  @HiveField(0)
  late String _id;
  String get id => _id;

  /// Exercise name to group all the information
  @HiveField(1)
  String? exerciseName;

  /// Amount of repetitions to do for this exercise
  @HiveField(2)
  int? count;

  /// The time to wait to add 1 to the `count`
  @HiveField(3)
  double? intervalCount;

  /// time to  wait until the next `serie`
  @HiveField(4)
  double? breakDuration;

  /// the amount of series to repeat
  @HiveField(5)
  int? series;

  /// (optional) weight added to this exercise
  @HiveField(6)
  double? addedWeight;

  // date when the object was created
  @HiveField(7)
  late DateTime createdAt;

  @override
  String toString() => "$_id: $exerciseName";

  Exercise({
    String? id,
    required this.exerciseName,
    required this.count,
    required this.intervalCount,
    required this.breakDuration,
    required this.series,
    this.addedWeight,
  }) {
    final uuid = Uuid();
    _id = id ?? uuid.v4();
    if (id == null) createdAt = DateTime.now();
  }
}

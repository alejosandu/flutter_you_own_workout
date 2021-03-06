import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import 'models.dart';

part 'workout.g.dart';

@HiveType(typeId: 2, adapterName: "WorkoutAdapter")
class WorkoutModel implements BoxModel {
  static String get boxName => "workouts";

  /// id for workout
  @HiveField(0)
  late String _id;
  String get id => _id;

  /// name for the workout
  @HiveField(1)
  String workoutName;

  /// description of the overall wokrout
  @HiveField(2)
  String? description;

  /// list of all the exercises that make part of the entire workout
  @HiveField(3)
  List<ExerciseModel> exercises = [];

  /// date when the object was created
  @HiveField(4)
  late DateTime _createdAt;
  DateTime get createdAt => _createdAt;

  /// get the total duration within all exercises and break times on milliseconds
  Duration get duration {
    return exercisesDuration + breakTimeDuration;
  }

  /// get the duration of the exercises excluding breaks on milliseconds
  Duration get exercisesDuration {
    final duration = exercises.fold<Duration>(
      Duration(),
      (previousValue, element) => previousValue + element.exerciseDuration,
    );
    return duration;
  }

  /// get the duration of the break time only on milliseconds
  Duration get breakTimeDuration {
    final duration = exercises.fold<Duration>(
      Duration(),
      (previousValue, element) => previousValue + element.breakTimeDuration,
    );
    return duration;
  }

  /// create a full copy of the current object, this is intended to remove a reference to the object in memory
  WorkoutModel copy() {
    return WorkoutModel(
      id: id,
      workoutName: workoutName,
      description: description,
      exercises: List.from(exercises),
      createdAt: createdAt,
    );
  }

  WorkoutModel({
    String? id,
    this.workoutName = '',
    this.description,
    List<ExerciseModel>? exercises,
    DateTime? createdAt,
  }) {
    final uuid = Uuid();
    _id = id ?? uuid.v4();
    this.exercises = exercises ?? [];
    this._createdAt = createdAt ?? DateTime.now();
  }
}

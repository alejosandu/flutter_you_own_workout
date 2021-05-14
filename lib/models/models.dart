export 'exercise.dart';
export 'workout.dart';

abstract class BoxModel {
  String get id;
  DateTime get createdAt;
}

enum ExerciseMethod { repetitionsAtEnd, increaseByTime }

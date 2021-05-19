export 'exercise.dart';
export 'workout.dart';

abstract class BoxModel {
  String get id;
  DateTime get createdAt;
}

enum ExerciseMethod {
  /// this method is intended to work with a defined time by the user
  /// at the end of the exercise the user must put the value of the amount of repetitions made during the elapsed time
  repetitionsAtEnd,

  /// apart from the `repetitionsAtEnd` method, this is configured to increase the value by time
  /// the duration of exercise is calculated by taking the increment in time and count still the configured value
  increaseByTime,
}

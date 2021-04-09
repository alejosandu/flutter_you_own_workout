import 'package:uuid/uuid.dart';

/// Model for exercise
class Exercise {
  String _id;
  String exerciseName;
  int count;
  double intervalCount;
  double breakDuration;
  int series;
  double addedWeight;

  Exercise({
    this.exerciseName,
    this.count,
    this.intervalCount,
    this.breakDuration,
    this.series,
  })  : assert(exerciseName != null),
        assert(count != null),
        assert(intervalCount != null),
        assert(breakDuration != null),
        assert(series != null) {
    final uuid = Uuid();
    _id = uuid.v4();
  }

  String get id => _id;
}

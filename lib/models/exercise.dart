import 'package:uuid/uuid.dart';
import 'package:meta/meta.dart';

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
    String id,
    @required this.exerciseName,
    @required this.count,
    @required this.intervalCount,
    @required this.breakDuration,
    @required this.series,
    this.addedWeight,
  })  : assert(exerciseName != null),
        assert(count != null),
        assert(intervalCount != null),
        assert(breakDuration != null),
        assert(series != null) {
    final uuid = Uuid();
    _id = id ?? uuid.v4();
  }

  String get id => _id;
}

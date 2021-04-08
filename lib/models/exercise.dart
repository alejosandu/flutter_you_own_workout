/// Model for exercise
class Exercise {
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
        assert(series != null);
}

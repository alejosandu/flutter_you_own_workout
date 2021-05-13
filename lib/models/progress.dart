import 'package:yourownworkout/models/models.dart';

class WorkoutProgress {
  late WorkoutModel _workout;

  List<ExerciseProgress> exercisesProgress = [];

  WorkoutProgress(this._workout) {
    final Iterable<ExerciseProgress> newExercisesProgress =
        _workout.exercises.map((exercise) => ExerciseProgress(exercise));
    exercisesProgress.addAll(newExercisesProgress);
  }

  Duration get elapsedTotal {
    return exercisesProgress.fold(
      Duration(),
      (prev, current) => prev + current.elapsed,
    );
  }
}

class ExerciseProgress {
  double counter = 0;

  Stopwatch _stopwatch = Stopwatch();

  ExerciseModel _exercise;

  ExerciseProgress(this._exercise);

  start() => _stopwatch.start();
  stop() => _stopwatch.stop();

  Duration get elapsed => _stopwatch.elapsed;
}

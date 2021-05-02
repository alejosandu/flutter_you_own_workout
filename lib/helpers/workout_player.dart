import 'dart:async';

import '../models/models.dart';

class WorkoutPlayer {
  late WorkoutModel _workoutSource;
  late WorkoutModel _workout;
  late Function _update;

  late ExerciseModel _currentExercise = ExerciseModel();
  ExerciseModel get currentExercise => _currentExercise;

  double _counter = 0;
  double get counter => _counter;
  late Timer _timer;

  Stopwatch _stopwatch = Stopwatch();
  Duration get elapsed => _stopwatch.elapsed;

  bool _isStarted = false;

  WorkoutPlayer(this._workoutSource);

  addUpdater(Function updater) => _update = updater;

  play() {
    try {
      if (_isStarted) return;
      _workout = _workoutSource.copy();
      _stopwatch.start();
      _doWorkout();
      _update();
    } catch (e) {
      rethrow;
    }
  }

  pause() {
    try {
      _stopwatch.stop();
      _timer.cancel();
      _update();
    } catch (e) {
      rethrow;
    }
  }

  /// `stop` and `reset` are pretty much the same, the only difference is that reset clear the timer;
  stop() {
    try {
      _isStarted = false;
      _counter = 0;
      _timer.cancel();
      _stopwatch.stop();
      _update();
    } catch (e) {
      rethrow;
    }
  }

  reset() {
    try {
      _isStarted = false;
      _counter = 0;
      _timer.cancel();
      _stopwatch.reset();
      _update();
    } catch (e) {
      rethrow;
    }
  }

  _doWorkout() async {
    try {
      for (int i = 0; i < _workout.exercises.length; i++) {
        _currentExercise = _workout.exercises.first;
        _update();
        await _doExercise(_currentExercise);
        _workout.exercises.remove(_currentExercise);
        if (_workout.exercises.length > 0) i--;
      }
    } catch (e) {
      rethrow;
    }
  }

  _doExercise(ExerciseModel exercise) async {
    try {
      for (var i = 0; i < exercise.series; i++) {
        await _doCount(exercise);
        // await _doBreak(exercise);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future _doCount(ExerciseModel exercise) {
    final completer = Completer();

    final int aumenta = 100;
    final double calc = double.parse(
        (aumenta / (exercise.intervalCount * 1000)).toStringAsFixed(2));
    // _stopwatch.start();
    _timer = Timer.periodic(Duration(milliseconds: aumenta), (_) {
      final double previousValue = _counter;
      _counter = double.parse((_counter + calc).toStringAsFixed(2));
      // only apply update when the value of _counter really changed
      if (previousValue.truncate() + 1 == _counter.truncate()) _update();
      // add 1 second to include the last repetition/count to the exercise
      if (_counter >= exercise.count + 1) {
        _timer.cancel();
        // _stopwatch.stop();
        _counter = 0;
        completer.complete();
      }
    });
    return completer.future;
  }

  Future _doCount2(ExerciseModel exercise) {
    final completer = Completer();
    final time = exercise.intervalCount * 1000;
    final durationIntervalCount = Duration(milliseconds: time.toInt());
    _stopwatch.start();
    _timer = Timer.periodic(durationIntervalCount, (_) {
      _counter++;
      if (_counter > exercise.count) {
        _timer.cancel();
        _stopwatch.stop();
        _counter = 0;
        completer.complete();
      }
      _update();
    });
    return completer.future;
  }

  Future _doBreak(ExerciseModel exercise) {
    final completer = Completer();
    final time = 1000;
    final duration = Duration(milliseconds: time);
    _counter = exercise.breakDuration;
    _timer = Timer.periodic(duration, (_) {
      _counter--;
      if (0 > _counter) {
        _timer.cancel();
        _counter = 0;
        completer.complete();
      }
      _update();
    });
    return completer.future;
  }
}

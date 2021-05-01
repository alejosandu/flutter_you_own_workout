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
  late Timer timer;

  bool isStarted = false;

  WorkoutPlayer(this._workoutSource);

  addUpdater(Function updater) => _update = updater;

  play() {
    try {
      if (isStarted) return;
      _workout = _workoutSource.copy();
      _doWorkout();
      _update();
    } catch (e) {
      rethrow;
    }
  }

  pause() {
    try {
      timer.cancel();
      _update();
    } catch (e) {
      rethrow;
    }
  }

  stop() {
    try {
      _update();
    } catch (e) {
      rethrow;
    }
  }

  _doWorkout() async {
    for (int i = 0; i < _workout.exercises.length; i++) {
      _currentExercise = _workout.exercises.first;
      _update();
      await _doExercise(_currentExercise);
      _workout.exercises.remove(_currentExercise);
      if (_workout.exercises.length > 0) i--;
    }
  }

  _doExercise(ExerciseModel exercise) async {
    for (var i = 0; i < exercise.series; i++) {
      await _doCount(exercise);
      await _doBreak(exercise);
    }
  }

  Future _doCount(ExerciseModel exercise) {
    final completer = Completer();
    final time = exercise.intervalCount * 1000;
    final durationIntervalCount = Duration(milliseconds: time.toInt());
    timer = Timer.periodic(durationIntervalCount, (_) {
      _counter++;
      if (_counter > exercise.count) {
        timer.cancel();
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
    timer = Timer.periodic(duration, (_) {
      _counter--;
      if (0 > _counter) {
        timer.cancel();
        _counter = 0;
        completer.complete();
      }
      _update();
    });
    return completer.future;
  }
}

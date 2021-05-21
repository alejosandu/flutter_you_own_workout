import 'dart:async';
import 'package:wakelock/wakelock.dart';

import '../models/models.dart';

import 'vibrator.dart';

enum Stage { stopped, next, workout, breakTime }

class WorkoutPlayer {
  late WorkoutModel _workoutSource;
  late WorkoutModel _workout;
  late Function _update;

  ExerciseModel _currentExercise = ExerciseModel();
  ExerciseModel get currentExercise => _currentExercise;

  double _counter = 0;
  int _seriesProgress = 0;
  double get counter => _counter;
  Timer _timer = Timer(Duration.zero, () {});

  Stopwatch _stopwatch = Stopwatch();
  Duration get elapsed => _stopwatch.elapsed;

  bool _isStarted = false;
  Stage _stage = Stage.stopped;

  Vibrator _vibrator = Vibrator();

  WorkoutPlayer(this._workoutSource);

  addUpdater(Function updater) => _update = updater;

  resetState() {
    _stage = Stage.stopped;
    _isStarted = false;
    _counter = 0;
    _timer.cancel();
    _stopwatch.stop();
  }

  play() {
    try {
      if (!_isStarted) {
        resetState();
        _stopwatch.reset();
        _isStarted = true;
        _workout = _workoutSource.copy();
      }
      Wakelock.enable();
      _vibrator.vibrationPLay();
      _doWorkout();
      _stopwatch.start();
      _update();
    } catch (e) {
      rethrow;
    }
  }

  pause() {
    try {
      _vibrator.vibrationPause();
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
      Wakelock.disable();
      resetState();
      _vibrator.vibrationStop();
      _update();
    } catch (e) {
      rethrow;
    }
  }

  reset() {
    try {
      stop();
      _workout = _workoutSource.copy();
      _stopwatch.reset();
    } catch (e) {
      rethrow;
    }
  }

  _doWorkout() async {
    try {
      for (int i = 0; i < _workout.exercises.length; i++) {
        _currentExercise = _workout.exercises.first;
        await _doExercise(_currentExercise);
        _workout.exercises.remove(_currentExercise);
        if (_workout.exercises.length > 0) i--;
      }
      print('finish');
      stop();
    } catch (e) {
      rethrow;
    }
  }

  _doExercise(ExerciseModel exercise) async {
    try {
      for (var i = _seriesProgress; i < exercise.series; i++) {
        _seriesProgress = i;
        if (_stage != Stage.breakTime) await _doCount(exercise);
        await _doBreak(exercise);
        _stage = Stage.next;
      }
      // reset series progress
      _seriesProgress = 0;
    } catch (e) {
      rethrow;
    }
  }

  Future _startIncreaseByTime(
    num limit,
    num intervalTimeToCount,
    num incrementTime,
  ) {
    // calculate the fraction of value to add on each time the Timer.periodic runs
    final double addedFractionPerIncrementTime = double.parse(
      (incrementTime / (intervalTimeToCount * 1000)).toStringAsFixed(2),
    );

    _stopwatch.start();
    final completer = Completer();

    _timer = Timer.periodic(Duration(milliseconds: incrementTime.toInt()), (_) {
      final double previousValue = _counter;
      _counter = double.parse(
        (_counter + addedFractionPerIncrementTime).toStringAsFixed(2),
      );
      // only apply update when the value of _counter really changed
      if (previousValue.truncate() + 1 == _counter.truncate()) _update();
      // add 1 second to include the last repetition/count to the exercise
      if (_counter >= limit + 1) {
        _timer.cancel();
        _stopwatch.stop();
        _counter = 0;
        completer.complete();
      }
    });

    return completer.future;
  }

  Future _startCount(
    num limit,
    num intervalTimeToCount,
    num incrementTime,
  ) {
    return _startIncreaseByTime(limit, intervalTimeToCount, incrementTime);
  }

  Future? _doCount(ExerciseModel exercise) {
    print('start exercise $exercise');
    _stage = Stage.workout;
    return _startCount(exercise.count, exercise.intervalCount, 100);
  }

  Future? _doBreak(ExerciseModel exercise) {
    print('start break');
    _stage = Stage.breakTime;
    return _startCount(exercise.breakDuration, 1, 100);
  }
}

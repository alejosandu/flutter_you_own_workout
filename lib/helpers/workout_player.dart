import 'dart:async';

import '../models/workout.dart';

class WorkoutPlayer {
  late WorkoutModel _workout;
  late Function _update;

  WorkoutPlayer(this._workout);

  addUpdater(Function updater) {
    _update = updater;
  }

  play() {
    try {
      _update();
    } catch (e) {
      rethrow;
    }
  }

  pause() {
    try {
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
}

class WorkoutPlayerOld {
  int counter = 0;
  late Timer timer;

  int count;
  double intervalCount;
  int breakDuration;
  int series;

  WorkoutPlayerOld({
    required this.count,
    required this.intervalCount,
    required this.breakDuration,
    required this.series,
  });

  void startCycling() async {
    for (var i = 0; i < series; i++) {
      await startCounter();
      await doBreakTime();
    }
  }

  Future startCounter() {
    final completer = Completer();
    final time = intervalCount * 1000;
    final durationIntervalCount = Duration(milliseconds: time.toInt());
    timer = Timer.periodic(durationIntervalCount, (_) {
      counter++;
      if (counter > count) {
        timer.cancel();
        counter = 0;
        completer.complete();
      }
    });
    return completer.future;
  }

  Future doBreakTime() {
    final completer = Completer();
    final time = 1000;
    final duration = Duration(milliseconds: time);
    counter = breakDuration;
    timer = Timer.periodic(duration, (_) {
      counter--;
      if (0 > counter) {
        timer.cancel();
        counter = 0;
        completer.complete();
      }
    });
    return completer.future;
  }
}

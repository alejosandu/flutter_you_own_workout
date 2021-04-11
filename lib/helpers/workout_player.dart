import 'dart:async';

class WorkoutPlayer {
  int counter = 0;
  Timer timer;

  int count;
  double intervalCount;
  int breakTime;
  int series;

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
    counter = breakTime;
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

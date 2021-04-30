import 'package:flutter/material.dart';

import '../helpers/logger.dart';
import '../models/models.dart';
import '../widgets/widgets.dart';
import '../helpers/workout_player.dart';

// page to play all exercises together as a full workout

class PlayWorkoutView extends StatefulWidget {
  static String get routeName => 'playWorkout';

  @override
  _PlayWorkoutViewState createState() => _PlayWorkoutViewState();
}

class _PlayWorkoutViewState extends State<PlayWorkoutView> {
  late WorkoutModel workout;
  late WorkoutPlayer player;
  bool isPlaying = false;
  bool isStopped = false;
  String state = 'stopped';

  play() async {
    try {
      state = 'playing';
      isPlaying = true;
      isStopped = false;
      player.play();
    } catch (e) {
      CustomSnackBar(context, text: "Ocurrió un error al reproducir");
      Logger.logError(e);
      debugPrint(e.toString());
    }
  }

  pause() async {
    try {
      state = 'paused';
      isPlaying = false;
      isStopped = false;
      player.pause();
    } catch (e) {
      CustomSnackBar(context, text: "Ocurrió un error al detener");
      Logger.logError(e);
      debugPrint(e.toString());
    }
  }

  stop() async {
    try {
      if (isPlaying) return;
      state = 'stopped';
      isStopped = true;
      player.stop();
    } catch (e) {
      CustomSnackBar(context, text: "Ocurrió un error al detener");
      Logger.logError(e);
      debugPrint(e.toString());
    }
  }

  init() async {
    try {
      workout = ModalRoute.of(context)?.settings.arguments as WorkoutModel;
      player = WorkoutPlayer(workout)..addUpdater(() => setState(() {}));
    } catch (e) {
      CustomSnackBar(context,
          text: "Ocurrió un error cargando el entrenamiento");
      Logger.logError(e);
      debugPrint(e.toString());
    }
  }

  @override
  void didChangeDependencies() {
    init();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final String title = workout.workoutName;

    IconData fabIcon = Icons.play_arrow_rounded;
    if (isPlaying) fabIcon = Icons.pause_rounded;
    if (isStopped) fabIcon = Icons.stop_rounded;

    return Scaffold(
      appBar: CustomAppBar(title: title),
      body: Container(
        child: Column(
          children: [
            Text(state),
          ],
        ),
      ),
      floatingActionButton: GestureDetector(
        onTap: isPlaying ? pause : play,
        onLongPress: stop,
        child: FloatingActionButton(
          child: Icon(fabIcon),
          onPressed: null,
        ),
      ),
    );
  }
}

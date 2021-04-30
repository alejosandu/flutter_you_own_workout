import 'package:flutter/material.dart';
import 'package:yourownworkout/helpers/logger.dart';
import '../widgets/widgets.dart';
import '../database/repository.dart';
import '../models/models.dart';
import '../extensions/duration_extensions.dart';
import 'views.dart';

class PrincipalPage extends StatefulWidget {
  static String get routeName => '/';

  @override
  _PrincipalPageState createState() => _PrincipalPageState();
}

class _PrincipalPageState extends State<PrincipalPage> {
  final workoutRepository = Repository<WorkoutModel>(WorkoutModel.boxName);
  List<WorkoutModel> workouts = [];

  getAllWorkouts() {
    setState(() {
      workouts = [];
      workouts.addAll(
        workoutRepository.values.toList()
          ..sort((a, b) => a.createdAt.compareTo(b.createdAt)),
      );
    });
  }

  init() async {
    try {
      await workoutRepository.isReady;
      getAllWorkouts();
    } catch (e) {
      CustomSnackBar(context,
          text: "Ocurrió un error cargando los entrenamientos");
      Logger.logError(e);
      debugPrint(e.toString());
    }
  }

  @override
  void initState() {
    init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Principal"),
      body: ListView.builder(
        itemCount: workouts.length,
        itemBuilder: (context, index) {
          return _WorkoutCard(
            workouts[index],
            update: getAllWorkouts,
          );
        },
      ),
      floatingActionButton: CustomFab(
        icon: AnimatedIcons.menu_close,
        children: [
          FabAction(
            child: Icon(Icons.fitness_center),
            label: 'Configurar ejercicios',
            onTap: () async {
              await Navigator.of(context).pushNamed(ExerciseView.routeName);
            },
          ),
          FabAction(
            child: Icon(Icons.sports),
            label: 'Configurar entrenamiento',
            onTap: () async {
              await Navigator.of(context).pushNamed(WorkoutView.routeName);
              getAllWorkouts();
            },
          ),
        ],
      ),
    );
  }
}

class _WorkoutCard extends StatelessWidget {
  final WorkoutModel workout;
  final Function() update;

  _WorkoutCard(this.workout, {required this.update});

  doEdit(BuildContext context) async {
    await Navigator.pushNamed(
      context,
      WorkoutView.routeName,
      arguments: workout,
    );
    update();
  }

  doWorkout(BuildContext context) {
    Navigator.pushNamed(
      context,
      PlayWorkoutView.routeName,
      arguments: workout,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              doWorkout(context);
            },
            child: Column(
              children: [
                Text(workout.workoutName),
                // Text(workout.description ?? ''),
                Text(workout.exercises.length.toString()),
                Text(workout.exercisesDuration.formatedDuration),
                Text(workout.breakTimeDuration.formatedDuration),
                Text(workout.duration.formatedDuration),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              doEdit(context);
            },
          ),
        ],
      ),
    );
  }
}

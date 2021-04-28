import 'package:flutter/material.dart';
import 'package:yourownworkout/helpers/logger.dart';
import '../widgets/widgets.dart';
import '../database/repository.dart';
import '../models/models.dart';
import 'views.dart';

class PrincipalPage extends StatefulWidget {
  static String get routeName => '/';

  @override
  _PrincipalPageState createState() => _PrincipalPageState();
}

class _PrincipalPageState extends State<PrincipalPage> {
  final workoutRepository = Repository<WorkoutModel>(WorkoutModel.boxName);
  List<WorkoutModel> workouts = [];

  init() async {
    try {
      await workoutRepository.isReady;
      setState(() {
        workouts.addAll(workoutRepository.values);
      });
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
          return Text(workouts[index].workoutName);
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
              setState(() {
                workouts = [];
                workouts.addAll(
                  workoutRepository.values.toList()
                    ..sort((a, b) => a.createdAt.compareTo(b.createdAt)),
                );
              });
            },
          ),
        ],
      ),
    );
  }
}

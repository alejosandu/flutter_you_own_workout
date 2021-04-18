import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:yourownworkout/models/workout.dart';
import '../../database/repository.dart';

import '../../widgets/appbar.dart';
import '../../widgets/name_textfield.dart';
import '../../widgets/custom_snackbar.dart';

import 'widgets/workout_form_data.dart';

class WorkoutView extends StatefulWidget {
  static String get routeName => "/createWorkout";

  @override
  _WorkoutViewState createState() => _WorkoutViewState();
}

class _WorkoutViewState extends State<WorkoutView> {
  final workoutRepository = Repository<WorkoutModel>(WorkoutModel.boxName);
  WorkoutFormData formData = WorkoutFormData();

  init() async {
    try {
      await workoutRepository.isReady;
      final workout =
          ModalRoute.of(context)?.settings.arguments as WorkoutModel?;
      if (workout != null) {
        formData = WorkoutFormData.fromWorkoutModel(workout);
      }
    } catch (e) {
      CustomSnackBar(context, text: "Ocurrió un error al cargar los datos");
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
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: CustomAppBar(title: "Entrenamiento"),
      body: Container(
        child: Column(
          children: [
            NameTextField(
              label: "test",
              onChanged: (_) {},
            ),
          ],
        ),
      ),
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        backgroundColor: theme.accentColor,
        foregroundColor: theme.buttonColor,
        children: [],
      ),
    );
  }
}

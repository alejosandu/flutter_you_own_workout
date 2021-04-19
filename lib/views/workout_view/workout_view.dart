import 'package:flutter/material.dart';
import '../../helpers/logger.dart';
import '../../errors/app_error.dart';
import '../../models/workout.dart';
import '../../models/exercise.dart';
import '../../database/repository.dart';
import '../../extensions/duration_extensions.dart';
import '../../extensions/num_extensions.dart';

import '../../widgets/widgets.dart';

import 'widgets/workout_form_data.dart';

class WorkoutView extends StatefulWidget {
  static String get routeName => "/createWorkout";

  @override
  _WorkoutViewState createState() => _WorkoutViewState();
}

class _WorkoutViewState extends State<WorkoutView> {
  final workoutRepository = Repository<WorkoutModel>(WorkoutModel.boxName);
  WorkoutFormData workout = WorkoutFormData();

  addExercise() async {
    final exercises = await Navigator.push<List<ExerciseModel>>(
      context,
      MaterialPageRoute(
        builder: (_) => _ExerciseSelector(),
      ),
    );
    if (exercises != null) {
      setState(() {
        workout.exercises.addAll(exercises);
      });
    }
  }

  validateAll() {
    if (workout.validateFields) {
      throw AppError(message: "Algunos campos tienen errores");
    }
  }

  save() {
    try {
      validateAll();
    } on AppError catch (e) {
      CustomSnackBar(context, text: e.message);
    } catch (e) {
      CustomSnackBar(context, text: "Ocurrió un error al guardar");
      Logger.logError(e);
      debugPrint(e.toString());
    }
  }

  init() async {
    try {
      await workoutRepository.isReady;
      final workoutData =
          ModalRoute.of(context)?.settings.arguments as WorkoutModel?;
      if (workoutData != null) {
        workout = WorkoutFormData.fromWorkoutModel(workoutData);
      }
    } catch (e) {
      CustomSnackBar(context, text: "Ocurrió un error al cargar los datos");
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
      appBar: CustomAppBar(title: "Entrenamiento"),
      body: Container(
        child: Column(
          children: [
            NameTextField(
              label: "Nombre del entrenamiento",
              onChanged: workout.setWorkoutName,
              defaultValue: workout.workoutName,
              isValid: workout.workoutNameIsValid,
            ),
            Container(
              child: Column(
                children: [
                  Text(workout.exercisesDuration.formatedDuration),
                  Text(workout.breakTimeDuration.formatedDuration),
                  Text(workout.duration.formatedDuration),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: CustomFab(
        icon: AnimatedIcons.menu_close,
        children: [
          FabAction(
            child: Icon(Icons.save),
            label: "Guardar entrenamiento",
            onTap: save,
          ),
          FabAction(
            child: Icon(Icons.add),
            label: "Agregar un ejercicio",
            onTap: addExercise,
          ),
        ],
      ),
    );
  }
}

class _ExerciseSelector extends StatefulWidget {
  @override
  __ExerciseSelectorState createState() => __ExerciseSelectorState();
}

class __ExerciseSelectorState extends State<_ExerciseSelector> {
  final exercisesRepository = Repository<ExerciseModel>(ExerciseModel.boxName);
  List<ExerciseModel> exercises = [];
  List<ExerciseModel> selectedExercises = [];

  sendBack() {
    Navigator.pop(context, selectedExercises);
  }

  init() async {
    try {
      await exercisesRepository.isReady;
      // TODO: aplicar filtros de busqueda
      exercises = exercisesRepository.values.toList();

      setState(() {});
    } catch (e) {
      CustomSnackBar(context, text: "Ocurrió un error listando los ejercicios");
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
      appBar: CustomAppBar(title: "Seleccione ejercicios"),
      body: ListView.builder(
        itemCount: exercises.length,
        itemBuilder: (_, index) {
          return CheckboxListTile(
            title: Text(exercises[index].exerciseName),
            subtitle: _Card(exercises[index]),
            value: true,
            onChanged: (value) {},
            controlAffinity: ListTileControlAffinity.leading,
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.playlist_add),
        onPressed: sendBack,
      ),
    );
  }
}

class _Card extends StatelessWidget {
  final ExerciseModel exercise;

  _Card(this.exercise);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      child: GridView.count(
        crossAxisCount: 2,
        childAspectRatio: 18 / 2,
        physics: ScrollPhysics(),
        children: [
          _Details(
            label: " repeticiones",
            value: exercise.count.toString(),
          ),
          _Details(
            label: "s para cada aumento",
            value: exercise.intervalCount.toString(),
          ),
          _Details(
            label: " de reposo/serie",
            value: exercise.breakDuration.toDuration.formatedDurationShort,
          ),
          _Details(
            label: " series",
            value: exercise.series.toString(),
          ),
          _Details(
            label: " de ejercicio",
            value: exercise.exerciseDuration.formatedDurationShort,
          ),
          _Details(
            label: " de reposo",
            value: exercise.breakTimeDuration.formatedDurationShort,
          ),
          _Details(
            label: " en total",
            value: exercise.duration.formatedDurationShort,
          ),
        ],
      ),
    );
  }
}

class _Details extends StatelessWidget {
  final String label;
  final String value;

  _Details({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(this.value),
        Text(this.label),
      ],
    );
  }
}

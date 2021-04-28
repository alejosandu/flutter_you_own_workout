import 'package:flutter/material.dart';
import '../../helpers/logger.dart';
import '../../errors/app_error.dart';
import '../../models/models.dart';
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
      exercises.forEach((a) {
        if (!workout.exercises.any((b) => b == a)) workout.exercises.add(a);
      });

      setState(() {});
    }
  }

  removeExercise(dynamic object) {
    setState(() {
      workout.exercises.remove(object);
    });
  }

  validateAll() {
    if (workout.validateFields) {
      setState(() {});
      throw AppError(message: "Algunos campos tienen errores");
    }
  }

  save() async {
    try {
      validateAll();
      workoutRepository.put(workout);
      Navigator.pop(context);
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
      body: Column(
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
          _ExercisesList(
            exercises: workout.exercises,
            remove: removeExercise,
          ),
        ],
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

class _ExercisesList extends StatelessWidget {
  final List<ExerciseModel> exercises;
  final Function(dynamic) remove;

  _ExercisesList({
    required this.exercises,
    required this.remove,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Flexible(
      child: ListView.builder(
        itemCount: exercises.length,
        itemBuilder: (context, index) {
          return DismissibleContainer(
            child: _Card(
              exercise: exercises[index],
              theme: theme,
            ),
            onDismissed: remove,
            index: exercises[index],
          );
        },
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
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: CustomAppBar(title: "Seleccione ejercicios"),
      body: SingleChildScrollView(
        child: ExpansionPanelList.radio(
          elevation: 1,
          expandedHeaderPadding: const EdgeInsets.all(0),
          children: exercises.map<ExpansionPanelRadio>((exercise) {
            return _Card(
              exercise: exercise,
              selected: selectedExercises.any((element) => element == exercise),
              theme: theme,
              onTap: () {
                setState(() {
                  if (selectedExercises.any((element) => element == exercise)) {
                    selectedExercises.remove(exercise);
                  } else {
                    selectedExercises.add(exercise);
                  }
                });
              },
            );
          }).toList(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.playlist_add),
        onPressed: sendBack,
      ),
    );
  }
}

class _Card extends StatelessWidget implements ExpansionPanelRadio {
  final ExerciseModel exercise;
  final Function()? onTap;
  final bool selected;
  final ThemeData theme;
  late final _expansionPanelRadio;
  late final Widget _header;
  late final Widget _body;
  _Card({
    required this.exercise,
    this.onTap,
    this.selected = false,
    required this.theme,
  }) {
    this._header = InkWell(
      onTap: onTap,
      child: ListTile(
        title: Row(
          children: [
            Text(exercise.exerciseName),
            Text(" | "),
            Icon(Icons.pending_actions),
            Text(" "),
            Text(exercise.duration.formatedDuration),
          ],
        ),
      ),
    );

    this._body = InkWell(
      child: _Content(exercise),
      onTap: onTap,
    );

    this._expansionPanelRadio = ExpansionPanelRadio(
      backgroundColor: selected ? theme.buttonColor : null,
      value: exercise,
      headerBuilder: (context, isExpanded) {
        return _header;
      },
      body: _body,
    );
  }

  @override
  Color? get backgroundColor => _expansionPanelRadio.backgroundColor;

  @override
  Widget get body => _expansionPanelRadio.body;

  @override
  bool get canTapOnHeader => _expansionPanelRadio.canTapOnHeader;

  @override
  get headerBuilder => _expansionPanelRadio.headerBuilder;

  @override
  bool get isExpanded => _expansionPanelRadio.isExpanded;

  @override
  Object get value => _expansionPanelRadio.value;

  @override
  Widget build(BuildContext context) {
    return ExpansionPanelList.radio(
      elevation: 1,
      children: [_expansionPanelRadio],
    );
    // return Container(
    //   height: 180,
    //   child: Column(
    //     children: [
    //       _header,
    //       _body,
    //     ],
    //   ),
    //   decoration: BoxDecoration(
    //     border: Border.all(
    //       color: Colors.grey,
    //     ),
    //   ),
    // );
  }
}

class _Content extends StatelessWidget {
  final ExerciseModel exercise;

  _Content(this.exercise);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ConstrainedBox(
          constraints: BoxConstraints.expand(
            height: 120,
          ),
          child: Row(
            children: [
              Flexible(
                flex: 1,
                child: Table(
                  children: [
                    TableRow(
                      children: [
                        Icon(Icons.arrow_circle_up),
                        Text(exercise.count.toString()),
                      ],
                    ),
                    TableRow(
                      children: [
                        Icon(Icons.update),
                        Text(exercise.intervalCount.toString()),
                      ],
                    ),
                    TableRow(
                      children: [
                        Icon(Icons.hourglass_empty),
                        Text(
                            exercise.breakDuration.toDuration.formatedDuration),
                      ],
                    ),
                    TableRow(
                      children: [
                        Icon(Icons.repeat),
                        Text(exercise.series.toString()),
                      ],
                    ),
                  ],
                ),
              ),
              Flexible(
                flex: 1,
                child: Table(
                  children: [
                    TableRow(
                      children: [
                        Icon(Icons.timer),
                        Text(exercise.exerciseDuration.formatedDuration),
                      ],
                    ),
                    TableRow(
                      children: [
                        Icon(Icons.timer_off),
                        Text(exercise.breakTimeDuration.formatedDuration),
                      ],
                    ),
                    TableRow(
                      children: [
                        Icon(Icons.pending_actions),
                        Text(exercise.duration.formatedDuration),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

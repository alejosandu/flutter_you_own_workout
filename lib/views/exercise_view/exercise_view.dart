import 'package:flutter/material.dart';
import '../../helpers/logger.dart';

import '../../widgets/widgets.dart';
import '../../errors/errors.dart';
import '../../database/repository.dart';
import '../../models/exercise.dart';

import 'widgets/dismissible_container.dart';
import 'widgets/exercise_form_container.dart';
import 'widgets/exercise_form_data.dart';

class ExerciseView extends StatefulWidget {
  static String get routeName => "/createExercise";

  @override
  _ExerciseViewState createState() => _ExerciseViewState();
}

class _ExerciseViewState extends State<ExerciseView> {
  List<ExerciseFormData> exercises = [];

  final exerciseRepository = Repository<ExerciseModel>(ExerciseModel.boxName);

  void addItem() {
    setState(() {
      exercises.insert(0, ExerciseFormData());
    });
  }

  void validateAll() {
    final result = exercises.any((exercise) => exercise.validateFields);
    if (result) {
      setState(() {});
      throw AppError(message: "Algunos campos tienen errores");
    }
  }

  void save() async {
    try {
      validateAll();
      exercises.forEach((exercise) => exerciseRepository.put(exercise));
      CustomSnackBar(context, text: "Ejercicios guardados");
      Navigator.of(context).pop();
    } on AppError catch (e) {
      CustomSnackBar(context, text: e.message);
    } catch (e) {
      CustomSnackBar(context, text: "Ocurrió un error al guardar");
      Logger.logError(e);
      debugPrint(e.toString());
    }
  }

  void removeItem<ExerciseFormData>(item) async {
    setState(() {
      exerciseRepository.delete(item);
      exercises.remove(item);
    });
  }

  init() async {
    try {
      await exerciseRepository.isReady;
      final exercisesFormData = exerciseRepository.values
          .map<ExerciseFormData>(
            (exercise) => ExerciseFormData.fromExerciseModel(exercise),
          )
          .toList()
            ..sort((a, b) => a.createdAt.compareTo(b.createdAt));
      setState(() {
        // if its empty add a default
        if (exercisesFormData.isEmpty) {
          exercises.add(ExerciseFormData());
        } else {
          exercises.addAll(exercisesFormData);
        }
      });
    } catch (e) {
      CustomSnackBar(context, text: "Ocurrió un error cargando los datos");
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
      appBar: CustomAppBar(
        title: "Crear ejercicio",
      ),
      body: Container(
        child: ListView.custom(
          childrenDelegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              return DismissibleContainer(
                child: ExerciseFormContainer(exercises[index]),
                index: exercises[index],
                onDismissed: removeItem,
              );
            },
            childCount: exercises.length,
            findChildIndexCallback: (Key key) {
              // called when reordering
              debugPrint(key.toString());
              final ValueKey valueKey = key as ValueKey;
              return exercises.indexOf(valueKey.value);
            },
          ),
        ),
      ),
      floatingActionButton: CustomFab(
        icon: AnimatedIcons.menu_close,
        children: [
          FabAction(
            label: 'Guardar',
            child: Icon(
              Icons.save,
            ),
            onTap: save,
          ),
          FabAction(
            label: 'Agregar más',
            child: Icon(
              Icons.add,
            ),
            onTap: addItem,
          ),
        ],
      ),
    );
  }
}

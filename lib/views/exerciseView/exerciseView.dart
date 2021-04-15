import 'package:flutter/material.dart';
import 'package:floating_action_bubble/floating_action_bubble.dart';

import '../../widgets/custom_snackbar.dart';
import '../../widgets/widgets.dart';
import '../../errors/errors.dart';
import '../../database/database.dart';
import '../../models/exercise.dart';

import 'widgets/dismissible_container.dart';
import 'widgets/exercise_form_container.dart';
import 'widgets/exercise_form_data.dart';

class ExerciseView extends StatefulWidget {
  static String get routeName => "/createExercise";

  @override
  _ExerciseViewState createState() => _ExerciseViewState();
}

class _ExerciseViewState extends State<ExerciseView>
    with TickerProviderStateMixin {
  List<ExerciseFormData> exercises = [];

  late Animation<double> _animation;
  late AnimationController _animationController;

  void addItem() {
    setState(() {
      exercises.insert(0, ExerciseFormData());
    });
  }

  void validateAll() {
    // TODO: agregar arreglo para que vaya iterando y validando cada uno de los campos
  }

  void save() async {
    try {
      validateAll();

      //   List<Exercise> newExercises = exercises.toList();

      final box =
          await Database.connection?.open<ExerciseModel>(ExerciseModel.box);

      exercises.forEach((exercise) => box?.put(exercise.id, exercise));
      CustomSnackBar(context, text: "Ejercicios guardados");
      Navigator.of(context).pop();
    } on AppError catch (e) {
      CustomSnackBar(context, text: e.message);
    } on AssertionError catch (e) {
      if (e.message is AppError) {
        final error = e.message as AppError;
        CustomSnackBar(context, text: error.message);
      }
      debugPrint(e.message.toString());
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void removeItem<ExerciseFormData>(item) async {
    final box =
        await Database.connection?.open<ExerciseModel>(ExerciseModel.box);
    setState(() {
      box?.delete(item.id);
      exercises.remove(item);
    });
  }

  loadSaved() async {
    try {
      final box =
          await Database.connection?.open<ExerciseModel>(ExerciseModel.box);
      final exercisesFormData = box?.values
          .map<ExerciseFormData>(
            (exercise) => ExerciseFormData.fromExerciseModel(exercise),
          )
          .toList()
            ?..sort((a, b) => a.createdAt.compareTo(b.createdAt));
      setState(() {
        // si está vacío significa se agrega uno default
        if (exercisesFormData == null) return;
        if (exercisesFormData.isEmpty) {
          exercises.add(ExerciseFormData());
        } else {
          exercises.addAll(exercisesFormData);
        }
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 260),
    );

    final curvedAnimation =
        CurvedAnimation(curve: Curves.easeInOut, parent: _animationController);
    _animation = Tween<double>(begin: 0, end: 1).animate(curvedAnimation);

    loadSaved();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return Scaffold(
      appBar: CustomAppBar(
        title: "Crear ejercicio",
      ),
      body: Container(
        margin: const EdgeInsets.only(top: 5),
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
              // llamado en caso de reordenamiento
              debugPrint(key.toString());
              final ValueKey valueKey = key as ValueKey;
              return exercises.indexOf(valueKey.value);
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionBubble(
        items: [
          Bubble(
            title: "Agregar más",
            titleStyle: themeData.primaryTextTheme.bodyText1,
            iconColor: themeData.buttonColor,
            bubbleColor: themeData.accentColor,
            icon: Icons.add,
            onPress: () {
              _animationController.reverse();
              addItem();
            },
          ),
          Bubble(
            title: "Guardar",
            titleStyle: themeData.primaryTextTheme.bodyText1,
            iconColor: themeData.buttonColor,
            bubbleColor: themeData.accentColor,
            icon: Icons.save,
            onPress: () {
              _animationController.reverse();
              save();
            },
          ),
        ],
        animation: _animation,
        backGroundColor: null,
        iconColor: themeData.buttonColor,
        iconData: Icons.menu,
        onPress: () {
          _animationController.isCompleted
              ? _animationController.reverse()
              : _animationController.forward();
        },
      ),
    );
  }
}

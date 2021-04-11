import 'package:flutter/material.dart';
import 'package:floating_action_bubble/floating_action_bubble.dart';

import 'package:yourownworkout/widgets/custom_snackbar.dart';

import '../../widgets/widgets.dart';
import '../../errors/errors.dart';

import './widgets/dismissible_container.dart';
import './widgets/exercise_form_container.dart';

class ExerciseView extends StatefulWidget {
  static String routeName = "/createExercise";

  @override
  _ExerciseViewState createState() => _ExerciseViewState();
}

class _ExerciseViewState extends State<ExerciseView>
    with TickerProviderStateMixin {
  List<ExerciseFormData> exercises = [ExerciseFormData()];

  Animation<double> _animation;
  AnimationController _animationController;

  void validateAll() {
    // TODO: agregar arreglo para que vaya iterando y validando cada uno de los campos
  }

  void save() {
    try {
      validateAll();
      // TODO: guardar en base de datos los ejercicios creados
      Navigator.of(context).pop();
    } on AppError catch (e) {
      CustomSnackBar(context, text: e.message);
    } on AssertionError catch (e) {
      if (e.message is AppError) {
        final AppError error = e.message;
        CustomSnackBar(context, text: error.message);
      }
      debugPrint(e.message);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void addItem() {
    setState(() {
      exercises.add(ExerciseFormData());
    });
  }

  void removeItem(dynamic index) {
    setState(() {
      exercises.remove(index);
    });
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

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return Scaffold(
      appBar: CustomAppBar(
        title: "Crear ejercicio",
      ),
      body: ListView.custom(
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
            final ValueKey valueKey = key;
            return exercises.indexOf(valueKey.value);
          },
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

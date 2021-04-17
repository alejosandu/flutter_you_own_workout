import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import '../widgets/appbar.dart';
import 'views.dart';

class PrincipalPage extends StatelessWidget {
  static String get routeName => '/';

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: CustomAppBar(title: "Principal"),
      body: Container(),
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        backgroundColor: theme.accentColor,
        foregroundColor: theme.buttonColor,
        children: [
          SpeedDialChild(
            child: Icon(Icons.fitness_center),
            label: 'Configurar ejercicios',
            onTap: () {
              try {
                Navigator.of(context).pushNamed(ExerciseView.routeName);
              } catch (e) {
                debugPrint(e.toString());
              }
            },
          ),
          SpeedDialChild(
            child: Icon(Icons.sports),
            label: 'Configurar entrenamientos',
            onTap: () {
              try {
                Navigator.of(context).pushNamed(WorkoutView.routeName);
              } catch (e) {
                debugPrint(e.toString());
              }
            },
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../widgets/custom_fab.dart';
import '../widgets/appbar.dart';
import 'views.dart';

class PrincipalPage extends StatelessWidget {
  static String get routeName => '/';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Principal"),
      body: Container(),
      floatingActionButton: CustomFab(
        icon: AnimatedIcons.menu_close,
        children: [
          FabAction(
            child: Icon(Icons.fitness_center),
            label: 'Configurar ejercicios',
            onTap: () {
              Navigator.of(context).pushNamed(ExerciseView.routeName);
            },
          ),
          FabAction(
            child: Icon(Icons.sports),
            label: 'Configurar entrenamientos',
            onTap: () {
              Navigator.of(context).pushNamed(WorkoutView.routeName);
            },
          ),
        ],
      ),
    );
  }
}

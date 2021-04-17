import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:yourownworkout/widgets/appbar.dart';

class WorkoutView extends StatelessWidget {
  static String get routeName => "/createWorkout";

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: CustomAppBar(title: "Entrenamiento"),
      body: Container(),
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        backgroundColor: theme.accentColor,
        foregroundColor: theme.buttonColor,
        children: [],
      ),
    );
  }
}

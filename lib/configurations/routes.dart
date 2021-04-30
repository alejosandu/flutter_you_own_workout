import 'package:flutter/material.dart';

import '../views/views.dart';

final Map<String, WidgetBuilder> appRoutes = {
  PrincipalPage.routeName: (_) => PrincipalPage(),
  ExerciseView.routeName: (_) => ExerciseView(),
  WorkoutView.routeName: (_) => WorkoutView(),
  PlayWorkoutView.routeName: (_) => PlayWorkoutView(),
};

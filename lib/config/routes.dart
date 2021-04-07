import 'package:flutter/material.dart';

import 'package:yourownworkout/views/views.dart';

final Map<String, WidgetBuilder> appRoutes = {
  "/": (_) => PrincipalPage(),
  "/createWorkout": (_) => ExercisePage(),
};

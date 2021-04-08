import 'package:flutter/material.dart';

import 'package:yourownworkout/views/views.dart';

final Map<String, WidgetBuilder> appRoutes = {
  PrincipalPage.routeName: (_) => PrincipalPage(),
  ExerciseView.routeName: (_) => ExerciseView(),
};

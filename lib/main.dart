import 'package:flutter/material.dart';

import 'configurations/configurations.dart';
import 'database/database.dart';

void main() async {
  await Database.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Your own workout',
      theme: appTheme,
      routes: appRoutes,
      initialRoute: "/",
    );
  }
}

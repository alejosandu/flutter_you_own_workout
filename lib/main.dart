import 'package:flutter/material.dart';

import 'config/configurations.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: appTheme,
      routes: appRoutes,
      onGenerateRoute: (settings) {
        debugPrint(settings.arguments);
        // return MaterialPageRoute(builder: appRoutes[settings.name]);
        return null;
      },
      initialRoute: "/",
    );
  }
}

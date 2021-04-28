import 'package:flutter/material.dart';

import 'configurations/configurations.dart';
import 'database/database.dart';

void main() async {
  await Database.init();
  await Database.initDatabase();
  runApp(AppKeepStateWrapper());
}

class AppKeepStateWrapper extends StatefulWidget {
  @override
  _AppKeepStateWrapperState createState() => _AppKeepStateWrapperState();
}

class _AppKeepStateWrapperState extends State<AppKeepStateWrapper>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return MaterialApp(
      title: 'Your own workout',
      theme: appTheme,
      routes: appRoutes,
      initialRoute: "/",
    );
  }
}

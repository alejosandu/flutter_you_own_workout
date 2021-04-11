import 'package:flutter/material.dart';
import '../widgets/appbar.dart';
import '../models/models.dart';
import '../views/exerciseView.dart';

class PrincipalPage extends StatelessWidget implements RouteName {
  static String routeName = '/';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Principal"),
      body: Container(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          try {
            Navigator.of(context).pushNamed(ExerciseView.routeName);
          } catch (e) {
            debugPrint(e.toString());
          }
        },
      ),
    );
  }
}

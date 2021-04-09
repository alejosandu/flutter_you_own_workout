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
            final result = await Navigator.of(context)
                .pushNamed(ExerciseView.routeName) as Exercise;
            debugPrint("result: ${result.toString()}");
            if (result == null) return;
          } catch (e) {
            debugPrint(e.toString());
          }
        },
      ),
    );
  }
}

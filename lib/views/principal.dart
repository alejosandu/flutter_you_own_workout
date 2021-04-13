import 'package:flutter/material.dart';
import '../widgets/appbar.dart';
import 'exerciseView/exerciseView.dart';

class PrincipalPage extends StatelessWidget {
  static String get routeName => '/';

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

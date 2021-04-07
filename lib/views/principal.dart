import 'package:flutter/material.dart';
import 'package:yourownworkout/widgets/appbar.dart';

class PrincipalPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Principal"),
      body: Container(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          final result =
              await Navigator.of(context).pushNamed("/createWorkout");
        },
      ),
    );
  }
}

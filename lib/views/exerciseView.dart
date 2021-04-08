import 'dart:async';

import 'package:flutter/material.dart';
import 'package:yourownworkout/widgets/custom_snackbar.dart';
import '../widgets/widgets.dart';
import '../models/models.dart';
import '../errors/errors.dart';

class ExerciseView extends StatefulWidget {
  @override
  _ExerciseViewState createState() => _ExerciseViewState();
}

class _ExerciseViewState extends State<ExerciseView> {
  String stage = "";
  int counter = 0;
  Timer timer;

  final _count = TextEditingController();

  final _intervalCount = TextEditingController();

  final _break = TextEditingController();

  final _series = TextEditingController();

  final _weight = TextEditingController();

  void setStage(String message) {
    setState(() {
      stage = message;
    });
  }

  void startCycling() async {
    final series = int.parse(_series.text);
    for (var i = 0; i < series; i++) {
      await startCounter();
      await breakTime();
    }
  }

  Future breakTime() {
    final completer = Completer();
    final time = 1000;
    final duration = Duration(milliseconds: time);
    setState(() {
      counter = int.parse(_break.text);
    });
    timer = Timer.periodic(duration, (_) {
      counter--;
      if (0 > counter) {
        timer.cancel();
        counter = 0;
        completer.complete();
      }
      setState(() {});
    });
    setStage("Break");
    return completer.future;
  }

  Future startCounter() {
    final completer = Completer();
    final time = double.parse(_intervalCount.text) * 1000;
    final durationIntervalCount = Duration(milliseconds: time.toInt());
    timer = Timer.periodic(durationIntervalCount, (_) {
      counter++;
      if (counter > int.parse(_count.text)) {
        timer.cancel();
        counter = 0;
        completer.complete();
      }
      setState(() {});
    });
    setStage("Count");
    return completer.future;
  }

  void validateAll() {
    //
  }

  void save() {
    try {
      // TODO: create validation of fields
      validateAll();
    } on AppError catch (e) {
      CustomSnackBar(context, text: e.message);
    } catch (e) {
      debugPrint(e);
    }
    // Navigator.of(context).pop();
    //
  }

  void stop() {
    //
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Crear ejercicio",
      ),
      body: SingleChildScrollView(
        // scrollDirection: Axis.horizontal,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: 120,
            minWidth: 360,
            maxWidth: 400,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _ConfigSection(
                    icon: Icons.arrow_circle_up,
                    controller: _count,
                  ),
                  _ConfigSection(
                    icon: Icons.more_time,
                    controller: _intervalCount,
                  ),
                  _ConfigSection(
                    icon: Icons.access_time_rounded,
                    controller: _break,
                  ),
                  _ConfigSection(
                    icon: Icons.autorenew,
                    controller: _series,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.save),
        onPressed: save,
      ),
    );
  }
}

class _ConfigSection extends StatelessWidget {
//   final String label;
  final IconData icon;
  final TextEditingController controller;

  _ConfigSection({
    Key key,
    @required this.icon,
    this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Container(
      child: Column(
        children: [
          SizedBox(
            height: 35,
            width: 35,
            child: Icon(
              icon,
              size: 35,
            ),
          ),
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.only(top: 5),
            child: TextField(
              autofocus: false,
              keyboardType: TextInputType.number,
              controller: controller,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                isDense: true,
                contentPadding: EdgeInsets.symmetric(
                  vertical: 8,
                ),
              ),
            ),
          )
        ],
      ),
      height: 90,
      width: 90,
      padding: EdgeInsets.fromLTRB(5, 5, 5, 0),
      decoration: BoxDecoration(
        border: Border.all(
          color: theme.primaryColor,
          width: 1,
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(5),
        ),
      ),
    );
  }
}

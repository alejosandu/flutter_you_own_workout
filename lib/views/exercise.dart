import 'dart:async';

import 'package:flutter/material.dart';
import 'package:yourownworkout/widgets/custom_snackbar.dart';
import '../widgets/widgets.dart';
import '../models/models.dart';
import '../errors/errors.dart';

class ExercisePage extends StatefulWidget {
  @override
  _ExercisePageState createState() => _ExercisePageState();
}

class _ExercisePageState extends State<ExercisePage> {
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

  void validateAll() {}

  void save() {
    try {
      // TODO: create validation of fields
      validateAll();
      throw AppError(message: "test");
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
        title: "Create workout",
      ),
      body: GridView.count(
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        padding: const EdgeInsets.all(15),
        childAspectRatio: 1.45,
        children: [
          _ConfigSection(
            label: "Conteo",
            controller: _count,
          ),
          _ConfigSection(
            label: "Intervalo de conteo (en segundos)",
            controller: _intervalCount,
          ),
          _ConfigSection(
            label: "Reposo por serie (en segundos)",
            controller: _break,
          ),
          _ConfigSection(
            label: "Series",
            controller: _series,
          ),
          _ConfigSection(
            label: "Peso",
            controller: _weight,
          ),
          Container(
            child: Text(counter.toString()),
          ),
          Container(
            child: Text(stage),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.save),
        onPressed: save,
      ),
    );
  }
}

class _ConfigSection extends StatelessWidget {
  final String label;
  final TextEditingController controller;

  _ConfigSection({
    Key key,
    @required this.label,
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
            child: Text(label),
          ),
          SizedBox(
            child: TextField(
              autofocus: false,
              keyboardType: TextInputType.number,
              controller: controller,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
          )
        ],
      ),
      height: 60,
      width: 130,
      padding: EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 10,
      ),
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

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yourownworkout/widgets/custom_snackbar.dart';
import '../widgets/widgets.dart';
import '../models/models.dart';
import '../errors/errors.dart';

class ExerciseView extends StatefulWidget {
  static String routeName = "/createExercise";

  @override
  _ExerciseViewState createState() => _ExerciseViewState();
}

class _ExerciseViewState extends State<ExerciseView> {
  String stage = "";
  int counter = 0;
  Timer timer;
  bool aditionalOptionsIsExpanded = false;

  final _exerciseName = TextEditingController();

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
    if (_exerciseName.text.isEmpty)
      throw AppError(message: "Nombre del ejercicio es requerido");
    if (_count.text.isEmpty)
      throw AppError(message: "Número de repeticiones es requirido");
    if (_intervalCount.text.isEmpty)
      throw AppError(message: "El intervalo de incremento es requirido");
    if (_break.text.isEmpty)
      throw AppError(message: "Tiempo de reposo es requirido");
    if (_series.text.isEmpty)
      throw AppError(message: "Cantidad de series es requirido");
  }

  Exercise createExercise() {
    return Exercise(
      exerciseName: _exerciseName.text,
      count: int.parse(_count.text),
      intervalCount: double.parse(_intervalCount.text),
      breakDuration: double.parse(_break.text),
      series: int.parse(_series.text),
      addedWeight: _weight.text.isNotEmpty ? double.parse(_weight.text) : null,
    );
  }

  void save() {
    try {
      validateAll();
      Exercise exercise = createExercise();
      // TODO: guardar en base de datos los ejercicios creados
      Navigator.of(context).pop();
    } on AppError catch (e) {
      CustomSnackBar(context, text: e.message);
    } on AssertionError catch (e) {
      if (e.message is AppError) {
        final AppError error = e.message;
        CustomSnackBar(context, text: error.message);
      }
      debugPrint(e.message);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final IconData expandIcon = aditionalOptionsIsExpanded
        ? Icons.keyboard_arrow_up
        : Icons.keyboard_arrow_down;

    return Scaffold(
      appBar: CustomAppBar(
        title: "Crear ejercicio",
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 10,
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: 120,
              minWidth: 360,
              maxWidth: 400,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: TextField(
                    autofocus: false,
                    controller: _exerciseName,
                    textAlign: TextAlign.center,
                    textAlignVertical: TextAlignVertical.center,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: InputDecoration(
                      labelText: "Nombre del ejercicio",
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: _AditionalConfig(
                    expanded: aditionalOptionsIsExpanded,
                    children: [
                      _ConfigSection(
                        icon: Icons.fitness_center,
                        controller: _weight,
                      ),
                    ],
                  ),
                ),
                ElevatedButton.icon(
                  icon: Icon(expandIcon),
                  label: Text("Agregar opciones"),
                  onPressed: () {
                    setState(() {
                      aditionalOptionsIsExpanded = !aditionalOptionsIsExpanded;
                    });
                  },
                ),
              ],
            ),
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

class _AditionalConfig extends StatelessWidget {
  final bool expanded;
  final List<Widget> children;

  _AditionalConfig({
    this.expanded = false,
    this.children = const [],
  });

  @override
  Widget build(BuildContext context) {
    final double height = expanded ? 90 : 0;
    return AnimatedContainer(
      child: SingleChildScrollView(
        child: Row(
          children: children,
        ),
      ),
      duration: const Duration(milliseconds: 200),
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }
}

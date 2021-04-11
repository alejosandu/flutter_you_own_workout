import 'package:flutter/material.dart';

import '../../../models/models.dart';
import '../../../errors/errors.dart';

import 'aditional_configuration_container.dart';
import 'configuration_section_container.dart';

class ExerciseFormData {
  bool aditionalOptionsIsExpanded = false;

  final exerciseName = TextEditingController();

  final count = TextEditingController();

  final intervalCount = TextEditingController();

  final breakTime = TextEditingController();

  final series = TextEditingController();

  final weight = TextEditingController();

  Exercise createExercise() {
    return Exercise(
      exerciseName: exerciseName.text,
      count: int.parse(count.text),
      intervalCount: double.parse(intervalCount.text),
      breakDuration: double.parse(breakTime.text),
      series: int.parse(series.text),
      addedWeight: weight.text.isNotEmpty ? double.parse(weight.text) : null,
    );
  }

  void validateAll() {
    if (exerciseName.text.isEmpty)
      throw AppError(message: "Nombre del ejercicio es requerido");
    if (count.text.isEmpty)
      throw AppError(message: "Número de repeticiones es requirido");
    if (intervalCount.text.isEmpty)
      throw AppError(message: "El intervalo de incremento es requirido");
    if (breakTime.text.isEmpty)
      throw AppError(message: "Tiempo de reposo es requirido");
    if (series.text.isEmpty)
      throw AppError(message: "Cantidad de series es requirido");
  }

  /// update the state on the parent widget using widgets setState as callback
  Function setState;

  set setterState(Function setState) {
    this.setState = setState;
  }

  void validateFields() {
    setState();
  }
}

class ExerciseFormContainer extends StatefulWidget {
  final ExerciseFormData formData;
  ExerciseFormContainer(this.formData);

  @override
  _ExerciseFormContainerState createState() => _ExerciseFormContainerState();
}

class _ExerciseFormContainerState extends State<ExerciseFormContainer>
    with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    widget.formData.setterState = setState;
    super.initState();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    final IconData expandIcon = widget.formData.aditionalOptionsIsExpanded
        ? Icons.keyboard_arrow_up
        : Icons.keyboard_arrow_down;
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: TextField(
              autofocus: false,
              controller: widget.formData.exerciseName,
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
              ConfigurationSectionContainer(
                icon: Icons.arrow_circle_up,
                controller: widget.formData.count,
              ),
              ConfigurationSectionContainer(
                icon: Icons.more_time,
                controller: widget.formData.intervalCount,
              ),
              ConfigurationSectionContainer(
                icon: Icons.access_time_rounded,
                controller: widget.formData.breakTime,
              ),
              ConfigurationSectionContainer(
                icon: Icons.autorenew,
                controller: widget.formData.series,
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: AditionalConfigurationContainer(
              expanded: widget.formData.aditionalOptionsIsExpanded,
              children: [
                ConfigurationSectionContainer(
                  icon: Icons.fitness_center,
                  controller: widget.formData.weight,
                ),
              ],
            ),
          ),
          ElevatedButton.icon(
            icon: Icon(expandIcon),
            label: Text("Agregar opciones"),
            onPressed: () {
              setState(() {
                widget.formData.aditionalOptionsIsExpanded =
                    !widget.formData.aditionalOptionsIsExpanded;
              });
            },
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 8,
      ),
      decoration: BoxDecoration(
          //
          ),
    );
  }
}

import 'package:flutter/material.dart';

import '../../../extensions/num_extensions.dart';
import '../../../models/models.dart';
import '../../../errors/errors.dart';

import 'aditional_configuration_container.dart';
import 'configuration_section_container.dart';

class ExerciseFormData extends Exercise {
  bool aditionalOptionsIsExpanded = false;

  ExerciseFormData({
    String? id,
    String? exerciseName,
    int? count,
    double? intervalCount,
    double? breakDuration,
    int? series,
    double? addedWeight,
  }) : super(
          id: id,
          exerciseName: exerciseName,
          count: count,
          intervalCount: intervalCount,
          breakDuration: breakDuration,
          series: series,
          addedWeight: addedWeight,
        ) {
    exerciseNameController.text = exerciseName as String;
    countController.text = count.toStringEmpty;
    intervalCountController.text = intervalCount.toStringEmpty;
    breakDurationController.text = breakDuration.toStringEmpty;
    seriesController.text = series.toStringEmpty;
    weightController.text = addedWeight.toStringEmpty;
  }

  final exerciseNameController = TextEditingController();

  final countController = TextEditingController();

  final intervalCountController = TextEditingController();

  final breakDurationController = TextEditingController();

  final seriesController = TextEditingController();

  final weightController = TextEditingController();

  static fromExerciseModel(Exercise exercise) {
    return ExerciseFormData(
      id: exercise.id,
      exerciseName: exercise.exerciseName,
      count: exercise.count,
      intervalCount: exercise.intervalCount,
      breakDuration: exercise.breakDuration,
      series: exercise.series,
      addedWeight: exercise.addedWeight,
    );
  }

  Exercise createExercise() {
    return Exercise(
      exerciseName: exerciseNameController.text,
      count: int.parse(countController.text),
      intervalCount: double.parse(intervalCountController.text),
      breakDuration: double.parse(breakDurationController.text),
      series: int.parse(seriesController.text),
      addedWeight: weightController.text.isNotEmpty
          ? double.parse(weightController.text)
          : null,
    );
  }

  void validateAll() {
    if (exerciseNameController.text.isEmpty)
      throw AppError(message: "Nombre del ejercicio es requerido");
    if (countController.text.isEmpty)
      throw AppError(message: "Número de repeticiones es requirido");
    if (intervalCountController.text.isEmpty)
      throw AppError(message: "El intervalo de incremento es requirido");
    if (breakDurationController.text.isEmpty)
      throw AppError(message: "Tiempo de reposo es requirido");
    if (seriesController.text.isEmpty)
      throw AppError(message: "Cantidad de series es requirido");
  }

  /// update the state on the parent widget using widgets setState as callback
  late Function setState;

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
              controller: widget.formData.exerciseNameController,
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
                controller: widget.formData.countController,
              ),
              ConfigurationSectionContainer(
                icon: Icons.more_time,
                controller: widget.formData.intervalCountController,
              ),
              ConfigurationSectionContainer(
                icon: Icons.access_time_rounded,
                controller: widget.formData.breakDurationController,
              ),
              ConfigurationSectionContainer(
                icon: Icons.autorenew,
                controller: widget.formData.seriesController,
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
                  controller: widget.formData.weightController,
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

import 'package:flutter/material.dart';

import '../../../extensions/num_extensions.dart';

import 'aditional_configuration_container.dart';
import 'configuration_section_container.dart';
import 'exercise_form_data.dart';

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
            child: ConfigurationExerciseName(
              label: "Nombre del ejercicio",
              onChanged: widget.formData.setExerciseName,
              defaultValue: widget.formData.exerciseName,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ConfigurationSectionContainer(
                icon: Icons.arrow_circle_up,
                onChanged: widget.formData.setCount,
                defaultValue: widget.formData.count.toStringEmpty,
              ),
              ConfigurationSectionContainer(
                icon: Icons.more_time,
                onChanged: widget.formData.setIntervalCount,
                defaultValue: widget.formData.intervalCount.toStringEmpty,
              ),
              ConfigurationSectionContainer(
                icon: Icons.access_time_rounded,
                onChanged: widget.formData.setBreakDuration,
                defaultValue: widget.formData.breakDuration.toStringEmpty,
              ),
              ConfigurationSectionContainer(
                icon: Icons.autorenew,
                onChanged: widget.formData.setSeries,
                defaultValue: widget.formData.series.toStringEmpty,
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
                  onChanged: widget.formData.setWeight,
                  defaultValue: widget.formData.addedWeight.toStringEmpty,
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

import '../../../extensions/num_extensions.dart';
import '../../../models/models.dart';
import '../../../errors/errors.dart';

class ExerciseFormData extends ExerciseModel {
  bool aditionalOptionsIsExpanded = false;

  ExerciseFormData({
    String? id,
    String? exerciseName,
    int? count,
    double? intervalCount,
    double? breakDuration,
    int? series,
    double? addedWeight,
    DateTime? createdAt,
  }) : super(
          id: id,
          exerciseName: exerciseName as String,
          count: count as int,
          intervalCount: intervalCount as double,
          breakDuration: breakDuration as double,
          series: series as int,
          addedWeight: addedWeight,
          createdAt: createdAt,
        );

  static ExerciseFormData fromExerciseModel(ExerciseModel exercise) {
    final exerciseFormData = ExerciseFormData(
      id: exercise.id,
      exerciseName: exercise.exerciseName,
      count: exercise.count,
      intervalCount: exercise.intervalCount,
      breakDuration: exercise.breakDuration,
      series: exercise.series,
      addedWeight: exercise.addedWeight,
      createdAt: exercise.createdAt,
    );
    return exerciseFormData;
  }

  setExerciseName(String value) => exerciseName = value;

  setCount(String value) => count = int.tryParse(value) as int;

  setIntervalCount(String value) =>
      intervalCount = double.tryParse(value) as double;

  setBreakDuration(String value) =>
      breakDuration = double.tryParse(value) as double;

  setSeries(String value) => series = int.tryParse(value) as int;

  setWeight(String value) => addedWeight = double.tryParse(value) as double;

  void validateAll() {
    if (exerciseName.isEmpty)
      throw AppError(message: "Nombre del ejercicio es requerido");
    if (count.toStringEmpty.isEmpty)
      throw AppError(message: "Número de repeticiones es requirido");
    if (intervalCount.toStringEmpty.isEmpty)
      throw AppError(message: "El intervalo de incremento es requirido");
    if (breakDuration.toStringEmpty.isEmpty)
      throw AppError(message: "Tiempo de reposo es requirido");
    if (series.toStringEmpty.isEmpty)
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

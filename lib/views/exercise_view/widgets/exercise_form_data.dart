import '../../../extensions/num_extensions.dart';
import '../../../models/models.dart';
import '../../../helpers/validator.dart';

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
          exerciseName: exerciseName ?? '',
          count: count ?? 0,
          intervalCount: intervalCount ?? 1,
          breakDuration: breakDuration ?? 0,
          series: series ?? 0,
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
  String? get exerciseNameIsValid {
    return Validator([
      Rule(
        () => exerciseName.isEmpty,
        "Nombre del ejercicio es requerido",
      )
    ]).test();
  }

  setCount(String value) => count = int.tryParse(value) ?? 0;
  String? get countIsValid {
    return Validator([
      Rule(() => count.toStringEmpty.isEmpty, ""),
      Rule(() => count <= 0, "")
    ]).test();
  }

  setIntervalCount(String value) => intervalCount = double.tryParse(value) ?? 0;
  String? get intervalCountIsValid {
    return Validator([
      Rule(() => intervalCount.toStringEmpty.isEmpty, ""),
      Rule(() => intervalCount <= 0, "")
    ]).test();
  }

  setBreakDuration(String value) => breakDuration = double.tryParse(value) ?? 0;
  String? get breakDurationIsValid {
    return Validator([
      Rule(() => breakDuration.toStringEmpty.isEmpty, ""),
      Rule(() => breakDuration <= 0, "")
    ]).test();
  }

  setSeries(String value) => series = int.tryParse(value) ?? 0;
  String? get seriesIsValid {
    return Validator([
      Rule(() => series.toStringEmpty.isEmpty, ""),
      Rule(() => series <= 0, ""),
    ]).test();
  }

  setWeight(String value) => addedWeight = double.tryParse(value) ?? 0;

  bool get validateFields {
    final result = [
      exerciseNameIsValid,
      countIsValid,
      intervalCountIsValid,
      breakDurationIsValid,
      seriesIsValid,
    ].any((v) => v != null);
    return result;
  }
}

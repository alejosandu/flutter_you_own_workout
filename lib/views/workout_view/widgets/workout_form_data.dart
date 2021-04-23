import 'package:yourownworkout/helpers/validator.dart';
import 'package:yourownworkout/models/workout.dart';

// import '../../../models/models.dart';

class WorkoutFormData extends WorkoutModel {
  setWorkoutName(String value) => workoutName = value;
  String? get workoutNameIsValid {
    return Validator([
      Rule(() => workoutName.isEmpty, "Nombre del entrenamiento es requerido"),
    ]).test();
  }

  String? get workoutExercisesAreValid {
    return Validator([
      Rule(() => exercises.isEmpty, "Debe haber al menos un ejercicio"),
    ]).test();
  }

  static fromWorkoutModel(WorkoutModel model) {
    final workoutFormData = WorkoutFormData();
    return workoutFormData;
  }

  bool get validateFields {
    return [
      workoutNameIsValid,
      workoutExercisesAreValid,
    ].any((v) => v != null);
  }
}

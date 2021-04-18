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

  static fromWorkoutModel(WorkoutModel model) {
    final workoutFormData = WorkoutFormData();
    return workoutFormData;
  }

  bool get validateFields {
    return [
      workoutNameIsValid,
    ].any((v) => v != null);
  }
}

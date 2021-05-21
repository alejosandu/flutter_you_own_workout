import '../../../helpers/validator.dart';
import '../../../models/models.dart';

class WorkoutFormData extends WorkoutModel {
  // TODO: change this class to not extend only compose
  late WorkoutModel _workout;

  WorkoutFormData({
    String? id,
    String workoutName = '',
    String? description,
    List<ExerciseModel>? exercises,
    DateTime? createdAt,
    WorkoutModel? workout,
  }) : super(
          id: id,
          workoutName: workoutName,
          description: description,
          exercises: exercises,
          createdAt: createdAt,
        ) {
    _workout = workout ?? WorkoutModel();
  }

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

  static fromWorkoutModel(WorkoutModel workout) {
    final workoutFormData = WorkoutFormData(
      id: workout.id,
      workoutName: workout.workoutName,
      description: workout.description,
      // TODO: investigar cómo solucionar las listas inmutables de tra forma que no sea crear una nueva a partir de la original
      exercises: List.from(workout.exercises),
      createdAt: workout.createdAt,
    );
    return workoutFormData;
  }

  bool get validateFields {
    return [
      workoutNameIsValid,
      workoutExercisesAreValid,
    ].any((v) => v != null);
  }
}

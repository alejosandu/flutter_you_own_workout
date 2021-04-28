import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../models/models.dart';

import 'repository.dart';

class Database {
  static Database? _instance;
  Database._();

  static Database? get connection => _instance;

  /// called to initiate the adapters on database
  static Future init() async {
    if (_instance != null) return _instance;
    await Hive.initFlutter();
    Hive.registerAdapter(ExerciseAdapter());
    Hive.registerAdapter(WorkoutAdapter());
    _instance = Database._();
  }

  /// called to fill the db with default data
  static Future initDatabase() async {
    final workoutRepository = Repository<WorkoutModel>(WorkoutModel.boxName);
    final exercisesRepository =
        Repository<ExerciseModel>(ExerciseModel.boxName);

    await workoutRepository.isReady;
    await exercisesRepository.isReady;

    if (!workoutRepository.isEmpty && !exercisesRepository.isEmpty) return;

    final List<ExerciseModel> exercises = [
      ExerciseModel(
        exerciseName: "Levantamiento limpio",
        description:
            "Se trata de coger una mancuerna, hacer una sentadilla con un pie al frente y otro atrás, y luego pararse abriendo los pies alzando la mancuerna al hombro",
        count: 30,
        intervalCount: 1,
        breakDuration: 15,
        series: 2,
      ),
      ExerciseModel(
        exerciseName: "Balanceo de mancuerna",
        description:
            "Estando de pie colocar la mancuerna entre lo pies y comenzar a alzarla con de a una mano y completamente extendida",
        count: 30,
        intervalCount: 1,
        breakDuration: 15,
        series: 2,
      ),
      ExerciseModel(
        exerciseName: "Levantamiento sentado",
        description:
            "Estando sentado y con inclinación hacia atrás casi que para hacer abdominales acostado, en esa posición levantar la mancuerna con ambas manos y luego moviendola casi al suelo hacia un lado, esto durante 30 segundos hasta terminar un lado y luego continuar con el otro",
        count: 30,
        intervalCount: 1,
        breakDuration: 15,
        series: 2,
      ),
      ExerciseModel(
        exerciseName: "Levantamiento y lagartija con mancuerna",
        description:
            "Casi como una lagartija normal, solamente que se agrega una mancuerna y al estar arriba se alza, esto por 30 segundos seguidos y luego con el otro brazo",
        count: 30,
        intervalCount: 1,
        breakDuration: 15,
        series: 2,
      ),
    ];

    final WorkoutModel workout = WorkoutModel(
      workoutName: "Entrenamiento de 10 minutos",
      description:
          "Un breve entrenamiento para quemar unas cuantas calorías y activar todo el cuerpo en tan solo 10 minutos!",
      exercises: exercises,
    );

    await workoutRepository.put(workout);
  }
}

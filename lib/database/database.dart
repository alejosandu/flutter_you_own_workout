import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:yourownworkout/models/workout.dart';
import '../models/models.dart';

// to generate run flutter packages pub run build_runner build

class Database {
  static Database? _instance;
  Database._();

  static Database? get connection => _instance;

  static Future init() async {
    if (_instance != null) return Database._();
    await Hive.initFlutter();
    Hive.registerAdapter(ExerciseAdapter());
    Hive.registerAdapter(WorkoutAdapter());
    _instance = Database._();
  }
}

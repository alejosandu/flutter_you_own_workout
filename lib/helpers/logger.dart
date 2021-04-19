import 'dart:io';
import 'package:path_provider/path_provider.dart';

class Logger {
  static final isRelease = bool.fromEnvironment("dart.vm.product");
  static Future get _localPath async {
    final directory = await getExternalStorageDirectory();
    return directory?.path;
  }

  static Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/your_own_workout.txt');
  }

  static Future log(String text) async {
    if (!isRelease) return null;
    final file = await _localFile;
    // Write the file.
    await file.writeAsString(text, mode: FileMode.append);
  }

  static Future logError(Object error) async {
    if (!isRelease) return null;
    final file = await _localFile;
    final DateTime date = DateTime.now();
    await file.writeAsString('$date\n', mode: FileMode.append);
    await file.writeAsString('$error\n', mode: FileMode.append);
    if (error is Error) {
      if (error.stackTrace != null) {
        await file.writeAsString(
          "${error.stackTrace.toString()}\n",
          mode: FileMode.append,
        );
      }
    }
    await file.writeAsString('\n\n', mode: FileMode.append);
  }
}

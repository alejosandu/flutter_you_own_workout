import 'generic_error.dart';
import 'package:meta/meta.dart';

class AppError implements GenericError {
  @override
  String message;

  @override
  String title;

  AppError({
    this.title,
    @required this.message,
  });
}

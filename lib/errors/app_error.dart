import 'generic_error.dart';

class AppError implements GenericError {
  @override
  String message;

  @override
  String title;

  AppError({
    this.title,
    this.message,
  });
}

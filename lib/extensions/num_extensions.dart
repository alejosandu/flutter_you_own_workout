extension NumberExtension on num? {
  /// return the string value of a number, if the number is null return an empty string
  String get toStringEmpty {
    return this != null ? this.toString() : '';
  }
}

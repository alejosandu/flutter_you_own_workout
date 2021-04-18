extension DurationExtensions on Duration {
  String get formatedDuration {
    final string = this.toString();
    return string.substring(0, 7);
  }

  String get formatedDurationShort {
    final string = this.toString();
    return string.substring(2, 7);
  }
}

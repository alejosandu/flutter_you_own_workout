extension DurationExtensions on Duration {
  String get formatedDuration {
    final string = this.toString();
    return string.substring(0, 7);
  }

  String get formatedDurationShort {
    final string = this.toString();
    return string.substring(2, 7);
  }

  double get elapsedInSeconds => (this.inSeconds % 60);

  double get elapsedInMinutes => (this.inMinutes % 60);

  double get elapsedInHours => (this.inHours % 60);
}

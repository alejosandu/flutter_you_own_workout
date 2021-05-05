import 'package:vibration/vibration.dart';

class _VibrationConfig {
  final int duration;
  final int amplitude;
  final List<int> intensities;
  final List<int> pattern;
  final int repeat;

  const _VibrationConfig({
    this.duration = 500,
    this.amplitude = -1,
    this.intensities = const [],
    this.pattern = const [],
    this.repeat = -1,
  });
}

enum _VibrationTypes { PLAY, PAUSE, STOP }

const Map _VibrationMap = {
  _VibrationTypes.PLAY: _VibrationConfig(),
  _VibrationTypes.PAUSE: _VibrationConfig(),
  _VibrationTypes.STOP: _VibrationConfig(),
};

class Vibrator {
  bool? _canVibrate = false;

  Vibrator() {
    _init();
  }

  _init() async {
    _canVibrate = await Vibration.hasVibrator();
  }

  Future? _vibrate(_VibrationConfig vibrationConfig) {
    if (_canVibrate != null && _canVibrate == true)
      return Vibration.vibrate(
        duration: vibrationConfig.duration,
        amplitude: vibrationConfig.amplitude,
        intensities: vibrationConfig.intensities,
        pattern: vibrationConfig.pattern,
        repeat: vibrationConfig.repeat,
      );
  }

  Future? vibrationPLay() {
    return _vibrate(_VibrationMap[_VibrationTypes.PLAY]);
  }

  Future? vibrationPause() {
    return _vibrate(_VibrationMap[_VibrationTypes.PAUSE]);
  }

  Future? vibrationStop() {
    return _vibrate(_VibrationMap[_VibrationTypes.STOP]);
  }
}

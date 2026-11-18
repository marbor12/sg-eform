enum LivenessStep { front, blink, turnLeft }

class LivenessChecker {
  static const double _frontYaw = 12;
  static const double _turnYaw = 20;
  static const double _eyeOpen = 0.6;
  static const double _eyeClosed = 0.3;
  static const int _frontFrames = 4;

  static const double turnLeftSign = 1;

  int _index = 0;
  int _stable = 0;
  bool _sawOpen = false;
  bool _sawClosed = false;

  int get index => _index;
  bool get done => _index >= LivenessStep.values.length;

  void lostFace() => _stable = 0;

  bool update({
    required double yaw,
    required double? leftEye,
    required double? rightEye,
  }) {
    if (done) return false;
    var ok = false;

    switch (LivenessStep.values[_index]) {
      case LivenessStep.front:
        _stable = yaw.abs() < _frontYaw ? _stable + 1 : 0;
        ok = _stable >= _frontFrames;
      case LivenessStep.blink:
        if (leftEye == null || rightEye == null) return false;
        final open = leftEye > _eyeOpen && rightEye > _eyeOpen;
        final closed = leftEye < _eyeClosed && rightEye < _eyeClosed;

        if (open && !_sawClosed) _sawOpen = true;
        if (closed && _sawOpen) _sawClosed = true;
        ok = open && _sawClosed;
      case LivenessStep.turnLeft:
        _stable = yaw * turnLeftSign > _turnYaw ? _stable + 1 : 0;
        ok = _stable >= 2;
    }

    if (ok) {
      _index++;
      _stable = 0;
      _sawOpen = false;
      _sawClosed = false;
    }
    return ok;
  }
}

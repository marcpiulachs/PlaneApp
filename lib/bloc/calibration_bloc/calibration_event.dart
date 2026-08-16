abstract class CalibrationEvent {}

class CalibrateImuEvent extends CalibrationEvent {}

class CalibrateCompassEvent extends CalibrationEvent {}

class CalibrationTickEvent extends CalibrationEvent {
  final int secondsRemaining;
  CalibrationTickEvent(this.secondsRemaining);
}
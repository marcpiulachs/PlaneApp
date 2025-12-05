import 'package:equatable/equatable.dart';
import 'package:paperwings/models/telemetry.dart';
import 'package:paperwings/models/user_action.dart';

abstract class FlyEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FlyCheckConnectionEvent extends FlyEvent {}

class GyroXUpdated extends FlyEvent {
  final double value;
  GyroXUpdated(this.value);
}

class GyroYUpdated extends FlyEvent {
  final double value;
  GyroYUpdated(this.value);
}

class GyroZUpdated extends FlyEvent {
  final double value;
  GyroZUpdated(this.value);
}

class MagnetometerXUpdated extends FlyEvent {
  final double value;
  MagnetometerXUpdated(this.value);
}

class MagnetometerYUpdated extends FlyEvent {
  final double value;
  MagnetometerYUpdated(this.value);
}

class MagnetometerZUpdated extends FlyEvent {
  final double value;
  MagnetometerZUpdated(this.value);
}

class AccelerometerXUpdated extends FlyEvent {
  final double value;
  AccelerometerXUpdated(this.value);
}

class AccelerometerYUpdated extends FlyEvent {
  final double value;
  AccelerometerYUpdated(this.value);
}

class AccelerometerZUpdated extends FlyEvent {
  final double value;
  AccelerometerZUpdated(this.value);
}

class BarometerUpdated extends FlyEvent {
  final double value;
  BarometerUpdated(this.value);
}

class Motor1SpeedUpdated extends FlyEvent {
  final double value;
  Motor1SpeedUpdated(this.value);
}

class Motor2SpeedUpdated extends FlyEvent {
  final double value;
  Motor2SpeedUpdated(this.value);
}

class BatterySocUpdated extends FlyEvent {
  final double value;
  BatterySocUpdated(this.value);
}

class BatteryVolUpdated extends FlyEvent {
  final double value;
  BatteryVolUpdated(this.value);
}

class SignalUpdated extends FlyEvent {
  final double value;
  SignalUpdated(this.value);
}

class SendArmed extends FlyEvent {
  final bool isArmed;

  SendArmed(this.isArmed);
}

class SendThrottle extends FlyEvent {
  final int value;

  SendThrottle(this.value);
}

class SendManeuver extends FlyEvent {
  final int maneuver;

  SendManeuver(this.maneuver);
}

class FlightRecorderUpdated extends FlyEvent {
  FlightRecorderUpdated();
}

class SendYoke extends FlyEvent {
  final int value;
  SendYoke(this.value);
}

class YawUpdated extends FlyEvent {
  final double value;
  YawUpdated(this.value);
}

class RollUpdated extends FlyEvent {
  final double value;
  RollUpdated(this.value);
}

class PitchUpdated extends FlyEvent {
  final double value;
  PitchUpdated(this.value);
}

class FlightData {
  final Telemetry telemetry;
  final UserAction userAction;
  const FlightData({required this.telemetry, required this.userAction});
}

class CaptureData extends FlyEvent {
  final FlightData flightData;
  CaptureData(this.flightData);
}

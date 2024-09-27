import 'package:equatable/equatable.dart';
import 'package:object_3d/models/telemetry.dart';

abstract class FlyEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FlyCheckConnectionEvent extends FlyEvent {}

class GyroXUpdated extends FlyEvent {
  final int value;
  GyroXUpdated(this.value);
}

class GyroYUpdated extends FlyEvent {
  final int value;
  GyroYUpdated(this.value);
}

class GyroZUpdated extends FlyEvent {
  final int value;
  GyroZUpdated(this.value);
}

class MagnetometerXUpdated extends FlyEvent {
  final int value;
  MagnetometerXUpdated(this.value);
}

class MagnetometerYUpdated extends FlyEvent {
  final int value;
  MagnetometerYUpdated(this.value);
}

class MagnetometerZUpdated extends FlyEvent {
  final int value;
  MagnetometerZUpdated(this.value);
}

class BarometerUpdated extends FlyEvent {
  final int value;
  BarometerUpdated(this.value);
}

class Motor1SpeedUpdated extends FlyEvent {
  final int value;
  Motor1SpeedUpdated(this.value);
}

class Motor2SpeedUpdated extends FlyEvent {
  final int value;
  Motor2SpeedUpdated(this.value);
}

class BatteryUpdated extends FlyEvent {
  final int value;
  BatteryUpdated(this.value);
}

class SignalUpdated extends FlyEvent {
  final int value;
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

class YawUpdated extends FlyEvent {
  final int value;
  YawUpdated(this.value);
}

class RollUpdated extends FlyEvent {
  final int value;
  RollUpdated(this.value);
}

class PitchUpdated extends FlyEvent {
  final int value;
  PitchUpdated(this.value);
}

class CaptureData extends FlyEvent {
  final Telemetry telemetry;
  CaptureData(this.telemetry);
}

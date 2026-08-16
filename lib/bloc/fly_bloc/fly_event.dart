import 'package:equatable/equatable.dart';
import 'package:paperwings/enum/maneuver_type.dart';
import 'package:paperwings/models/telemetry.dart';
import 'package:paperwings/models/user_action.dart';

abstract class FlyEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class ManeuverSelectedEvent extends FlyEvent {
  final ManeuverType maneuverType;
  ManeuverSelectedEvent(this.maneuverType);

  @override
  List<Object?> get props => [maneuverType];
}

class FlyCheckConnectionEvent extends FlyEvent {}

class TelemetryUpdated extends FlyEvent {
  final Telemetry telemetry;
  TelemetryUpdated(this.telemetry);
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

class FlightData {
  final Telemetry telemetry;
  final UserAction userAction;
  const FlightData({required this.telemetry, required this.userAction});
}

class CaptureData extends FlyEvent {
  final FlightData flightData;
  CaptureData(this.flightData);
}

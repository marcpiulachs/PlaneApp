abstract class FlightSettingsEvent {}

class UpdateSteeringAngle extends FlightSettingsEvent {
  final double value;
  UpdateSteeringAngle(this.value);
}

class UpdatePitchKp extends FlightSettingsEvent {
  final double value;
  UpdatePitchKp(this.value);
}

class UpdatePitchRateKp extends FlightSettingsEvent {
  final double value;
  UpdatePitchRateKp(this.value);
}

class UpdateRollKp extends FlightSettingsEvent {
  final double value;
  UpdateRollKp(this.value);
}

class UpdateRollRateKp extends FlightSettingsEvent {
  final double value;
  UpdateRollRateKp(this.value);
}

class UpdateYawKp extends FlightSettingsEvent {
  final double value;
  UpdateYawKp(this.value);
}

class UpdateYawRateKp extends FlightSettingsEvent {
  final double value;
  UpdateYawRateKp(this.value);
}

class UpdateAngleOfAttack extends FlightSettingsEvent {
  final double value;
  UpdateAngleOfAttack(this.value);
}

class ResetFactorySettings extends FlightSettingsEvent {}

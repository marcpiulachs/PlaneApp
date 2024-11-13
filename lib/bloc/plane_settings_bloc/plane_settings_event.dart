abstract class PlaneSettingsEvent {}

class UpdateBeacon extends PlaneSettingsEvent {
  final int value;
  UpdateBeacon(this.value);
}

class UpdateSteeringAngle extends PlaneSettingsEvent {
  final double value;
  UpdateSteeringAngle(this.value);
}

class UpdatePitchKp extends PlaneSettingsEvent {
  final double value;
  UpdatePitchKp(this.value);
}

class UpdatePitchRateKp extends PlaneSettingsEvent {
  final double value;
  UpdatePitchRateKp(this.value);
}

class UpdateRollKp extends PlaneSettingsEvent {
  final double value;
  UpdateRollKp(this.value);
}

class UpdateRollRateKp extends PlaneSettingsEvent {
  final double value;
  UpdateRollRateKp(this.value);
}

class UpdateYawKp extends PlaneSettingsEvent {
  final double value;
  UpdateYawKp(this.value);
}

class UpdateYawRateKp extends PlaneSettingsEvent {
  final double value;
  UpdateYawRateKp(this.value);
}

class UpdateAngleOfAttack extends PlaneSettingsEvent {
  final double value;
  UpdateAngleOfAttack(this.value);
}

class ResetFactorySettings extends PlaneSettingsEvent {}

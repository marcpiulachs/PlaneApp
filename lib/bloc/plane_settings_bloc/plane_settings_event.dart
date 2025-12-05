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

class UpdatePitchKi extends PlaneSettingsEvent {
  final double value;
  UpdatePitchKi(this.value);
}

class UpdatePitchKd extends PlaneSettingsEvent {
  final double value;
  UpdatePitchKd(this.value);
}

class UpdateRollKp extends PlaneSettingsEvent {
  final double value;
  UpdateRollKp(this.value);
}

class UpdateRollKi extends PlaneSettingsEvent {
  final double value;
  UpdateRollKi(this.value);
}

class UpdateRollKd extends PlaneSettingsEvent {
  final double value;
  UpdateRollKd(this.value);
}

class UpdateYawKp extends PlaneSettingsEvent {
  final double value;
  UpdateYawKp(this.value);
}

class UpdateYawKi extends PlaneSettingsEvent {
  final double value;
  UpdateYawKi(this.value);
}

class UpdateYawKd extends PlaneSettingsEvent {
  final double value;
  UpdateYawKd(this.value);
}

class UpdateAngleOfAttack extends PlaneSettingsEvent {
  final double value;
  UpdateAngleOfAttack(this.value);
}

class ResetFactorySettings extends PlaneSettingsEvent {}

class UpdateIMULogEvent extends PlaneSettingsEvent {
  final bool value;
  UpdateIMULogEvent(this.value);
}

class UpdateMotorLogEvent extends PlaneSettingsEvent {
  final bool value;
  UpdateMotorLogEvent(this.value);
}

class UpdateThrustLogEvent extends PlaneSettingsEvent {
  final bool value;
  UpdateThrustLogEvent(this.value);
}

class UpdateBatteryLogEvent extends PlaneSettingsEvent {
  final bool value;
  UpdateBatteryLogEvent(this.value);
}

class RebootEvent extends PlaneSettingsEvent {
  RebootEvent();
}

class ShutdownEvent extends PlaneSettingsEvent {
  ShutdownEvent();
}

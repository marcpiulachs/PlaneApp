part of 'motor_settings_bloc.dart';

abstract class MotorSettingsEvent extends Equatable {
  const MotorSettingsEvent();

  @override
  List<Object> get props => [];
}

class Motor1SpeedUpdated extends MotorSettingsEvent {
  final double value;
  const Motor1SpeedUpdated(this.value);
  @override
  List<Object> get props => [value];
}

class Motor2SpeedUpdated extends MotorSettingsEvent {
  final double value;
  const Motor2SpeedUpdated(this.value);
  @override
  List<Object> get props => [value];
}

class Slider1Changed extends MotorSettingsEvent {
  final double value;

  const Slider1Changed(this.value);

  @override
  List<Object> get props => [value];
}

class Slider2Changed extends MotorSettingsEvent {
  final double value;

  const Slider2Changed(this.value);

  @override
  List<Object> get props => [value];
}

class ToggleArmedState extends MotorSettingsEvent {}

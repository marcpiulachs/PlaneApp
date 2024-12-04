part of 'motor_settings_bloc.dart';

class MotorSettingsState {
  final bool isArmed;
  final double slider1Value;
  final double slider2Value;
  final double motor1Value;
  final double motor2Value;

  const MotorSettingsState({
    required this.isArmed,
    required this.slider1Value,
    required this.slider2Value,
    required this.motor1Value,
    required this.motor2Value,
  });

  factory MotorSettingsState.initial() {
    return const MotorSettingsState(
      isArmed: false,
      slider1Value: 0,
      slider2Value: 0,
      motor1Value: 0,
      motor2Value: 0,
    );
  }

  MotorSettingsState copyWith({
    bool? isArmed,
    double? slider1Value,
    double? slider2Value,
    double? motor1Value,
    double? motor2Value,
  }) {
    return MotorSettingsState(
      isArmed: isArmed ?? this.isArmed,
      slider1Value: slider1Value ?? this.slider1Value,
      slider2Value: slider2Value ?? this.slider2Value,
      motor1Value: motor1Value ?? this.motor1Value,
      motor2Value: motor2Value ?? this.motor2Value,
    );
  }
}

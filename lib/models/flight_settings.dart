class FlightSettings {
  final double steeringAngle; // Ángulo de dirección del avión
  final double pitchKp; // Coeficiente proporcional del pitch
  final double pitchRateKp; // Tasa de cambio de pitch
  final double rollKp; // Coeficiente proporcional
  final double rollRateKp; // Tasa de cambio de roll
  final double yawKp; // Coeficiente proporcional del yaw
  final double yawRateKp; // Tasa de cambio de yaw
  final double angleOfAttack; // Ángulo de ataque del avión

  FlightSettings({
    required this.steeringAngle,
    required this.pitchKp,
    required this.pitchRateKp,
    required this.rollKp,
    required this.rollRateKp,
    required this.yawKp,
    required this.yawRateKp,
    required this.angleOfAttack,
  });

  FlightSettings copyWith({
    double? steeringAngle,
    double? pitchKp,
    double? pitchRateKp,
    double? rollKp,
    double? rollRateKp,
    double? yawKp,
    double? yawRateKp,
    double? angleOfAttack,
  }) {
    return FlightSettings(
      steeringAngle: steeringAngle ?? this.steeringAngle,
      pitchKp: pitchKp ?? this.pitchKp,
      pitchRateKp: pitchRateKp ?? this.pitchRateKp,
      rollKp: rollKp ?? this.rollKp,
      rollRateKp: rollRateKp ?? this.rollRateKp,
      yawKp: yawKp ?? this.yawKp,
      yawRateKp: yawRateKp ?? this.yawRateKp,
      angleOfAttack: angleOfAttack ?? this.angleOfAttack,
    );
  }
}

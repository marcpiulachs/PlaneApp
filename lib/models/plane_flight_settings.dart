class PlaneFlightSettings {
  final double steeringAngle; // Ángulo de dirección del avión

  // PID Pitch
  final double pitchKp;
  final double pitchKi;
  final double pitchKd;

  // PID Roll
  final double rollKp;
  final double rollKi;
  final double rollKd;

  // PID Yaw
  final double yawKp;
  final double yawKi;
  final double yawKd;

  final double angleOfAttack; // Ángulo de ataque del avión
  final int beacon;

  PlaneFlightSettings({
    required this.steeringAngle,
    required this.pitchKp,
    required this.pitchKi,
    required this.pitchKd,
    required this.rollKp,
    required this.rollKi,
    required this.rollKd,
    required this.yawKp,
    required this.yawKi,
    required this.yawKd,
    required this.angleOfAttack,
    required this.beacon,
  });

  PlaneFlightSettings copyWith({
    double? steeringAngle,
    double? pitchKp,
    double? pitchKi,
    double? pitchKd,
    double? rollKp,
    double? rollKi,
    double? rollKd,
    double? yawKp,
    double? yawKi,
    double? yawKd,
    double? angleOfAttack,
    int? beacon,
  }) {
    return PlaneFlightSettings(
      steeringAngle: steeringAngle ?? this.steeringAngle,
      pitchKp: pitchKp ?? this.pitchKp,
      pitchKi: pitchKi ?? this.pitchKi,
      pitchKd: pitchKd ?? this.pitchKd,
      rollKp: rollKp ?? this.rollKp,
      rollKi: rollKi ?? this.rollKi,
      rollKd: rollKd ?? this.rollKd,
      yawKp: yawKp ?? this.yawKp,
      yawKi: yawKi ?? this.yawKi,
      yawKd: yawKd ?? this.yawKd,
      angleOfAttack: angleOfAttack ?? this.angleOfAttack,
      beacon: beacon ?? this.beacon,
    );
  }
}

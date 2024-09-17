class FlightSettings {
  double steeringAngle;
  double pitchKp;
  double pitchRateKp;
  double rollKp;
  double rollRateKp;
  double yawKp;
  double yawRateKp;
  double angleOfAttack;

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

  void updateSteeringAngle(double value) => steeringAngle = value;
  void updatePitchKp(double value) => pitchKp = value;
  void updatePitchRateKp(double value) => pitchRateKp = value;
  void updateRollKp(double value) => rollKp = value;
  void updateRollRateKp(double value) => rollRateKp = value;
  void updateYawKp(double value) => yawKp = value;
  void updateYawRateKp(double value) => yawRateKp = value;
  void updateAngleOfAttack(double value) => angleOfAttack = value;
}

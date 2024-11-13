class PlaneLogSettings {
  final bool imu;
  final bool thrust;
  final bool battery;
  final bool motor;

  PlaneLogSettings({
    required this.imu,
    required this.thrust,
    required this.battery,
    required this.motor,
  });

  PlaneLogSettings copyWith({
    bool? imu,
    bool? thrust,
    bool? battery,
    bool? motor,
  }) {
    return PlaneLogSettings(
        imu: imu ?? this.imu,
        thrust: thrust ?? this.thrust,
        battery: battery ?? this.battery,
        motor: motor ?? this.motor);
  }
}

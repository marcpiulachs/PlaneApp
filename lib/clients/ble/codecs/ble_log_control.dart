/// Flag de registro de la característica `logControl`. Espeja el orden del
/// firmware: LOG_IMU = bit 0, LOG_THRUST = bit 1, LOG_BATT = bit 2,
/// LOG_MOTOR = bit 3.
enum BleLogFlag {
  imu(0),
  thrust(1),
  battery(2),
  motor(3);

  const BleLogFlag(this.bit);

  final int bit;
}

/// Payload de la característica `logControl` (1 byte: bitmask con cuatro
/// flags). Bit 0 = IMU, bit 1 = thrust, bit 2 = battery, bit 3 = motor.
class BleLogControl {
  BleLogControl({
    this.imu = false,
    this.thrust = false,
    this.battery = false,
    this.motor = false,
  });

  BleLogControl.fromMask(int mask)
      : imu = mask & (1 << BleLogFlag.imu.bit) != 0,
        thrust = mask & (1 << BleLogFlag.thrust.bit) != 0,
        battery = mask & (1 << BleLogFlag.battery.bit) != 0,
        motor = mask & (1 << BleLogFlag.motor.bit) != 0;

  final bool imu;
  final bool thrust;
  final bool battery;
  final bool motor;

  int get mask =>
      (imu ? 1 << BleLogFlag.imu.bit : 0) |
      (thrust ? 1 << BleLogFlag.thrust.bit : 0) |
      (battery ? 1 << BleLogFlag.battery.bit : 0) |
      (motor ? 1 << BleLogFlag.motor.bit : 0);

  List<int> toBytes() => [mask];
}

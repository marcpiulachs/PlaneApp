/// Objetivo de calibración de la característica `calibrate`.
enum BleCalibrationTarget {
  imu(0),
  magnetometer(1);

  const BleCalibrationTarget(this.value);

  final int value;
}

/// Payload de la característica `calibrate` (1 byte: 0 = IMU, 1 = MAG).
class BleCalibrate {
  BleCalibrate(this.target);

  final BleCalibrationTarget target;

  List<int> toBytes() => [target.value];
}

/// Orientación de montaje del sensor IMU (transformación sensor -> cuerpo).
/// Espeja `SensorOrientation` del firmware: FLAT = 0, ROLL_RIGHT_90 = 1,
/// ROLL_LEFT_90 = 2.
enum BleSensorOrientation {
  flat(0),
  rollRight90(1),
  rollLeft90(2);

  const BleSensorOrientation(this.value);

  final int value;

  static BleSensorOrientation fromValue(int value) {
    return switch (value) {
      0 => BleSensorOrientation.flat,
      1 => BleSensorOrientation.rollRight90,
      2 => BleSensorOrientation.rollLeft90,
      _ => throw ArgumentError('Unknown BleSensorOrientation: $value'),
    };
  }
}

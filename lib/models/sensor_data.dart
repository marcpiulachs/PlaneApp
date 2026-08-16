// Constructor named 'empty' para SensorState
extension SensorStateEmpty on SensorState {
  static SensorState empty() => const SensorState(
    gyroscopeX: 0.0,
    gyroscopeY: 0.0,
    gyroscopeZ: 0.0,
    accelerometerX: 0.0,
    accelerometerY: 0.0,
    accelerometerZ: 0.0,
    magnamometerX: 0.0,
    magnamometerY: 0.0,
    magnamometerZ: 0.0,
  );
}
// Estado que contiene los datos de los sensores
class SensorState {
  final double gyroscopeX;
  final double gyroscopeY;
  final double gyroscopeZ;
  final double accelerometerX;
  final double accelerometerY;
  final double accelerometerZ;
  final double magnamometerX;
  final double magnamometerY;
  final double magnamometerZ;

  const SensorState({
    required this.gyroscopeX,
    required this.gyroscopeY,
    required this.gyroscopeZ,
    required this.accelerometerX,
    required this.accelerometerY,
    required this.accelerometerZ,
    required this.magnamometerX,
    required this.magnamometerY,
    required this.magnamometerZ,
  });

  // Método copyWith para actualizar solo ciertos valores
  SensorState copyWith({
    double? gyroscopeX,
    double? gyroscopeY,
    double? gyroscopeZ,
    double? accelerometerX,
    double? accelerometerY,
    double? accelerometerZ,
    double? magnamometerX,
    double? magnamometerY,
    double? magnamometerZ,
  }) {
    return SensorState(
      gyroscopeX: gyroscopeX ?? this.gyroscopeX,
      gyroscopeY: gyroscopeY ?? this.gyroscopeY,
      gyroscopeZ: gyroscopeZ ?? this.gyroscopeZ,
      accelerometerX: accelerometerX ?? this.accelerometerX,
      accelerometerY: accelerometerY ?? this.accelerometerY,
      accelerometerZ: accelerometerZ ?? this.accelerometerZ,
      magnamometerX: magnamometerX ?? this.magnamometerX,
      magnamometerY: magnamometerY ?? this.magnamometerY,
      magnamometerZ: magnamometerZ ?? this.magnamometerZ,
    );
  }
}

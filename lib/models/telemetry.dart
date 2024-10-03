import 'dart:math';

class Telemetry {
  final int gyroX;
  final int gyroY;
  final int gyroZ;
  final int magnetometerX;
  final int magnetometerY;
  final int magnetometerZ;
  final int barometer;
  final int motor1Speed;
  final int motor2Speed;
  final int battery;
  final int signal;
  final int accelX;
  final int accelY;
  final int accelZ;

  Telemetry({
    this.gyroX = 0,
    this.gyroY = 0,
    this.gyroZ = 0,
    this.magnetometerX = 0,
    this.magnetometerY = 0,
    this.magnetometerZ = 0,
    this.barometer = 0,
    this.motor1Speed = 0,
    this.motor2Speed = 0,
    this.battery = 0,
    this.signal = 0,
    this.accelX = 0,
    this.accelY = 0,
    this.accelZ = 0,
  });

  double get degrees {
    // Calcula el ángulo en grados basado en los datos del magnetómetro.
    // La fórmula real puede variar según el tipo de magnetómetro y los datos.
    double angle = atan2(magnetometerY.toDouble(), magnetometerX.toDouble());
    return angle * (180 / pi);
  }

  double get altitude {
    const double seaLevelPressure = 1013.25; // Presión al nivel del mar en hPa
    return (seaLevelPressure - barometer) / 0.12;
  }

  Telemetry copyWith({
    int? gyroX,
    int? gyroY,
    int? gyroZ,
    int? magnetometerX,
    int? magnetometerY,
    int? magnetometerZ,
    int? barometer,
    int? motor1Speed,
    int? motor2Speed,
    int? battery,
    int? signal,
    int? accelX,
    int? accelY,
    int? accelZ,
  }) {
    return Telemetry(
      gyroX: gyroX ?? this.gyroX,
      gyroY: gyroY ?? this.gyroY,
      gyroZ: gyroZ ?? this.gyroZ,
      magnetometerX: magnetometerX ?? this.magnetometerX,
      magnetometerY: magnetometerY ?? this.magnetometerY,
      magnetometerZ: magnetometerZ ?? this.magnetometerZ,
      barometer: barometer ?? this.barometer,
      motor1Speed: motor1Speed ?? this.motor1Speed,
      motor2Speed: motor2Speed ?? this.motor2Speed,
      battery: battery ?? this.battery,
      signal: signal ?? this.signal,
      accelX: accelX ?? this.accelX,
      accelY: accelY ?? this.accelY,
      accelZ: accelZ ?? this.accelZ,
    );
  }
}

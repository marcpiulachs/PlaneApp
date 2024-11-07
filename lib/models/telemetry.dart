import 'dart:math';

class Telemetry {
  final double gyroX;
  final double gyroY;
  final double gyroZ;
  final double magX;
  final double magY;
  final double magZ;
  final double barometer;
  final double motor1Speed;
  final double motor2Speed;
  final double batterySoc;
  final double batteryVol;
  final double signal;
  final double accelX;
  final double accelY;
  final double accelZ;
  final double pitch;
  final double roll;
  final double yaw;

  Telemetry({
    this.gyroX = 0,
    this.gyroY = 0,
    this.gyroZ = 0,
    this.magX = 0,
    this.magY = 0,
    this.magZ = 0,
    this.barometer = 0,
    this.motor1Speed = 0,
    this.motor2Speed = 0,
    this.batterySoc = 0,
    this.batteryVol = 0,
    this.signal = 0,
    this.accelX = 0,
    this.accelY = 0,
    this.accelZ = 0,
    this.pitch = 0,
    this.roll = 0,
    this.yaw = 0,
  });

  double get degrees {
    // Calcula el ángulo en grados basado en los datos del magnetómetro.
    // La fórmula real puede variar según el tipo de magnetómetro y los datos.
    double angle = atan2(magY.toDouble(), magX.toDouble());
    return angle * (180 / pi);
  }

  double get altitude {
    return 0;
  }

  /// Tasa de giro en grados por segundo
  double get turnRate {
    return gyroZ.toDouble(); // Suponiendo que gyroZ ya esté en grados/seg
  }

  /// Slip estimado basado en la aceleración lateral
  double get slip {
    return accelX.toDouble();
  }

  Telemetry copyWith({
    double? gyroX,
    double? gyroY,
    double? gyroZ,
    double? magX,
    double? magY,
    double? magZ,
    double? barometer,
    double? motor1Speed,
    double? motor2Speed,
    double? batterySoc,
    double? batteryVol,
    double? signal,
    double? accelX,
    double? accelY,
    double? accelZ,
    double? pitch,
    double? roll,
    double? yaw,
  }) {
    return Telemetry(
      gyroX: gyroX ?? this.gyroX,
      gyroY: gyroY ?? this.gyroY,
      gyroZ: gyroZ ?? this.gyroZ,
      magX: magX ?? this.magX,
      magY: magY ?? this.magY,
      magZ: magZ ?? this.magZ,
      barometer: barometer ?? this.barometer,
      motor1Speed: motor1Speed ?? this.motor1Speed,
      motor2Speed: motor2Speed ?? this.motor2Speed,
      batterySoc: batterySoc ?? this.batterySoc,
      batteryVol: batteryVol ?? this.batteryVol,
      signal: signal ?? this.signal,
      accelX: accelX ?? this.accelX,
      accelY: accelY ?? this.accelY,
      accelZ: accelZ ?? this.accelZ,
      pitch: pitch ?? this.pitch,
      roll: roll ?? this.roll,
      yaw: yaw ?? this.yaw,
    );
  }
}

class Telemetry {
  final double gyroX;
  final double gyroY;
  final double gyroZ;
  final double magX;
  final double magY;
  final double magZ;
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
    // Usa el yaw calculado por el firmware que ya tiene compensación de inclinación (tilt compensation)
    // El yaw del firmware considera pitch y roll para dar el heading correcto
    return yaw;
  }

  double get altitude {
    return 0;
  }

  /// Tasa de giro en grados por segundo
  double get turnRate {
    return gyroZ; // Suponiendo que gyroZ ya esté en grados/seg
  }

  /// Slip estimado basado en la aceleración lateral
  double get slip {
    return accelX;
  }

  Telemetry copyWith({
    double? gyroX,
    double? gyroY,
    double? gyroZ,
    double? magX,
    double? magY,
    double? magZ,
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

  Map<String, dynamic> toMap() {
    return {
      'gyroX': gyroX,
      'gyroY': gyroY,
      'gyroZ': gyroZ,
      'magX': magX,
      'magY': magY,
      'magZ': magZ,
      'accelX': accelX,
      'accelY': accelY,
      'accelZ': accelZ,
      'pitch': pitch,
      'roll': roll,
      'yaw': yaw,
      'motor1Speed': motor1Speed,
      'motor2Speed': motor2Speed,
    };
  }

  factory Telemetry.fromMap(Map<String, dynamic> map) {
    return Telemetry(
      gyroX: map['gyroX'] as double,
      gyroY: map['gyroY'] as double,
      gyroZ: map['gyroZ'] as double,
      magX: map['magX'] as double,
      magY: map['magY'] as double,
      magZ: map['magZ'] as double,
      accelX: map['accelX'] as double,
      accelY: map['accelY'] as double,
      accelZ: map['accelZ'] as double,
      pitch: map['pitch'] as double,
      roll: map['roll'] as double,
      yaw: map['yaw'] as double,
      motor1Speed: map['motor1Speed'] as double,
      motor2Speed: map['motor2Speed'] as double,
    );
  }
}

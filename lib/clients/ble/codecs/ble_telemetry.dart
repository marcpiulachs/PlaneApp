import 'package:paperwings/clients/ble/codecs/ble_codec_bytes.dart';

/// Payload de la característica `telemetry` (61 bytes): snapshot completo de
/// telemetría, una notificación por tick. Layout (f32 little-endian, struct
/// nativo empaquetado del firmware):
///   gyro 3×f32 | accel 3×f32 | attitude 3×f32 | mag 3×f32 | motors 2×f32
///   | batteryVol f32 | batterySoc u8
class BleTelemetry {
  const BleTelemetry({
    required this.gyroX,
    required this.gyroY,
    required this.gyroZ,
    required this.accelX,
    required this.accelY,
    required this.accelZ,
    required this.pitch,
    required this.roll,
    required this.yaw,
    required this.magX,
    required this.magY,
    required this.magZ,
    required this.motor1,
    required this.motor2,
    required this.batteryVol,
    required this.batterySoc,
  });

  final double gyroX;
  final double gyroY;
  final double gyroZ;
  final double accelX;
  final double accelY;
  final double accelZ;
  final double pitch;
  final double roll;
  final double yaw;
  final double magX;
  final double magY;
  final double magZ;
  final double motor1;
  final double motor2;
  final double batteryVol;
  final int batterySoc;

  static const int byteLength = 61;

  static BleTelemetry fromBytes(List<int> bytes) {
    if (bytes.length < byteLength) {
      throw FormatException('BleTelemetry payload requires $byteLength bytes');
    }
    final v = readFloat32LittleEndian(bytes, 15);
    return BleTelemetry(
      gyroX: v[0],
      gyroY: v[1],
      gyroZ: v[2],
      accelX: v[3],
      accelY: v[4],
      accelZ: v[5],
      pitch: v[6],
      roll: v[7],
      yaw: v[8],
      magX: v[9],
      magY: v[10],
      magZ: v[11],
      motor1: v[12],
      motor2: v[13],
      batteryVol: v[14],
      batterySoc: bytes[60],
    );
  }
}
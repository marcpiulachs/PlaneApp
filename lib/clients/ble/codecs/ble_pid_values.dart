import 'package:paperwings/clients/ble/codecs/ble_codec_bytes.dart';

/// Payload de la característica `pidValues` (9 f32 LE: KP/KI/KD por eje).
class BlePidValues {
  const BlePidValues({
    required this.kpPitch,
    required this.kiPitch,
    required this.kdPitch,
    required this.kpRoll,
    required this.kiRoll,
    required this.kdRoll,
    required this.kpYaw,
    required this.kiYaw,
    required this.kdYaw,
  });

  final double kpPitch;
  final double kiPitch;
  final double kdPitch;
  final double kpRoll;
  final double kiRoll;
  final double kdRoll;
  final double kpYaw;
  final double kiYaw;
  final double kdYaw;

  List<double> toList() => [
        kpPitch, kiPitch, kdPitch,
        kpRoll, kiRoll, kdRoll,
        kpYaw, kiYaw, kdYaw,
      ];

  static BlePidValues fromBytes(List<int> bytes) {
    final v = readFloat32LittleEndian(bytes, 9);
    return BlePidValues(
      kpPitch: v[0], kiPitch: v[1], kdPitch: v[2],
      kpRoll: v[3], kiRoll: v[4], kdRoll: v[5],
      kpYaw: v[6], kiYaw: v[7], kdYaw: v[8],
    );
  }
}

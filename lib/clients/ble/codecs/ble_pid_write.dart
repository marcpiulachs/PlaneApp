import 'package:paperwings/clients/ble/codecs/ble_codec_bytes.dart';

/// Eje del PID de la característica `pidWrite`.
enum BlePidAxis {
  pitch(0),
  roll(1),
  yaw(2);

  const BlePidAxis(this.value);

  final int value;
}

/// Término del PID de la característica `pidWrite`.
enum BlePidTerm {
  kp(0),
  ki(1),
  kd(2);

  const BlePidTerm(this.value);

  final int value;
}

/// Payload de la característica `pidWrite` (6 bytes: axis, term, f32 LE).
class BlePidWrite {
  BlePidWrite({required this.axis, required this.term, required this.value});

  final BlePidAxis axis;
  final BlePidTerm term;
  final double value;

  List<int> toBytes() => [
        axis.value,
        term.value,
        ...writeFloat32LittleEndian(value),
      ];
}

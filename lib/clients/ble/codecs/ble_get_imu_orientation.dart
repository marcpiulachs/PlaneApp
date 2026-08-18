import 'package:paperwings/clients/ble/codecs/ble_codec_bytes.dart';

/// Payload de la característica `getImuOrientation` (trigger sin parámetros).
class BleGetImuOrientation {
  List<int> toBytes() => [bleTriggerByte];
}

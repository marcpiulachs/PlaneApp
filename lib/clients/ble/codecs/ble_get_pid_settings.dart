import 'package:paperwings/clients/ble/codecs/ble_codec_bytes.dart';

/// Payload de la característica `getPidSettings` (trigger sin parámetros).
class BleGetPidSettings {
  List<int> toBytes() => [bleTriggerByte];
}

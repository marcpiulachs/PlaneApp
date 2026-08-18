import 'package:paperwings/clients/ble/codecs/ble_codec_bytes.dart';

/// Payload de la característica `shutdown` (trigger sin parámetros).
class BleShutdown {
  List<int> toBytes() => [bleTriggerByte];
}

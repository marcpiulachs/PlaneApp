import 'package:paperwings/clients/ble/codecs/ble_sensor_orientation.dart';

/// Payload de la característica `imuOrientation` (1 byte).
class BleImuOrientation {
  const BleImuOrientation(this.orientation);

  final BleSensorOrientation orientation;

  static BleImuOrientation fromBytes(List<int> bytes) {
    if (bytes.isEmpty) {
      throw const FormatException('BleImuOrientation payload is empty');
    }
    return BleImuOrientation(BleSensorOrientation.fromValue(bytes[0]));
  }
}

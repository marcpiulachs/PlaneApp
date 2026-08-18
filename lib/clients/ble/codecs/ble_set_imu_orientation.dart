import 'package:paperwings/clients/ble/codecs/ble_sensor_orientation.dart';

/// Payload de la característica `setImuOrientation` (1 byte).
class BleSetImuOrientation {
  BleSetImuOrientation(this.orientation);

  final BleSensorOrientation orientation;

  List<int> toBytes() => [orientation.value];
}

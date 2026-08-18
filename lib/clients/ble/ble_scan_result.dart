import 'package:paperwings/clients/ble/ble_device_handle.dart';

class BleScanResult {
  const BleScanResult({
    required this.device,
    required this.advertisedName,
    required this.serviceUuids,
    required this.rssi,
  });

  final BleDeviceHandle device;
  final String advertisedName;
  final List<String> serviceUuids;
  final int rssi;
}

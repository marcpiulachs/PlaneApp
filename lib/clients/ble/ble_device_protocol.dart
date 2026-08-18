import 'package:paperwings/clients/ble/ble_char_id.dart';
import 'package:paperwings/clients/ble/ble_scan_result.dart';

/// Contrato de un perfil GATT de un dispositivo BLE, siguiendo el estilo de
/// SlotBridgeApp: el protocolo define el servicio, las características y
/// cómo reconocer el dispositivo al escanear.
abstract class BleDeviceProtocol {
  String get namePrefix;
  String get serviceUuid;
  String get label;
  Map<BleCharId, String> get characteristicUuids;
  List<BleCharId> get notifyCharacteristics;

  bool matches(BleScanResult result) {
    if (result.device.name.startsWith(namePrefix)) return true;
    if (result.advertisedName.startsWith(namePrefix)) return true;
    return result.serviceUuids.any(
      (uuid) => uuid.toLowerCase() == serviceUuid,
    );
  }
}

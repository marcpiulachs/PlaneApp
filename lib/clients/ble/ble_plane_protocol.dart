import 'package:paperwings/clients/ble/ble_char_id.dart';
import 'package:paperwings/clients/ble/ble_device_protocol.dart';

/// Perfil BLE del avión: servicio propio "PaperWings" con características
/// semánticas (una por comando y una por grupo de telemetría), al estilo de
/// SlotBridgeFirmware. Los UUIDs comparten la base
/// `6E40E0FF-0FFE-4001-8000-0000000000XX` y varían el último byte.
class BlePlaneProtocol extends BleDeviceProtocol {
  @override
  final namePrefix = 'PaperWings';

  @override
  final serviceUuid = '6e40e0ff-0ffe-4001-8000-000000000000';

  @override
  final label = 'Plane';

  @override
  Map<BleCharId, String> get characteristicUuids => {
        // Comandos (WRITE)
        BleCharId.arm: '6e40e0ff-0ffe-4001-8000-000000000001',
        BleCharId.throttle: '6e40e0ff-0ffe-4001-8000-000000000002',
        BleCharId.yoke: '6e40e0ff-0ffe-4001-8000-000000000003',
        BleCharId.maneuver: '6e40e0ff-0ffe-4001-8000-000000000004',
        BleCharId.logControl: '6e40e0ff-0ffe-4001-8000-000000000005',
        BleCharId.calibrate: '6e40e0ff-0ffe-4001-8000-000000000006',
        BleCharId.shutdown: '6e40e0ff-0ffe-4001-8000-000000000007',
        BleCharId.beacon: '6e40e0ff-0ffe-4001-8000-000000000008',
        BleCharId.pidWrite: '6e40e0ff-0ffe-4001-8000-000000000009',
        BleCharId.setImuOrientation: '6e40e0ff-0ffe-4001-8000-00000000000a',
        BleCharId.getPidSettings: '6e40e0ff-0ffe-4001-8000-00000000000b',
        BleCharId.getImuOrientation: '6e40e0ff-0ffe-4001-8000-00000000000c',

        // Telemetría (NOTIFY + READ)
        BleCharId.telemetry: '6e40e0ff-0ffe-4001-8000-00000000000d',
        BleCharId.pidValues: '6e40e0ff-0ffe-4001-8000-00000000000e',
        BleCharId.imuOrientation: '6e40e0ff-0ffe-4001-8000-00000000000f',
      };

  @override
  List<BleCharId> get notifyCharacteristics => [
        BleCharId.telemetry,
        BleCharId.pidValues,
        BleCharId.imuOrientation,
      ];
}

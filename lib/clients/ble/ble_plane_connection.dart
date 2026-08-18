import 'dart:async';
import 'dart:developer' as developer;

import 'package:flutter_blue_plus/flutter_blue_plus.dart';

import 'package:paperwings/clients/ble/ble_char_id.dart';
import 'package:paperwings/clients/ble/ble_device_protocol.dart';
import 'package:paperwings/clients/ble/ble_missing_characteristic_exception.dart';
import 'package:paperwings/clients/ble/codecs/ble_arm.dart';
import 'package:paperwings/clients/ble/codecs/ble_beacon.dart';
import 'package:paperwings/clients/ble/codecs/ble_calibrate.dart';
import 'package:paperwings/clients/ble/codecs/ble_get_imu_orientation.dart';
import 'package:paperwings/clients/ble/codecs/ble_get_pid_settings.dart';
import 'package:paperwings/clients/ble/codecs/ble_imu_orientation.dart';
import 'package:paperwings/clients/ble/codecs/ble_log_control.dart';
import 'package:paperwings/clients/ble/codecs/ble_maneuver.dart';
import 'package:paperwings/clients/ble/codecs/ble_pid_values.dart';
import 'package:paperwings/clients/ble/codecs/ble_pid_write.dart';
import 'package:paperwings/clients/ble/codecs/ble_sensor_orientation.dart';
import 'package:paperwings/clients/ble/codecs/ble_set_imu_orientation.dart';
import 'package:paperwings/clients/ble/codecs/ble_shutdown.dart';
import 'package:paperwings/clients/ble/codecs/ble_telemetry.dart';
import 'package:paperwings/clients/ble/codecs/ble_throttle.dart';
import 'package:paperwings/clients/ble/codecs/ble_yoke.dart';
import 'package:paperwings/enum/bacon_pattern.dart';
import 'package:paperwings/enum/maneuver_type.dart';

void _log(String msg) => developer.log(msg, name: 'Plane.BLE');

/// Conexión a un dispositivo BLE: conecta, descubre el servicio y las
/// características, activa notificaciones y expone lectura/escritura.
/// Sigue el estilo de `BleDeviceConnection` de SlotBridgeApp.
class BlePlaneConnection {
  BlePlaneConnection._(this.device, this._protocol, this._chars);

  final BluetoothDevice device;
  final BleDeviceProtocol _protocol;
  final Map<BleCharId, BluetoothCharacteristic> _chars;

  final _notifyControllers = <BleCharId, StreamController<List<int>>>{};
  final _notifySubs = <BleCharId, StreamSubscription<List<int>>>{};
  StreamSubscription<BluetoothConnectionState>? _stateSub;

  String get deviceId => device.remoteId.str;
  BleDeviceProtocol get protocol => _protocol;

  static Future<BlePlaneConnection> connect(
    BluetoothDevice device, {
    required BleDeviceProtocol protocol,
    required void Function(String deviceId) onDisconnect,
  }) async {
    _log('[${device.remoteId.str}] connecting…');
    await device.connect(
        license: License.nonprofit,
        timeout: const Duration(seconds: 10),
        mtu: 247);
    await device.requestMtu(247);

    // Android-only: conexión de alta prioridad (connection interval ~7.5-15ms)
    // para que las notificaciones de telemetría lleguen a la misma frecuencia
    // que los paquetes TCP (20 Hz). Sin esto, el sistema usa 30-50ms por
    // defecto y el tick del firmware cae entre connection events.
    try {
      await device.requestConnectionPriority(
          connectionPriorityRequest: ConnectionPriority.high);
    } catch (e) {
      _log('[${device.remoteId.str}] connection priority not supported: $e');
    }

    try {
      await device.clearGattCache();
    } catch (e) {
      _log('[${device.remoteId.str}] failed to clear GATT cache: $e');
    }
    await device.discoverServices();

    final chars = <BleCharId, BluetoothCharacteristic>{};
    final services = device.servicesList;
    final main = services.firstWhere(
      (s) => s.uuid.str128.toLowerCase() == protocol.serviceUuid,
      orElse: () => throw BleMissingCharacteristicException(
          'Service ${protocol.serviceUuid} not found'),
    );

    for (final entry in protocol.characteristicUuids.entries) {
      try {
        final char = main.characteristics.firstWhere(
          (c) => c.uuid.str128.toLowerCase() == entry.value,
          orElse: () => throw BleMissingCharacteristicException(
              'Char ${entry.value} not found'),
        );
        chars[entry.key] = char;
      } catch (e) {
        _log('[${device.remoteId.str}] characteristic ${entry.key} not found');
      }
    }

    final conn = BlePlaneConnection._(device, protocol, chars);
    conn._setupNotifications(onDisconnect);
    await conn._enableNotify();
    return conn;
  }

  Future<void> _enableNotify() async {
    for (final id in _protocol.notifyCharacteristics) {
      final char = _chars[id];
      if (char != null) {
        await char.setNotifyValue(true);
      }
    }
  }

  Future<void> writeChar(
    BleCharId id,
    List<int> data, {
    bool withoutResponse = false,
  }) async {
    final char = _chars[id];
    if (char == null) throw BleMissingCharacteristicException('$id');
    await char.write(data, withoutResponse: withoutResponse, timeout: 4);
  }

  Stream<List<int>> notify(BleCharId id) {
    return _notifyControllers
        .putIfAbsent(
          id,
          () => StreamController<List<int>>.broadcast(),
        )
        .stream;
  }

  // ── Comandos tipados (traducen el dominio a bytes vía codecs) ──────────

  Future<void> _write(BleCharId id, List<int> data,
          {bool withoutResponse = false}) =>
      writeChar(id, data, withoutResponse: withoutResponse);

  // Comandos de alta frecuencia (control continuo): write-without-response
  // para no esperar el round-trip ATT de cada cambio. El firmware ya acepta
  // ambos tipos (flags WRITE | WRITE_NO_RSP) en el mismo callback.
  Future<void> writeThrottle(int percent) =>
      _write(BleCharId.throttle, BleThrottle(percent).toBytes(),
          withoutResponse: true);

  Future<void> writeYoke(int value) =>
      _write(BleCharId.yoke, BleYoke(value).toBytes(),
          withoutResponse: true);

  // Comandos discretos (eventos, no control continuo): write con respuesta
  // para garantizar la entrega.
  Future<void> writeArmed(bool armed) =>
      _write(BleCharId.arm, BleArm(armed).toBytes());

  Future<void> writeManeuver(ManeuverType maneuver) =>
      _write(BleCharId.maneuver, BleManeuver(maneuver).toBytes());

  Future<void> writeLogControl(BleLogControl control) =>
      _write(BleCharId.logControl, control.toBytes());

  Future<void> writeCalibrate(BleCalibrationTarget target) =>
      _write(BleCharId.calibrate, BleCalibrate(target).toBytes());

  Future<void> writeShutdown() =>
      _write(BleCharId.shutdown, BleShutdown().toBytes());

  Future<void> writeBeacon(BaconPattern pattern) =>
      _write(BleCharId.beacon, BleBeacon(pattern).toBytes());

  Future<void> writePid(BlePidAxis axis, BlePidTerm term, double value) =>
      _write(BleCharId.pidWrite,
          BlePidWrite(axis: axis, term: term, value: value).toBytes());

  Future<void> writeImuOrientation(BleSensorOrientation orientation) =>
      _write(BleCharId.setImuOrientation,
          BleSetImuOrientation(orientation).toBytes());

  Future<void> writeGetPidSettings() =>
      _write(BleCharId.getPidSettings, BleGetPidSettings().toBytes());

  Future<void> writeGetImuOrientation() =>
      _write(BleCharId.getImuOrientation, BleGetImuOrientation().toBytes());

  // ── Telemetría tipada (decodifica bytes vía codecs) ────────────────────

  Stream<BleTelemetry> get telemetry =>
      notify(BleCharId.telemetry).map(BleTelemetry.fromBytes);

  Stream<BlePidValues> get pidValues =>
      notify(BleCharId.pidValues).map(BlePidValues.fromBytes);

  Stream<BleImuOrientation> get imuOrientation =>
      notify(BleCharId.imuOrientation).map(BleImuOrientation.fromBytes);

  void _setupNotifications(void Function(String) onDisconnect) {
    for (final id in _protocol.notifyCharacteristics) {
      if (_notifySubs.containsKey(id)) continue;
      final char = _chars[id];
      if (char == null) continue;

      final sub = char.onValueReceived.listen(
        (bytes) {
          // ignore: close_sinks
          final controller = _notifyControllers[id];
          if (controller != null && !controller.isClosed) {
            controller.add(bytes);
          }
        },
        onError: (Object e) => _log('[$deviceId] notify $id error: $e'),
      );
      _notifySubs[id] = sub;
    }

    _stateSub = device.connectionState.skip(1).listen(
      (state) {
        _log('[$deviceId] connectionState=$state');
        if (state == BluetoothConnectionState.disconnected) {
          _stateSub?.cancel();
          _stateSub = null;
          onDisconnect(deviceId);
        }
      },
      onError: (Object e) => _log('[$deviceId] connectionState error: $e'),
    );
  }

  Future<void> dispose() async {
    for (final char in _chars.values) {
      try {
        await char.setNotifyValue(false).timeout(const Duration(seconds: 2));
      } catch (e) {
        _log('[$deviceId] failed to disable notify: $e');
      }
    }

    for (final sub in _notifySubs.values) {
      await sub.cancel();
    }
    await _stateSub?.cancel();

    try {
      await device.disconnect(timeout: 4000);
    } catch (e) {
      _log('[$deviceId] error disconnecting device: $e');
    }

    for (final controller in _notifyControllers.values) {
      if (!controller.isClosed) {
        await controller.close();
      }
    }
    _log('[$deviceId] disposed');
  }
}

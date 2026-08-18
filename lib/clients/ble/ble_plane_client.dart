import 'dart:async';
import 'dart:developer' as developer;

import 'package:flutter_blue_plus/flutter_blue_plus.dart';

import 'package:paperwings/clients/ble/ble_char_id.dart';
import 'package:paperwings/clients/ble/ble_device_protocol.dart';
import 'package:paperwings/clients/ble/ble_device_handle.dart';
import 'package:paperwings/clients/ble/ble_plane_connection.dart';
import 'package:paperwings/clients/ble/ble_plane_protocol.dart';
import 'package:paperwings/clients/ble/ble_scan_result.dart';
import 'package:paperwings/clients/ble/codecs/ble_calibrate.dart';
import 'package:paperwings/clients/ble/codecs/ble_imu_orientation.dart';
import 'package:paperwings/clients/ble/codecs/ble_log_control.dart';
import 'package:paperwings/clients/ble/codecs/ble_pid_values.dart';
import 'package:paperwings/clients/ble/codecs/ble_pid_write.dart';
import 'package:paperwings/clients/ble/codecs/ble_sensor_orientation.dart';
import 'package:paperwings/clients/ble/codecs/ble_telemetry.dart';
import 'package:paperwings/enum/bacon_pattern.dart';
import 'package:paperwings/enum/maneuver_type.dart';
import 'package:paperwings/clients/plane_client_interface.dart';
import 'package:paperwings/models/telemetry.dart';

/// Cliente del avión sobre Bluetooth Low Energy.
///
/// El avión expone un servicio GATT propio con características semánticas
/// (una por comando y una por grupo de telemetría), al estilo de
/// SlotBridgeApp. Este cliente oculta ese perfil tras la interfaz común
/// [IPlaneClient]: cada llamada escribe en la característica correspondiente y
/// cada notificación de telemetría se traduce al modelo [Telemetry].
class BlePlaneClient implements IPlaneClient {
  BlePlaneClient({
    BleDeviceProtocol? protocol,
    Duration? connectTimeout,
  })  : _protocol = protocol ?? BlePlaneProtocol(),
        _connectTimeout = connectTimeout ?? const Duration(seconds: 10);

  final BleDeviceProtocol _protocol;
  final Duration _connectTimeout;

  // Controladores de estado y eventos
  final _connectedStreamController = StreamController<bool>.broadcast();
  final _onConnectStreamController = StreamController.broadcast();
  final _onDisconnectStreamController = StreamController.broadcast();
  final _onConnectionFailedStreamController = StreamController.broadcast();

  // Controlador del stream de telemetría
  final _telemetryController = StreamController<Telemetry>.broadcast();

  BlePlaneConnection? _connection;
  final _notifySubs = <BleCharId, StreamSubscription<dynamic>>{};
  bool _isConnected = false;
  Telemetry _latestTelemetry = Telemetry();

  // Estado del bitmask de control de log (una característica, cuatro flags)
  int _logControlMask = 0;

  // Contadores para estadísticas
  @override
  int packetsOk = 0;
  @override
  int packetsWithError = 0;

  @override
  Stream<void> get onConnect => _onConnectStreamController.stream;
  @override
  Stream<void> get onDisconnect => _onDisconnectStreamController.stream;
  @override
  Stream<void> get onConnectionFailed =>
      _onConnectionFailedStreamController.stream;

  @override
  Stream<Telemetry> get telemetryStream => _telemetryController.stream;

  @override
  Stream<bool> get connectedStream => _connectedStreamController.stream;

  @override
  bool get isConnected => _isConnected;

  @override
  Future<void> connect() async {
    try {
      final handle = await _discoverDevice();
      developer.log('Connecting to ${handle.name} (${handle.deviceId})…');

      _connection = await BlePlaneConnection.connect(
        BluetoothDevice.fromId(handle.deviceId),
        protocol: _protocol,
        onDisconnect: _handleDisconnection,
      );

      _subscribeToTelemetry();

      setConnected(true);
      _onConnectStreamController.add(null);
    } catch (e) {
      developer.log('Error connecting over BLE: $e');
      setConnected(false);
      _onConnectionFailedStreamController.add(null);
    }
  }

  /// Escanea hasta encontrar un dispositivo que coincida con el protocolo.
  Future<BleDeviceHandle> _discoverDevice() async {
    final completer = Completer<BleDeviceHandle>();
    StreamSubscription<List<ScanResult>>? sub;

    void completeIfPending(ScanResult result) {
      if (completer.isCompleted) return;
      final scan = _toScanResult(result);
      if (_protocol.matches(scan)) {
        developer.log('Found plane: ${scan.device.name} '
            '(${scan.device.deviceId})');
        completer.complete(scan.device);
      }
    }

    try {
      sub = FlutterBluePlus.scanResults.listen((results) {
        for (final result in results) {
          completeIfPending(result);
        }
      });
      await FlutterBluePlus.startScan(timeout: _connectTimeout);
      await completer.future.timeout(_connectTimeout);
      return await completer.future;
    } on TimeoutException {
      throw StateError(
          'No ${_protocol.namePrefix} device found within $_connectTimeout');
    } finally {
      await sub?.cancel();
      if (FlutterBluePlus.isScanningNow) {
        await FlutterBluePlus.stopScan();
      }
    }
  }

  static BleScanResult _toScanResult(ScanResult result) => BleScanResult(
        device: BleDeviceHandle(
          deviceId: result.device.remoteId.str,
          name: result.device.platformName,
        ),
        advertisedName: result.advertisementData.advName,
        serviceUuids: result.advertisementData.serviceUuids
            .map((uuid) => uuid.str128)
            .toList(growable: false),
        rssi: result.rssi,
      );

  // ── Telemetría (una suscripción por característica tipada) ─────────────

  void _subscribeToTelemetry() {
    final conn = _connection!;
    void listen<T>(BleCharId id, Stream<T> stream, void Function(T) onData) {
      _notifySubs[id] =
          stream.listen(onData, onError: _logNotifyError(id));
    }

    listen(BleCharId.telemetry, conn.telemetry, (BleTelemetry t) {
      _updateTelemetry((prev) => prev.copyWith(
            gyroX: t.gyroX,
            gyroY: t.gyroY,
            gyroZ: t.gyroZ,
            accelX: t.accelX,
            accelY: t.accelY,
            accelZ: t.accelZ,
            pitch: t.pitch,
            roll: t.roll,
            yaw: t.yaw,
            magX: t.magX,
            magY: t.magY,
            magZ: t.magZ,
            motor1Speed: t.motor1,
            motor2Speed: t.motor2,
            batteryVol: t.batteryVol,
            batterySoc: t.batterySoc.toDouble(),
          ));
    });
    listen(BleCharId.pidValues, conn.pidValues, (BlePidValues p) {
      // Respuesta a GET_PID_SETTINGS. La app aún no muestra estos valores; se
      // registran para depuración.
      developer.log('BLE pidValues: ${p.toList()}');
    });
    listen(BleCharId.imuOrientation, conn.imuOrientation, (BleImuOrientation o) {
      developer.log('BLE imuOrientation: ${o.orientation}');
    });
  }

  void Function(Object) _logNotifyError(BleCharId id) => (Object e) =>
      developer.log('BLE notify $id error: $e');

  void _updateTelemetry(Telemetry Function(Telemetry) apply) {
    _emit(apply(_latestTelemetry));
  }

  void _emit(Telemetry next) {
    _latestTelemetry = next;
    packetsOk++;
    _telemetryController.add(_latestTelemetry);
  }

  void _handleDisconnection(String deviceId) {
    developer.log('BLE device $deviceId disconnected');
    _connection = null;
    setConnected(false);
    _onDisconnectStreamController.add(null);
  }

  @override
  Future<void> disconnect() async {
    final conn = _connection;
    _connection = null;
    for (final sub in _notifySubs.values) {
      await sub.cancel();
    }
    _notifySubs.clear();
    if (conn != null) {
      await conn.dispose();
    }
    setConnected(false);
    _onDisconnectStreamController.add(null);
  }

  // ── Funciones remotas (comandos tipados) ────────────────────────────────

  Future<void> _send(Future<void> Function(BlePlaneConnection connection) action) async {
    final conn = _connection;
    if (conn == null) {
      developer.log('Not connected over BLE');
      return;
    }
    try {
      await action(conn);
    } catch (e) {
      developer.log('Error over BLE: $e');
    }
  }

  @override
  Future<void> sendArmed(bool armed) async => _send((c) => c.writeArmed(armed));

  @override
  Future<void> sendThrottle(int throttle) async =>
      _send((c) => c.writeThrottle(throttle));

  @override
  Future<void> sendYoke(int yoke) async => _send((c) => c.writeYoke(yoke));

  @override
  Future<void> sendManeuver(int maneuver) async {
    final type = ManeuverType.values.firstWhere(
      (e) => e.value == maneuver,
      orElse: () => throw ArgumentError('Unknown ManeuverType: $maneuver'),
    );
    await _send((c) => c.writeManeuver(type));
  }

  @override
  Future<void> sendBeacon(int beacon) async {
    final pattern = BaconPattern.values.firstWhere(
      (e) => e.value == beacon,
      orElse: () => throw ArgumentError('Unknown BaconPattern: $beacon'),
    );
    await _send((c) => c.writeBeacon(pattern));
  }

  @override
  Future<void> sendImuOrientation(int orientation) async {
    final sensorOrientation = BleSensorOrientation.values.firstWhere(
      (e) => e.value == orientation,
      orElse: () =>
          throw ArgumentError('Unknown BleSensorOrientation: $orientation'),
    );
    await _send((c) => c.writeImuOrientation(sensorOrientation));
  }

  @override
  Future<void> sendShutdown() async => _send((c) => c.writeShutdown());

  @override
  Future<void> sendCalibrateIMU() async =>
      _send((c) => c.writeCalibrate(BleCalibrationTarget.imu));

  @override
  Future<void> sendCalibrateMAG() async =>
      _send((c) => c.writeCalibrate(BleCalibrationTarget.magnetometer));

  @override
  Future<void> sendGetPIDSettings() async =>
      _send((c) => c.writeGetPidSettings());

  // PID Settings - Pitch
  @override
  Future<void> sendPitchKp(double value) async =>
      _send((c) => c.writePid(BlePidAxis.pitch, BlePidTerm.kp, value));

  @override
  Future<void> sendPitchKi(double value) async =>
      _send((c) => c.writePid(BlePidAxis.pitch, BlePidTerm.ki, value));

  @override
  Future<void> sendPitchKd(double value) async =>
      _send((c) => c.writePid(BlePidAxis.pitch, BlePidTerm.kd, value));

  // PID Settings - Roll
  @override
  Future<void> sendRollKp(double value) async =>
      _send((c) => c.writePid(BlePidAxis.roll, BlePidTerm.kp, value));

  @override
  Future<void> sendRollKi(double value) async =>
      _send((c) => c.writePid(BlePidAxis.roll, BlePidTerm.ki, value));

  @override
  Future<void> sendRollKd(double value) async =>
      _send((c) => c.writePid(BlePidAxis.roll, BlePidTerm.kd, value));

  // PID Settings - Yaw
  @override
  Future<void> sendYawKp(double value) async =>
      _send((c) => c.writePid(BlePidAxis.yaw, BlePidTerm.kp, value));

  @override
  Future<void> sendYawKi(double value) async =>
      _send((c) => c.writePid(BlePidAxis.yaw, BlePidTerm.ki, value));

  @override
  Future<void> sendYawKd(double value) async =>
      _send((c) => c.writePid(BlePidAxis.yaw, BlePidTerm.kd, value));

  // KP/KI/KD (0x96-0x98): no tienen característica propia en BLE (el firmware
  // los ignora también por TCP).
  @override
  Future<void> sendKP(double value) async =>
      developer.log('sendKP not supported over BLE');

  @override
  Future<void> sendKI(double value) async =>
      developer.log('sendKI not supported over BLE');

  @override
  Future<void> sendKD(double value) async =>
      developer.log('sendKD not supported over BLE');

  // Logging (un bitmask en una única característica)
  Future<void> _setLogFlag(BleLogFlag flag, bool enabled) async {
    if (enabled) {
      _logControlMask |= (1 << flag.bit);
    } else {
      _logControlMask &= ~(1 << flag.bit);
    }
    await _send((c) => c.writeLogControl(BleLogControl.fromMask(_logControlMask)));
  }

  @override
  Future<void> sendLogIMU(bool enabled) async =>
      _setLogFlag(BleLogFlag.imu, enabled);

  @override
  Future<void> sendLogThrust(bool enabled) async =>
      _setLogFlag(BleLogFlag.thrust, enabled);

  @override
  Future<void> sendLogBattery(bool enabled) async =>
      _setLogFlag(BleLogFlag.battery, enabled);

  @override
  Future<void> sendLogMotor(bool enabled) async =>
      _setLogFlag(BleLogFlag.motor, enabled);

  // Método para actualizar la propiedad y emitir el cambio
  void setConnected(bool value) {
    if (_isConnected != value) {
      _isConnected = value;
      if (!_connectedStreamController.isClosed) {
        _connectedStreamController.add(value);
      }
    }
  }

  // Método de limpieza para cerrar los StreamController cuando no se use
  void dispose() {
    _connectedStreamController.close();
    _telemetryController.close();
    _onConnectStreamController.close();
    _onDisconnectStreamController.close();
    _onConnectionFailedStreamController.close();
  }
}

import 'dart:async';

import 'package:paperwings/clients/ble/ble_plane_client.dart';
import 'package:paperwings/clients/mock_plane_client.dart';
import 'package:paperwings/clients/plane_client_interface.dart';
import 'package:paperwings/clients/plane_transport.dart';
import 'package:paperwings/clients/tcp_plane_client.dart';
import 'package:paperwings/models/telemetry.dart';

/// Gestiona el cliente de conexión activo.
///
/// Implementa [IPlaneClient] delegando todas las operaciones al cliente del
/// transporte activo. Expone streams propios y estables (telemetría y estado
/// de conexión) a los que los Blocs se suscriben una sola vez, y re-enruta
/// los eventos del cliente activo hacia ellos. La pantalla de conexión llama
/// a [use] para crear (o reutilizar) el cliente correspondiente según la
/// selección del usuario.
class ClientManager implements IPlaneClient {
  ClientManager({PlaneTransport? initialTransport})
      : _transport = initialTransport ?? PlaneTransport.wifi {
    _active = _clientFor(_transport);
    _attach(_active!);
  }

  PlaneTransport _transport;
  IPlaneClient? _active;

  // Streams propios (estables) a los que se suscriben los Blocs una sola vez.
  final _connectedStreamController = StreamController<bool>.broadcast();
  final _onConnectStreamController = StreamController.broadcast();
  final _onDisconnectStreamController = StreamController.broadcast();
  final _onConnectionFailedStreamController = StreamController.broadcast();
  final _telemetryController = StreamController<Telemetry>.broadcast();

  StreamSubscription<bool>? _connectedSub;
  StreamSubscription<void>? _onConnectSub;
  StreamSubscription<void>? _onDisconnectSub;
  StreamSubscription<void>? _onConnectionFailedSub;
  StreamSubscription<Telemetry>? _telemetrySub;

  PlaneTransport get transport => _transport;

  IPlaneClient _clientFor(PlaneTransport transport) {
    switch (transport) {
      case PlaneTransport.wifi:
        return TcpPlaneClient();
      case PlaneTransport.ble:
        return BlePlaneClient();
      case PlaneTransport.mock:
        return MockPlaneClient();
    }
  }

  /// Activa un transporte. Si ya está activo no hace nada; si se cambia,
  /// desconecta el cliente anterior y crea el del transporte seleccionado.
  Future<void> use(PlaneTransport transport) async {
    if (transport == _transport) return;
    _detach();
    final previous = _active;
    _active = null;
    if (previous != null) {
      try {
        await previous.disconnect();
      } catch (_) {}
    }
    _transport = transport;
    _active = _clientFor(transport);
    _attach(_active!);
  }

  void _detach() {
    _connectedSub?.cancel();
    _onConnectSub?.cancel();
    _onDisconnectSub?.cancel();
    _onConnectionFailedSub?.cancel();
    _telemetrySub?.cancel();
    _connectedSub = null;
    _onConnectSub = null;
    _onDisconnectSub = null;
    _onConnectionFailedSub = null;
    _telemetrySub = null;
  }

  void _attach(IPlaneClient client) {
    _connectedSub = client.connectedStream.listen((value) {
      if (!_connectedStreamController.isClosed) {
        _connectedStreamController.add(value);
      }
    });
    _onConnectSub = client.onConnect.listen((_) {
      if (!_onConnectStreamController.isClosed) {
        _onConnectStreamController.add(null);
      }
    });
    _onDisconnectSub = client.onDisconnect.listen((_) {
      if (!_onDisconnectStreamController.isClosed) {
        _onDisconnectStreamController.add(null);
      }
    });
    _onConnectionFailedSub = client.onConnectionFailed.listen((_) {
      if (!_onConnectionFailedStreamController.isClosed) {
        _onConnectionFailedStreamController.add(null);
      }
    });
    _telemetrySub = client.telemetryStream.listen((telemetry) {
      if (!_telemetryController.isClosed) {
        _telemetryController.add(telemetry);
      }
    });
  }

  // ── Getters delegados ────────────────────────────────────────────────

  @override
  bool get isConnected => _active?.isConnected ?? false;

  @override
  int get packetsOk => _active?.packetsOk ?? 0;

  @override
  int get packetsWithError => _active?.packetsWithError ?? 0;

  @override
  Stream<Telemetry> get telemetryStream => _telemetryController.stream;

  @override
  Stream<bool> get connectedStream => _connectedStreamController.stream;

  @override
  Stream<void> get onConnect => _onConnectStreamController.stream;

  @override
  Stream<void> get onDisconnect => _onDisconnectStreamController.stream;

  @override
  Stream<void> get onConnectionFailed =>
      _onConnectionFailedStreamController.stream;

  // ── Operaciones delegadas ─────────────────────────────────────────────

  @override
  Future<void> connect() async {
    final active = _active;
    if (active != null) {
      await active.connect();
    }
  }

  @override
  Future<void> disconnect() async {
    final active = _active;
    if (active != null) {
      await active.disconnect();
    }
  }

  Future<void> _send(Future<void> Function(IPlaneClient client) action) async {
    final active = _active;
    if (active != null) {
      await action(active);
    }
  }

  @override
  Future<void> sendArmed(bool armed) => _send((c) => c.sendArmed(armed));

  @override
  Future<void> sendThrottle(int throttle) =>
      _send((c) => c.sendThrottle(throttle));

  @override
  Future<void> sendYoke(int yoke) => _send((c) => c.sendYoke(yoke));

  @override
  Future<void> sendManeuver(int maneuver) =>
      _send((c) => c.sendManeuver(maneuver));

  @override
  Future<void> sendBeacon(int beacon) => _send((c) => c.sendBeacon(beacon));

  @override
  Future<void> sendImuOrientation(int orientation) =>
      _send((c) => c.sendImuOrientation(orientation));

  @override
  Future<void> sendShutdown() => _send((c) => c.sendShutdown());

  @override
  Future<void> sendKD(double value) => _send((c) => c.sendKD(value));

  @override
  Future<void> sendKP(double value) => _send((c) => c.sendKP(value));

  @override
  Future<void> sendKI(double value) => _send((c) => c.sendKI(value));

  @override
  Future<void> sendCalibrateIMU() => _send((c) => c.sendCalibrateIMU());

  @override
  Future<void> sendCalibrateMAG() => _send((c) => c.sendCalibrateMAG());

  // PID Settings - Pitch
  @override
  Future<void> sendPitchKp(double value) => _send((c) => c.sendPitchKp(value));

  @override
  Future<void> sendPitchKi(double value) => _send((c) => c.sendPitchKi(value));

  @override
  Future<void> sendPitchKd(double value) => _send((c) => c.sendPitchKd(value));

  // PID Settings - Roll
  @override
  Future<void> sendRollKp(double value) => _send((c) => c.sendRollKp(value));

  @override
  Future<void> sendRollKi(double value) => _send((c) => c.sendRollKi(value));

  @override
  Future<void> sendRollKd(double value) => _send((c) => c.sendRollKd(value));

  // PID Settings - Yaw
  @override
  Future<void> sendYawKp(double value) => _send((c) => c.sendYawKp(value));

  @override
  Future<void> sendYawKi(double value) => _send((c) => c.sendYawKi(value));

  @override
  Future<void> sendYawKd(double value) => _send((c) => c.sendYawKd(value));

  // Get PID Settings
  @override
  Future<void> sendGetPIDSettings() => _send((c) => c.sendGetPIDSettings());

  // Logging Settings
  @override
  Future<void> sendLogIMU(bool enabled) => _send((c) => c.sendLogIMU(enabled));

  @override
  Future<void> sendLogThrust(bool enabled) =>
      _send((c) => c.sendLogThrust(enabled));

  @override
  Future<void> sendLogBattery(bool enabled) =>
      _send((c) => c.sendLogBattery(enabled));

  @override
  Future<void> sendLogMotor(bool enabled) => _send((c) => c.sendLogMotor(enabled));

  /// Cierra los streams propios y desenchufa el cliente activo.
  void dispose() {
    _detach();
    _connectedStreamController.close();
    _telemetryController.close();
    _onConnectStreamController.close();
    _onDisconnectStreamController.close();
    _onConnectionFailedStreamController.close();
  }
}
import 'dart:async';
import 'dart:developer' as developer;
import 'dart:math';

import 'package:paperwings/models/telemetry.dart';
import 'plane_client_interface.dart';

class MockPlaneClient implements IPlaneClient {
  bool _isConnected = false;
  Timer? _timer;
  bool _armed = false;
  int _throttle = 0;

  int beacon = 0;

  double kp = 0, ki = 0, kd = 0;

  final Random _rng = Random(42);

  // Estado de la simulación de vuelo
  double _m1 = 0, _m2 = 0;
  double _pitch = 0, _roll = 0, _yaw = 0;
  double _prevPitch = 0, _prevRoll = 0;
  double _altitudeM = 0;
  double _batterySoc = 100;
  double _batteryVol = 8.4;
  double _signal = 48;
  int _tick = 0;

  // Implementación de los getters para las estadísticas
  @override
  int get packetsOk => 0;
  @override
  int get packetsWithError => 0;

  // Controlador del stream para la propiedad booleana
  final _connectedStreamController = StreamController<bool>.broadcast();
  final _onConnectStreamController = StreamController.broadcast();
  final _onDisconnectStreamController = StreamController.broadcast();
  final _onConnectionFailedStreamController = StreamController.broadcast();

  final _telemetryController = StreamController<Telemetry>.broadcast();

  // Stream con la telemetría del avión
  @override
  Stream<Telemetry> get telemetryStream => _telemetryController.stream;

  // Exponer el Stream público
  @override
  Stream<bool> get connectedStream => _connectedStreamController.stream;
  @override
  Stream<void> get onConnect => _onConnectStreamController.stream;
  @override
  Stream<void> get onDisconnect => _onDisconnectStreamController.stream;
  @override
  Stream<void> get onConnectionFailed =>
      _onConnectionFailedStreamController.stream;

  @override
  Future<void> connect() async {
    await Future.delayed(const Duration(seconds: 1));
    setConnected(true);
    _onConnectStreamController.add(null);

    // Iniciar simulación de datos
    _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (_armed) {
        _telemetryController.add(_buildTelemetry());
      }
    });
  }

  Telemetry _buildTelemetry() {
    const dt = 0.1; // 100 ms por tick
    _tick++;
    final t = _tick;

    // Motores: rampa suave hacia el throttle
    _m1 += (_throttle - _m1) * 0.35;
    _m2 += (_throttle * 0.98 - _m2) * 0.35;

    // Actitud: vaivén suave más pronunciado con potencia
    _prevPitch = _pitch;
    _prevRoll = _roll;
    final activity = 0.35 + _throttle / 100;
    final pitchTarget =
        (_throttle / 100) * 8 + 5 * activity * sin(t * 0.04);
    final rollTarget = 14 * activity * sin(t * 0.025);
    _pitch += (pitchTarget.clamp(-25.0, 25.0) - _pitch) * 0.03;
    _roll += (rollTarget.clamp(-35.0, 35.0) - _roll) * 0.03;

    // Rumbo: viraje a la derecha con la potencia (virada estándar ≈ 3 °/s)
    final yawRate = (_throttle / 100) * (2.0 + 0.6 * sin(t * 0.02));
    _yaw = (_yaw + yawRate * dt) % 360;

    // Altitud: sube cuando hay potencia, se mantiene si no
    final climb = max(0.0, (_throttle / 100) * 3.0 - 0.3);
    _altitudeM = max(0.0, _altitudeM + climb * dt);
    final baro = 1013.25 *
        pow(1 - _altitudeM / 44330, 1 / 0.190284).toDouble();

    // Batería: descarga con el consumo de los motores
    _batterySoc =
        max(0.0, _batterySoc - (0.2 + _throttle / 100) * dt);
    _batteryVol = 7.0 +
        (_batterySoc / 100) * 1.4 +
        _rng.nextDouble() * 0.05;

    // Señal: paseo aleatorio que sube/baja
    _signal = (_signal + (_rng.nextDouble() - 0.5) * 3).clamp(12.0, 60.0);

    // Acelerómetros coherentes con el vuelo
    final accelX = 0.3 * sin(t * 0.05); // derrape en el viraje
    final accelY = 0.2 * cos(t * 0.04);
    final accelZ = 500 + _pitch * 5 + _roll.abs() * 4 + 30 * sin(t * 0.05);

    // Giroscopios en grados/segundo
    final gyroX = (_roll - _prevRoll) / dt;
    final gyroY = (_pitch - _prevPitch) / dt;
    final gyroZ = yawRate / 3 * 100; // 0..1 = deflexión completa del TC

    // Magnetómetro coherente con el rumbo
    final magX = 1000 * cos(_yaw * pi / 180);
    final magY = 1000 * sin(_yaw * pi / 180);
    final magZ = _yaw;

    return Telemetry(
      gyroX: gyroX,
      gyroY: gyroY,
      gyroZ: gyroZ,
      magX: magX,
      magY: magY,
      magZ: magZ,
      barometer: baro,
      motor1Speed: _m1,
      motor2Speed: _m2,
      batterySoc: _batterySoc,
      batteryVol: _batteryVol,
      signal: _signal,
      accelX: accelX,
      accelY: accelY,
      accelZ: accelZ,
      pitch: _pitch,
      roll: _roll,
      yaw: _yaw,
    );
  }

  @override
  Future<void> disconnect() async {
    _timer?.cancel();
    _onDisconnectStreamController.add(null);
    await Future.delayed(const Duration(milliseconds: 500));
    setConnected(false);
  }

  @override
  Future<void> sendArmed(bool armed) async {
    _armed = armed;
    if (!_armed) {
      // Detener motores
      _telemetryController.add(_buildTelemetry().copyWith(
            motor1Speed: 0,
            motor2Speed: 0,
          ));
    }
  }

  @override
  Future<void> sendThrottle(int throttle) async {
    _throttle = throttle;
  }

  @override
  Future<void> sendManeuver(int maneuver) async {}

  @override
  Future<void> sendYoke(int yoke) async {}

  @override
  bool get isConnected => _isConnected;

  // Método para actualizar la propiedad y emitir el cambio
  void setConnected(bool value) {
    if (_isConnected != value) {
      _isConnected = value;
      _connectedStreamController.add(value); // Emitir el nuevo valor
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

  @override
  Future<void> sendBeacon(int beacon) async {
    beacon = beacon;
  }

  @override
  Future<void> sendCalibrateIMU() async {
    developer.log("Send Calibration IMU called");
  }

  @override
  Future<void> sendKD(double value) async {
    kd = value;
  }

  @override
  Future<void> sendKI(double value) async {
    ki = value;
  }

  @override
  Future<void> sendKP(double value) async {
    kp = value;
  }

  @override
  Future<void> sendShutdown() async {
    developer.log("Send Shutdown called");
  }

  @override
  Future<void> sendCalibrateMAG() async {
    developer.log("Send Calibration MAG called");
  }

  // PID Settings - Pitch
  @override
  Future<void> sendPitchKp(double value) async {
    developer.log("Send Pitch Kp: $value");
  }

  @override
  Future<void> sendPitchKi(double value) async {
    developer.log("Send Pitch Ki: $value");
  }

  @override
  Future<void> sendPitchKd(double value) async {
    developer.log("Send Pitch Kd: $value");
  }

  // PID Settings - Roll
  @override
  Future<void> sendRollKp(double value) async {
    developer.log("Send Roll Kp: $value");
  }

  @override
  Future<void> sendRollKi(double value) async {
    developer.log("Send Roll Ki: $value");
  }

  @override
  Future<void> sendRollKd(double value) async {
    developer.log("Send Roll Kd: $value");
  }

  // PID Settings - Yaw
  @override
  Future<void> sendYawKp(double value) async {
    developer.log("Send Yaw Kp: $value");
  }

  @override
  Future<void> sendYawKi(double value) async {
    developer.log("Send Yaw Ki: $value");
  }

  @override
  Future<void> sendYawKd(double value) async {
    developer.log("Send Yaw Kd: $value");
  }

  // Get PID Settings
  @override
  Future<void> sendGetPIDSettings() async {
    developer.log("Send Get PID Settings called");
  }

  @override
  Future<void> sendLogIMU(bool enabled) async {
    // Simulación: solo loguea la acción
    developer.log("Mock sendLogIMU: $enabled");
  }

  @override
  Future<void> sendLogThrust(bool enabled) async {
    developer.log("Mock sendLogThrust: $enabled");
  }

  @override
  Future<void> sendLogBattery(bool enabled) async {
    developer.log("Mock sendLogBattery: $enabled");
  }

  @override
  Future<void> sendLogMotor(bool enabled) async {
    developer.log("Mock sendLogMotor: $enabled");
  }
}

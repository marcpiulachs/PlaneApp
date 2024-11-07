import 'dart:async';
import 'plane_client_interface.dart';

class MockPlaneClient implements IPlaneClient {
  bool _isConnected = false;
  Timer? _timer;
  bool _armed = false;
  int _throttle = 0;

  // Implementación de los getters para las estadísticas
  @override
  int get packetsOk => 0;
  @override
  int get packetsWithError => 0;

  // Callbacks
  @override
  ConnectionCallback? onConnect;
  @override
  ConnectionCallback? onDisconnect;
  @override
  ConnectionCallback? onConnectionFailed;
  @override
  TelemetryCallback? onGyroX;
  @override
  TelemetryCallback? onGyroY;
  @override
  TelemetryCallback? onGyroZ;
  @override
  TelemetryCallback? onMagnetometerX;
  @override
  TelemetryCallback? onMagnetometerY;
  @override
  TelemetryCallback? onMagnetometerZ;
  @override
  TelemetryCallback? onBarometer;
  @override
  TelemetryCallback? onMotor1Speed;
  @override
  TelemetryCallback? onMotor2Speed;
  @override
  TelemetryCallback? onBatterySoc;
  @override
  TelemetryCallback? onBatteryVol;
  @override
  TelemetryCallback? onSignal;
  @override
  TelemetryCallback? onAccelerometerX;
  @override
  TelemetryCallback? onAccelerometerY;
  @override
  TelemetryCallback? onAccelerometerZ;
  @override
  TelemetryCallback? onPitch;
  @override
  TelemetryCallback? onRoll;
  @override
  TelemetryCallback? onYaw;

  // Controlador del stream para la propiedad booleana
  final _connectedStreamController = StreamController<bool>.broadcast();

  // Exponer el Stream público
  @override
  Stream<bool> get connectedStream => _connectedStreamController.stream;

  @override
  Future<void> connect() async {
    await Future.delayed(const Duration(seconds: 1));
    setConnected(true);
    onConnect?.call();

    // Iniciar simulación de datos
    _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (_armed) {
        _simulateGyroData();
        _simulateAccelerometerData();
        _simulateMagnetometerData();
        _simulateBarometerData();
        _simulateMotorData();
        _simulateBattery();
        _simulateSignal();
      }
    });
  }

  @override
  Future<void> disconnect() async {
    _timer?.cancel();
    onDisconnect?.call();
    await Future.delayed(const Duration(milliseconds: 500));
    setConnected(false);
  }

  @override
  Future<void> sendArmed(bool armed) async {
    _armed = armed;
    if (!_armed) {
      // Detener motores
      onMotor1Speed?.call(0);
      onMotor2Speed?.call(0);
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

  // Simulaciones de datos
  void _simulateGyroData() {
    onGyroX?.call(_generateRandomInt(-1000, 1000));
    onGyroY?.call(_generateRandomInt(-1000, 1000));
    onGyroZ?.call(_generateRandomInt(-1000, 1000));
  }

  void _simulateAccelerometerData() {
    onAccelerometerX?.call(_generateRandomInt(-1000, 1000));
    onAccelerometerY?.call(_generateRandomInt(-1000, 1000));
    onAccelerometerZ?.call(_generateRandomInt(-1000, 1000));
  }

  void _simulateMagnetometerData() {
    onMagnetometerX?.call(_generateRandomInt(-1000, 1000));
    onMagnetometerY?.call(_generateRandomInt(-1000, 1000));
    onMagnetometerZ?.call(_generateRandomInt(-1000, 1000));
  }

  void _simulateBarometerData() {
    onBarometer?.call(_generateRandomInt(1013, 1010)); // hPa
  }

  void _simulateMotorData() {
    int motorSpeed1 = (_throttle * 1).clamp(0, 100);
    int motorSpeed2 = (_throttle * 2).clamp(0, 100);
    onMotor1Speed?.call(motorSpeed1.toDouble());
    onMotor2Speed?.call(motorSpeed2.toDouble());
  }

  void _simulateBattery() {
    onBarometer?.call(_generateRandomInt(0, 100)); // hPa
  }

  void _simulateSignal() {
    onBarometer?.call(_generateRandomInt(12, 60)); // hPa
  }

  double _generateRandomInt(double min, int max) {
    return min +
        (max - min) * (DateTime.now().millisecondsSinceEpoch % 100) ~/ 100;
  }

  // Método para actualizar la propiedad y emitir el cambio
  void setConnected(bool value) {
    if (_isConnected != value) {
      _isConnected = value;
      _connectedStreamController.add(value); // Emitir el nuevo valor
    }
  }

  // Método de limpieza para cerrar el StreamController cuando no se use
  void dispose() {
    _connectedStreamController.close();
  }
}

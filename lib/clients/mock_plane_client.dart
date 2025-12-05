import 'dart:async';
import 'dart:developer' as developer;
import 'plane_client_interface.dart';

class MockPlaneClient implements IPlaneClient {
  bool _isConnected = false;
  Timer? _timer;
  bool _armed = false;
  int _throttle = 0;

  int beacon = 0;

  double kp = 0, ki = 0, kd = 0;

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

  final _onGyroXController = StreamController<double>.broadcast();
  final _onGyroYController = StreamController<double>.broadcast();
  final _onGyroZController = StreamController<double>.broadcast();
  final _onMagnetometerXController = StreamController<double>.broadcast();
  final _onMagnetometerYController = StreamController<double>.broadcast();
  final _onMagnetometerZController = StreamController<double>.broadcast();
  final _onBarometerController = StreamController<double>.broadcast();
  final _onMotor1SpeedController = StreamController<double>.broadcast();
  final _onMotor2SpeedController = StreamController<double>.broadcast();
  final _onBatterySocController = StreamController<double>.broadcast();
  final _onBatteryVolController = StreamController<double>.broadcast();
  final _onSignalController = StreamController<double>.broadcast();
  final _onAccelerometerXController = StreamController<double>.broadcast();
  final _onAccelerometerYController = StreamController<double>.broadcast();
  final _onAccelerometerZController = StreamController<double>.broadcast();
  final _onPitchController = StreamController<double>.broadcast();
  final _onRollController = StreamController<double>.broadcast();
  final _onYawController = StreamController<double>.broadcast();

  // Streams para cada tipo de dato
  @override
  Stream<double> get onGyroX => _onGyroXController.stream;
  @override
  Stream<double> get onGyroY => _onGyroYController.stream;
  @override
  Stream<double> get onGyroZ => _onGyroZController.stream;
  @override
  Stream<double> get onMagnetometerX => _onMagnetometerXController.stream;
  @override
  Stream<double> get onMagnetometerY => _onMagnetometerYController.stream;
  @override
  Stream<double> get onMagnetometerZ => _onMagnetometerZController.stream;
  @override
  Stream<double> get onBarometer => _onBarometerController.stream;
  @override
  Stream<double> get onMotor1Speed => _onMotor1SpeedController.stream;
  @override
  Stream<double> get onMotor2Speed => _onMotor2SpeedController.stream;
  @override
  Stream<double> get onBatterySoc => _onBatterySocController.stream;
  @override
  Stream<double> get onBatteryVol => _onBatteryVolController.stream;
  @override
  Stream<double> get onSignal => _onSignalController.stream;
  @override
  Stream<double> get onAccelerometerX => _onAccelerometerXController.stream;
  @override
  Stream<double> get onAccelerometerY => _onAccelerometerYController.stream;
  @override
  Stream<double> get onAccelerometerZ => _onAccelerometerZController.stream;
  @override
  Stream<double> get onPitch => _onPitchController.stream;
  @override
  Stream<double> get onRoll => _onRollController.stream;
  @override
  Stream<double> get onYaw => _onYawController.stream;

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
    _onDisconnectStreamController.add(null);
    await Future.delayed(const Duration(milliseconds: 500));
    setConnected(false);
  }

  @override
  Future<void> sendArmed(bool armed) async {
    _armed = armed;
    if (!_armed) {
      // Detener motores
      _onMotor1SpeedController.add(0);
      _onMotor2SpeedController.add(0);
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
    _onGyroXController.add(_generateRandomInt(-1000, 1000));
    _onGyroYController.add(_generateRandomInt(-1000, 1000));
    _onGyroZController.add(_generateRandomInt(-1000, 1000));
  }

  void _simulateAccelerometerData() {
    _onAccelerometerXController.add(_generateRandomInt(-1000, 1000));
    _onAccelerometerYController.add(_generateRandomInt(-1000, 1000));
    _onAccelerometerZController.add(_generateRandomInt(-1000, 1000));
  }

  void _simulateMagnetometerData() {
    _onMagnetometerXController.add(_generateRandomInt(-1000, 1000));
    _onMagnetometerYController.add(_generateRandomInt(-1000, 1000));
    _onMagnetometerZController.add(_generateRandomInt(-1000, 1000));
  }

  void _simulateBarometerData() {
    _onBarometerController.add(_generateRandomInt(1013, 1010)); // hPa
  }

  void _simulateMotorData() {
    int motorSpeed1 = (_throttle * 1).clamp(0, 100);
    int motorSpeed2 = (_throttle * 2).clamp(0, 100);
    _onMotor1SpeedController.add(motorSpeed1.toDouble());
    _onMotor2SpeedController.add(motorSpeed2.toDouble());
  }

  void _simulateBattery() {
    _onBarometerController.add(_generateRandomInt(0, 100)); // hPa
  }

  void _simulateSignal() {
    _onBarometerController.add(_generateRandomInt(12, 60)); // hPa
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
}

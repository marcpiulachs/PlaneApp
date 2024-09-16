import 'dart:async';
import 'tcp_client_interface.dart';

class MockTcpClient implements ITcpClient {
  bool _isConnected = false;
  Timer? _timer;
  bool _armed = false;
  int _throttle = 0;

  // Callbacks
  @override
  void Function()? onConnect;
  @override
  void Function()? onDisconnect;
  @override
  void Function()? onConnectionFailed;
  @override
  void Function(int)? onGyroX;
  @override
  void Function(int)? onGyroY;
  @override
  void Function(int)? onGyroZ;
  @override
  void Function(int)? onMagnetometerX;
  @override
  void Function(int)? onMagnetometerY;
  @override
  void Function(int)? onMagnetometerZ;
  @override
  void Function(int)? onBarometer;
  @override
  void Function(int)? onMotor1Speed;
  @override
  void Function(int)? onMotor2Speed;
  @override
  void Function(int)? onBattery;
  @override
  void Function(int)? onSignal;

  // Controlador del stream para la propiedad booleana
  final _connectedStreamController = StreamController<bool>.broadcast();

  // Exponer el Stream público
  @override
  Stream<bool> get connectedStream => _connectedStreamController.stream;

  @override
  Future<void> connect() async {
    await Future.delayed(const Duration(seconds: 1));
    _isConnected = true;
    onConnect?.call();

    // Iniciar simulación de datos
    _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (_armed) {
        _simulateGyroData();
        _simulateMagnetometerData();
        _simulateBarometerData();
        _simulateMotorData();
        _simulateBattery();
        _simulateSignal();
      }
    });
    setConnected(true);
  }

  @override
  Future<void> disconnect() async {
    _isConnected = false;
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
  bool get isConnected => _isConnected;

  // Simulaciones de datos
  void _simulateGyroData() {
    onGyroX?.call(_generateRandomInt(-1000, 1000));
    onGyroY?.call(_generateRandomInt(-1000, 1000));
    onGyroZ?.call(_generateRandomInt(-1000, 1000));
  }

  void _simulateMagnetometerData() {
    onMagnetometerX?.call(_generateRandomInt(-1000, 1000));
    onMagnetometerY?.call(_generateRandomInt(-1000, 1000));
    onMagnetometerZ?.call(_generateRandomInt(-1000, 1000));
  }

  void _simulateBarometerData() {
    onBarometer?.call(_generateRandomInt(900, 1100)); // hPa
  }

  void _simulateMotorData() {
    int motorSpeed1 = (_throttle * 1).clamp(0, 100);
    int motorSpeed2 = (_throttle * 2).clamp(0, 100);
    onMotor1Speed?.call(motorSpeed1);
    onMotor2Speed?.call(motorSpeed2);
  }

  void _simulateBattery() {
    onBarometer?.call(_generateRandomInt(0, 100)); // hPa
  }

  void _simulateSignal() {
    onBarometer?.call(_generateRandomInt(12, 60)); // hPa
  }

  int _generateRandomInt(int min, int max) {
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

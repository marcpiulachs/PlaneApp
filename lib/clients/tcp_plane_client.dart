// ignore_for_file: constant_identifier_names

import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:developer' as developer;
import 'package:paperwings/clients/plane_client_interface.dart';

// Definición de la clase Packet con el método toBytes()
class Packet {
  // Tamaño mínimo del paquete (por ejemplo, start, function, dataType, intData, end)
  static const int length = 8;

  // Bytes de inicio y fin
  static const int startByte = 0x02;
  static const int endByte = 0x03;

  // Definiciones de funciones
  static const int GYRO_X = 0x20;
  static const int GYRO_Y = 0x21;
  static const int GYRO_Z = 0x22;
  static const int MAGNETOMETER_X = 0x30;
  static const int MAGNETOMETER_Y = 0x31;
  static const int MAGNETOMETER_Z = 0x32;
  static const int BAROMETER = 0x40;
  static const int MOTOR_1_SPEED = 0x50;
  static const int MOTOR_2_SPEED = 0x51;
  static const int BATTERY_VOL = 0x70;
  static const int BATTERY_SOC = 0x83;
  static const int SIGNAL = 0x71;
  static const int ACCEL_X = 0x80;
  static const int ACCEL_Y = 0x81;
  static const int ACCEL_Z = 0x82;

  static const int ARMED = 0x60;
  static const int THROTTLE = 0x61;
  static const int PITCH = 0x62;
  static const int ROLL = 0x63;
  static const int YAW = 0x64;
  static const int MANEUVER = 0x65;
  static const int YOKE = 0x66;

  static const int LOG_IMU = 0x90;
  static const int LOG_THRUST = 0x91;
  static const int LOG_BATT = 0x92;
  static const int LOG_MOTOR = 0x93;
  static const int CALIBRATE_IMU = 0x94;
  static const int CALIBRATE_MAG = 0x95;
  static const int KP = 0x96;
  static const int KI = 0x97;
  static const int KD = 0x98;
  static const int SHUTDOWN = 0x99;
  static const int BEACON = 0x100;

  // Definiciones de tipo de datos
  static const int dataTypeInt = 0x01;
  static const int dataTypeBool = 0x03;
  static const int dataTypeDouble = 0x04;

  final int function;
  final int dataType;
  final double payload;

  // Payload para booleanos
  static const int boolTrue = 0x01;
  static const int boolFalse = 0x00;

  // Constructor básico
  Packet(this.function, this.dataType, this.payload);

  // Constructor adicional para booleanos
  Packet.forBool(this.function, bool value)
      : dataType = dataTypeBool,
        payload = value ? 1 : 0;

  // Constructor adicional para int
  Packet.forInt(this.function, int value)
      : dataType = dataTypeInt,
        payload = value.toDouble();

  Packet.forDouble(this.function, double value)
      : dataType = dataTypeInt,
        payload = value;

  // Constructor adicional para booleanos
  Packet.forEmpty(this.function)
      : dataType = dataTypeInt,
        payload = 0;

  // Método para convertir un array de bytes en un Packet
  static Packet? fromBytes(Uint8List data) {
    // Validar la longitud y los delimitadores de inicio y fin
    if (data.length != Packet.length ||
        data.first != Packet.startByte ||
        data.last != Packet.endByte) {
      // Paquete inválido
      developer.log('Invalid packet: incorrect length or delimiters');
      return null;
    }

    // Crear una vista de los bytes del paquete sin copiar los datos
    // Esto permite interpretar los datos de manera eficiente usando ByteData
    ByteData byteData = ByteData.sublistView(data);

    // Leer la función y el tipo de dato
    int function = byteData.getUint8(1);
    int dataType = byteData.getUint8(2);

    // Leer el payload como un entero de 16 bits en little-endian
    double payload = byteData.getFloat32(3, Endian.big);

    // Crear el paquete en función del tipo de dato
    switch (dataType) {
      case Packet.dataTypeDouble:
        return Packet.forDouble(function, payload);
      case Packet.dataTypeInt:
        return Packet.forInt(function, payload.toInt());
      case Packet.dataTypeBool:
        return Packet.forBool(function, payload == Packet.boolTrue);
      default: // Tipo de dato desconocido
        developer.log('Invalid packet: unknown data type: $dataType');
        return null;
    }
  }

  // Método que convierte el paquete a bytes, según el tipo de dato
  Uint8List toBytes() {
    return Uint8List.fromList([
      startByte, // Byte de inicio
      function, // Función
      dataType, // Tipo de dato
      ...floatToBytes(payload),
      endByte // Byte de fin
    ]);
  }

  // Conversión de int a bytes
  static List<int> floatToBytes(double value) {
    // 4 bytes para un float de 32 bits
    ByteData byteData = ByteData(4);
    // Usar setFloat32 en lugar de setInt16
    byteData.setFloat32(0, value, Endian.big);
    return byteData.buffer.asUint8List();
  }
}

class TcpPlaneClient implements IPlaneClient {
  // Controlador del stream para la propiedad booleana
  final _connectedStreamController = StreamController<bool>.broadcast();
  final String host;
  final int port;
  late Socket _socket;
  bool _isConnected = false;

  // Contadores para estadísticas
  @override
  int packetsOk = 0;
  @override
  int packetsWithError = 0;

  // Callbacks para eventos
  @override
  Stream<void> get onConnect => _onConnectStreamController.stream;
  @override
  Stream<void> get onDisconnect => _onDisconnectStreamController.stream;
  @override
  Stream<void> get onConnectionFailed =>
      _onConnectionFailedStreamController.stream;

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

  TcpPlaneClient({required this.host, required this.port});

  @override
  bool get isConnected => _isConnected;

  @override
  Future<void> connect() async {
    try {
      // Create socket
      _socket = await Socket.connect(
        host,
        port,
        timeout: const Duration(seconds: 5),
      );
      // Report to console
      developer.log('Connection established with $host:$port');
      // Actualiza el estado de conexión
      setConnected(true);
      // Emite el evento de conexión si existe
      _onConnectStreamController.add(null);
      // Escuchar mensajes del servidor
      _listenToServer();
    } catch (e) {
      // Report to console
      developer.log('Error connecting to the server: $e');
      // Actualiza el estado de conexión
      setConnected(false);
      // Emite el evento de falla de conexión si existe
      _onConnectionFailedStreamController.add(null);
    }
  }

  void _listenToServer() {
    _socket.listen(
      (Uint8List data) {
        try {
          _processReceivedData(data);
        } catch (e) {
          developer.log('Error processing received data: $e');
          _handleDisconnection();
        }
      },
      onError: (error) {
        developer.log('Error receiving data: $error');
        _handleDisconnection();
      },
      onDone: () {
        developer.log('Connection closed by the server');
        _handleDisconnection();
      },
    );
  }

  void _handleDisconnection() {
    setConnected(false);
    _socket.close(); // Cerrar el socket
    _onDisconnectStreamController.add(null);
  }

  void _processReceivedData(Uint8List data) {
    int index = 0;
    List<int> packetBuffer = [];

    // Bucle que recorre todos los bytes recibidos
    while (index < data.length) {
      // Obtener el byte actual
      int byte = data[index];
      // Detectar byte de inicio
      if (packetBuffer.isEmpty && byte == Packet.startByte) {
        // Si es el byte de inicio, agregarlo al buffer
        packetBuffer.add(byte);
      }
      // Si se ha detectado el byte de inicio, seguimos agregando bytes
      else if (packetBuffer.isNotEmpty) {
        // Agregar el byte actual al buffer
        packetBuffer.add(byte);
        // Detectar byte de fin y validar el paquete
        if (packetBuffer.length == Packet.length) {
          if (byte == Packet.endByte) {
            // Convertir el buffer en un Uint8List y tratar de interpretar el paquete
            Uint8List packetBytes = Uint8List.fromList(packetBuffer);
            // Load packet from bytes
            Packet? packet = Packet.fromBytes(packetBytes);
            if (packet != null) {
              packetsOk++;
              _handleReceivedPacket(packet);
            } else {
              packetsWithError++;
              developer.log('Invalid packet received');
            }
          } else {
            packetsWithError++;
            developer.log(
                'Packet malformed expecting ${Packet.endByte}, found $byte');
          }

          // Reiniciar el buffer tras procesar el paquete (correcto o incorrecto)
          packetBuffer.clear();
        }
      }
      // Avanzar al siguiente byte
      index++;
    }
  }

  void _handleReceivedPacket(Packet packet) {
    switch (packet.function) {
      case Packet.GYRO_X:
        _onGyroXController.add(packet.payload);
        break;
      case Packet.GYRO_Y:
        _onGyroYController.add(packet.payload);
        break;
      case Packet.GYRO_Z:
        _onGyroZController.add(packet.payload);
        break;
      case Packet.MAGNETOMETER_X:
        _onMagnetometerXController.add(packet.payload);
        break;
      case Packet.MAGNETOMETER_Y:
        _onMagnetometerYController.add(packet.payload);
        break;
      case Packet.MAGNETOMETER_Z:
        _onMagnetometerZController.add(packet.payload);
        break;
      case Packet.BAROMETER:
        _onBarometerController.add(packet.payload);
        break;
      case Packet.MOTOR_1_SPEED:
        _onMotor1SpeedController.add(packet.payload);
        break;
      case Packet.MOTOR_2_SPEED:
        _onMotor2SpeedController.add(packet.payload);
        break;
      case Packet.BATTERY_VOL:
        _onBatteryVolController.add(packet.payload);
        break;
      case Packet.BATTERY_SOC:
        _onBatterySocController.add(packet.payload);
        break;
      case Packet.SIGNAL:
        _onSignalController.add(packet.payload);
        break;
      case Packet.ACCEL_X:
        _onAccelerometerXController.add(packet.payload);
        break;
      case Packet.ACCEL_Y:
        _onAccelerometerYController.add(packet.payload);
        break;
      case Packet.ACCEL_Z:
        _onAccelerometerZController.add(packet.payload);
        break;
      case Packet.PITCH:
        _onPitchController.add(packet.payload);
        break;
      case Packet.ROLL:
        _onRollController.add(packet.payload);
        break;
      case Packet.YAW:
        _onYawController.add(packet.payload);
        break;
      default:
        developer.log('Unknown function: ${packet.function}');
        break;
    }
  }

  Future<void> sendPacket(Packet packet) async {
    if (!_isConnected) {
      developer.log('Not connected to the server');
      return;
    }

    try {
      Uint8List packetBytes = packet.toBytes();
      _socket.add(packetBytes);
    } catch (e) {
      developer.log('Error sending data: $e');
    }
  }

  @override
  Future<void> disconnect() async {
    if (_isConnected) {
      await _socket.close();
      setConnected(false);
      _onDisconnectStreamController.add(null);
    }
  }

  // Método para armar o desarmar el sistema
  @override
  Future<void> sendArmed(bool armed) async {
    Packet packet = Packet.forBool(Packet.ARMED, armed);
    await sendPacket(packet);
  }

  // Método para ajustar el throttle
  @override
  Future<void> sendThrottle(int throttle) async {
    Packet packet = Packet.forInt(Packet.THROTTLE, throttle);
    await sendPacket(packet);
  }

  @override
  Future<void> sendYoke(int yoke) async {
    Packet packet = Packet.forInt(Packet.YOKE, yoke);
    await sendPacket(packet);
  }

  @override
  Future<void> sendManeuver(int maneuver) async {
    Packet packet = Packet.forInt(Packet.MANEUVER, maneuver);
    await sendPacket(packet);
  }

  @override
  Future<void> sendBeacon(int beacon) async {
    Packet packet = Packet.forInt(Packet.BEACON, beacon);
    await sendPacket(packet);
  }

  @override
  Future<void> sendShutdown() async {
    Packet packet = Packet.forEmpty(Packet.SHUTDOWN);
    await sendPacket(packet);
  }

  @override
  Future<void> sendKD(double value) async {
    Packet packet = Packet.forDouble(Packet.KD, value);
    await sendPacket(packet);
  }

  @override
  Future<void> sendKP(double value) async {
    Packet packet = Packet.forDouble(Packet.KP, value);
    await sendPacket(packet);
  }

  @override
  Future<void> sendKI(double value) async {
    Packet packet = Packet.forDouble(Packet.KI, value);
    await sendPacket(packet);
  }

  @override
  Future<void> sendCalibrateIMU() async {
    Packet packet = Packet.forEmpty(Packet.CALIBRATE_IMU);
    await sendPacket(packet);
  }

  @override
  Future<void> sendCalibrateMAG() async {
    Packet packet = Packet.forEmpty(Packet.CALIBRATE_MAG);
    await sendPacket(packet);
  }

  // Método para actualizar la propiedad y emitir el cambio
  void setConnected(bool value) {
    if (_isConnected != value) {
      _isConnected = value;
      // Emitir el nuevo valor solo si el StreamController está abierto
      if (!_connectedStreamController.isClosed) {
        _connectedStreamController.add(value); // Emitir el nuevo valor
      }
    }
  }

  // Método de limpieza para cerrar el StreamController cuando no se use
  void dispose() {
    _connectedStreamController.close();
  }
}

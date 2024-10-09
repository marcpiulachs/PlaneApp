// ignore_for_file: constant_identifier_names

import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:developer' as developer;
import 'package:paperwings/clients/plane_client_interface.dart';

// Definición de la clase Packet con el método toBytes()
class Packet {
  // Tamaño mínimo del paquete (por ejemplo, start, function, dataType, intData, end)
  static const int length = 6;

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
  static const int BATTERY = 0x70;
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

  // Definiciones de tipo de datos
  static const int dataTypeInt = 0x01;
  static const int dataTypeBool = 0x03;

  final int function;
  final int dataType;
  final int payload;

  // Payload para booleanos
  static const int boolTrue = 0x01;
  static const int boolFalse = 0x00;

  // Constructor básico
  Packet(this.function, this.dataType, this.payload);

  // Constructor adicional para booleanos
  Packet.forBool(this.function, bool value)
      : dataType = dataTypeBool,
        payload = value ? boolTrue : boolFalse;

  // Constructor adicional para int
  Packet.forInt(this.function, int value)
      : dataType = dataTypeInt,
        payload = value;

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

    ByteData byteData = ByteData.sublistView(data);

    // Leer la función y el tipo de dato
    int function = byteData.getUint8(1);
    int dataType = byteData.getUint8(2);

    // Leer el payload como un entero de 16 bits en little-endian
    int payload = byteData.getInt16(3, Endian.little);

    // Crear el paquete en función del tipo de dato
    switch (dataType) {
      case Packet.dataTypeInt:
        return Packet.forInt(function, payload);
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
      ...intToBytes(payload),
      endByte // Byte de fin
    ]);
  }

  // Conversión de int a bytes
  static List<int> intToBytes(int value) {
    ByteData byteData = ByteData(2);
    byteData.setInt16(0, value, Endian.big);
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
  TelemetryCallback? onBattery;
  @override
  TelemetryCallback? onSignal;
  @override
  TelemetryCallback? onAccelerometerX;
  @override
  TelemetryCallback? onAccelerometerY;
  @override
  TelemetryCallback? onAccelerometerZ;

  // Exponer el Stream público
  @override
  Stream<bool> get connectedStream => _connectedStreamController.stream;

  TcpPlaneClient({required this.host, required this.port});

  @override
  bool get isConnected => _isConnected;

  @override
  Future<void> connect() async {
    try {
      _socket = await Socket.connect(
        host,
        port,
        timeout: const Duration(seconds: 5),
      );
      developer.log('Connection established with $host:$port');

      // Actualiza el estado de conexión
      setConnected(true);

      // Emite el evento de conexión si existe
      onConnect?.call();

      // Escuchar mensajes del servidor
      _listenToServer();
    } catch (e) {
      developer.log('Error connecting to the server: $e');

      // Actualiza el estado de conexión
      setConnected(false);

      // Emite el evento de falla de conexión si existe
      onConnectionFailed?.call();
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
    onDisconnect?.call();
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
        if (byte == Packet.endByte) {
          if (packetBuffer.length != Packet.length) {
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
            developer.log('Packet too short');
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
        onGyroX?.call(packet.payload);
        break;
      case Packet.GYRO_Y:
        onGyroY?.call(packet.payload);
        break;
      case Packet.GYRO_Z:
        onGyroZ?.call(packet.payload);
        break;
      case Packet.MAGNETOMETER_X:
        onMagnetometerX?.call(packet.payload);
        break;
      case Packet.MAGNETOMETER_Y:
        onMagnetometerY?.call(packet.payload);
        break;
      case Packet.MAGNETOMETER_Z:
        onMagnetometerZ?.call(packet.payload);
        break;
      case Packet.BAROMETER:
        onBarometer?.call(packet.payload);
        break;
      case Packet.MOTOR_1_SPEED:
        onMotor1Speed?.call(packet.payload);
        break;
      case Packet.MOTOR_2_SPEED:
        onMotor2Speed?.call(packet.payload);
        break;
      case Packet.BATTERY:
        onBattery?.call(packet.payload);
        break;
      case Packet.SIGNAL:
        onSignal?.call(packet.payload);
        break;
      case Packet.ACCEL_X:
        onAccelerometerX?.call(packet.payload);
        break;
      case Packet.ACCEL_Y:
        onAccelerometerY?.call(packet.payload);
        break;
      case Packet.ACCEL_Z:
        onAccelerometerZ?.call(packet.payload);
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
      onDisconnect?.call();
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
  Future<void> sendYaw(int yaw) async {
    Packet packet = Packet.forInt(Packet.YAW, yaw);
    await sendPacket(packet);
  }

  @override
  Future<void> sendRoll(int roll) async {
    Packet packet = Packet.forInt(Packet.ROLL, roll);
    await sendPacket(packet);
  }

  @override
  Future<void> sendPitch(int pitch) async {
    Packet packet = Packet.forInt(Packet.PITCH, pitch);
    await sendPacket(packet);
  }

  @override
  Future<void> sendManeuver(int maneuver) async {
    Packet packet = Packet.forInt(Packet.MANEUVER, maneuver);
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

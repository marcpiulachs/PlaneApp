// ignore_for_file: constant_identifier_names

import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:developer' as developer;
import 'package:paperwings/clients/plane_client_interface.dart';

// Definición de la clase Packet con el método toBytes()
class Packet {
  static const int startByte = 0x02;
  static const int endByte = 0x03;

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

  static const int dataTypeInt = 0x01;
  static const int dataTypeBool = 0x03;

  final int function;
  final int dataType;
  final int payload;

  static const int boolTrue = 0x01;
  static const int boolFalse = 0x00;

  Packet(this.function, this.dataType, this.payload);

  // Constructor adicional para booleanos
  Packet.forBool(this.function, bool value)
      : dataType = dataTypeBool,
        payload = value ? boolTrue : boolFalse;

  // Constructor adicional para int
  Packet.forInt(this.function, int value)
      : dataType = dataTypeInt,
        payload = value;

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
  final String host;
  final int port;
  late Socket _socket;
  bool _isConnected = false;

  // Callbacks para eventos
  @override
  void Function()? onConnect;
  @override
  void Function()? onDisconnect;
  @override
  void Function()? onConnectionFailed;
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

  // Controlador del stream para la propiedad booleana
  final _connectedStreamController = StreamController<bool>.broadcast();

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
        timeout: const Duration(
          seconds: 5,
        ),
      );
      developer.log('Connection with plane stablished');
      setConnected(true);
      if (onConnect != null) {
        onConnect!(); // Emitir evento de conexión
      }
      _listenToServer();
    } catch (e) {
      developer.log('Error connecting to the server: $e');
      setConnected(false);
      if (onConnectionFailed != null) {
        onConnectionFailed!(); // Emitir evento de desconexión por error
      }
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
    if (onDisconnect != null) {
      onDisconnect!(); // Emitir evento de desconexión
    }
  }

  void _processReceivedData(Uint8List data) {
    // Máquina de estados para manejar el parsing del paquete
    int index = 0;
    bool startDetected = false;
    List<int> packetBuffer = [];

    while (index < data.length) {
      int byte = data[index];

      if (!startDetected) {
        // Esperamos el byte de inicio
        if (byte == Packet.startByte) {
          startDetected = true;
          packetBuffer.clear();
          packetBuffer.add(byte);
        }
      } else {
        packetBuffer.add(byte);

        if (byte == Packet.endByte) {
          // Fin de paquete detectado, procesar paquete
          Packet? packet = _parsePacket(Uint8List.fromList(packetBuffer));
          if (packet != null) {
            _handleReceivedPacket(packet);
          } else {
            developer.log('Invalid packet received');
          }
          startDetected = false;
          packetBuffer.clear();
        }
      }

      index++;
    }
  }

  Packet? _parsePacket(Uint8List data) {
    // Verificar si el paquete tiene al menos la longitud mínima
    if (data.length >= 5 &&
        data.first == Packet.startByte &&
        data.last == Packet.endByte) {
      int function = data[1];
      int dataType = data[2];

      ByteData byteData = ByteData(2);

      // Coloca los bytes en el buffer
      byteData.setUint8(0, data[3]); // Primer byte (byte alto)
      byteData.setUint8(1, data[4]); // Segundo byte (byte bajo)

      // Lee los bytes como un int16 (Endianness puede cambiar según el caso)
      int value = byteData.getInt16(0, Endian.little);

      if (dataType == Packet.dataTypeInt) {
        return Packet.forInt(function, value);
      } else if (dataType == Packet.dataTypeBool) {
        return Packet.forBool(function, value == Packet.boolTrue);
      } else {
        return null; // Tipo de dato desconocido
      }
    } else {
      return null; // Paquete inválido
    }
  }

  void _handleReceivedPacket(Packet packet) {
    switch (packet.function) {
      case Packet.GYRO_X:
        if (onGyroX != null) {
          onGyroX!(packet.payload);
        }
        break;
      case Packet.GYRO_Y:
        if (onGyroY != null) {
          onGyroY!(packet.payload);
        }
        break;
      case Packet.GYRO_Z:
        if (onGyroZ != null) {
          onGyroZ!(packet.payload);
        }
        break;
      case Packet.MAGNETOMETER_X:
        if (onMagnetometerX != null) {
          onMagnetometerX!(packet.payload);
        }
        break;
      case Packet.MAGNETOMETER_Y:
        if (onMagnetometerY != null) {
          onMagnetometerY!(packet.payload);
        }
        break;
      case Packet.MAGNETOMETER_Z:
        if (onMagnetometerZ != null) {
          onMagnetometerZ!(packet.payload);
        }
        break;
      case Packet.BAROMETER:
        if (onBarometer != null) {
          onBarometer!(packet.payload);
        }
        break;
      case Packet.MOTOR_1_SPEED:
        if (onMotor1Speed != null) {
          onMotor1Speed!(packet.payload);
        }
        break;
      case Packet.MOTOR_2_SPEED:
        if (onMotor2Speed != null) {
          onMotor2Speed!(packet.payload);
        }
        break;
      case Packet.BATTERY:
        if (onBattery != null) {
          onBattery!(packet.payload);
        }
        break;
      case Packet.SIGNAL:
        if (onSignal != null) {
          onSignal!(packet.payload);
        }
        break;
      case Packet.ACCEL_X:
        if (onAccelerometerX != null) {
          onAccelerometerX!(packet.payload);
        }
        break;
      case Packet.ACCEL_Y:
        if (onAccelerometerY != null) {
          onAccelerometerY!(packet.payload);
        }
        break;
      case Packet.ACCEL_Z:
        if (onAccelerometerZ != null) {
          onAccelerometerZ!(packet.payload);
        }
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
      if (onDisconnect != null) {
        onDisconnect!();
      }
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
      _connectedStreamController.add(value); // Emitir el nuevo valor
    }
  }

  // Método de limpieza para cerrar el StreamController cuando no se use
  void dispose() {
    _connectedStreamController.close();
  }
}

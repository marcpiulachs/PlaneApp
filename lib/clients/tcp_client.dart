import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:object_3d/clients/tcp_client_interface.dart';

// Constantes para las funciones del protocolo
const int GYRO_X = 0x20;
const int GYRO_Y = 0x21;
const int GYRO_Z = 0x22;
const int MAGNETOMETER_X = 0x30;
const int MAGNETOMETER_Y = 0x31;
const int MAGNETOMETER_Z = 0x32;
const int BAROMETER = 0x40;
const int MOTOR_1_SPEED = 0x50;
const int MOTOR_2_SPEED = 0x51;
const int ARMED = 0x60;
const int THROTTLE = 0x61;
const int BATTERY = 0x70;
const int SIGNAL = 0x71;

class TcpClient implements ITcpClient {
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

  TcpClient({required this.host, required this.port});

  @override
  bool get isConnected => _isConnected;

  @override
  Future<void> connect() async {
    try {
      _socket = await Socket.connect(host, port);
      setConnected(true);
      if (onConnect != null) onConnect!(); // Emitir evento de conexión
      _listenToServer();
    } catch (e) {
      print('Error connecting to the server: $e');
      _isConnected = false;
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
          print('Error processing received data: $e');
          _handleDisconnection();
        }
      },
      onError: (error) {
        print('Error receiving data: $error');
        _handleDisconnection();
      },
      onDone: () {
        print('Connection closed by the server');
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
    // Aquí procesamos los datos recibidos según el protocolo
    print('Received data: $data');

    // Simular el procesamiento de paquetes recibidos
    int index = 0;
    while (index < data.length) {
      if (data[index] == 0x02) {
        // Start of packet
        // Buscar el final del paquete
        int endIndex = data.indexOf(0x03, index);
        if (endIndex == -1) break; // No se encontró el final del paquete

        // Extraer el paquete
        Uint8List packet = data.sublist(index, endIndex + 1);

        if (packet.length >= 4) {
          int function = packet[1];
          int dataType = packet[2];

          // Extraer el valor de acuerdo al tipo de dato
          dynamic value;
          if (dataType == 0x01) {
            // Integer
            value = ByteData.sublistView(packet.buffer.asUint8List(), 3, 5)
                .getInt16(0, Endian.big);
          } else if (dataType == 0x03) {
            // Boolean
            value = packet[3] == 0x01;
          }

          _handleReceivedFunction(function, value);
        }

        index = endIndex + 1; // Continuar con el siguiente paquete
      } else {
        index++;
      }
    }
  }

  void _handleReceivedFunction(int function, dynamic value) {
    switch (function) {
      case GYRO_X:
        if (onGyroX != null) onGyroX!(value);
        break;
      case GYRO_Y:
        if (onGyroY != null) onGyroY!(value);
        break;
      case GYRO_Z:
        if (onGyroZ != null) onGyroZ!(value);
        break;
      case MAGNETOMETER_X:
        if (onMagnetometerX != null) onMagnetometerX!(value);
        break;
      case MAGNETOMETER_Y:
        if (onMagnetometerY != null) onMagnetometerY!(value);
        break;
      case MAGNETOMETER_Z:
        if (onMagnetometerZ != null) onMagnetometerZ!(value);
        break;
      case BAROMETER:
        if (onBarometer != null) onBarometer!(value);
        break;
      case MOTOR_1_SPEED:
        if (onMotor1Speed != null) onMotor1Speed!(value);
        break;
      case MOTOR_2_SPEED:
        if (onMotor2Speed != null) onMotor2Speed!(value);
        break;
      case BATTERY:
        if (onBattery != null) onBattery!(value);
        break;
      case SIGNAL:
        if (onSignal != null) onSignal!(value);
        break;
      default:
        print('Unknown function: $function');
        break;
    }
  }

  Future<void> sendPacket(int function, int dataType, dynamic value) async {
    if (!_isConnected) {
      print('Not connected to the server');
      return;
    }

    try {
      List<int> packet = _createPacket(function, dataType, value);
      _socket.add(Uint8List.fromList(packet));
    } catch (e) {
      print('Error sending data: $e');
    }
  }

  List<int> _createPacket(int function, int dataType, dynamic value) {
    List<int> packet = [];

    // Carácter de inicio de paquete
    packet.add(0x02);

    // Función
    packet.add(function);

    // Tipo de dato
    packet.add(dataType);

    // Datos
    if (dataType == 0x01) {
      // Integer (convertir a 2 bytes)
      packet.addAll(_intToBytes(value));
    } else if (dataType == 0x03) {
      // Boolean (convertir a 2 bytes)
      packet.addAll(_boolToBytes(value));
    }

    // Carácter de fin de paquete
    packet.add(0x03);

    return packet;
  }

  List<int> _intToBytes(int value) {
    ByteData byteData = ByteData(2);
    byteData.setInt16(0, value, Endian.big);
    return byteData.buffer.asUint8List();
  }

  List<int> _boolToBytes(bool value) {
    ByteData byteData = ByteData(2);
    byteData.setUint16(0, value ? 0x01 : 0x00, Endian.big);
    return byteData.buffer.asUint8List();
  }

  @override
  Future<void> disconnect() async {
    if (_isConnected) {
      _socket.close();
      setConnected(false);
      if (onDisconnect != null) {
        onDisconnect!();
      }
    }
  }

  // Método para armar o desarmar el sistema
  @override
  Future<void> sendArmed(bool armed) async {
    await sendPacket(ARMED, 0x03, armed);
  }

  // Método para ajustar el throttle
  @override
  Future<void> sendThrottle(int throttle) async {
    await sendPacket(THROTTLE, 0x01, throttle);
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

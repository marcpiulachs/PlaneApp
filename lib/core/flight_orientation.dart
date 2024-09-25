import 'dart:async';
import 'dart:math';
import 'package:sensors_plus/sensors_plus.dart';

class FlightOrientation {
  final Function(int pitch) onPitchChanged; // Cambiado a int
  final Function(int roll) onRollChanged; // Cambiado a int
  final Function(int yaw) onYawChanged; // Cambiado a int

  double _yaw = 0; // Almacena y acumula el valor de yaw en grados
  StreamSubscription<AccelerometerEvent>? _accelerometerSubscription;
  StreamSubscription<GyroscopeEvent>? _gyroscopeSubscription;

  DateTime? _lastTimestamp;

  FlightOrientation({
    required this.onPitchChanged,
    required this.onRollChanged,
    required this.onYawChanged,
  });

  /// Inicia la escucha de los sensores.
  void start() {
    // Escuchar los eventos del acelerómetro
    _accelerometerSubscription =
        accelerometerEventStream().listen((AccelerometerEvent event) {
      double pitch =
          atan2(event.x, sqrt(event.y * event.y + event.z * event.z)) *
              180 /
              pi;
      double roll = atan2(event.y, event.z) * 180 / pi;

      // Llamar a los callbacks, convirtiendo los valores a enteros
      onPitchChanged(pitch.round());
      onRollChanged(roll.round());
    });

    // Escuchar los eventos del giroscopio para calcular yaw
    _gyroscopeSubscription =
        gyroscopeEventStream().listen((GyroscopeEvent event) {
      DateTime now = DateTime.now();
      double deltaTime = 0;

      if (_lastTimestamp != null) {
        deltaTime =
            now.difference(_lastTimestamp!).inMicroseconds / 1e6; // segundos
      }
      _lastTimestamp = now;

      // Asumiendo que event.z está en radianes por segundo
      // Convertir a grados por segundo
      double angularVelocityDegreesPerSecond = event.z * 180 / pi;

      // Integrar la velocidad angular para obtener yaw en grados
      double deltaYaw = angularVelocityDegreesPerSecond * deltaTime;
      _yaw += deltaYaw;

      // Llamar al callback, convirtiendo el valor de yaw a entero
      onYawChanged(_yaw.round());
    });
  }

  /// Detiene la escucha de los sensores.
  void stop() {
    _accelerometerSubscription?.cancel();
    _gyroscopeSubscription?.cancel();
  }

  // Libera recursos del timer cuando ya no se necesita
  void dispose() {
    stop();
  }
}

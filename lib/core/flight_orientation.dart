import 'dart:async';
import 'dart:math'; // Importar para usar la función atan y sqrt
import 'package:sensors_plus/sensors_plus.dart';

class FlightOrientation {
  final Function(int pitch) onPitchChanged;
  final Function(int roll) onRollChanged;
  final Function(int yaw) onYawChanged;

  final Function(int degrees)? onLeftChanged;
  final Function(int degrees)? onRightChanged;
  final Function(int degrees)? onUpChanged;
  final Function(int degrees)? onDownChanged;

  final Function(int degrees)?
      onRotateLeftChanged; // Evento para rotación hacia la izquierda (yaw)
  final Function(int degrees)?
      onRotateRightChanged; // Evento para rotación hacia la derecha (yaw)

  StreamSubscription<GyroscopeEvent>? _gyroscopeSubscription;
  StreamSubscription<AccelerometerEvent>? _accelerometerSubscription;

  FlightOrientation({
    required this.onPitchChanged,
    required this.onRollChanged,
    required this.onYawChanged,
    this.onLeftChanged,
    this.onRightChanged,
    this.onUpChanged,
    this.onDownChanged,
    this.onRotateLeftChanged,
    this.onRotateRightChanged,
  });

  /// Inicia la escucha de los sensores.
  void start() {
    _accelerometerSubscription = accelerometerEventStream().listen(
      (AccelerometerEvent event) {
        _handleAccelerometerEvent(event);
      },
    );

    _gyroscopeSubscription = gyroscopeEventStream().listen(
      (GyroscopeEvent event) {
        _handleGyroscopeEvent(event);
      },
    );
  }

  /// Detiene la escucha de los sensores.
  void stop() {
    _gyroscopeSubscription?.cancel();
    _accelerometerSubscription?.cancel();
  }

  /// Limpia los recursos, cancela las suscripciones.
  void dispose() {
    stop(); // Asegura que las suscripciones se cancelen
  }

  /// Maneja los eventos del acelerómetro y calcula los ángulos.
  void _handleAccelerometerEvent(AccelerometerEvent event) {
    // Valores crudos del acelerómetro
    double ax = event.x;
    double ay = event.y;
    double az = event.z;

    // Cálculo de pitch y roll con las fórmulas correctas
    double pitch = atan(ay / sqrt(ax * ax + az * az)) * (180 / pi);
    double roll = atan(ax / sqrt(ay * ay + az * az)) * (180 / pi);

    // Llamada a los callbacks con los valores correctos
    onPitchChanged(pitch.round());
    onRollChanged(roll.round());

    // Detecta left/right con base en el roll
    if (roll > 0) {
      if (onRightChanged != null) {
        onRightChanged!(roll.round());
      }
    } else {
      if (onLeftChanged != null) {
        onLeftChanged!(roll.abs().round());
      }
    }

    // Detecta up/down con base en el pitch
    if (pitch > 0) {
      if (onDownChanged != null) {
        onDownChanged!(pitch.round());
      }
    } else {
      if (onUpChanged != null) {
        onUpChanged!(pitch.abs().round());
      }
    }
  }

  /// Maneja los eventos del giroscopio para obtener la rotación (yaw).
  void _handleGyroscopeEvent(GyroscopeEvent event) {
    double yaw = event.z * 57.2958; // Convierte a grados

    // Llama a la función de callback con el valor redondeado a entero
    onYawChanged(yaw.round());

    // Detecta rotación hacia la derecha (yaw positivo)
    if (yaw > 0) {
      if (onRotateRightChanged != null) {
        onRotateRightChanged!(yaw.round());
      }
    }
    // Detecta rotación hacia la izquierda (yaw negativo)
    else {
      if (onRotateLeftChanged != null) {
        onRotateLeftChanged!(yaw.abs().round());
      }
    }
  }
}

import 'package:flutter/material.dart';
import 'package:paperwings/models/direction.dart';
import 'package:paperwings/models/telemetry.dart';

class PlaneDirection extends StatelessWidget {
  final Telemetry telemetry;
  final Direction direction;

  const PlaneDirection({
    super.key,
    required this.telemetry,
    required this.direction,
  });

  // Función para obtener el punto cardinal basado en el entero de yaw en grados
  String getCardinalDirection(int yaw) {
    yaw = yaw % 360; // Asegura que el valor de yaw esté entre 0 y 360

    if (yaw >= 337.5 || yaw < 22.5) return 'N'; // Norte
    if (yaw >= 22.5 && yaw < 67.5) return 'NE'; // Noreste
    if (yaw >= 67.5 && yaw < 112.5) return 'E'; // Este
    if (yaw >= 112.5 && yaw < 157.5) return 'SE'; // Sureste
    if (yaw >= 157.5 && yaw < 202.5) return 'S'; // Sur
    if (yaw >= 202.5 && yaw < 247.5) return 'SO'; // Suroeste
    if (yaw >= 247.5 && yaw < 292.5) return 'O'; // Oeste
    if (yaw >= 292.5 && yaw < 337.5) return 'NO'; // Noroeste
    return 'N'; // Por defecto
  }

  @override
  Widget build(BuildContext context) {
    // Obtén el valor de yaw y su dirección cardinal
    final yawDegrees = direction.yaw.round();
    final cardinalDirection = getCardinalDirection(direction.yaw);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Primera columna con Yaw y Punto Cardinal
          SizedBox(
            width: 100, // Ancho fijo para la primera columna
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  '$yawDegrees°',
                  style: const TextStyle(
                    fontSize: 40, // Grado en grande
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  cardinalDirection,
                  style: const TextStyle(
                    fontSize: 60, // Punto cardinal en grande
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 20), // Separación entre las columnas

          // Segunda columna con los valores de pitch, roll y yaw
          SizedBox(
            width: 100, // Ancho fijo para la segunda columna
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Direction:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                    height: 10), // Espacio entre 'Direction' y los valores
                Text(
                  'Pitch: ${telemetry.pitch.round()}°',
                  style: const TextStyle(fontSize: 16),
                ),
                Text(
                  'Roll: ${telemetry.roll.round()}°',
                  style: const TextStyle(fontSize: 16),
                ),
                Text(
                  'Yaw: ${telemetry.yaw.round()}°',
                  style: const TextStyle(fontSize: 16),
                ),
                Text(
                  'Gyro X: ${telemetry.gyroX.round()}°/s',
                  style: const TextStyle(fontSize: 16),
                ),
                Text(
                  'Gyro Y: ${telemetry.gyroY.round()}°/s',
                  style: const TextStyle(fontSize: 16),
                ),
                Text(
                  'Giro Z: ${telemetry.gyroZ.round()}°/s',
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

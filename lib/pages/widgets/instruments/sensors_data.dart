import 'package:flutter/material.dart';
import 'package:paperwings/models/direction.dart';
import 'package:paperwings/models/telemetry.dart';

class SensorsData extends StatelessWidget {
  final Telemetry telemetry;
  final Direction direction;

  const SensorsData({
    super.key,
    required this.telemetry,
    required this.direction,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child:
          // Segunda columna con los valores de pitch, roll y yaw
          Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Primera columna
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.rotate_90_degrees_ccw,
                        color: Colors.white),
                    const SizedBox(width: 5),
                    Text(
                      'Pitch: ${telemetry.pitch.round()}°',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Icon(Icons.rotate_left, color: Colors.white),
                    const SizedBox(width: 5),
                    Text(
                      'Roll: ${telemetry.roll.round()}°',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Icon(Icons.navigation, color: Colors.white),
                    const SizedBox(width: 5),
                    Text(
                      'Yaw: ${telemetry.yaw.round()}°',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Icon(Icons.speed, color: Colors.white),
                    const SizedBox(width: 5),
                    Text(
                      'Gyro X: ${telemetry.gyroX.toStringAsPrecision(2)}°/s',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Icon(Icons.speed, color: Colors.white),
                    const SizedBox(width: 5),
                    Text(
                      'Gyro Y: ${telemetry.gyroY.toStringAsPrecision(2)}°/s',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Icon(Icons.speed, color: Colors.white),
                    const SizedBox(width: 5),
                    Text(
                      'Gyro Z: ${telemetry.gyroZ.toStringAsPrecision(2)}°/s',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 20),
          // Segunda columna
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.trending_up, color: Colors.white),
                    const SizedBox(width: 5),
                    Text(
                      'Acc X: ${telemetry.accelX.toStringAsPrecision(2)}°/s',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Icon(Icons.trending_up, color: Colors.white),
                    const SizedBox(width: 5),
                    Text(
                      'Acc Y: ${telemetry.accelY.toStringAsPrecision(2)}°/s',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Icon(Icons.trending_up, color: Colors.white),
                    const SizedBox(width: 5),
                    Text(
                      'Acc Z: ${telemetry.accelZ.toStringAsPrecision(2)}°/s',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Icon(Icons.explore, color: Colors.white),
                    const SizedBox(width: 5),
                    Text(
                      'Mag X: ${telemetry.magX.round()}',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Icon(Icons.explore, color: Colors.white),
                    const SizedBox(width: 5),
                    Text(
                      'Mag Y: ${telemetry.magY.round()}',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Icon(Icons.explore, color: Colors.white),
                    const SizedBox(width: 5),
                    Text(
                      'Mag Z: ${telemetry.magZ.round()}',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

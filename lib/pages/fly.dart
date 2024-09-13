import 'package:flutter/material.dart';
import 'package:object_3d/widgets/circular.dart';
import 'package:object_3d/widgets/compass.dart';
import 'package:object_3d/widgets/throttle.dart';
import 'package:sensors_plus/sensors_plus.dart';

class Fly extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          Center(
            child: Container(
              child: Center(
                child: const Text(
                  "00:00",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressBar(
                    progress: 0.7, // Puedes cambiar el valor del progreso
                    icon: Icons.radar, // Ícono a mostrar
                    text: '-23dbi', // Texto a mostrar
                    backgroundColor: Colors.white,
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressBar(
                    progress: 0.7, // Puedes cambiar el valor del progreso
                    icon: Icons.height, // Ícono a mostrar
                    text: '16 m.', // Texto a mostrar
                    backgroundColor: Colors.white,
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressBar(
                    progress: 0.7, // Puedes cambiar el valor del progreso
                    icon: Icons.local_gas_station, // Ícono a mostrar
                    text: '70%', // Texto a mostrar
                    backgroundColor: Colors.white,
                  ),
                ],
              ),
            ],
          ),
          // Segunda fila con contenido expandido y centrado en el medio
          Expanded(
            child: Center(
              child: CompassWidget(
                degrees: 20,
                size: Size(250, 250),
                textColor: Colors.white,
                barsColor: Colors.white,
                showDegrees: false,
              ),
            ),
          ),
          /*
          LayoutBuilder(
            builder: (context, constraints) {
              return Container(
                height: 80,
                width: 200,
                color: Colors.red,
                child: ClipRect(
                  child: Align(
                    alignment: Alignment.bottomRight,
                    heightFactor: 0.5,
                    child: CompassWidget(
                      degrees: 30,
                      size: Size(constraints.maxWidth, constraints.maxHeight),
                    ),
                  ),
                ),
              );
            },
          ),*/
          // Tercera fila con 3 columnas, centradas pero pegadas a la parte baja
          Expanded(
            child: Row(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: CircularProgressBar(
                        progress: 0.4, // Puedes cambiar el valor del progreso
                        icon: Icons.rotate_right, // Ícono a mostrar
                        text: 'Engine', // Texto a mostrar
                        backgroundColor: Colors.white, size: 100.0,
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Throttle(
                      onStateChanged: (ThrottleState state) {
                        print('Throttle state: ${state.toString()}');
                      },
                      onThrottleUpdated: (double value) {
                        print('Armed throttle value: ${value.toInt()}');
                      },
                    ),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: CircularProgressBar(
                        progress: 0.2, // Puedes cambiar el valor del progreso
                        icon: Icons.rotate_left, // Ícono a mostrar
                        text: 'Engine', // Texto a mostrar
                        backgroundColor: Colors.white, size: 100,
                      ),
                    ),
                  ],
                ),
              ],
              mainAxisAlignment: MainAxisAlignment.end,
            ),
          ),
        ],
      ),
    );
  }
}

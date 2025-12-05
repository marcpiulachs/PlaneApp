import 'dart:math';
import 'package:flutter/material.dart';

class TurnCoordinator extends StatefulWidget {
  final double turnRate; // Rango: -1.0 (izquierda) a 1.0 (derecha)
  final double slip; // Rango: -1.0 (izquierda) a 1.0 (derecha)

  const TurnCoordinator({
    super.key,
    required this.turnRate,
    required this.slip,
  });

  @override
  State<TurnCoordinator> createState() => _TurnCoordinatorState();
}

class _TurnCoordinatorState extends State<TurnCoordinator>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          alignment: Alignment.center,
          children: [
            // Fondo del indicador
            Container(
              height: constraints.maxHeight,
              width: constraints.maxHeight,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey.shade900,
                border: Border.all(color: Colors.black, width: 2),
              ),
            ),
            // Avión central, marcas L/R y marcas de alineación
            Positioned(
              top: constraints.maxHeight * 0.18,
              child: SizedBox(
                width: constraints.maxHeight,
                height: 100,
                child: Stack(
                  children: [
                    // Avión
                    Align(
                      alignment: Alignment.center,
                      child: Transform.rotate(
                        angle: -widget.turnRate * pi / 4,
                        child: CustomPaint(
                          size: const Size(100, 100),
                          painter: AirplanePainter(),
                        ),
                      ),
                    ),

                    // Alignment marks estilo instrumento real (izquierda)
                    Positioned(
                      left: 8,
                      top: 54,
                      child: Column(
                        children: [
                          Container(
                            width: 18,
                            height: 3,
                            color: Colors.white,
                          ),
                          const SizedBox(height: 7),
                          Text('L',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13)),
                          const SizedBox(height: 7),
                          Container(
                            width: 18,
                            height: 3,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                    // Alignment marks estilo instrumento real (derecha)
                    Positioned(
                      right: 8,
                      top: 54,
                      child: Column(
                        children: [
                          Container(
                            width: 18,
                            height: 3,
                            color: Colors.white,
                          ),
                          const SizedBox(height: 7),
                          Text('R',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13)),
                          const SizedBox(height: 7),
                          Container(
                            width: 18,
                            height: 3,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Bola que se mueve lateralmente para indicar deslizamiento
            Positioned(
              bottom: 30,
              child: SizedBox(
                width: 120,
                height: 24,
                child: Stack(
                  children: [
                    // Fondo y bola
                    Container(
                      width: 120,
                      height: 20,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white.withOpacity(0.3),
                      ),
                    ),
                    // Bola
                    Positioned(
                      left: ((widget.slip + 1) / 2) * 100,
                      top: 0,
                      child: Container(
                        width: 20,
                        height: 20,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Pantallas digitales TURN y SLIP debajo del avión
            Positioned(
              top: constraints.maxHeight * 0.55,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 70,
                    height: 44,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.85),
                      borderRadius: BorderRadius.circular(7),
                      border: Border.all(color: Colors.white24, width: 1),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'TURN',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              widget.turnRate.toStringAsFixed(2),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Icon(Icons.sync_alt,
                                color: Colors.orange, size: 16),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Container(
                    width: 70,
                    height: 44,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.85),
                      borderRadius: BorderRadius.circular(7),
                      border: Border.all(color: Colors.white24, width: 1),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'SLIP',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              widget.slip.toStringAsFixed(2),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Icon(Icons.horizontal_rule,
                                color: Colors.blue, size: 16),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class AirplanePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    // Dibujar la bola en el centro (cuerpo del avión)
    double radius = 10.0; // Radio de la bola
    canvas.drawCircle(Offset(size.width / 2, size.height / 2), radius, paint);

    // Dibujar las alas
    paint.color = Colors.white; // Color de las alas
    double wingLength = 60.0; // Longitud de las alas
    double wingHeight = 5.0; // Altura de las alas

    // Alas izquierda
    canvas.drawRect(
      Rect.fromLTWH(size.width / 2 - wingLength,
          size.height / 2 - wingHeight / 2, wingLength, wingHeight),
      paint,
    );

    // Alas derecha
    canvas.drawRect(
      Rect.fromLTWH(size.width / 2, size.height / 2 - wingHeight / 2,
          wingLength, wingHeight),
      paint,
    );

    // Dibujar la cola (una línea vertical en el centro hacia arriba)
    double tailHeight = 20.0; // Altura de la cola
    canvas.drawRect(
      Rect.fromLTWH(size.width / 2 - 2.5, size.height / 2 - radius - tailHeight,
          5, tailHeight), // Ajustar la posición
      paint,
    );

    // Dibujar la cola (una línea vertical en el centro hacia arriba)
    //double tailHeight = 20.0; // Altura de la cola
    double tailWidth = 5.0; // Ancho de la cola
    canvas.drawRect(
      Rect.fromLTWH(
          size.width / 2 - tailWidth / 2,
          size.height / 2 - radius - tailHeight,
          tailWidth,
          tailHeight), // Ajustar la posición
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false; // No necesita repintarse
  }
}

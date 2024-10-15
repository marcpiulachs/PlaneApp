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
            // Avión central que rota según la tasa de giro
            Transform.rotate(
              angle: widget.turnRate * pi / 4, // Rango de rotación
              child: CustomPaint(
                size: const Size(100, 100), // Tamaño del avión
                painter: AirplanePainter(),
              ),
            ),
            // Bola que se mueve lateralmente para indicar deslizamiento
            Positioned(
              bottom: 30,
              child: Container(
                width: 100,
                height: 20,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white.withOpacity(0.3),
                ),
                child: Stack(
                  children: [
                    // Bola
                    Positioned(
                      // Posición de la bola
                      left: (widget.slip + 1) * 0.5 * 100,
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
    double wingLength = 80.0; // Longitud de las alas
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

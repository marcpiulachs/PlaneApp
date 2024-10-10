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
              child: const Icon(
                Icons.airplanemode_active,
                size: 100,
                color: Colors.white,
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

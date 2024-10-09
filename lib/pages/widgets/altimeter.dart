import 'package:flutter/material.dart';
import 'dart:math' as math;

enum AltitudeUnit { feet, meters }

class Altimeter extends StatelessWidget {
  final double altitude;
  final AltitudeUnit unit;

  const Altimeter({
    super.key,
    required this.altitude,
    this.unit = AltitudeUnit.feet,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          alignment: Alignment.center,
          children: [
            Container(
              height: constraints.maxHeight,
              width: constraints.maxHeight,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(width: 2.0, color: Colors.black),
              ),
              child: CustomPaint(
                painter: _AltimeterPainter(altitude: altitude, unit: unit),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _AltimeterPainter extends CustomPainter {
  final double altitude;
  final AltitudeUnit unit;

  _AltimeterPainter({required this.altitude, required this.unit});

  @override
  void paint(Canvas canvas, Size size) {
    double radius = size.width / 2;
    Offset center = Offset(radius, radius);

    // Fondo gris oscuro
    canvas.drawCircle(center, radius, Paint()..color = Colors.grey.shade900);

    // Fondo blanco dinámico basado en altitud (llenado de abajo hacia arriba)
    _drawDynamicFill(canvas, center, radius, size);

    // Dibujar el círculo contrastante en el centro con el valor de altitud
    _drawAltitudeText(canvas, center, altitude, unit);
  }

  void _drawDynamicFill(
      Canvas canvas, Offset center, double radius, Size size) {
    // Calcular el porcentaje de relleno basado en la altitud
    double fillPercentage = (altitude.clamp(0, 25) / 25);

    // Crear un path circular que representa el círculo completo
    Path clipPath = Path()
      ..addOval(Rect.fromCircle(center: center, radius: radius));

    // Aplicar un rectángulo de relleno que sube de abajo hacia arriba
    double fillHeight = size.height * fillPercentage;
    Rect fillRect =
        Rect.fromLTWH(0, size.height - fillHeight, size.width, fillHeight);

    // Usar `clipPath` para enmascarar el rectángulo de relleno dentro del círculo
    canvas.save();
    canvas.clipPath(clipPath);
    Paint fillPaint = Paint()..color = Colors.white;
    canvas.drawRect(fillRect, fillPaint);
    canvas.restore();
  }

  void _drawAltitudeText(
      Canvas canvas, Offset center, double altitude, AltitudeUnit unit) {
    // Texto que muestra la altitud actual
    String altitudeText =
        '${altitude.toStringAsFixed(1)} ${unit == AltitudeUnit.meters ? 'm' : 'ft'}';

    // Círculo en el centro para destacar el texto
    double textCircleRadius = center.dx * 0.4; // 40% del radio total
    Paint textCirclePaint = Paint()..color = Colors.black;
    canvas.drawCircle(center, textCircleRadius, textCirclePaint);

    // Configuración del texto en el centro
    TextPainter textPainter = TextPainter(
      text: TextSpan(
        text: altitudeText,
        style: const TextStyle(
            color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();

    // Centrar el texto dentro del círculo pequeño
    Offset textOffset = Offset(
        center.dx - textPainter.width / 2, center.dy - textPainter.height / 2);
    textPainter.paint(canvas, textOffset);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

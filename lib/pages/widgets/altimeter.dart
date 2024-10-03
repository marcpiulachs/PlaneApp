import 'package:flutter/material.dart';
import 'dart:math' as math;

enum AltitudeUnit { feet, meters } // Enum para las unidades de altitud

class Altimeter extends StatelessWidget {
  final double altitude; // Altitud
  final AltitudeUnit unit; // Unidad de altitud

  const Altimeter({
    super.key,
    required this.altitude,
    this.unit = AltitudeUnit.feet, // Valor por defecto en pies
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          alignment: Alignment.center, // Centra los elementos
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
            )
          ],
        );
      },
    );
  }
}

class _AltimeterPainter extends CustomPainter {
  final double altitude; // Altitud
  final AltitudeUnit unit; // Unidad de altitud

  _AltimeterPainter({required this.altitude, required this.unit});

  @override
  void paint(Canvas canvas, Size size) {
    double radius = size.width / 2;
    Offset center = Offset(radius, radius);
    Paint circlePaint = Paint()..color = Colors.black;

    // Dibujar el fondo del altímetro
    //canvas.drawCircle(center, radius, circlePaint);
    canvas.drawCircle(center, radius,
        Paint()..color = Colors.grey.shade900); // Círculo interior

    // Dibujar la escala de altitud
    _drawScale(canvas, center, radius);

    // Dibujar la aguja del altímetro
    _drawNeedle(canvas, center, radius, altitude);
  }

  void _drawScale(Canvas canvas, Offset center, double radius) {
    Paint scalePaint = Paint()..color = Colors.white;
    double angleStep = math.pi / 25; // 7.2 grados
    double length = radius - 20; // Longitud de las marcas

    // Definir los valores de altitud según la unidad
    double maxAltitude = unit == AltitudeUnit.meters
        ? 25.0
        : 25.0 * 3.28084; // 25 metros en pies
    int steps = (maxAltitude / 5)
        .ceil(); // Cantidad de marcas de escala cada 5 metros o su equivalente
    double stepSize = maxAltitude / steps;

    // Dibujar marcas de la escala (toda la circunferencia)
    for (int i = 0; i <= steps; i++) {
      double angle = -math.pi / 2 + (i * angleStep);
      double x1 = center.dx + (length * math.cos(angle));
      double y1 = center.dy + (length * math.sin(angle));
      double x2 = center.dx + (length - 10) * math.cos(angle);
      double y2 = center.dy + (length - 10) * math.sin(angle);

      // Dibujar líneas
      canvas.drawLine(Offset(x1, y1), Offset(x2, y2), scalePaint);

      // Dibujar texto de la altitud
      TextPainter textPainter = TextPainter(
        text: TextSpan(
          text:
              '${(i * stepSize).toStringAsFixed(0)} ${unit == AltitudeUnit.meters ? 'm' : 'ft'}',
          style: const TextStyle(color: Colors.white, fontSize: 12),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(center.dx + (length - 30) * math.cos(angle) - 10,
            center.dy + (length - 30) * math.sin(angle) - 6),
      );

      // Dibujar texto negativo
      double negativeAngle =
          angle + math.pi; // Invertir el ángulo para el texto negativo
      textPainter.paint(
        canvas,
        Offset(center.dx + (length - 30) * math.cos(negativeAngle) - 10,
            center.dy + (length - 30) * math.sin(negativeAngle) - 6),
      );
    }
  }

  void _drawNeedle(
      Canvas canvas, Offset center, double radius, double altitude) {
    Paint needlePaint = Paint()..color = Colors.red;

    // Calcular el ángulo de la aguja basado en la altitud
    double angle = -math.pi / 2 + (altitude / 25 * (math.pi / 2));

    // Longitudes de la aguja (más largas en la base y más cortas en la punta)
    double baseLength = radius - 40; // Longitud de la base
    double tipLength = 20; // Longitud de la punta

    // Calcular la posición de la base y la punta de la aguja
    double xBase = center.dx + baseLength * math.cos(angle);
    double yBase = center.dy + baseLength * math.sin(angle);
    double xTip = center.dx + (baseLength - tipLength) * math.cos(angle);
    double yTip = center.dy + (baseLength - tipLength) * math.sin(angle);

    // Dibujar la aguja
    Path needlePath = Path();
    needlePath.moveTo(center.dx, center.dy); // Comenzar desde el centro
    needlePath.lineTo(xBase, yBase); // Línea a la base
    needlePath.lineTo(xTip, yTip); // Línea a la punta

    // Dibujar la base ancha de la aguja
    needlePath.lineTo(
        center.dx + 5 * math.cos(angle + math.pi / 2),
        center.dy +
            5 * math.sin(angle + math.pi / 2)); // Línea hacia la derecha
    needlePath.lineTo(
        center.dx + 5 * math.cos(angle - math.pi / 2),
        center.dy +
            5 * math.sin(angle - math.pi / 2)); // Línea hacia la izquierda
    needlePath.close(); // Cerrar el camino

    // Pintar la aguja
    canvas.drawPath(needlePath, needlePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true; // Repintar si cambia la altitud
  }
}

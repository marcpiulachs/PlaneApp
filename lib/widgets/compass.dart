import 'package:flutter/material.dart';
import 'dart:math';

class CompassWidget extends StatelessWidget {
  final double degrees;
  final Color backgroundColor;
  final Color textColor;
  final Color barsColor;
  final bool showDegrees;
  final Widget? child; // Nuevo child opcional

  const CompassWidget({
    super.key,
    required this.degrees,
    this.backgroundColor = const Color(0xFFEEEEEE),
    this.textColor = Colors.black,
    this.barsColor = Colors.black,
    this.showDegrees = true,
    this.child, // Añadido el parámetro child
  });

  String getCardinalDirection(double degrees) {
    if (degrees >= 337.5 || degrees < 22.5) return "N";
    if (degrees >= 22.5 && degrees < 67.5) return "NE";
    if (degrees >= 67.5 && degrees < 112.5) return "E";
    if (degrees >= 112.5 && degrees < 157.5) return "SE";
    if (degrees >= 157.5 && degrees < 202.5) return "S";
    if (degrees >= 202.5 && degrees < 247.5) return "SW";
    if (degrees >= 247.5 && degrees < 292.5) return "W";
    if (degrees >= 292.5 && degrees < 337.5) return "NW";
    return "N";
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          alignment: Alignment.center, // Centra los elementos
          children: [
            Transform.rotate(
              angle: (degrees - 90) * pi / 180,
              child: CustomPaint(
                size: Size(constraints.maxHeight, constraints.maxHeight),
                painter: CompassPainter(
                  degrees: degrees,
                  cardinalDirection: getCardinalDirection(degrees),
                  backgroundColor: backgroundColor,
                  textColor: textColor,
                  barsColor: barsColor,
                  showDegrees: showDegrees,
                ),
              ),
            ),
            if (child != null)
              child!, // Dibuja el widget en el centro si se pasa un child
          ],
        );
      },
    );
  }
}

class CompassPainter extends CustomPainter {
  final double degrees;
  final String cardinalDirection;
  final Color backgroundColor;
  final Color textColor;
  final Color barsColor;
  final bool showDegrees;

  CompassPainter({
    required this.degrees,
    required this.cardinalDirection,
    required this.backgroundColor,
    required this.textColor,
    required this.barsColor,
    required this.showDegrees,
  });

  @override
  void paint(Canvas canvas, Size size) {
    double radius = size.width / 2;
    final Paint circlePaint = Paint()
      ..color = Colors.transparent; // Centro transparente
    final Paint linePaintLarge = Paint()
      ..color = barsColor
      ..strokeWidth = 2;
    final Paint linePaintMedium = Paint()
      ..color = barsColor
      ..strokeWidth = 1.5;
    final Paint linePaintSmall = Paint()
      ..color = barsColor
      ..strokeWidth = 1;

    Offset center = Offset(size.width / 2, size.height / 2);
    canvas.drawCircle(center, radius, circlePaint);

    // Definir los largos para cada tipo de palito
    double largeLength = 20;
    double mediumLength = 15;
    double smallLength = 10;

    // Pintar los palitos
    for (int i = 0; i < 360; i++) {
      double angle = i * pi / 180;
      Paint currentPaint;
      double length;

      if (i % 90 == 0) {
        currentPaint = linePaintLarge;
        length = largeLength;
      } else if (i % 10 == 0) {
        currentPaint = linePaintMedium;
        length = mediumLength;
      } else {
        currentPaint = linePaintSmall;
        length = smallLength;
      }

      Offset start = Offset(
        center.dx + radius * cos(angle),
        center.dy + radius * sin(angle),
      );
      Offset end = Offset(
        center.dx + (radius - length) * cos(angle),
        center.dy + (radius - length) * sin(angle),
      );

      canvas.drawLine(start, end, currentPaint);
    }

    // Dibujar grados/puntos cardinales cada 10 grados
    for (int i = 0; i < 360; i += 10) {
      double angle = i * pi / 180;
      double x = center.dx + (radius - 20) * cos(angle);
      double y = center.dy + (radius - 20) * sin(angle);

      String label;
      bool cardinal = false;
      TextStyle textStyle = TextStyle(color: textColor, fontSize: 12);

      if (i == 0 || i == 90 || i == 180 || i == 270) {
        // Reemplazar con los puntos cardinales
        switch (i) {
          case 0:
            label = "N";
            cardinal = true;
            break;
          case 90:
            label = "E";
            cardinal = true;
            break;
          case 180:
            label = "S";
            cardinal = true;
            break;
          case 270:
            label = "W";
            cardinal = true;
            break;
          default:
            label = i.toString();
            cardinal = false;
        }
        textStyle = textStyle.copyWith(fontWeight: FontWeight.bold);
      } else {
        label = i.toString(); // Mostrar grados
        cardinal = false;
      }

      if (cardinal || showDegrees) {
        TextPainter textPainter = TextPainter(
          text: TextSpan(
            text: label,
            style: textStyle,
          ),
          textDirection: TextDirection.ltr,
        );
        textPainter.layout();

        // Rotar textos correctamente
        canvas.save();
        canvas.translate(x, y);
        double textRotationAngle = angle + pi / 2;
        canvas.rotate(textRotationAngle);
        textPainter.paint(
            canvas, Offset(-textPainter.width / 2, textPainter.height / 2));
        canvas.restore();
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

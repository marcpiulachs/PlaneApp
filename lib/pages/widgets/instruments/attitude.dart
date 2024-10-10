import 'package:flutter/material.dart';
import 'dart:math' as math;

class AttitudeIndicator extends StatelessWidget {
  final double roll; // Ángulo de rotación lateral (en grados)
  final double pitch; // Ángulo de cabeceo (en grados)

  const AttitudeIndicator({
    super.key,
    required this.roll,
    required this.pitch,
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
                border: Border.all(width: 2.0, color: Colors.grey.shade900),
              ),
              child: ClipOval(
                child: CustomPaint(
                  painter: _AttitudeIndicatorPainter(roll: roll, pitch: pitch),
                ),
              ),
            ),
            // Línea blanca que permanece inmóvil en el centro
            // Representación del avión con una línea, semicírculo y otra línea
            Positioned(
              child: CustomPaint(
                size: Size(constraints.maxHeight, constraints.maxHeight),
                painter: _PlanePainter(),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _AttitudeIndicatorPainter extends CustomPainter {
  final double roll; // Ángulo de rotación lateral (en grados)
  final double pitch; // Ángulo de cabeceo (en grados)

  _AttitudeIndicatorPainter({required this.roll, required this.pitch});

  @override
  void paint(Canvas canvas, Size size) {
    double radius = size.width / 2;
    Offset center = Offset(radius, radius);

    // Aplicar la rotación del horizonte según el roll
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(roll * math.pi / 180);
    canvas.translate(-center.dx, -center.dy);

    // Dibujar el fondo (cielo arriba y tierra abajo) y la línea del horizonte desplazada según el pitch
    _drawBackgroundAndHorizon(canvas, size, pitch);

    // Restaurar el canvas para que la línea central no se vea afectada
    canvas.restore();
  }

  void _drawBackgroundAndHorizon(Canvas canvas, Size size, double pitch) {
    Paint skyPaint = Paint()..color = Colors.blue;
    Paint groundPaint = Paint()..color = Colors.brown;
    Paint horizonLine = Paint()
      ..color = Colors.white
      ..strokeWidth = 2;

    double pitchOffset =
        pitch * (size.height / 90); // Escalar pitch a la pantalla

    // Dibujar cielo y tierra
    Rect skyRect =
        Rect.fromLTRB(0, 0, size.width, size.height / 2 + pitchOffset);
    Rect groundRect = Rect.fromLTRB(
        0, size.height / 2 + pitchOffset, size.width, size.height);

    canvas.drawRect(skyRect, skyPaint);
    canvas.drawRect(groundRect, groundPaint);

    // Dibujar la línea del horizonte
    canvas.drawLine(
      Offset(0, size.height / 2 + pitchOffset),
      Offset(size.width, size.height / 2 + pitchOffset),
      horizonLine,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true; // Se repinta cada vez que cambian los valores de roll o pitch
  }
}

class _PlanePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    double radius = size.width / 2;
    Offset center = Offset(radius, radius);

    Paint leftLinePaint = Paint()
      ..color = Colors.orange
      ..strokeWidth = 5;

    Paint rightLinePaint = Paint()
      ..color = Colors.orange
      ..strokeWidth = 5;

    Paint semiCirclePaint = Paint()
      ..color = Colors.black
      ..strokeWidth = 5
      ..style = PaintingStyle.stroke;

    Paint degreeLinePaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 2;

    // Dibujar la línea corta izquierda
    canvas.drawLine(
      Offset(center.dx - 40, center.dy),
      Offset(center.dx - 10, center.dy),
      leftLinePaint,
    );

// Dibujar el semicírculo en el centro (invertido)
    Rect semiCircleRect = Rect.fromCircle(center: center, radius: 10);
    canvas.drawArc(
      semiCircleRect,
      0, // Empezar desde la parte superior
      math.pi, // Dibujar un semicírculo hacia abajo
      false,
      semiCirclePaint,
    );

    // Dibujar la línea corta derecha
    canvas.drawLine(
      Offset(center.dx + 10, center.dy),
      Offset(center.dx + 40, center.dy),
      rightLinePaint,
    );

    // Dibujar las líneas de grados (positivos y negativos)
    _drawDegreeLines(canvas, size, center, degreeLinePaint);
  }

  void _drawDegreeLines(Canvas canvas, Size size, Offset center, Paint paint) {
    double spacing =
        20; // Espacio entre líneas, ajustado según el tamaño del indicador

    // Lista de grados y longitudes correspondientes
    List<Map<String, dynamic>> degreeLines = [
      {'degrees': 5, 'length': 10.0},
      {'degrees': 10, 'length': 15.0},
      {'degrees': 15, 'length': 20.0},
      {'degrees': 20, 'length': 25.0},
    ];

    // Dibujar líneas de referencia hacia arriba (grados positivos) y texto
    for (var i = 0; i < degreeLines.length; i++) {
      int degrees = degreeLines[i]['degrees'];
      double lineLength = degreeLines[i]['length'];
      double yOffset = center.dy - (i + 1) * spacing;

      // Dibujar la línea
      canvas.drawLine(
        Offset(center.dx - lineLength, yOffset),
        Offset(center.dx + lineLength, yOffset),
        paint,
      );

      // Dibujar los números de grados al lado de las líneas
      _drawDegreeText(canvas, center, degrees, yOffset, lineLength);
    }

    // Dibujar líneas de referencia hacia abajo (grados negativos) y texto
    for (var i = 0; i < degreeLines.length; i++) {
      int degrees = degreeLines[i]['degrees'];
      double lineLength = degreeLines[i]['length'];
      double yOffset = center.dy + (i + 1) * spacing;

      // Dibujar la línea
      canvas.drawLine(
        Offset(center.dx - lineLength, yOffset),
        Offset(center.dx + lineLength, yOffset),
        paint,
      );

      // Dibujar los números de grados al lado de las líneas
      _drawDegreeText(canvas, center, -degrees, yOffset, lineLength);
    }
  }

  void _drawDegreeText(Canvas canvas, Offset center, int degrees,
      double yOffset, double lineLength) {
    TextPainter textPainter = TextPainter(
      text: TextSpan(
        text: '$degrees°',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
        ),
      ),
      textDirection: TextDirection.ltr,
    );

    // Dibujar el texto a la izquierda de la línea
    textPainter.layout();
    textPainter.paint(canvas, Offset(center.dx - lineLength - 25, yOffset - 6));

    // Dibujar el texto a la derecha de la línea
    textPainter.paint(canvas, Offset(center.dx + lineLength + 5, yOffset - 6));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false; // La representación del avión y líneas es fija
  }
}

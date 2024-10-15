import 'package:flutter/material.dart';
import 'dart:math';

enum AltitudeUnit { feet, meters }

class AltimeterWidget extends StatefulWidget {
  final double altitude; // Altitud actual en pies o metros
  final double pressure; // Presión barométrica en bares
  final AltitudeUnit unit; // Unidad: pies o metros
  final double minAltitude; // Altitud mínima
  final double maxAltitude; // Altitud máxima

  const AltimeterWidget({
    Key? key,
    required this.altitude,
    required this.pressure,
    this.unit = AltitudeUnit.feet, // Pies por defecto
    this.minAltitude = 0.0, // Valor mínimo por defecto
    this.maxAltitude = 10000.0, // Valor máximo por defecto
  }) : super(key: key);

  @override
  _AltimeterWidgetState createState() => _AltimeterWidgetState();
}

class _AltimeterWidgetState extends State<AltimeterWidget> {
  String get altitudeLabel {
    return widget.unit == AltitudeUnit.feet ? 'feet' : 'meters';
  }

  double get altitudeValue {
    return widget.unit == AltitudeUnit.feet
        ? widget.altitude
        : widget.altitude * 0.3048; // Conversión de pies a metros
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double size = min(constraints.maxWidth, constraints.maxHeight);

        return Center(
          child: Stack(
            alignment: Alignment.center,
            children: [
              CustomPaint(
                size: Size(size, size),
                painter: AltimeterPainter(
                  altitude: widget.altitude,
                  minAltitude: widget.minAltitude,
                  maxAltitude: widget.maxAltitude,
                ),
              ),
              Positioned(
                child: Icon(Icons.airplanemode_active,
                    size: size * 0.2, color: Colors.white),
              ),
              // Mostrar altitud y presión en recuadros con bordes redondeados
              Positioned(
                bottom: 20,
                child: Column(
                  children: [
                    _buildInfoBox(
                      label: 'Altitude',
                      value:
                          '${altitudeValue.toStringAsFixed(0)} $altitudeLabel',
                      size: size,
                    ),
                    const SizedBox(height: 10),
                    _buildInfoBox(
                      label: 'Pressure',
                      value: '${widget.pressure.toStringAsFixed(2)} bar',
                      size: size,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInfoBox(
      {required String label, required String value, required double size}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4)],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$label: ',
            style: TextStyle(
              fontSize: size * 0.04,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: size * 0.04,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}

class AltimeterPainter extends CustomPainter {
  final double altitude;
  final double minAltitude;
  final double maxAltitude;

  AltimeterPainter({
    required this.altitude,
    required this.minAltitude,
    required this.maxAltitude,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final paint = Paint()..color = Colors.black;

    // Dibujar el círculo principal
    canvas.drawCircle(center, radius, paint);

    // Dibujar las marcas del altímetro (barras más pequeñas)
    final tickPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 1.5;

    final numTicks = 36; // 36 marcas
    for (int i = 0; i < numTicks; i++) {
      final angle = (i * 10) * pi / 180; // Convertir grados a radianes
      final tickStart = Offset(
        center.dx + radius * 0.85 * cos(angle),
        center.dy + radius * 0.85 * sin(angle),
      );
      final tickEnd = Offset(
        center.dx + radius * cos(angle),
        center.dy + radius * sin(angle),
      );
      canvas.drawLine(tickStart, tickEnd, tickPaint);
    }

    // Dibujar la aguja del altímetro
    final needlePaint = Paint()
      ..color = Colors.red
      ..strokeWidth = 3;

    // Calcular el ángulo basado en la altitud con respecto al mínimo y máximo
    final normalizedAltitude =
        (altitude - minAltitude) / (maxAltitude - minAltitude);
    final angle = normalizedAltitude * 2 * pi; // Convertir altitud a ángulo
    final needleEnd = Offset(
      center.dx + radius * 0.7 * cos(angle - pi / 2),
      center.dy + radius * 0.7 * sin(angle - pi / 2),
    );
    canvas.drawLine(center, needleEnd, needlePaint);

    // Dibujar el centro del altímetro (donde se sitúa el avión)
    canvas.drawCircle(center, 5, Paint()..color = Colors.red);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

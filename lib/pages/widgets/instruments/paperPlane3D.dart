import 'package:flutter/material.dart';
import 'dart:math' as math;

class PaperPlane3D extends StatefulWidget {
  final double roll; // Inclinación en el eje Z
  final double pitch; // Inclinación en el eje X
  final double yaw; // Rotación en el eje Y

  // Constructor del widget con parámetros roll y pitch
  const PaperPlane3D({
    super.key,
    required this.roll,
    required this.pitch,
    this.yaw = 0,
  });

  @override
  State<PaperPlane3D> createState() => _PaperPlane3DState();
}

class _PaperPlane3DState extends State<PaperPlane3D> {
  late double _rotationX;
  late double _rotationY;
  late double _rotationZ;

  @override
  void initState() {
    super.initState();
    // Inicializamos los valores de rotación según roll y pitch
    _rotationX = widget.pitch;
    _rotationY = widget.yaw;
    _rotationZ = widget.roll;
  }

  @override
  void didUpdateWidget(PaperPlane3D oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Actualizamos las rotaciones si los valores de roll o pitch cambian
    if (oldWidget.roll != widget.roll || oldWidget.pitch != widget.pitch) {
      setState(() {
        // Convertir pitch a radianes
        _rotationX = -widget.pitch * (math.pi / 180) + 45;
        // Convertir roll a radianes
        _rotationZ = -widget.roll * (math.pi / 180);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Stack(
          alignment: Alignment.center, // Centra los elementos
          children: [
            Container(
              height: constraints.maxHeight - 60,
              width: constraints.maxHeight - 60,
              child: Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()
                  ..rotateX(_rotationX) // Pitch (eje X)
                  ..rotateY(_rotationY) // Rotación Y (libre)
                  ..rotateZ(_rotationZ), // Roll (eje Z)
                child: CustomPaint(
                  size: Size(
                    constraints.maxWidth,
                    constraints.maxHeight,
                  ),
                  painter: PaperPlanePainter(
                    roll: widget.roll,
                    pitch: widget.pitch,
                  ),
                ),
              ),
            )
          ]);
    });
  }
}

// Widget que dibuja el avión de papel
class PaperPlanePainter extends CustomPainter {
  final double roll; // Ángulo de rotación lateral (en grados)
  final double pitch; // Ángulo de cabeceo (en grados)

  PaperPlanePainter({required this.roll, required this.pitch});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final linePaint = Paint()
      ..color = Colors.grey
      ..strokeWidth = 2;

    // Cambiar el color dependiendo de pitch
    if (pitch > 0) {
      paint.color = Colors.white; // Blanco si pitch es positivo
      linePaint.color = Colors.grey;
    } else {
      paint.color = Colors.grey[300]!; // Gris claro si pitch es negativo
      linePaint.color = Colors.black;
    }

    final path = Path();
    path.moveTo(size.width * 0.5, 0); // Punta del avión
    path.lineTo(size.width, size.height); // Ala derecha
    path.lineTo(size.width * 0.5, size.height * 0.7); // Cola
    path.lineTo(0, size.height); // Ala izquierda
    path.close();

    // Dibujar la forma del avión de papel
    canvas.drawPath(path, paint);

    // Dibujar una línea para darle más apariencia de avión
    canvas.drawLine(Offset(size.width * 0.5, 0),
        Offset(size.width * 0.5, size.height * 0.7), linePaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

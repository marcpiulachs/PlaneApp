import 'package:flutter/material.dart';
import 'dart:math' as math;

class PaperPlane3D extends StatefulWidget {
  final double roll;
  final double pitch;
  final double yaw;
  final double pitchOffset;
  final double yawOffset;
  final double rollOffset;

  const PaperPlane3D({
    super.key,
    required this.roll,
    required this.pitch,
    this.yaw = 0,
    this.pitchOffset = 45,
    this.yawOffset = 0,
    this.rollOffset = 0,
  });

  @override
  State<PaperPlane3D> createState() => _PaperPlane3DState();
}

class _PaperPlane3DState extends State<PaperPlane3D> {
  late double _rotationX;
  late double _rotationY;
  late double _rotationZ;

  void _updateRotations() {
    _rotationX = (-widget.pitch + widget.pitchOffset) * (math.pi / 180);
    _rotationY = (widget.roll + widget.rollOffset) * (math.pi / 180);
    _rotationZ = (widget.yaw + widget.yawOffset) * (math.pi / 180);
  }

  @override
  void initState() {
    super.initState();
    _updateRotations();
  }

  @override
  void didUpdateWidget(PaperPlane3D oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.roll != widget.roll ||
        oldWidget.pitch != widget.pitch ||
        oldWidget.yaw != widget.yaw) {
      setState(_updateRotations);
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = constraints.maxHeight - 60;
        return Stack(
          alignment: Alignment.center,
          children: [
            // Sombra proyectada fija (no rota con el avión)
            SizedBox(
              width: size,
              height: size,
              child: const CustomPaint(painter: _PlaneShadowPainter()),
            ),
            // Avión con silueta clásica, rotado en 3D
            SizedBox(
              width: size,
              height: size,
              child: Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()
                  ..rotateX(_rotationX)
                  ..rotateY(_rotationY)
                  ..rotateZ(_rotationZ),
                child: CustomPaint(
                  painter: PaperPlanePainter(
                    roll: widget.roll,
                    pitch: widget.pitch,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

/// Sombra suave que sugiere que el avión flota sobre una superficie.
class _PlaneShadowPainter extends CustomPainter {
  const _PlaneShadowPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black.withValues(alpha: 0.28)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 9);
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width / 2, size.height * 0.82),
        width: size.width * 0.5,
        height: size.width * 0.13,
      ),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant _PlaneShadowPainter oldDelegate) => false;
}

/// Silueta clásica de avión de papel con dos mitades sombreadas (pliegue).
class PaperPlanePainter extends CustomPainter {
  final double roll;
  final double pitch;

  PaperPlanePainter({required this.roll, required this.pitch});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final nose = Offset(w * 0.5, 0);
    final tailBottom = Offset(w * 0.5, h * 0.72);
    final leftTip = Offset(0, h);
    final rightTip = Offset(w, h);

    // Ala derecha (lado sombreado del pliegue)
    final rightPath = Path()
      ..moveTo(nose.dx, nose.dy)
      ..lineTo(rightTip.dx, rightTip.dy)
      ..lineTo(tailBottom.dx, tailBottom.dy)
      ..close();
    canvas.drawPath(
      rightPath,
      Paint()..color = const Color(0xFFD4D4DA),
    );

    // Ala izquierda (lado más iluminado)
    final leftPath = Path()
      ..moveTo(nose.dx, nose.dy)
      ..lineTo(leftTip.dx, leftTip.dy)
      ..lineTo(tailBottom.dx, tailBottom.dy)
      ..close();
    canvas.drawPath(
      leftPath,
      Paint()..color = const Color(0xFFF2F2F5),
    );

    // Pliegue central
    canvas.drawLine(
      nose,
      tailBottom,
      Paint()
        ..color = Colors.black.withValues(alpha: 0.25)
        ..strokeWidth = 1.5,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
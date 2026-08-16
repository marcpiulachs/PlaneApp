import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:paperwings/config/app_theme.dart';

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

  @override
  void initState() {
    super.initState();
    _rotationX = widget.pitch;
    _rotationY = widget.yaw;
    _rotationZ = widget.roll;
  }

  @override
  void didUpdateWidget(PaperPlane3D oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.roll != widget.roll ||
        oldWidget.pitch != widget.pitch ||
        oldWidget.yaw != widget.yaw) {
      setState(() {
        _rotationX = -widget.pitch * (math.pi / 180) + widget.pitchOffset;
        _rotationZ = (widget.yaw + widget.yawOffset) * (math.pi / 180);
        _rotationY = (widget.roll + widget.rollOffset) * (math.pi / 180);
      });
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
            // Horizonte de referencia (oscuro, estilo cabina)
            SizedBox(
              height: size,
              width: size,
              child: CustomPaint(
                painter: _BackdropPainter(roll: widget.roll, pitch: widget.pitch),
              ),
            ),
            SizedBox(
              height: size,
              width: size,
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

/// Fondo oscuro con horizonte que acompaña al avión de papel.
class _BackdropPainter extends CustomPainter {
  final double roll;
  final double pitch;

  _BackdropPainter({required this.roll, required this.pitch});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final horizonY = center.dy + pitch * (size.height / 90);

    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(roll * math.pi / 180);
    canvas.translate(-center.dx, -center.dy);

    final skyRect = Rect.fromLTRB(0, 0, size.width, horizonY);
    canvas.drawRect(
      skyRect,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF1A2333), Color(0xFF2E4057)],
        ).createShader(skyRect),
    );
    final groundRect = Rect.fromLTRB(0, horizonY, size.width, size.height);
    canvas.drawRect(
      groundRect,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF3A3A44), Color(0xFF1C1C22)],
        ).createShader(groundRect),
    );
    canvas.drawLine(
      Offset(0, horizonY),
      Offset(size.width, horizonY),
      Paint()
        ..color = AppTheme.instrumentMark.withValues(alpha: 0.6)
        ..strokeWidth = 2,
    );
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _BackdropPainter oldDelegate) =>
      oldDelegate.roll != roll || oldDelegate.pitch != pitch;
}

class PaperPlanePainter extends CustomPainter {
  final double roll;
  final double pitch;

  PaperPlanePainter({required this.roll, required this.pitch});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final linePaint = Paint()
      ..color = Colors.grey
      ..strokeWidth = 2;

    final path = Path();
    path.moveTo(size.width * 0.5, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width * 0.5, size.height * 0.7);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);
    canvas.drawLine(Offset(size.width * 0.5, 0),
        Offset(size.width * 0.5, size.height * 0.7), linePaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
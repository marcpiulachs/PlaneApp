import 'package:flutter/material.dart';
import 'package:paperwings/models/telemetry.dart';
import 'package:paperwings/config/app_theme.dart';

/// Panel de telemetría estilo MFD (glass cockpit) navegable por páginas.
/// Botones laterales para cambiar el bloque de datos mostrado.
class SensorsData extends StatefulWidget {
  final Telemetry telemetry;

  const SensorsData({
    super.key,
    required this.telemetry,
  });

  @override
  State<SensorsData> createState() => _SensorsDataState();
}

class _SensorsDataState extends State<SensorsData> {
  int _page = 0;

  static const _pageCount = 5;

  void _goTo(int page) {
    setState(() {
      _page = (page + _pageCount) % _pageCount;
    });
  }

  @override
  Widget build(BuildContext context) {
    final t = widget.telemetry;
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF5A5A62),
              AppTheme.instrumentBezel,
              Color(0xFF1C1C20),
            ],
          ),
          borderRadius: BorderRadius.circular(AppRadius.radiusSm),
          border: Border.all(color: Colors.black45, width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.6),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        padding: const EdgeInsets.all(3),
        child: Container(
          decoration: BoxDecoration(
            color: AppTheme.instrumentFace,
            borderRadius: BorderRadius.circular(AppRadius.radiusSm - 2),
            border: Border.all(color: Colors.black, width: 1.5),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.radiusSm - 2),
            child: Stack(
              children: [
                Positioned.fill(
                  child: CustomPaint(
                    painter: const _ScreenGridPainter(),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 8,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _SystemHeader(page: _page, pageCount: _pageCount),
                      const SizedBox(height: 6),
                      const _Divider(),
                      const SizedBox(height: 6),
                      Expanded(
                        child: Row(
                          children: [
                            _NavButton(
                              icon: Icons.chevron_left,
                              onPressed: () => _goTo(_page - 1),
                            ),
                            Expanded(
                              child: _PageScroller(child: _buildPage(t)),
                            ),
                            _NavButton(
                              icon: Icons.chevron_right,
                              onPressed: () => _goTo(_page + 1),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPage(Telemetry t) {
    final column = <Widget>[
      const _BlockTitle('FLIGHT'),
      const SizedBox(height: 6),
      _row('PITCH', '${t.pitch.round()}°'),
      _row('ROLL', '${t.roll.round()}°'),
      _row('YAW', '${t.yaw.round()}°'),
      _row('GYRO', '${t.gyroZ.toStringAsPrecision(2)}°/s'),
    ];
    switch (_page) {
      case 0:
        break;
      case 1:
        column
          ..clear()
          ..addAll([
            const _BlockTitle('ALTITUDE'),
            const SizedBox(height: 6),
            _row('ALT', '${t.altitude.toStringAsFixed(0)} m'),
            _row('PRESS', '${t.barometer.toStringAsFixed(1)} hPa'),
            _row('RATE', '${t.turnRate.toStringAsPrecision(2)}°/s'),
            _row('SLIP', '${t.slip.toStringAsPrecision(2)} g'),
          ]);
        break;
      case 2:
        column
          ..clear()
          ..addAll([
            const _BlockTitle('ACCEL'),
            const SizedBox(height: 6),
            _row('X', '${t.accelX.toStringAsPrecision(2)} g'),
            _row('Y', '${t.accelY.toStringAsPrecision(2)} g'),
            _row('Z', '${(t.accelZ / 500).toStringAsPrecision(2)} g'),
          ]);
        break;
      case 3:
        column
          ..clear()
          ..addAll([
            const _BlockTitle('MAG'),
            const SizedBox(height: 6),
            _row('X', '${t.magX.round()}'),
            _row('Y', '${t.magY.round()}'),
            _row('Z', '${t.magZ.round()}'),
            _row('HDG', '${t.degrees.round()}°'),
          ]);
        break;
      default:
        column
          ..clear()
          ..addAll([
            const _BlockTitle('POWER'),
            const SizedBox(height: 6),
            _row('BATT', '${t.batteryVol.toStringAsPrecision(3)} V'),
            _row('SOC', '${t.batterySoc.toStringAsPrecision(2)}%'),
            _row('M1', t.motor1Speed.toStringAsFixed(0)),
            _row('M2', t.motor2Speed.toStringAsFixed(0)),
          ]);
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: column,
    );
  }

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          SizedBox(
            width: 42,
            child: Text(
              label,
              style: const TextStyle(
                color: AppTheme.instrumentMark,
                fontSize: 10,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontFeatures: [FontFeature.tabularFigures()],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const _NavButton({
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(icon),
      color: AppTheme.instrumentMark,
      iconSize: 20,
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(minWidth: 24, minHeight: 40),
      splashRadius: 16,
    );
  }
}

/// Centra el contenido cuando cabe en el área y permite hacer scroll
/// cuando el alto disponible es menor (evita overflow por abajo).
class _PageScroller extends StatelessWidget {
  final Widget child;

  const _PageScroller({required this.child});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight,
            ),
            child: Center(
              child: child,
            ),
          ),
        );
      },
    );
  }
}

class _SystemHeader extends StatelessWidget {
  final int page;
  final int pageCount;

  const _SystemHeader({required this.page, required this.pageCount});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text(
          'MFD',
          style: TextStyle(
            color: AppTheme.warning,
            fontSize: 12,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          '· TELEMETRY',
          style: TextStyle(
            color: AppTheme.instrumentMark.withValues(alpha: 0.6),
            fontSize: 11,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
        const Spacer(),
        Row(
          children: [
            Container(
              width: 6,
              height: 6,
              decoration: const BoxDecoration(
                color: AppTheme.success,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 4),
            const Text(
              'LIVE',
              style: TextStyle(
                color: AppTheme.success,
                fontSize: 9,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(width: 10),
            Text(
              'P${page + 1}/$pageCount',
              style: const TextStyle(
                color: AppTheme.instrumentMark,
                fontSize: 10,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _BlockTitle extends StatelessWidget {
  final String text;

  const _BlockTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        color: AppTheme.warning,
        fontSize: 11,
        fontWeight: FontWeight.bold,
        letterSpacing: 1.5,
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1,
      color: AppTheme.instrumentMark.withValues(alpha: 0.15),
    );
  }
}

/// Scanlines horizontales sutiles para simular la pantalla del panel.
class _ScreenGridPainter extends CustomPainter {
  const _ScreenGridPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.02)
      ..strokeWidth = 1;

    const spacing = 4.0;
    for (double y = 0; y < size.height; y += spacing) {
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        linePaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:paperwings/config/app_theme.dart';

/// Gráfico de líneas en vivo con aspecto coherente de MFD (glass cockpit).
/// Marco metálico, cara oscura con scanlines, cabecera de sistema y leyenda.
class LineChartWidget extends StatefulWidget {
  final String title;
  final double xValue;
  final double yValue;
  final double zValue;
  final bool showX; // Mostrar o no el eje X
  final bool showY; // Mostrar o no el eje Y
  final bool showZ; // Mostrar o no el eje Z
  final Color xColor; // Color del eje X
  final Color yColor; // Color del eje Y
  final Color zColor; // Color del eje Z
  final String xDescription; // Descripción del eje X
  final String yDescription; // Descripción del eje Y
  final String zDescription; // Descripción del eje Z
  final bool showLegend; // Mostrar u ocultar la leyenda
  final double? minX;
  final double? maxX;
  final double? minY;
  final double? maxY;

  const LineChartWidget({
    super.key,
    required this.title,
    required this.xValue,
    required this.yValue,
    required this.zValue,
    this.showX = true,
    this.showY = true,
    this.showZ = true,
    this.xColor = AppTheme.chartAccelX,
    this.yColor = AppTheme.chartAccelY,
    this.zColor = AppTheme.chartAccelZ,
    this.xDescription = 'X',
    this.yDescription = 'Y',
    this.zDescription = 'Z',
    this.showLegend = true,
    this.minX = double.nan,
    this.maxX = double.nan,
    this.minY = double.nan,
    this.maxY = double.nan,
  });

  @override
  State<LineChartWidget> createState() => _LineChartWidgetState();
}

class _LineChartWidgetState extends State<LineChartWidget> {
  final List<double> _xValues = [];
  final List<double> _yValues = [];
  final List<double> _zValues = [];
  // Número máximo de puntos a mostrar
  final int _maxValues = 100;

  @override
  void didUpdateWidget(LineChartWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Actualiza los valores solo si están habilitados
    if (widget.showX) _updateValues(_xValues, widget.xValue);
    if (widget.showY) _updateValues(_yValues, widget.yValue);
    if (widget.showZ) _updateValues(_zValues, widget.zValue);
  }

  void _updateValues(List<double> values, double newValue) {
    setState(() {
      if (values.length >= _maxValues) {
        // Elimina el valor más antiguo si excede el límite
        values.removeAt(0);
      }
      values.add(newValue);
    });
  }

  @override
  Widget build(BuildContext context) {
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
                    horizontal: 10,
                    vertical: 8,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _ChartHeader(title: widget.title),
                      const SizedBox(height: 6),
                      const _Divider(),
                      const SizedBox(height: 6),
                      Expanded(
                        child: LineChart(
                          LineChartData(
                            gridData: FlGridData(
                              show: true,
                              getDrawingHorizontalLine: (value) => FlLine(
                                color: AppTheme.instrumentMark
                                    .withValues(alpha: 0.1),
                                strokeWidth: 1,
                              ),
                              getDrawingVerticalLine: (value) => FlLine(
                                color: AppTheme.instrumentMark
                                    .withValues(alpha: 0.1),
                                strokeWidth: 1,
                              ),
                            ),
                            titlesData: FlTitlesData(
                              topTitles: const AxisTitles(
                                sideTitles: SideTitles(
                                  reservedSize: 30,
                                  showTitles: false,
                                ),
                              ),
                              rightTitles: const AxisTitles(
                                sideTitles: SideTitles(
                                  reservedSize: 50,
                                  showTitles: true,
                                  minIncluded: false,
                                  maxIncluded: false,
                                ),
                              ),
                              leftTitles: const AxisTitles(
                                sideTitles: SideTitles(
                                  reservedSize: 50,
                                  showTitles: true,
                                  minIncluded: false,
                                  maxIncluded: false,
                                ),
                              ),
                              bottomTitles: const AxisTitles(
                                sideTitles: SideTitles(
                                  reservedSize: 30,
                                  showTitles: false,
                                ),
                              ),
                            ),
                            borderData: FlBorderData(
                              show: false,
                              border: const Border(
                                left: BorderSide(color: Colors.black),
                                bottom: BorderSide(color: Colors.black),
                              ),
                            ),
                            maxX: widget.maxX,
                            minX: widget.minX,
                            maxY: widget.maxY,
                            minY: widget.minY,
                            lineBarsData: [
                              if (widget.showX)
                                _buildLineBarData(_xValues, widget.xColor),
                              if (widget.showY)
                                _buildLineBarData(_yValues, widget.yColor),
                              if (widget.showZ)
                                _buildLineBarData(_zValues, widget.zColor),
                            ],
                          ),
                        ),
                      ),
                      if (widget.showLegend) ...[
                        const SizedBox(height: 6),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (widget.showX)
                              LegendItem(
                                  color: widget.xColor,
                                  text: widget.xDescription),
                            if (widget.showY)
                              LegendItem(
                                  color: widget.yColor,
                                  text: widget.yDescription),
                            if (widget.showZ)
                              LegendItem(
                                  color: widget.zColor,
                                  text: widget.zDescription),
                          ],
                        ),
                      ],
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

  LineChartBarData _buildLineBarData(List<double> values, Color color) {
    return LineChartBarData(
      spots: values
          .asMap()
          .entries
          .map((entry) => FlSpot(entry.key.toDouble(), entry.value))
          .toList(),
      isCurved: true,
      color: color,
      barWidth: 2,
      belowBarData: BarAreaData(show: false),
      dotData: const FlDotData(show: false), // Oculta los puntos en la línea
    );
  }
}

class _ChartHeader extends StatelessWidget {
  final String title;

  const _ChartHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title.toUpperCase(),
          style: const TextStyle(
            color: AppTheme.warning,
            fontSize: 12,
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
          ],
        ),
      ],
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

class LegendItem extends StatelessWidget {
  final Color color;
  final String text;

  const LegendItem({
    super.key,
    required this.color,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8, bottom: 4),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          const SizedBox(width: 6),
          Text(
            text,
            style: AppTheme.bodyMedium,
          ),
        ],
      ),
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
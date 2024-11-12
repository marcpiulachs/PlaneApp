import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

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
    this.xColor = Colors.red,
    this.yColor = Colors.green,
    this.zColor = Colors.blue,
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
    return Column(
      children: [
        Text(
          widget.title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: LineChart(
              LineChartData(
                gridData: const FlGridData(show: true),
                titlesData: const FlTitlesData(
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(
                        reservedSize: 30,
                        showTitles: false,
                      ),
                    ),
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(
                        reservedSize: 50,
                        showTitles: true,
                        minIncluded: false,
                        maxIncluded: false,
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        reservedSize: 50,
                        showTitles: true,
                        minIncluded: false,
                        maxIncluded: false,
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        reservedSize: 30,
                        showTitles: false,
                      ),
                    )),
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
                  if (widget.showX) _buildLineBarData(_xValues, widget.xColor),
                  if (widget.showY) _buildLineBarData(_yValues, widget.yColor),
                  if (widget.showZ) _buildLineBarData(_zValues, widget.zColor),
                ],
              ),
            ),
          ),
        ),
        if (widget.showLegend)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (widget.showX)
                LegendItem(color: widget.xColor, text: widget.xDescription),
              if (widget.showY)
                LegendItem(color: widget.yColor, text: widget.yDescription),
              if (widget.showZ)
                LegendItem(color: widget.zColor, text: widget.zDescription),
            ],
          ),
      ],
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
      barWidth: 8,
      belowBarData: BarAreaData(show: false),
      dotData: const FlDotData(show: false), // Oculta los puntos en la línea
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
      padding: const EdgeInsets.only(left: 8.0, right: 8, bottom: 16),
      child: Row(
        children: [
          Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

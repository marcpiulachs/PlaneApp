import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class LineChartWidget extends StatefulWidget {
  final String title;
  final double xValue;
  final double yValue;
  final double zValue;

  const LineChartWidget({
    required this.title,
    required this.xValue,
    required this.yValue,
    required this.zValue,
    super.key,
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

    // Actualiza los valores para los gráficos
    _updateValues(_xValues, widget.xValue);
    _updateValues(_yValues, widget.yValue);
    _updateValues(_zValues, widget.zValue);
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
                  show: true,
                  border: const Border(
                    left: BorderSide(color: Colors.black),
                    bottom: BorderSide(color: Colors.black),
                  ),
                ),
                lineBarsData: [
                  _buildLineBarData(_xValues, Colors.red),
                  _buildLineBarData(_yValues, Colors.green),
                  _buildLineBarData(_zValues, Colors.blue),
                ],
              ),
            ),
          ),
        ), /*
        const SizedBox(height: 0),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LegendItem(color: Colors.red, text: 'X'),
            const SizedBox(width: 20),
            LegendItem(color: Colors.green, text: 'Y'),
            const SizedBox(width: 20),
            LegendItem(color: Colors.blue, text: 'Z'),
          ],
        ),*/
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
      barWidth: 2,
      belowBarData: BarAreaData(show: false),
    );
  }
}

class LegendItem extends StatelessWidget {
  final Color color;
  final String text;

  const LegendItem({
    required this.color,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
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
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

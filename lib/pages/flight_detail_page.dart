import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:paperwings/models/recorded_item.dart';

class FlightDetailPage extends StatefulWidget {
  final RecordedFlight flight;

  const FlightDetailPage({super.key, required this.flight});

  @override
  State<FlightDetailPage> createState() => _FlightDetailPageState();
}

class _FlightDetailPageState extends State<FlightDetailPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'Detalles del Vuelo',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Colors.white,
          tabs: const [
            Tab(icon: Icon(Icons.info), text: 'Resumen'),
            Tab(icon: Icon(Icons.compass_calibration), text: 'Orientación'),
            Tab(icon: Icon(Icons.speed), text: 'Movimiento'),
            Tab(icon: Icon(Icons.settings_input_antenna), text: 'Sensores'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildSummaryTab(),
          _buildOrientationTab(),
          _buildMotionTab(),
          _buildSensorsTab(),
        ],
      ),
    );
  }

  Widget _buildSummaryTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStatusCard(),
          const SizedBox(height: 16),
          _buildStatsGrid(),
          const SizedBox(height: 16),
          _buildFlightPathCard(),
        ],
      ),
    );
  }

  Widget _buildStatusCard() {
    Color statusColor = widget.flight.hasCrash
        ? Colors.red
        : (widget.flight.hasEmergency ? Colors.orange : Colors.green);
    String statusText = widget.flight.hasCrash
        ? 'CRASH'
        : (widget.flight.hasEmergency ? 'EMERGENCIA' : 'COMPLETADO');

    return Card(
      color: Colors.grey[850],
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: statusColor,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    widget.flight.hasCrash ? Icons.warning : Icons.check,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        statusText,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: statusColor,
                        ),
                      ),
                      Text(
                        widget.flight.formattedDate,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Divider(color: Colors.grey[700]),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildQuickStat(
                    'Duración', widget.flight.formattedDuration, Icons.timer),
                _buildQuickStat('Puntos',
                    '${widget.flight.telemetryData.length}', Icons.analytics),
                _buildQuickStat('Frecuencia', '10 Hz', Icons.insights),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickStat(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.white70, size: 24),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.white70,
          ),
        ),
      ],
    );
  }

  Widget _buildStatsGrid() {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.8,
      children: [
        _buildStatCard(
            'Altitud Máx',
            '${widget.flight.maxAltitude.toStringAsFixed(1)} m',
            Icons.height,
            Colors.blue),
        _buildStatCard(
            'Velocidad Máx',
            '${widget.flight.maxSpeed.toStringAsFixed(1)} m/s',
            Icons.speed,
            Colors.green),
        _buildStatCard(
            'Pitch Máx',
            '${widget.flight.maxPitch.toStringAsFixed(1)}°',
            Icons.swap_vert,
            Colors.orange),
        _buildStatCard(
            'Roll Máx',
            '${widget.flight.maxRoll.toStringAsFixed(1)}°',
            Icons.swap_horiz,
            Colors.purple),
      ],
    );
  }

  Widget _buildStatCard(
      String label, String value, IconData icon, Color color) {
    return Card(
      color: Colors.grey[850],
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFlightPathCard() {
    return Card(
      color: Colors.grey[850],
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Altitud vs Tiempo',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  backgroundColor: Colors.transparent,
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: 20,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color: Colors.grey[700]!,
                        strokeWidth: 1,
                      );
                    },
                  ),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            value.toInt().toString(),
                            style: const TextStyle(
                                color: Colors.white70, fontSize: 10),
                          );
                        },
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            '${value.toInt()}s',
                            style: const TextStyle(
                                color: Colors.white70, fontSize: 10),
                          );
                        },
                      ),
                    ),
                    rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                    topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                  ),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: _getAltitudeData(),
                      isCurved: true,
                      color: Colors.blue,
                      barWidth: 3,
                      dotData: const FlDotData(show: false),
                      belowBarData: BarAreaData(
                        show: true,
                        color: Colors.blue.withOpacity(0.3),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrientationTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          _buildChartCard('Pitch (Cabeceo)', _getPitchData(), Colors.red),
          const SizedBox(height: 16),
          _buildChartCard('Roll (Alabeo)', _getRollData(), Colors.deepPurple),
          const SizedBox(height: 16),
          _buildChartCard('Yaw (Guiñada)', _getYawData(), Colors.lightBlue),
        ],
      ),
    );
  }

  Widget _buildMotionTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          _buildChartCard('Aceleración X', _getAccelXData(), Colors.red),
          const SizedBox(height: 16),
          _buildChartCard('Aceleración Y', _getAccelYData(), Colors.green),
          const SizedBox(height: 16),
          _buildChartCard('Aceleración Z', _getAccelZData(), Colors.blue),
        ],
      ),
    );
  }

  Widget _buildSensorsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          _buildChartCard('Giroscopio X', _getGyroXData(), Colors.pinkAccent),
          const SizedBox(height: 16),
          _buildChartCard('Giroscopio Y', _getGyroYData(), Colors.tealAccent),
          const SizedBox(height: 16),
          _buildChartCard('Giroscopio Z', _getGyroZData(), Colors.amberAccent),
          const SizedBox(height: 16),
          _buildChartCard('Motor 1', _getMotor1Data(), Colors.orange),
          const SizedBox(height: 16),
          _buildChartCard('Motor 2', _getMotor2Data(), Colors.deepOrange),
        ],
      ),
    );
  }

  Widget _buildChartCard(String title, List<FlSpot> data, Color color) {
    return Card(
      color: Colors.grey[850],
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: 1,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color: Colors.grey[700]!,
                        strokeWidth: 1,
                      );
                    },
                  ),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            value.toStringAsFixed(1),
                            style: const TextStyle(
                                color: Colors.white70, fontSize: 10),
                          );
                        },
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        interval: widget.flight.duration / 4,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            '${value.toInt()}s',
                            style: const TextStyle(
                                color: Colors.white70, fontSize: 10),
                          );
                        },
                      ),
                    ),
                    rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                    topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                  ),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: data,
                      isCurved: true,
                      color: color,
                      barWidth: 2,
                      dotData: const FlDotData(show: false),
                      belowBarData: BarAreaData(show: false),
                    ),
                  ],
                ),
                duration: Duration.zero,
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<FlSpot> _getAltitudeData() {
    // Usar datos sintéticos de altitud basados en aceleración Z
    double altitude = 0;
    return widget.flight.telemetryData.asMap().entries.map((entry) {
      altitude +=
          (entry.value.accelZ - 0.7) * 0.1; // Simular cambios de altitud
      return FlSpot(entry.key / 10, altitude.clamp(0, 100));
    }).toList();
  }

  List<FlSpot> _getPitchData() {
    return widget.flight.telemetryData.asMap().entries.map((entry) {
      return FlSpot(entry.key / 10, entry.value.pitch);
    }).toList();
  }

  List<FlSpot> _getRollData() {
    return widget.flight.telemetryData.asMap().entries.map((entry) {
      return FlSpot(entry.key / 10, entry.value.roll);
    }).toList();
  }

  List<FlSpot> _getYawData() {
    return widget.flight.telemetryData.asMap().entries.map((entry) {
      return FlSpot(entry.key / 10, entry.value.yaw);
    }).toList();
  }

  List<FlSpot> _getAccelXData() {
    return widget.flight.telemetryData.asMap().entries.map((entry) {
      return FlSpot(entry.key / 10, entry.value.accelX);
    }).toList();
  }

  List<FlSpot> _getAccelYData() {
    return widget.flight.telemetryData.asMap().entries.map((entry) {
      return FlSpot(entry.key / 10, entry.value.accelY);
    }).toList();
  }

  List<FlSpot> _getAccelZData() {
    return widget.flight.telemetryData.asMap().entries.map((entry) {
      return FlSpot(entry.key / 10, entry.value.accelZ);
    }).toList();
  }

  List<FlSpot> _getGyroXData() {
    return widget.flight.telemetryData.asMap().entries.map((entry) {
      return FlSpot(entry.key / 10, entry.value.gyroX);
    }).toList();
  }

  List<FlSpot> _getGyroYData() {
    return widget.flight.telemetryData.asMap().entries.map((entry) {
      return FlSpot(entry.key / 10, entry.value.gyroY);
    }).toList();
  }

  List<FlSpot> _getGyroZData() {
    return widget.flight.telemetryData.asMap().entries.map((entry) {
      return FlSpot(entry.key / 10, entry.value.gyroZ);
    }).toList();
  }

  List<FlSpot> _getMotor1Data() {
    return widget.flight.telemetryData.asMap().entries.map((entry) {
      return FlSpot(entry.key / 10, entry.value.motor1Speed);
    }).toList();
  }

  List<FlSpot> _getMotor2Data() {
    return widget.flight.telemetryData.asMap().entries.map((entry) {
      return FlSpot(entry.key / 10, entry.value.motor2Speed);
    }).toList();
  }
}

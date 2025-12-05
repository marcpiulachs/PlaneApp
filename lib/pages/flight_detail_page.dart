import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/flight_detail_bloc.dart';
import '../models/recorded_item.dart';

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
    final flightDetailBloc = BlocProvider.of<FlightDetailBloc>(context);
    flightDetailBloc.add(LoadFlightDetail(widget.flight.id));
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
      body: BlocBuilder<FlightDetailBloc, FlightDetailState>(
        builder: (context, state) {
          if (state is FlightDetailLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is FlightDetailError) {
            return Center(
                child: Text(state.message,
                    style: const TextStyle(color: Colors.red)));
          } else if (state is FlightDetailLoaded) {
            return TabBarView(
              controller: _tabController,
              children: [
                _buildSummaryTabWithFlight(state.flight),
                _buildOrientationTabWithFlight(state.flight),
                _buildMotionTabWithFlight(state.flight),
                _buildSensorsTabWithFlight(state.flight),
              ],
            );
          } else {
            return const Center(child: Text('No hay datos'));
          }
        },
      ),
    );
  }

  Widget _buildSummaryTabWithFlight(RecordedFlight flight) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStatusCard(flight),
          const SizedBox(height: 16),
          _buildStatsGrid(flight),
          const SizedBox(height: 16),
          _buildExtraMetrics(flight),
        ],
      ),
    );
  }

  Widget _buildExtraMetrics(RecordedFlight flight) {
    final telemetry = flight.telemetryData;
    if (telemetry.isEmpty) {
      return const SizedBox();
    }
    double maxAccelX =
        telemetry.map((e) => e.accelX).reduce((a, b) => a > b ? a : b);
    double maxAccelY =
        telemetry.map((e) => e.accelY).reduce((a, b) => a > b ? a : b);
    double maxAccelZ =
        telemetry.map((e) => e.accelZ).reduce((a, b) => a > b ? a : b);
    double maxGyroX =
        telemetry.map((e) => e.gyroX).reduce((a, b) => a > b ? a : b);
    double maxGyroY =
        telemetry.map((e) => e.gyroY).reduce((a, b) => a > b ? a : b);
    double maxGyroZ =
        telemetry.map((e) => e.gyroZ).reduce((a, b) => a > b ? a : b);
    double avgPitch = telemetry.map((e) => e.pitch).reduce((a, b) => a + b) /
        telemetry.length;
    double avgRoll =
        telemetry.map((e) => e.roll).reduce((a, b) => a + b) / telemetry.length;
    double avgYaw =
        telemetry.map((e) => e.yaw).reduce((a, b) => a + b) / telemetry.length;
    double maxMotor1 =
        telemetry.map((e) => e.motor1Speed).reduce((a, b) => a > b ? a : b);
    double maxMotor2 =
        telemetry.map((e) => e.motor2Speed).reduce((a, b) => a > b ? a : b);
    double avgMotor1 =
        telemetry.map((e) => e.motor1Speed).reduce((a, b) => a + b) /
            telemetry.length;
    double avgMotor2 =
        telemetry.map((e) => e.motor2Speed).reduce((a, b) => a + b) /
            telemetry.length;

    return Card(
      color: Colors.grey[850],
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Métricas adicionales',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 16,
              runSpacing: 12,
              children: [
                _buildMetric('Aceleración máx X', maxAccelX.toStringAsFixed(2)),
                _buildMetric('Aceleración máx Y', maxAccelY.toStringAsFixed(2)),
                _buildMetric('Aceleración máx Z', maxAccelZ.toStringAsFixed(2)),
                _buildMetric('Giro máx X', maxGyroX.toStringAsFixed(2)),
                _buildMetric('Giro máx Y', maxGyroY.toStringAsFixed(2)),
                _buildMetric('Giro máx Z', maxGyroZ.toStringAsFixed(2)),
                _buildMetric('Pitch medio', avgPitch.toStringAsFixed(2)),
                _buildMetric('Roll medio', avgRoll.toStringAsFixed(2)),
                _buildMetric('Yaw medio', avgYaw.toStringAsFixed(2)),
                _buildMetric('Motor 1 máx', maxMotor1.toStringAsFixed(2)),
                _buildMetric('Motor 2 máx', maxMotor2.toStringAsFixed(2)),
                _buildMetric('Motor 1 medio', avgMotor1.toStringAsFixed(2)),
                _buildMetric('Motor 2 medio', avgMotor2.toStringAsFixed(2)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetric(String label, String value) {
    return SizedBox(
      width: 140,
      child: Row(
        children: [
          Text(
            '$label: ',
            style: const TextStyle(color: Colors.white70, fontSize: 13),
          ),
          Text(
            value,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
          ),
        ],
      ),
    );
  }
}

Widget _buildStatusCard(RecordedFlight flight) {
  Color statusColor = flight.hasCrash
      ? Colors.red
      : (flight.hasEmergency ? Colors.orange : Colors.green);
  String statusText = flight.hasCrash
      ? 'CRASH'
      : (flight.hasEmergency ? 'EMERGENCIA' : 'COMPLETADO');

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
                  flight.hasCrash ? Icons.warning : Icons.check,
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
                      flight.formattedDate,
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
                  'Duración', flight.formattedDuration, Icons.timer),
              _buildQuickStat(
                  'Puntos', '${flight.telemetryData.length}', Icons.analytics),
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

Widget _buildStatsGrid(RecordedFlight flight) {
  return GridView.count(
    crossAxisCount: 2,
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    mainAxisSpacing: 12,
    crossAxisSpacing: 12,
    childAspectRatio: 1.8,
    children: [
      _buildStatCard(
          'Velocidad Máx',
          '${flight.maxSpeed.toStringAsFixed(1)} m/s',
          Icons.speed,
          Colors.green),
      _buildStatCard('Pitch Máx', '${flight.maxPitch.toStringAsFixed(1)}°',
          Icons.swap_vert, Colors.orange),
      _buildStatCard('Roll Máx', '${flight.maxRoll.toStringAsFixed(1)}°',
          Icons.swap_horiz, Colors.purple),
    ],
  );
}

Widget _buildStatCard(String label, String value, IconData icon, Color color) {
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

Widget _buildOrientationTabWithFlight(RecordedFlight flight) {
  return SingleChildScrollView(
    padding: const EdgeInsets.all(16.0),
    child: Column(
      children: [
        _buildChartCard('Pitch (Cabeceo)', _getPitchData(flight), Colors.red),
        const SizedBox(height: 16),
        _buildChartCard(
            'Roll (Alabeo)', _getRollData(flight), Colors.deepPurple),
        const SizedBox(height: 16),
        _buildChartCard('Yaw (Guiñada)', _getYawData(flight), Colors.lightBlue),
      ],
    ),
  );
}

Widget _buildMotionTabWithFlight(RecordedFlight flight) {
  return SingleChildScrollView(
    padding: const EdgeInsets.all(16.0),
    child: Column(
      children: [
        _buildChartCard('Aceleración X', _getAccelXData(flight), Colors.red),
        const SizedBox(height: 16),
        _buildChartCard('Aceleración Y', _getAccelYData(flight), Colors.green),
        const SizedBox(height: 16),
        _buildChartCard('Aceleración Z', _getAccelZData(flight), Colors.blue),
      ],
    ),
  );
}

Widget _buildSensorsTabWithFlight(RecordedFlight flight) {
  return SingleChildScrollView(
    padding: const EdgeInsets.all(16.0),
    child: Column(
      children: [
        _buildChartCard(
            'Giroscopio X', _getGyroXData(flight), Colors.pinkAccent),
        const SizedBox(height: 16),
        _buildChartCard(
            'Giroscopio Y', _getGyroYData(flight), Colors.tealAccent),
        const SizedBox(height: 16),
        _buildChartCard(
            'Giroscopio Z', _getGyroZData(flight), Colors.amberAccent),
        const SizedBox(height: 16),
        _buildChartCard('Motor 1', _getMotor1Data(flight), Colors.orange),
        const SizedBox(height: 16),
        _buildChartCard('Motor 2', _getMotor2Data(flight), Colors.deepOrange),
      ],
    ),
  );
}

Widget _buildChartCard(String title, List<FlSpot> data, Color color) {
  double maxX = data.isNotEmpty
      ? data.map((e) => e.x).reduce((a, b) => a > b ? a : b)
      : 10;
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
                      interval: maxX / 4,
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

List<FlSpot> _getPitchData(RecordedFlight flight) {
  return flight.telemetryData.asMap().entries.map((entry) {
    return FlSpot(entry.key / 10, entry.value.pitch);
  }).toList();
}

List<FlSpot> _getRollData(RecordedFlight flight) {
  return flight.telemetryData.asMap().entries.map((entry) {
    return FlSpot(entry.key / 10, entry.value.roll);
  }).toList();
}

List<FlSpot> _getYawData(RecordedFlight flight) {
  return flight.telemetryData.asMap().entries.map((entry) {
    return FlSpot(entry.key / 10, entry.value.yaw);
  }).toList();
}

List<FlSpot> _getAccelXData(RecordedFlight flight) {
  return flight.telemetryData.asMap().entries.map((entry) {
    return FlSpot(entry.key / 10, entry.value.accelX);
  }).toList();
}

List<FlSpot> _getAccelYData(RecordedFlight flight) {
  return flight.telemetryData.asMap().entries.map((entry) {
    return FlSpot(entry.key / 10, entry.value.accelY);
  }).toList();
}

List<FlSpot> _getAccelZData(RecordedFlight flight) {
  return flight.telemetryData.asMap().entries.map((entry) {
    return FlSpot(entry.key / 10, entry.value.accelZ);
  }).toList();
}

List<FlSpot> _getGyroXData(RecordedFlight flight) {
  return flight.telemetryData.asMap().entries.map((entry) {
    return FlSpot(entry.key / 10, entry.value.gyroX);
  }).toList();
}

List<FlSpot> _getGyroYData(RecordedFlight flight) {
  return flight.telemetryData.asMap().entries.map((entry) {
    return FlSpot(entry.key / 10, entry.value.gyroY);
  }).toList();
}

List<FlSpot> _getGyroZData(RecordedFlight flight) {
  return flight.telemetryData.asMap().entries.map((entry) {
    return FlSpot(entry.key / 10, entry.value.gyroZ);
  }).toList();
}

List<FlSpot> _getMotor1Data(RecordedFlight flight) {
  return flight.telemetryData.asMap().entries.map((entry) {
    return FlSpot(entry.key / 10, entry.value.motor1Speed);
  }).toList();
}

List<FlSpot> _getMotor2Data(RecordedFlight flight) {
  return flight.telemetryData.asMap().entries.map((entry) {
    return FlSpot(entry.key / 10, entry.value.motor2Speed);
  }).toList();
}

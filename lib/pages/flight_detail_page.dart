import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paperwings/config/app_theme.dart';
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
      backgroundColor: AppTheme.backgroundDark,
      appBar: AppBar(
        backgroundColor: AppTheme.surfaceDarker,
        title: const Text(
          'Detalles del Vuelo',
          style: TextStyle(color: AppTheme.textPrimary),
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
                    style: AppTheme.statusError));
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
      padding: AppSpacing.pagePadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStatusCard(flight),
          const SizedBox(height: AppSpacing.spacingLg),
          _buildStatsGrid(flight),
          const SizedBox(height: AppSpacing.spacingLg),
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
      color: AppTheme.cardColor,
      child: Padding(
        padding: AppSpacing.cardPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Métricas adicionales',
              style: AppTheme.heading3,
            ),
            const SizedBox(height: AppSpacing.spacingMd),
            Wrap(
              spacing: AppSpacing.spacingLg,
              runSpacing: AppSpacing.spacingMd,
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
            style: AppTheme.metricLabel,
          ),
          Text(
            value,
            style: AppTheme.metricLabel.copyWith(
              color: AppTheme.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

Widget _buildStatusCard(RecordedFlight flight) {
  Color statusColor = flight.hasCrash
      ? AppTheme.error
      : (flight.hasEmergency ? AppTheme.warning : AppTheme.success);
  String statusText = flight.hasCrash
      ? 'CRASH'
      : (flight.hasEmergency ? 'EMERGENCIA' : 'COMPLETADO');

  return Card(
    color: AppTheme.cardColor,
    child: Padding(
      padding: AppSpacing.cardPadding,
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
              const SizedBox(width: AppSpacing.spacingLg),
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
                      style: AppTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.spacingLg),
          Divider(color: AppTheme.surfaceDarker),
          const SizedBox(height: AppSpacing.spacingSm),
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
      Icon(icon, color: AppTheme.textSecondary, size: 24),
      const SizedBox(height: AppSpacing.spacingXs),
      Text(
        value,
        style: AppTheme.statValue,
      ),
      Text(
        label,
        style: AppTheme.statLabel,
      ),
    ],
  );
}

Widget _buildStatsGrid(RecordedFlight flight) {
  return GridView.count(
    crossAxisCount: 2,
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    mainAxisSpacing: AppSpacing.spacingMd,
    crossAxisSpacing: AppSpacing.spacingMd,
    childAspectRatio: 1.8,
    children: [
      _buildStatCard(
          'Velocidad Máx',
          '${flight.maxSpeed.toStringAsFixed(1)} m/s',
          Icons.speed,
          AppTheme.success),
      _buildStatCard('Pitch Máx', '${flight.maxPitch.toStringAsFixed(1)}°',
          Icons.swap_vert, AppTheme.warning),
      _buildStatCard('Roll Máx', '${flight.maxRoll.toStringAsFixed(1)}°',
          Icons.swap_horiz, AppTheme.chartRoll),
    ],
  );
}

Widget _buildStatCard(String label, String value, IconData icon, Color color) {
  return Card(
    color: AppTheme.cardColor,
    child: Padding(
      padding: const EdgeInsets.all(AppSpacing.spacingMd),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: AppSpacing.spacingSm),
          Text(
            value,
            style: AppTheme.statValue,
          ),
          Text(
            label,
            style: AppTheme.statLabel,
          ),
        ],
      ),
    ),
  );
}

Widget _buildOrientationTabWithFlight(RecordedFlight flight) {
  return SingleChildScrollView(
    padding: AppSpacing.pagePadding,
    child: Column(
      children: [
        _buildChartCard('Pitch (Cabeceo)', _getPitchData(flight), AppTheme.chartPitch),
        const SizedBox(height: AppSpacing.spacingLg),
        _buildChartCard(
            'Roll (Alabeo)', _getRollData(flight), AppTheme.chartRoll),
        const SizedBox(height: AppSpacing.spacingLg),
        _buildChartCard('Yaw (Guiñada)', _getYawData(flight), AppTheme.chartYaw),
      ],
    ),
  );
}

Widget _buildMotionTabWithFlight(RecordedFlight flight) {
  return SingleChildScrollView(
    padding: AppSpacing.pagePadding,
    child: Column(
      children: [
        _buildChartCard('Aceleración X', _getAccelXData(flight), AppTheme.chartAccelX),
        const SizedBox(height: AppSpacing.spacingLg),
        _buildChartCard('Aceleración Y', _getAccelYData(flight), AppTheme.chartAccelY),
        const SizedBox(height: AppSpacing.spacingLg),
        _buildChartCard('Aceleración Z', _getAccelZData(flight), AppTheme.chartAccelZ),
      ],
    ),
  );
}

Widget _buildSensorsTabWithFlight(RecordedFlight flight) {
  return SingleChildScrollView(
    padding: AppSpacing.pagePadding,
    child: Column(
      children: [
        _buildChartCard(
            'Giroscopio X', _getGyroXData(flight), AppTheme.chartGyroX),
        const SizedBox(height: AppSpacing.spacingLg),
        _buildChartCard(
            'Giroscopio Y', _getGyroYData(flight), AppTheme.chartGyroY),
        const SizedBox(height: AppSpacing.spacingLg),
        _buildChartCard(
            'Giroscopio Z', _getGyroZData(flight), AppTheme.chartGyroZ),
        const SizedBox(height: AppSpacing.spacingLg),
        _buildChartCard('Motor 1', _getMotor1Data(flight), AppTheme.chartMotor1),
        const SizedBox(height: AppSpacing.spacingLg),
        _buildChartCard('Motor 2', _getMotor2Data(flight), AppTheme.chartMotor2),
      ],
    ),
  );
}

Widget _buildChartCard(String title, List<FlSpot> data, Color color) {
  double maxX = data.isNotEmpty
      ? data.map((e) => e.x).reduce((a, b) => a > b ? a : b)
      : 10;
  return Card(
    color: AppTheme.cardColor,
    child: Padding(
      padding: AppSpacing.cardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTheme.heading3,
          ),
          const SizedBox(height: AppSpacing.spacingLg),
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
                      color: AppTheme.surfaceDarker,
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
                          style: AppTheme.chartAxis,
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
                          style: AppTheme.chartAxis,
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

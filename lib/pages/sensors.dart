// Widget de gráficos
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paperwings/bloc/sensor_bloc/sensor_bloc.dart';
import 'package:paperwings/models/sensor_data.dart';
import 'package:paperwings/pages/widgets/line_chart.dart';

// Página principal con los gráficos
class SensorGraphPage extends StatelessWidget {
  const SensorGraphPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<SensorBloc, SensorState>(
              builder: (context, state) {
                return LineChartWidget(
                  title: "Gyroscope Data",
                  xValue: state.gyroscopeX,
                  yValue: state.gyroscopeY,
                  zValue: state.gyroscopeZ,
                );
              },
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: BlocBuilder<SensorBloc, SensorState>(
              builder: (context, state) {
                return LineChartWidget(
                  title: "Accelerometer Data",
                  xValue: state.accelerometerX,
                  yValue: state.accelerometerY,
                  zValue: state.accelerometerZ,
                );
              },
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: BlocBuilder<SensorBloc, SensorState>(
              builder: (context, state) {
                return LineChartWidget(
                  title: "Magnamometer Data",
                  xValue: state.magnamometerX,
                  yValue: state.magnamometerY,
                  zValue: state.magnamometerZ,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

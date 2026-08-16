import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paperwings/bloc/motor_settings_bloc/motor_settings_bloc.dart';
import 'package:paperwings/config/app_theme.dart';
import 'package:paperwings/pages/widgets/line_chart.dart';
import 'package:paperwings/widgets/full_width_button.dart';

class MotorSettingsScreen extends StatefulWidget {
  const MotorSettingsScreen({super.key});

  @override
  State<MotorSettingsScreen> createState() => _MotorSettingsScreenState();
}

class _MotorSettingsScreenState extends State<MotorSettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          "Motors",
          style: AppTheme.heading3,
        ),
        const SizedBox(height: AppSpacing.spacingLg),
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: BlocBuilder<MotorSettingsBloc, MotorSettingsState>(
                  builder: (context, state) {
                    return LineChartWidget(
                      title: "Right",
                      xValue: state.slider1Value,
                      yValue: state.motor1Value,
                      zValue: 0,
                      xColor: AppTheme.chartReq,
                      yColor: AppTheme.chartCur,
                      xDescription: "Req.",
                      yDescription: "Current",
                      showLegend: true,
                      showZ: false,
                      minX: 0,
                      maxX: 100,
                      minY: 0,
                      maxY: 100,
                    );
                  },
                ),
              ),
              const SizedBox(width: 0), // Espacio entre los gráficos
              Expanded(
                child: BlocBuilder<MotorSettingsBloc, MotorSettingsState>(
                  builder: (context, state) {
                    return LineChartWidget(
                      title: "Left",
                      xValue: state.slider2Value,
                      yValue: state.motor2Value,
                      zValue: 0,
                      xColor: AppTheme.chartReq,
                      yColor: AppTheme.chartCur,
                      xDescription: "Req.",
                      yDescription: "Current",
                      showLegend: true,
                      showZ: false,
                      minX: 0,
                      maxX: 100,
                      minY: 0,
                      maxY: 100,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: BlocBuilder<MotorSettingsBloc, MotorSettingsState>(
                  builder: (context, state) {
                    return _SliderColumn(
                      requested: state.slider1Value,
                      current: state.motor1Value,
                      onChanged: (value) {
                        context
                            .read<MotorSettingsBloc>()
                            .add(Slider1Changed(value));
                      },
                    );
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: BlocBuilder<MotorSettingsBloc, MotorSettingsState>(
                  builder: (context, state) {
                    return _SliderColumn(
                      requested: state.slider2Value,
                      current: state.motor2Value,
                      onChanged: (value) {
                        context
                            .read<MotorSettingsBloc>()
                            .add(Slider2Changed(value));
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        //const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.all(AppSpacing.spacingMd),
          child: FullWidthButton(
            label: '',
            onPressed: () {
              context.read<MotorSettingsBloc>().add(ToggleArmedState());
            },
            child: BlocBuilder<MotorSettingsBloc, MotorSettingsState>(
              builder: (context, state) {
                return Text(
                  state.isArmed ? "DISARM" : "ARM",
                  style: AppTheme.heading3,
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

class _SliderColumn extends StatelessWidget {
  final double requested;
  final double current;
  final ValueChanged<double> onChanged;

  const _SliderColumn({
    required this.requested,
    required this.current,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final height = constraints.maxHeight;
        final circleSize = height * 0.2;
        final progressStroke = circleSize * 0.15;

        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Indicador circular adaptado
            SizedBox(
              width: circleSize,
              height: circleSize,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CircularProgressIndicator(
                    value: requested / 100,
                    strokeWidth: progressStroke,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Color.lerp(Colors.green, Colors.red, requested / 100)!,
                    ),
                    backgroundColor: Colors.grey[300],
                  ),
                  CircularProgressIndicator(
                    value: current / 100,
                    strokeWidth: progressStroke / 2,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      Colors.white,
                    ),
                    backgroundColor: Colors.transparent,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${current.toInt()}%',
                        style: TextStyle(
                          fontSize: circleSize * 0.25,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${requested.toInt()}%',
                        style: TextStyle(
                          fontSize: circleSize * 0.18,
                          color: AppTheme.whiteSoft,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Slider rotado
            RotatedBox(
              quarterTurns: -1,
              child: Slider(
                value: requested,
                onChanged: onChanged,
                min: 0,
                max: 100,
                divisions: 100,
                activeColor:
                    Color.lerp(Colors.green, Colors.red, requested / 100),
                inactiveColor: Colors.grey[300],
              ),
            ),
          ],
        );
      },
    );
  }
}

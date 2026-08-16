import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paperwings/bloc/fly_bloc/fly_bloc.dart';
import 'package:paperwings/config/app_theme.dart';
import 'package:paperwings/bloc/fly_bloc/fly_event.dart';
import 'package:paperwings/bloc/fly_bloc/fly_state.dart';
import 'package:paperwings/bloc/home_bloc/home_bloc.dart';
import 'package:paperwings/bloc/home_bloc/home_event.dart';
import 'package:paperwings/enum/maneuver_type.dart';
import 'package:paperwings/models/telemetry.dart';
import 'package:paperwings/pages/connect.dart';
import 'package:paperwings/pages/widgets/line_chart.dart';
import 'package:paperwings/pages/widgets/instruments/paper_plane.dart';
import 'package:paperwings/pages/widgets/instruments/attitude.dart';
import 'package:paperwings/pages/widgets/recording_indicator.dart';
import 'package:paperwings/pages/widgets/instruments/turn_coordinator.dart';
import 'package:paperwings/widgets/carousel.dart';
import 'package:paperwings/widgets/circular.dart';
import 'package:paperwings/pages/widgets/instruments/compass.dart';
import 'package:paperwings/pages/widgets/instruments/airspeed_indicator.dart';
import 'package:paperwings/pages/widgets/instruments/sensors_data.dart';
import 'package:paperwings/pages/widgets/instruments/altimeter.dart';
import 'package:paperwings/pages/widgets/instruments/variometer.dart';
import 'package:paperwings/pages/widgets/instruments/tachometer.dart';
import 'package:paperwings/pages/widgets/instruments/voltmeter.dart';
import 'package:paperwings/pages/widgets/instruments/signal_gauge.dart';
import 'package:paperwings/pages/widgets/instruments/g_meter.dart';
import 'package:paperwings/pages/widgets/instruments/flight_clock.dart';
import 'package:paperwings/widgets/throttle.dart';

class Fly extends StatelessWidget {
  const Fly({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FlyBloc, FlyState>(
      // Solo reconstruir la estructura cuando cambie algo que no sea
      // telemetría de alta frecuencia. Los instrumentos se suscriben por
      // separado mediante BlocSelector.
      buildWhen: _shouldRebuild,
      builder: (context, state) {
        if (state is FlyDisconnectedState) {
          return const Connect();
        } else if (state is FlyInitialState) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is FlyLoadedState) {
          return Scaffold(
            backgroundColor: Colors.transparent,
            body: Column(
              children: [
                RecordingIndicator(
                  isRecording: state.isRecording,
                  duration: state.duration,
                ),
                const SizedBox(height: 16),
                const _TopIndicators(),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: const _InstrumentsCarousel(),
                  ),
                ),
                const _BottomControls(),
              ],
            ),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  static bool _shouldRebuild(FlyState previous, FlyState current) {
    if (previous is FlyLoadedState && current is FlyLoadedState) {
      return previous.isArmed != current.isArmed ||
          previous.isRecording != current.isRecording ||
          previous.duration != current.duration ||
          previous.userAction != current.userAction;
    }
    return previous.runtimeType != current.runtimeType;
  }
}

class _TopIndicators extends StatelessWidget {
  const _TopIndicators();

  @override
  Widget build(BuildContext context) {
    return BlocSelector<FlyBloc, FlyState,
        ({int wifiSignal, double batterySoc, double batteryVol})>(
      selector: (state) => state is FlyLoadedState
          ? (
              wifiSignal: state.wifiSignal,
              batterySoc: state.telemetry.batterySoc,
              batteryVol: state.telemetry.batteryVol,
            )
          : (wifiSignal: 0, batterySoc: 0, batteryVol: 0),
      builder: (context, values) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressBar(
                  progress: values.wifiSignal.toDouble(),
                  icon: Icons.radar,
                  color: AppTheme.info,
                  text: '${values.wifiSignal} dBm',
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressBar(
                  progress: values.batterySoc,
                  icon: Icons.battery_full_outlined,
                  color: AppTheme.success,
                  text: '${values.batteryVol.toStringAsPrecision(3)} V',
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressBar(
                  progress: values.batterySoc,
                  icon: Icons.local_gas_station,
                  color: AppTheme.warning,
                  text: '${values.batterySoc.toStringAsPrecision(2)}%',
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

class _InstrumentsCarousel extends StatelessWidget {
  const _InstrumentsCarousel();

  @override
  Widget build(BuildContext context) {
    return BlocSelector<FlyBloc, FlyState, Telemetry>(
      selector: (state) =>
          state is FlyLoadedState ? state.telemetry : Telemetry(),
      builder: (context, telemetry) {
        return CarouselWidget(
          items: [
            PaperPlane3D(
              roll: telemetry.roll.toDouble(),
              pitch: telemetry.pitch.toDouble(),
            ),
            // Botones de maniobra
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _CockpitButton(
                      icon: Icons.loop,
                      color: AppTheme.info,
                      label: 'LOOP',
                      onPressed: () {
                        context
                            .read<FlyBloc>()
                            .add(ManeuverSelectedEvent(ManeuverType.loop));
                      },
                    ),
                    const SizedBox(width: 24),
                    _CockpitButton(
                      icon: Icons.sync,
                      color: AppTheme.warning,
                      label: 'SPIN',
                      onPressed: () {
                        context
                            .read<FlyBloc>()
                            .add(ManeuverSelectedEvent(ManeuverType.spin));
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _CockpitButton(
                      icon: Icons.flight_land,
                      color: AppTheme.success,
                      label: 'LAND',
                      onPressed: () {
                        context
                            .read<FlyBloc>()
                            .add(ManeuverSelectedEvent(ManeuverType.land));
                      },
                    ),
                    const SizedBox(width: 24),
                    _CockpitButton(
                      icon: Icons.flight_takeoff,
                      color: AppTheme.settingsColor,
                      label: 'TAKEOFF',
                      onPressed: () {
                        context
                            .read<FlyBloc>()
                            .add(ManeuverSelectedEvent(ManeuverType.takeoff));
                      },
                    ),
                    const SizedBox(width: 24),
                    _CockpitButton(
                      icon: Icons.threesixty,
                      color: AppTheme.error,
                      label: 'BARREL',
                      onPressed: () {
                        context.read<FlyBloc>().add(
                            ManeuverSelectedEvent(ManeuverType.barrelRoll));
                      },
                    ),
                  ],
                ),
              ],
            ),
            AirspeedIndicator(
              speed: telemetry.motor1Speed,
              minSpeed: 0,
              maxSpeed: 120,
              unit: 'km/h',
            ),
            CompassWidget(
              degrees: telemetry.degrees,
              textColor: Colors.white,
              barsColor: Colors.white,
              showDegrees: true,
              child: const Icon(
                Icons.flight,
                size: 150,
                color: Colors.white,
              ),
            ),
            AttitudeIndicator(
              roll: telemetry.roll.toDouble(),
              pitch: telemetry.pitch.toDouble(),
            ),
            TurnCoordinator(
              // 0: sin giro, 1: giro completo derecha
              turnRate: telemetry.turnRate / 100,
              // 0: sin deslizamiento, valores negativos/positivos indican deslizamiento
              slip: telemetry.slip,
            ),
            SensorsData(
              telemetry: telemetry,
            ),
            Altimeter(
              altitudeMeters: telemetry.altitude,
            ),
            Variometer(
              altitude: telemetry.altitude,
            ),
            Tachometer(
              motor1: telemetry.motor1Speed,
              motor2: telemetry.motor2Speed,
            ),
            Voltmeter(
              batteryVolts: telemetry.batteryVol,
            ),
            SignalGauge(
              signal: telemetry.signal,
            ),
            GMeter(
              accelZ: telemetry.accelZ,
            ),
            const FlightClock(),
            LineChartWidget(
              title: "Engines",
              xValue: telemetry.motor1Speed,
              yValue: telemetry.motor2Speed,
              zValue: 0,
              xColor: AppTheme.success,
              yColor: AppTheme.warning,
              xDescription: "Left",
              yDescription: "Right",
              showLegend: true,
              showZ: false,
              minX: 0,
              maxX: 100,
              minY: 0,
              maxY: 100,
            ),
            LineChartWidget(
              title: "Orientation",
              xValue: telemetry.pitch,
              yValue: telemetry.roll,
              zValue: 0,
              xColor: AppTheme.chartPitch,
              yColor: AppTheme.chartRoll,
              xDescription: "Pitch",
              yDescription: "Roll",
              showLegend: true,
              showZ: false,
              //minX: -90,
              //maxX: 90,
              minY: -90,
              maxY: 90,
            ),
            LineChartWidget(
              title: "Battery",
              xValue: telemetry.batterySoc,
              yValue: 0,
              zValue: 0,
              xColor: AppTheme.success,
              xDescription: "Battery",
              yDescription: "Roll",
              showLegend: true,
              showY: false,
              showZ: false,
              //minX: 0,
              //maxX: 100,
            ),
          ],
          indicatorSize: 10.0,
        );
      },
    );
  }
}

class _CockpitButton extends StatelessWidget {
  const _CockpitButton({
    required this.icon,
    required this.color,
    required this.onPressed,
    this.label,
  });

  final IconData icon;
  final Color color;
  final VoidCallback onPressed;
  final String? label;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: onPressed,
          customBorder: const CircleBorder(),
          child: Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.6),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF5A5A62),
                    AppTheme.instrumentBezel,
                    Color(0xFF1C1C20),
                  ],
                ),
                border: Border.all(color: Colors.black45, width: 1.5),
              ),
              padding: const EdgeInsets.all(3),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color.lerp(color, Colors.white, 0.25)!,
                      color,
                      Color.lerp(color, Colors.black, 0.3)!,
                    ],
                  ),
                  border: Border.all(color: Colors.black, width: 1.5),
                ),
                child: Icon(icon, size: 24, color: Colors.white),
              ),
            ),
          ),
        ),
        if (label != null) ...[
          const SizedBox(height: 4),
          Text(
            label!,
            style: AppTheme.bodySmall.copyWith(fontWeight: FontWeight.bold),
          ),
        ],
      ],
    );
  }
}

class _BottomControls extends StatelessWidget {
  const _BottomControls();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: BlocSelector<FlyBloc, FlyState, double>(
                  selector: (state) =>
                      state is FlyLoadedState ? state.telemetry.motor1Speed : 0,
                  builder: (context, motor1Speed) => CircularProgressBar(
                    progress: motor1Speed / 100.0,
                    icon: Icons.rotate_right,
                    text: '${motor1Speed.toStringAsFixed(0)}%',
                    size: 100.0,
                  ),
                ),
              ),
              _CockpitButton(
                icon: Icons.settings,
                color: AppTheme.mechanicsColor,
                onPressed: () {
                  context.read<HomeBloc>().add(
                        const HomeTabChangedEvent(3),
                      );
                },
              ),
            ],
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Throttle(
                onStateChanged: (ThrottleState state) {
                  context
                      .read<FlyBloc>()
                      .add(SendArmed(state == ThrottleState.armed));
                },
                onThrottleUpdated: (double value) {
                  context.read<FlyBloc>().add(SendThrottle(value.toInt()));
                },
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: BlocSelector<FlyBloc, FlyState, double>(
                  selector: (state) =>
                      state is FlyLoadedState ? state.telemetry.motor2Speed : 0,
                  builder: (context, motor2Speed) => CircularProgressBar(
                    progress: motor2Speed / 100.0,
                    icon: Icons.rotate_left,
                    text: '${motor2Speed.toStringAsFixed(0)}%',
                    size: 100,
                  ),
                ),
              ),
              _CockpitButton(
                icon: Icons.crisis_alert,
                color: AppTheme.recorderColor,
                onPressed: () {
                  context.read<HomeBloc>().add(
                        const HomeTabChangedEvent(2),
                      );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

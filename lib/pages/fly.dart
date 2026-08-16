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
                  backgroundColor: AppTheme.surfaceLight,
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
                  text: '${values.batteryVol.toStringAsPrecision(3)} V',
                  backgroundColor: AppTheme.surfaceLight,
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressBar(
                  progress: values.batterySoc,
                  icon: Icons.local_gas_station,
                  text: '${values.batterySoc.toStringAsPrecision(2)}%',
                  backgroundColor: AppTheme.surfaceLight,
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
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 80,
                          child: ElevatedButton(
                            onPressed: () {
                              context.read<FlyBloc>().add(ManeuverSelectedEvent(
                                  ManeuverType.loop));
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 12.0, horizontal: 16.0),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Icon(Icons.loop, size: 32),
                                SizedBox(height: 4),
                                Text('LOOP'),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: SizedBox(
                          height: 80,
                          child: ElevatedButton(
                            onPressed: () {
                              context.read<FlyBloc>().add(ManeuverSelectedEvent(
                                  ManeuverType.spin));
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 12.0, horizontal: 16.0),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Icon(Icons.sync, size: 32),
                                SizedBox(height: 4),
                                Text('SPIN'),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 80,
                          child: ElevatedButton(
                            onPressed: () {
                              context.read<FlyBloc>().add(ManeuverSelectedEvent(
                                  ManeuverType.land));
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 12.0, horizontal: 16.0),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Icon(Icons.flight_land, size: 32),
                                SizedBox(height: 4),
                                Text('LAND'),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: SizedBox(
                          height: 80,
                          child: ElevatedButton(
                            onPressed: () {
                              context.read<FlyBloc>().add(ManeuverSelectedEvent(
                                  ManeuverType.takeoff));
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 12.0, horizontal: 16.0),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Icon(Icons.flight_takeoff, size: 32),
                                SizedBox(height: 4),
                                Text('TAKEOFF'),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
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
              xColor: AppTheme.backgroundDark,
              yColor: AppTheme.warning,
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
                  selector: (state) => state is FlyLoadedState
                      ? state.telemetry.motor1Speed
                      : 0,
                  builder: (context, motor1Speed) => CircularProgressBar(
                    progress: motor1Speed / 100.0,
                    icon: Icons.rotate_right,
                    text: '${motor1Speed.toStringAsFixed(0)}%',
                    backgroundColor: Colors.white,
                    size: 100.0,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.settings),
                color: Colors.white,
                iconSize: 40,
                padding: const EdgeInsets.all(10.0),
                onPressed: () => {
                  context.read<HomeBloc>().add(
                        const HomeTabChangedEvent(3),
                      )
                },
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(Colors.black),
                  shape: WidgetStateProperty.all(const CircleBorder()),
                ),
              ),
            ],
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Throttle(
                onStateChanged: (ThrottleState state) {
                  context.read<FlyBloc>().add(SendArmed(state == ThrottleState.armed));
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
                  selector: (state) => state is FlyLoadedState
                      ? state.telemetry.motor2Speed
                      : 0,
                  builder: (context, motor2Speed) => CircularProgressBar(
                    progress: motor2Speed / 100.0,
                    icon: Icons.rotate_left,
                    text: '${motor2Speed.toStringAsFixed(0)}%',
                    backgroundColor: Colors.white,
                    size: 100,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.crisis_alert),
                color: Colors.white,
                iconSize: 40,
                padding: const EdgeInsets.all(10.0),
                onPressed: () => {
                  context.read<HomeBloc>().add(
                        const HomeTabChangedEvent(2),
                      )
                },
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(Colors.black),
                  shape: WidgetStateProperty.all(const CircleBorder()),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
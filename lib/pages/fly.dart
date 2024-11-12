import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paperwings/bloc/fly_bloc/fly_bloc.dart';
import 'package:paperwings/bloc/fly_bloc/fly_event.dart';
import 'package:paperwings/bloc/fly_bloc/fly_state.dart';
import 'package:paperwings/bloc/home_bloc/home_bloc.dart';
import 'package:paperwings/bloc/home_bloc/home_event.dart';
import 'package:paperwings/pages/connect.dart';
import 'package:paperwings/pages/widgets/line_chart.dart';
import 'package:paperwings/pages/widgets/maneuvers.dart';
import 'package:paperwings/pages/widgets/instruments/paper_plane.dart';
import 'package:paperwings/pages/widgets/instruments/attitude.dart';
import 'package:paperwings/pages/widgets/recording_indicator.dart';
import 'package:paperwings/pages/widgets/instruments/turn_coordinator.dart';
import 'package:paperwings/widgets/carousel.dart';
import 'package:paperwings/widgets/circular.dart';
import 'package:paperwings/pages/widgets/instruments/compass.dart';
import 'package:paperwings/pages/widgets/instruments/sensors_data.dart';
import 'package:paperwings/widgets/throttle.dart';
import 'dart:developer' as developer;

class Fly extends StatefulWidget {
  const Fly({super.key});

  @override
  State<Fly> createState() => _FlyState();
}

class _FlyState extends State<Fly> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FlyBloc, FlyState>(
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressBar(
                          progress: 0.7,
                          icon: Icons.radar,
                          text: '${state.telemetry.signal}dBI',
                          backgroundColor: Colors.white,
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressBar(
                          progress: state.telemetry.batterySoc
                            ..toStringAsPrecision(2),
                          icon: Icons.battery_full_outlined,
                          text:
                              "${state.telemetry.batteryVol.toStringAsPrecision(3)} V",
                          backgroundColor: Colors.white,
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressBar(
                          progress: state.telemetry.batterySoc.toDouble(),
                          icon: Icons.local_gas_station,
                          text:
                              '${state.telemetry.batterySoc.toStringAsPrecision(2)}%',
                          backgroundColor: Colors.white,
                        ),
                      ],
                    ),
                  ],
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: CarouselWidget(
                      items: [
                        PaperPlane3D(
                          roll: state.telemetry.roll.toDouble(),
                          pitch: state.telemetry.pitch.toDouble(),
                        ),
                        CompassWidget(
                          degrees: state.telemetry.degrees,
                          textColor: Colors.white,
                          barsColor: Colors.white,
                          backgroundColor: Colors.blue,
                          showDegrees: false,
                          child: const Icon(
                            Icons.flight,
                            size: 150,
                            color: Colors.white,
                          ),
                        ),
                        AttitudeIndicator(
                          roll: state.telemetry.roll.toDouble(),
                          pitch: state.telemetry.pitch.toDouble(),
                        ),
                        TurnCoordinator(
                          // 0: sin giro, 1: giro completo derecha
                          turnRate: state.telemetry.turnRate / 100,
                          // 0: sin deslizamiento, valores negativos/positivos indican deslizamiento
                          slip: state.telemetry.slip,
                        ),
                        SensorsData(
                          direction: state.direction,
                          telemetry: state.telemetry,
                        ),
                        LineChartWidget(
                          title: "Engines",
                          xValue: state.telemetry.motor1Speed,
                          yValue: state.telemetry.motor2Speed,
                          zValue: 0,
                          xColor: Colors.green,
                          yColor: Colors.yellow,
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
                          xValue: state.telemetry.pitch,
                          yValue: state.telemetry.roll,
                          zValue: 0,
                          xColor: Colors.green,
                          yColor: Colors.yellow,
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
                          xValue: state.telemetry.batterySoc,
                          yValue: 0,
                          zValue: 0,
                          xColor: Colors.green,
                          xDescription: "Battery",
                          yDescription: "Roll",
                          showLegend: true,
                          showY: false,
                          showZ: false,
                          //minX: 0,
                          //maxX: 100,
                        ),
                        Maneuvers(
                          onManeuverSelected: (int index) {
                            context.read<FlyBloc>().add(SendManeuver(index));
                          },
                        ),
                      ],
                      indicatorSize: 10.0,
                    ),
                  ),
                ),
                SizedBox(
                  height: 250,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: CircularProgressBar(
                              progress: state.telemetry.motor1Speed / 100.0,
                              icon: Icons.rotate_right,
                              text: '${state.telemetry.motor1Speed}%',
                              backgroundColor: Colors.white,
                              size: 100.0,
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
                              backgroundColor:
                                  WidgetStateProperty.all(Colors.black),
                              shape:
                                  WidgetStateProperty.all(const CircleBorder()),
                            ),
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
                              context
                                  .read<FlyBloc>()
                                  .add(SendThrottle(value.toInt()));
                            },
                          ),
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: CircularProgressBar(
                              progress: state.telemetry.motor2Speed / 100.0,
                              icon: Icons.rotate_left,
                              text: '${state.telemetry.motor2Speed}%',
                              backgroundColor: Colors.white,
                              size: 100,
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
                              backgroundColor:
                                  WidgetStateProperty.all(Colors.black),
                              shape:
                                  WidgetStateProperty.all(const CircleBorder()),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
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
}

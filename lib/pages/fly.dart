import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paperwings/bloc/fly_bloc/fly_bloc.dart';
import 'package:paperwings/bloc/fly_bloc/fly_event.dart';
import 'package:paperwings/bloc/fly_bloc/fly_state.dart';
import 'package:paperwings/models/flight_settings.dart';
import 'package:paperwings/pages/connect.dart';
import 'package:paperwings/pages/widgets/instruments/altimeterwidget.dart';
import 'package:paperwings/pages/widgets/maneuvers.dart';
import 'package:paperwings/pages/widgets/instruments/altimeter.dart';
import 'package:paperwings/pages/widgets/instruments/attitude.dart';
import 'package:paperwings/pages/widgets/engine_settings.dart';
import 'package:paperwings/pages/widgets/recording_indicator.dart';
import 'package:paperwings/pages/widgets/instruments/turn_coordinator.dart';
import 'package:paperwings/widgets/carousel.dart';
import 'package:paperwings/widgets/circular.dart';
import 'package:paperwings/pages/widgets/instruments/compass.dart';
import 'package:paperwings/pages/widgets/instruments/plane_direction.dart';
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
                          text: '${state.telemetry.battery}dBI',
                          backgroundColor: Colors.white,
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressBar(
                          progress: 0.7,
                          icon: Icons.height,
                          text:
                              "${(state.telemetry.altitude).toStringAsFixed(2)} m.",
                          backgroundColor: Colors.white,
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressBar(
                          progress: 0.7,
                          icon: Icons.local_gas_station,
                          text: '${state.telemetry.battery}%',
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
                        CompassWidget(
                          degrees: state.telemetry.degrees,
                          textColor: Colors.white,
                          barsColor: Colors.white,
                          showDegrees: false,
                          child: const Icon(
                            Icons.flight,
                            size: 150,
                            color: Colors.white,
                          ),
                        ),
                        AttitudeIndicator(
                          roll: state.direction.roll.toDouble(),
                          pitch: state.direction.pitch.toDouble(),
                        ),
                        Altimeter(
                          altitude: state.telemetry.altitude,
                        ),
                        const TurnCoordinator(
                          // 0: sin giro, 1: giro completo derecha
                          turnRate: 0.5,
                          // 0: sin deslizamiento, valores negativos/positivos indican deslizamiento
                          slip: 0.3,
                        ),
                        PlaneDirection(
                          direction: state.direction,
                          telemetry: state.telemetry,
                        ),
                        Maneuvers(
                          onManeuverSelected: (int index) {
                            context.read<FlyBloc>().add(SendManeuver(index));
                          },
                        ),
                        const AltimeterWidget(
                          minAltitude: 0,
                          maxAltitude: 20, //unit: AltitudeUnit.,
                          altitude: 2,
                          pressure: 3,
                        )
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
                              text: 'Engine',
                              backgroundColor: Colors.white,
                              size: 100.0,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.settings),
                            color: Colors.white,
                            iconSize: 40,
                            padding: const EdgeInsets.all(10.0),
                            onPressed: () =>
                                _showEngineSettingsBottomSheet(context),
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
                              text: 'Engine',
                              backgroundColor: Colors.white,
                              size: 100,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.loop),
                            color: Colors.white,
                            iconSize: 40,
                            padding: const EdgeInsets.all(10.0),
                            onPressed: () =>
                                _showAerobaticManeuversBottomSheet(context),
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

  void _showEngineSettingsBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) => EngineSettings(
        onSettingsChanged: (FlightSettings updatedSettings) {
          // Manejar los ajustes actualizados
          developer.log('Settings changed');
        },
        onFactorySettings: () {
          developer.log('Factory settings');
        },
        onDone: () {
          developer.log('Done');
        },
      ),
      backgroundColor: Colors.transparent,
    );
  }

  void _showAerobaticManeuversBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) => Maneuvers(
        onManeuverSelected: (int index) {
          context.read<FlyBloc>().add(SendManeuver(index));
        },
      ),
      backgroundColor: Colors.transparent,
    );
  }
}

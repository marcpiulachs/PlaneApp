import 'package:flutter/material.dart';
import 'package:object_3d/bloc/fly_bloc/fly_bloc.dart';
import 'package:object_3d/bloc/fly_bloc/fly_event.dart';
import 'package:object_3d/bloc/fly_bloc/fly_state.dart';
import 'package:object_3d/core/flight_settings.dart';
import 'package:object_3d/pages/widgets/aerobatic_maneuvers_bottom_sheet.dart';
import 'package:object_3d/pages/widgets/engine_settings_bottom_sheet.dart';
import 'package:object_3d/pages/widgets/record_indicator.dart';
import 'package:object_3d/widgets/circular.dart';
import 'package:object_3d/widgets/compass.dart';
import 'package:object_3d/widgets/connecting.dart';
import 'package:object_3d/widgets/disconected.dart';
import 'package:object_3d/widgets/plane_direction.dart';
import 'package:object_3d/widgets/throttle.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
        // Verifica el estado y muestra el widget adecuado
        if (state is FlyPlaneConnecting) {
          return const Connecting();
        } else if (state is FlyPlaneDisconnected) {
          return Disconnected(
            onConnect: () {
              context.read<FlyBloc>().add(PlaneClientConnect());
            },
          );
        } else if (state is FlyInitial) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is FlyPlaneConnected) {
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
                              "${(state.telemetry.barometer / 100).toStringAsFixed(2)} m.",
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
                  child: Center(
                      /*
                    child: PlaneDirection(
                      direction: state.direction,
                      telemetry: state.telemetry,
                    ), ,*/
                      child: CompassWidget(
                    degrees: state.telemetry.degrees,
                    size: const Size(250, 250),
                    textColor: Colors.white,
                    barsColor: Colors.white,
                    showDegrees: false,
                    child: const Icon(
                      Icons.flight,
                      size: 150,
                      color: Colors.white,
                    ),
                  )),
                ),
                Expanded(
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
      builder: (BuildContext context) => EngineSettingsBottomSheet(
        settings: FlightSettings(
          steeringAngle: 30.0,
          pitchKp: 0.9,
          pitchRateKp: 1.1,
          rollKp: 1.3,
          rollRateKp: 1.2,
          yawKp: 1.8,
          yawRateKp: 1.0,
          angleOfAttack: 7.5,
        ), // Puedes pasar la configuración actual aquí
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
      builder: (BuildContext context) => AerobaticManeuversBottomSheet(
        onManeuverSelected: (int index) {
          context.read<FlyBloc>().add(SendManeuver(index));
        },
      ),
      backgroundColor: Colors.transparent,
    );
  }
}

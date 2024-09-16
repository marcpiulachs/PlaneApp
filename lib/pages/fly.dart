import 'package:flutter/material.dart';
import 'package:object_3d/bloc/fly_bloc/fly_bloc.dart';
import 'package:object_3d/bloc/fly_bloc/fly_event.dart';
import 'package:object_3d/bloc/fly_bloc/fly_state.dart';
import 'package:object_3d/widgets/circular.dart';
import 'package:object_3d/widgets/compass.dart';
import 'package:object_3d/widgets/connecting.dart';
import 'package:object_3d/widgets/disconected.dart';
import 'package:object_3d/widgets/throttle.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Fly extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FlyBloc, FlyState>(
      builder: (context, state) {
        // Verifica el estado y muestra el widget adecuado
        if (state is FlyConnecting) {
          return const Connecting();
        } else if (state is FlyPlaneDisconnected) {
          return Disconnected(
            onConnect: () {
              context.read<FlyBloc>().add(TcpClientConnect());
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
                Center(
                  child: Container(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Círculo que indica si está grabando
                        Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color:
                                state.duration > 0 ? Colors.red : Colors.grey,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          Duration(seconds: state.duration)
                              .toString()
                              .substring(2, 7),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
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
                    child: CompassWidget(
                      degrees: state.telemetry.degrees,
                      size: const Size(250, 250),
                      textColor: Colors.white,
                      barsColor: Colors.white,
                      showDegrees: false,
                    ),
                  ),
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

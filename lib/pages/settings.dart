import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:object_3d/bloc/ota_bloc/ota_bloc.dart';
import 'package:object_3d/bloc/ota_bloc/ota_event.dart';
import 'package:object_3d/bloc/ota_bloc/ota_state.dart';
import 'package:object_3d/pages/connect.dart';
import 'package:object_3d/pages/widgets/version.dart';

class Settings extends StatefulWidget {
  final VoidCallback onConnectPressed;
  const Settings({super.key, required this.onConnectPressed});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          const Center(
            child: Text(
              "Keep your plane updated",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 50),
          Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                BlocBuilder<OtaBloc, OtaState>(
                  builder: (context, state) {
                    if (state is OtaInitialState) {
                      return const Version(
                        appVersion: "N/A",
                        firmwareVersion: "N/A",
                      );
                    } else if (state is OtaLoadedVersionState) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Version(
                              appVersion: state.appVersion,
                              firmwareVersion: state.devFirmware,
                            ),
                            const SizedBox(height: 20),
                            state.updateAvailable
                                ? Column(
                                    children: [
                                      Text(
                                        'New version ${state.appFirmware} available!',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      ElevatedButton(
                                        onPressed: () {
                                          context
                                              .read<OtaBloc>()
                                              .add(StartUpdateEvent());
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.black,
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 16,
                                          ),
                                        ),
                                        child: const Text(
                                          'UPDATE',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                : const Text(
                                    'No update available, you are running the lastes version',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                          ],
                        ),
                      );
                    } else if (state is OtaGettingVersionState) {
                      return const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(height: 20),
                            CircularProgressIndicator(
                              strokeWidth: 6,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Getting version...',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      );
                    } else if (state is OtaUpdatingState) {
                      return const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(height: 20),
                            CircularProgressIndicator(
                              strokeWidth: 6,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Updating firmware...',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      );
                    } else if (state is OtaUpdateCompletedState) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(height: 20),
                            Icon(
                              state.success ? Icons.check_circle : Icons.error,
                              color: Colors.white,
                              size: 50,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              state.success
                                  ? 'Update completed successfully!'
                                  : 'Update failed!',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () {
                                context
                                    .read<OtaBloc>()
                                    .add(CheckVersionEvent());
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                              ),
                              child: const Text(
                                'Check Again',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            )
                          ],
                        ),
                      );
                    } else if (state is OtaPlaneDisconectedState) {
                      return const Connect();
                    } else if (state is OtaErrorState) {
                      return Column(
                        children: [
                          const SizedBox(height: 20),
                          const Icon(
                            Icons.error,
                            color: Colors.white,
                            size: 50,
                          ),
                          const SizedBox(height: 16),
                          Padding(
                            padding: const EdgeInsets.only(left: 40, right: 40),
                            child: Center(
                              child: Text(
                                state.error,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              context.read<OtaBloc>().add(CheckVersionEvent());
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                            ),
                            child: const Text(
                              'Check Again',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          )
                        ],
                      );
                    }
                    return const Center();
                  },
                ),
                // const SizedBox(height: 24),
                // const Text(
                //   'Información Genérica:',
                //   style: TextStyle(
                //     fontWeight: FontWeight.bold,
                //     fontSize: 18,
                //     color: Colors.white,
                //   ),
                // ),
                // const SizedBox(height: 8),
                // const Text(
                //   'www.pagina.com',
                //   style: TextStyle(fontSize: 16),
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

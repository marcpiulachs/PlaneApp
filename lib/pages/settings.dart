import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paperwings/bloc/ota_bloc/ota_bloc.dart';
import 'package:paperwings/config/app_theme.dart';
import 'package:paperwings/bloc/ota_bloc/ota_event.dart';
import 'package:paperwings/bloc/ota_bloc/ota_state.dart';
import 'package:paperwings/pages/connect.dart';
import 'package:paperwings/pages/widgets/version.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: BlocBuilder<OtaBloc, OtaState>(
        builder: (context, state) {
          if (state is OtaInitialState) {
            return const Center();
          } else if (state is OtaLoadedVersionState) {
            return Column(
              children: [
                const Center(
                  child: Text(
                    "Keep your plane updated",
                    style: AppTheme.heading3,
                  ),
                ),
                const SizedBox(height: 100),
                Versions(
                  appVersion: state.appVersion,
                  devVersion: state.devFirmware,
                ),
                const SizedBox(height: AppSpacing.spacingXl),
                state.updateAvailable
                    ? Column(
                        children: [
                          const Icon(
                            Icons.system_update,
                            color: Colors.white,
                            size: 80,
                          ),
                          const SizedBox(height: AppSpacing.spacingLg),
                          Text(
                            'New version ${state.appFirmware} available!',
                            style: AppTheme.bodyLarge,
                          ),
                          const SizedBox(height: AppSpacing.spacingXl),
                          ElevatedButton(
                            onPressed: () {
                              context.read<OtaBloc>().add(StartUpdateEvent());
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.buttonColor,
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.spacingLg,
                              ),
                            ),
                            child: const Text(
                              'UPDATE FIRMWARE',
                              style: AppTheme.heading3,
                            ),
                          ),
                        ],
                      )
                    : const Column(
                        children: [
                          Icon(
                            Icons.check_circle,
                            color: Colors.white,
                            size: 50,
                          ),
                          SizedBox(height: 16),
                          Padding(
                            padding: EdgeInsets.only(
                              left: 40,
                              right: 40,
                            ),
                            child: Text(
                              'No update available, you are already running the lastest version',
                              style: AppTheme.heading3,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      )
              ],
            );
          } else if (state is OtaGettingVersionState) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    strokeWidth: 6,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Getting version...',
                    style: AppTheme.heading3,
                  ),
                ],
              ),
            );
          } else if (state is OtaUpdatingState) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    strokeWidth: 6,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Updating firmware...',
                    style: AppTheme.heading3,
                  ),
                ],
              ),
            );
          } else if (state is OtaUpdateCompletedState) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    state.success ? Icons.check_circle : Icons.error,
                    color: Colors.white,
                    size: 80,
                  ),
                  const SizedBox(height: AppSpacing.spacingLg),
                  Text(
                    state.success
                        ? 'Update completed successfully!'
                        : 'Update failed!',
                    style: state.success
                        ? AppTheme.statusSuccess
                        : AppTheme.statusError,
                  ),
                  const SizedBox(height: AppSpacing.spacingLg),
                  ElevatedButton(
                    onPressed: () {
                      context.read<OtaBloc>().add(CheckVersionEvent());
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.buttonColor,
                      padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.spacingLg),
                    ),
                    child: const Text(
                      'Check Again',
                      style: AppTheme.heading3,
                    ),
                  )
                ],
              ),
            );
          } else if (state is OtaPlaneDisconectedState) {
            return const Connect();
          } else if (state is OtaErrorState) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error,
                  color: Colors.white,
                  size: 80,
                ),
                const SizedBox(height: AppSpacing.spacingLg),
                Padding(
                  padding: const EdgeInsets.only(left: 40, right: 40),
                  child: Center(
                    child: Text(
                      state.error,
                      style: AppTheme.statusMessage,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.spacingLg),
                ElevatedButton(
                  onPressed: () {
                    context.read<OtaBloc>().add(CheckVersionEvent());
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.buttonColor,
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.spacingLg),
                  ),
                  child: const Text(
                    'CHECK AGAIN',
                    style: AppTheme.heading3,
                  ),
                )
              ],
            );
          }
          return const Center();
        },
      ),
    );
  }
}

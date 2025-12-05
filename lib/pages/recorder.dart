import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paperwings/bloc/recordings_bloc/recordings_bloc.dart';
import 'package:paperwings/config/app_theme.dart';
import 'package:paperwings/bloc/recordings_bloc/recordings_events.dart';
import 'package:paperwings/bloc/recordings_bloc/recordings_states.dart';
import 'package:paperwings/pages/flight_detail_page.dart';

class RecordedFlights extends StatefulWidget {
  const RecordedFlights({super.key});

  @override
  State<RecordedFlights> createState() => _RecordedFlightsState();
}

class _RecordedFlightsState extends State<RecordedFlights> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<RecordedFlightsBloc>(context).add(LoadRecordedFlights());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RecordedFlightsBloc, RecordedFlightsState>(
      builder: (context, state) {
        if (state is RecordedFlightsLoading) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.white),
          );
        } else if (state is RecordedFlightsLoaded) {
          if (state.flights.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.flight_takeoff,
                      size: 100, color: Colors.white.withOpacity(0.3)),
                  const SizedBox(height: 24),
                  Text(
                    'No hay vuelos grabados',
                    style: AppTheme.heading2.copyWith(color: Colors.white70),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tus vuelos aparecerán aquí',
                    style: AppTheme.bodyMedium,
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    const Icon(Icons.analytics, color: Colors.white, size: 24),
                    const SizedBox(width: 12),
                    const Text(
                      "Análisis de Vuelos",
                      style: AppTheme.heading2,
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppTheme.primary.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white, width: 1),
                      ),
                      child: Text(
                        '${state.flights.length} vuelos',
                        style:
                            AppTheme.bodyMedium.copyWith(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: state.flights.length,
                    itemBuilder: (context, index) {
                      final flight = state.flights[index];
                      return Card(
                        color: AppTheme.surfaceDark,
                        elevation: 2,
                        margin: const EdgeInsets.symmetric(
                            vertical: 6.0, horizontal: 12.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: BorderSide(
                            color: flight.hasCrash
                                ? AppTheme.error.withOpacity(0.3)
                                : (flight.hasEmergency
                                    ? AppTheme.warning.withOpacity(0.3)
                                    : AppTheme.success.withOpacity(0.3)),
                            width: 1,
                          ),
                        ),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    FlightDetailPage(flight: flight),
                              ),
                            );
                          },
                          borderRadius: BorderRadius.circular(16),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              children: [
                                Container(
                                  width: 56,
                                  height: 56,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: flight.hasCrash
                                          ? [
                                              AppTheme.error,
                                              AppTheme.error.withOpacity(0.7)
                                            ]
                                          : (flight.hasEmergency
                                              ? [
                                                  AppTheme.warning,
                                                  AppTheme.warning
                                                      .withOpacity(0.7)
                                                ]
                                              : [
                                                  AppTheme.success,
                                                  AppTheme.success
                                                      .withOpacity(0.7)
                                                ]),
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: (flight.hasCrash
                                                ? AppTheme.error
                                                : (flight.hasEmergency
                                                    ? AppTheme.warning
                                                    : AppTheme.success))
                                            .withOpacity(0.3),
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Icon(
                                    flight.hasCrash
                                        ? Icons.warning_rounded
                                        : (flight.hasEmergency
                                            ? Icons.error_outline_rounded
                                            : Icons.flight_takeoff_rounded),
                                    color: Colors.white,
                                    size: 28,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        flight.formattedDate,
                                        style: AppTheme.bodyLarge.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          const Icon(Icons.timer_outlined,
                                              size: 14, color: Colors.white70),
                                          const SizedBox(width: 4),
                                          Text(
                                            flight.formattedDuration,
                                            style: AppTheme.bodyMedium,
                                          ),
                                          const SizedBox(width: 16),
                                          if (flight.hasCrash ||
                                              flight.hasEmergency ||
                                              flight.hasWarning) ...[
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8,
                                                      vertical: 2),
                                              decoration: BoxDecoration(
                                                color: flight.hasCrash
                                                    ? AppTheme.error
                                                        .withOpacity(0.2)
                                                    : (flight.hasEmergency
                                                        ? AppTheme.warning
                                                            .withOpacity(0.2)
                                                        : AppTheme.warning
                                                            .withOpacity(0.2)),
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              child: Text(
                                                flight.hasCrash
                                                    ? 'Crash'
                                                    : (flight.hasEmergency
                                                        ? 'Emergencia'
                                                        : 'Advertencia'),
                                                style:
                                                    AppTheme.bodySmall.copyWith(
                                                  color: flight.hasCrash
                                                      ? AppTheme.error
                                                      : (flight.hasEmergency
                                                          ? AppTheme.warning
                                                          : AppTheme.warning),
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            )
                                          ],
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                const Icon(Icons.chevron_right_rounded,
                                    color: Colors.white54, size: 28),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              if (state.hasMore)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    onPressed: () {
                      // TODO: Cargar más vuelos
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                      backgroundColor: Colors.black,
                    ),
                    child: const Text('MOSTRAR MÁS'),
                  ),
                ),
            ],
          );
        } else if (state is RecordedFlightsError) {
          return Center(
            child: Text(
              state.message,
              style: const TextStyle(color: Colors.white),
            ),
          );
        } else {
          return const Center(
            child: Text(
              'No hay grabaciones',
              style: TextStyle(color: Colors.white),
            ),
          );
        }
      },
    );
  }
}

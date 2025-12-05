import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paperwings/bloc/recordings_bloc/recordings_bloc.dart';
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
                  Icon(Icons.flight_takeoff, size: 80, color: Colors.grey[600]),
                  const SizedBox(height: 16),
                  Text(
                    'No hay vuelos grabados',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[400],
                    ),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              const Text(
                "Análisis de Vuelos",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: state.flights.length,
                    itemBuilder: (context, index) {
                      final flight = state.flights[index];
                      return Card(
                        color: Colors.white,
                        margin: const EdgeInsets.symmetric(
                            vertical: 4.0, horizontal: 8.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    FlightDetailPage(flight: flight),
                              ),
                            );
                          },
                          leading: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: flight.hasCrash
                                  ? Colors.red
                                  : (flight.hasEmergency
                                      ? Colors.orange
                                      : Colors.green),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              flight.hasCrash
                                  ? Icons.warning
                                  : (flight.hasEmergency
                                      ? Icons.error_outline
                                      : Icons.flight),
                              color: Colors.white,
                            ),
                          ),
                          title: Text(
                            flight.formattedDate,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          subtitle: Text(
                            'Duración: ${flight.formattedDuration} • Alt: ${flight.maxAltitude.toStringAsFixed(0)}m',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (flight.hasCrash)
                                const Icon(Icons.close,
                                    color: Colors.red, size: 20),
                              if (flight.hasEmergency)
                                const Icon(Icons.warning_amber,
                                    color: Colors.orange, size: 20),
                              if (flight.hasWarning)
                                const Icon(Icons.error_outline,
                                    color: Colors.amber, size: 20),
                              const SizedBox(width: 8),
                              const Icon(Icons.chevron_right,
                                  color: Colors.grey),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              if (state.hasMore)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      // TODO: Cargar más vuelos
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: const Text(
                      'MOSTRAR MÁS',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
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

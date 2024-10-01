import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paperwings/bloc/recordings_bloc/recordings_bloc.dart';
import 'package:paperwings/bloc/recordings_bloc/recordings_events.dart';
import 'package:paperwings/bloc/recordings_bloc/recordings_states.dart';

class RecordedFlights extends StatelessWidget {
  const RecordedFlights({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RecordedFlightsBloc()..add(LoadRecordedFlights()),
      child: const RecordedFlightsList(),
    );
  }
}

class RecordedFlightsList extends StatelessWidget {
  const RecordedFlightsList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RecordedFlightsBloc, RecordedFlightsState>(
      builder: (context, state) {
        if (state is RecordedFlightsLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is RecordedFlightsLoaded) {
          return Column(
            children: [
              const Center(
                child: Center(
                  child: Text(
                    "Investigate your crashes",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
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
                        margin: const EdgeInsets.all(8.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: ListTile(
                          leading: flight.icon,
                          iconColor: Colors.red,
                          textColor: Colors.black,
                          title: Text(flight.time,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              )),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: flight.additionalIcons,
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
                      // Manejar la acción del botón aquí
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: const Text(
                      'SHOW MORE',
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
          return Center(child: Text(state.message));
        } else {
          return const Center(child: Text('No data'));
        }
      },
    );
  }
}

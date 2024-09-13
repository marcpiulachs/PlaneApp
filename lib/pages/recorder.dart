import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:object_3d/bloc/recordings_bloc/recordings_bloc.dart';
import 'package:object_3d/bloc/recordings_bloc/recordings_states.dart';

import '../bloc/recordings_bloc/recordings_events.dart';

class RecordedFlightsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RecordedFlightsBloc()..add(LoadRecordedFlights()),
      child: RecordedFlightsList(),
    );
  }
}

class RecordedFlightsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RecordedFlightsBloc, RecordedFlightsState>(
      builder: (context, state) {
        if (state is RecordedFlightsLoading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is RecordedFlightsLoaded) {
          return Container(
            child: Column(
              children: [
                Center(
                  child: Container(
                    child: Center(
                      child: const Text(
                        "Investigate your crashes",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16),
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
                          margin: EdgeInsets.all(8.0),
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
                      child: Text(
                        'SHOW MORE',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        minimumSize: Size(double.infinity, 50),
                      ),
                    ),
                  ),
              ],
            ),
          );
        } else if (state is RecordedFlightsError) {
          return Center(child: Text(state.message));
        } else {
          return Center(child: Text('No data'));
        }
      },
    );
  }
}

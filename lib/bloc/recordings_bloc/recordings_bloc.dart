// recorded_flights_bloc.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paperwings/bloc/recordings_bloc/recordings_events.dart';
import 'package:paperwings/bloc/recordings_bloc/recordings_states.dart';
import 'package:paperwings/models/recorded_item.dart';

// Bloc
class RecordedFlightsBloc
    extends Bloc<RecordedFlightsEvent, RecordedFlightsState> {
  RecordedFlightsBloc() : super(RecordedFlightsInitial()) {
    on<LoadRecordedFlights>(
      (event, emit) {
        emit(RecordedFlightsLoading());
        try {
          // Aquí deberías hacer la llamada a tu API o fuente de datos.
          // Este es solo un ejemplo estático.
          List<RecordedFlight> flights = List.generate(
            20,
            (index) => RecordedFlight(
              const Icon(Icons.flight),
              '0${index + 1}:00 min',
              [
                const Icon(Icons.car_crash_sharp),
                const Icon(Icons.star_border),
                const Icon(Icons.star_half)
              ],
            ),
          );
          emit(RecordedFlightsLoaded(flights, true));
        } catch (e) {
          emit(RecordedFlightsError('Failed to load recorded flights.'));
        }
      },
    );
  }
}

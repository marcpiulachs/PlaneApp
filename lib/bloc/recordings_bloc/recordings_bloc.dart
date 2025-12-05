import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paperwings/bloc/recordings_bloc/recordings_events.dart';
import 'package:paperwings/bloc/recordings_bloc/recordings_states.dart';
import 'package:paperwings/repositories/recorder_repository.dart';

// Bloc
class RecordedFlightsBloc
    extends Bloc<RecordedFlightsEvent, RecordedFlightsState> {
  final RecorderRepository repository;
  RecordedFlightsBloc({required this.repository})
      : super(RecordedFlightsInitial()) {
    on<LoadRecordedFlights>(
      (event, emit) async {
        emit(RecordedFlightsLoading());
        try {
          var flights = await repository.fetchRecordings();
          emit(RecordedFlightsLoaded(flights, true));
        } catch (e) {
          emit(RecordedFlightsError('Failed to load recorded flights.'));
        }
      },
    );
  }
}

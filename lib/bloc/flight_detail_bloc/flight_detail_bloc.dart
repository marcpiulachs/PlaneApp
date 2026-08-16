import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paperwings/bloc/flight_detail_bloc/flight_detail_event.dart';
import 'package:paperwings/bloc/flight_detail_bloc/flight_detail_state.dart';
import 'package:paperwings/repositories/recorder_repository.dart';

class FlightDetailBloc extends Bloc<FlightDetailEvent, FlightDetailState> {
  final RecorderRepository repository;

  FlightDetailBloc({required this.repository}) : super(FlightDetailInitial()) {
    on<LoadFlightDetail>(_onLoadFlightDetail);
  }

  Future<void> _onLoadFlightDetail(
    LoadFlightDetail event,
    Emitter<FlightDetailState> emit,
  ) async {
    emit(FlightDetailLoading());
    try {
      final flight = await repository.getFlightById(event.flightId);
      if (flight == null) {
        emit(FlightDetailError('Vuelo no encontrado'));
      } else {
        emit(FlightDetailLoaded(flight));
      }
    } catch (e) {
      emit(FlightDetailError(e.toString()));
    }
  }
}
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/recorded_item.dart';
import '../repositories/recorder_repository.dart';

// Events
abstract class FlightDetailEvent {}

class LoadFlightDetail extends FlightDetailEvent {
  final String flightId;
  LoadFlightDetail(this.flightId);
}

// States
abstract class FlightDetailState {}

class FlightDetailInitial extends FlightDetailState {}

class FlightDetailLoading extends FlightDetailState {}

class FlightDetailLoaded extends FlightDetailState {
  final RecordedFlight flight;
  FlightDetailLoaded(this.flight);
}

class FlightDetailError extends FlightDetailState {
  final String message;
  FlightDetailError(this.message);
}

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

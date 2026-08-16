import 'package:paperwings/models/recorded_item.dart';

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
// Estados
import 'package:object_3d/models/recorded_item.dart';

abstract class RecordedFlightsState {}

class RecordedFlightsInitial extends RecordedFlightsState {}

class RecordedFlightsLoading extends RecordedFlightsState {}

class RecordedFlightsLoaded extends RecordedFlightsState {
  final List<RecordedFlight> flights;
  final bool hasMore;

  RecordedFlightsLoaded(this.flights, this.hasMore);
}

class RecordedFlightsError extends RecordedFlightsState {
  final String message;

  RecordedFlightsError(this.message);
}

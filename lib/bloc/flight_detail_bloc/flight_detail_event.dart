abstract class FlightDetailEvent {}

class LoadFlightDetail extends FlightDetailEvent {
  final String flightId;
  LoadFlightDetail(this.flightId);
}
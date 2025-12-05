import 'package:paperwings/models/recorded_item.dart';
import '../core/database_helper.dart';

class RecorderRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  Future<List<RecordedFlight>> fetchRecordings() async {
    final flights = await _dbHelper.getAllFlights();

    // Cargar telemetría para cada vuelo
    final flightsWithTelemetry = <RecordedFlight>[];
    for (var flight in flights) {
      final telemetry =
          await _dbHelper.getTelemetryForFlight(int.parse(flight.id));
      flightsWithTelemetry.add(RecordedFlight(
        id: flight.id,
        timestamp: flight.timestamp,
        duration: flight.duration,
        telemetryData: telemetry,
        maxAltitude: flight.maxAltitude,
        maxSpeed: flight.maxSpeed,
        maxPitch: flight.maxPitch,
        maxRoll: flight.maxRoll,
        status: flight.status,
      ));
    }

    return flightsWithTelemetry;
  }

  Future<RecordedFlight?> getFlightById(String id) async {
    return await _dbHelper.getFlightById(int.parse(id));
  }

  Future<int> saveFlight(RecordedFlight flight) async {
    // Guardar el vuelo y obtener su ID
    final flightId = await _dbHelper.insertFlight(flight);

    // Guardar la telemetría
    if (flight.telemetryData.isNotEmpty) {
      await _dbHelper.insertTelemetry(flightId, flight.telemetryData);
    }

    return flightId;
  }

  Future<void> deleteFlight(String id) async {
    await _dbHelper.deleteFlight(int.parse(id));
  }
}

import 'package:paperwings/models/recorded_item.dart';
import '../core/database_helper.dart';

class RecorderRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  Future<List<RecordedFlight>> fetchRecordings() async {
    return await _dbHelper.getAllFlights();
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

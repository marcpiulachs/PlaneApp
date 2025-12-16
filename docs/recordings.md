# Recordings

How flights are recorded and surfaced in the app.

## Components
- RecorderRepository: stores and fetches recordings (sqflite-backed).
- RecordedFlightsBloc: exposes list/state of stored flights.
- FlightDetailBloc: exposes detail for a selected recording.

## Flow (expected)
- Start recording when a flight session begins; stop when landing/end is detected or the user stops it.
- Persist telemetry and metadata (e.g., timestamps, plane model, settings snapshot when available).
- Display list in UI via RecordedFlightsBloc; open detail via FlightDetailBloc.

## Storage
- Uses sqflite; data is stored in the app sandbox on device.
- Consider pruning or size limits if recordings grow large.

## Testing
- Unit test RecorderRepository with an in-memory or temp sqflite database.
- Bloc tests for list/detail loading, empty states, and error paths.

## Future improvements
- Export/import recordings (e.g., JSON or CSV).
- Add filtering and search (by date, plane, duration).
- Add summaries and charts (fl_chart) per flight.

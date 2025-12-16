# Paperwings

Flutter app to control and monitor a motorized paper plane over Wi-Fi. Uses Flutter + BLoC to orchestrate connection, telemetry, configuration, and firmware updates.

## Overview
- Platforms: Android and iOS.
- Use case: connect to the plane via TCP (default 192.168.4.1:3333), send flight commands, read sensors, and record flights.
- Key tech: Flutter, flutter_bloc, provider, event_bus, sensors_plus, sqflite, fl_chart.
- Assets: three plane models (assets/planes/) and firmware binary (assets/firmware/pfw.bin).

## Architecture
- Flutter UI with theme in `config/app_theme.dart`.
- State layer via BLoC (`lib/bloc/*`) and `provider` for dependency injection.
- Network clients (`lib/clients/`) implementing `IPlaneClient`; TCP and mock variants.
- Repositories (`lib/repositories/`) for planes and recordings (`RecorderRepository`).
- EventBus to broadcast cross-cutting events (e.g., plane selection and settings).

## Key BLoCs
- `FlyBloc`: flight commands and input mapping to the TCP client.
- `SensorBloc`: real-time sensor streaming.
- `OrientationBloc`: orientation/IMU state.
- `PlaneSettingsBloc` and `MotorSettingsBloc`: plane parameter configuration.
- `PlaneCarouselBloc`: plane selection and UI state.
- `ConnectBloc`: TCP connection lifecycle.
- `OtaBloc`: firmware updates.
- `CalibrationBloc`: sensor calibration flow.
- `RecordedFlightsBloc` and `FlightDetailBloc`: local recording management and detail.

## Critical flows
- **Connection**: `TcpPlaneClient` defaults to 192.168.4.1:3333; swap for `MockPlaneClient` for offline dev.
- **Flight/controls**: `FlyBloc` sends control commands; validates sensor-derived states.
- **Sensors and orientation**: `SensorBloc` + `OrientationBloc` consume `sensors_plus`.
- **OTA**: `OtaBloc` uses `assets/firmware/pfw.bin`; ensure stable power and connection first.
- **Recording**: `RecorderRepository` stores flights in SQLite (sqflite); `FlightDetailBloc` exposes details.

## Requirements and setup
- Flutter SDK 3.5.4 or newer.
- Android minSdk 21.
- Assets declared in `pubspec.yaml` (planes and firmware) included.
- Expected permissions: network/Wi-Fi; sensors (IMU) via `sensors_plus`.

## Quick structure
- `lib/main.dart`: dependency injection and theme.
- `lib/bloc/`: domain BLoCs (flight, connection, settings, OTA, recordings, sensors, orientation, carousel, calibration).
- `lib/clients/`: `IPlaneClient`, `TcpPlaneClient`, `MockPlaneClient`.
- `lib/repositories/`: `PlaneRepository`, `RecorderRepository`.
- `assets/`: plane models and firmware.

## Run
- Local (TCP): in `main.dart`, `TcpPlaneClient(host: '192.168.4.1', port: 3333)`; adjust if device uses another IP/port.
- Simulated: uncomment `MockPlaneClient` in `main.dart` for hardware-free development.
- Typical commands:
	- `flutter pub get`
	- `flutter run` (or `flutter run -d <device>`)
	- `flutter test` (once tests are added)

## Testing
No suites included yet. Recommended:
- Unit tests for critical BLoCs (`fly`, `connect`, `ota`, `sensor`).
- Widget tests for home/telemetry screens.
- OTA smoke test with mock client.

## Contributing
- Follow `analysis_options.yaml` lints.
- Keep BLoCs small and focused; avoid business logic in widgets.
- Document new events/states in their BLoCs.

## Roadmap / open items
- Automatic reconnection if the socket drops.
- Persistent metrics/logs for diagnostics.
- Regression tests for OTA and motors.

## License
Private (pub.dev publishing disabled). Ask for authorization before redistribution.

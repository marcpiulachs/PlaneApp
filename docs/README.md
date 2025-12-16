# Paperwings docs

Reference guide to understand and contribute to the app.

## Index
- Overview
- Architecture (see docs/architecture.md)
- BLoC and state (see docs/blocs.md)
- Clients (see docs/clients.md)
- OTA (see docs/ota.md)
- Recordings (see docs/recordings.md)
- Critical flows (see docs/flows.md)
- Setup and requirements (see docs/setup.md)
- Run and build (see docs/setup.md)
- Testing (see docs/testing.md)
- Contributing (see docs/contributing.md)
- Troubleshooting (see docs/troubleshooting.md)
- Roadmap

## Overview
- Flutter app to control and monitor a motorized paper plane via Wi-Fi.
- Default TCP client (192.168.4.1:3333) and mock client for hardware-free development.
- Platforms: Android and iOS.
- Tech: Flutter, flutter_bloc, provider, event_bus, sensors_plus, sqflite, fl_chart.

## Architecture
- Flutter UI with theme in config/app_theme.dart.
- State layer with BLoC in lib/bloc and provider for dependency injection.
- Network clients in lib/clients/ with IPlaneClient and TcpPlaneClient/MockPlaneClient implementations.
- Repositories in lib/repositories/ for planes and recordings.
- EventBus to publish cross-cutting events (e.g., plane selection, settings changes).

## Critical flows
- Connection: TcpPlaneClient to 192.168.4.1:3333; switch to MockPlaneClient in main.dart for offline dev.
- Flight/controls: FlyBloc maps inputs to TCP commands and validates sensor state.
- Sensors and orientation: SensorBloc and OrientationBloc consume sensors_plus.
- OTA: OtaBloc uses assets/firmware/pfw.bin; needs stable connection and battery.
- Recordings: RecorderRepository + RecordedFlightsBloc/FlightDetailBloc store and display flights via sqflite.

## Setup and requirements
- Flutter SDK 3.5.4 or newer.
- Android minSdk 21.
- Assets declared in pubspec.yaml: plane models (assets/planes/) and firmware (assets/firmware/pfw.bin).
- Permissions: network/Wi-Fi and sensors (IMU) handled by sensors_plus.

## Run and build
- Dependencies: `flutter pub get`.
- Typical run: `flutter run` or `flutter run -d <device>`.
- Swap client: in lib/main.dart choose TcpPlaneClient or MockPlaneClient.
- (Optional) add env/flavor flag to pick the client automatically.

## Testing
- No suites yet. Recommended:
  - Unit tests for FlyBloc, ConnectBloc, OtaBloc, SensorBloc.
  - Widget tests for home/telemetry screens.
  - OTA smoke test with mock client.

## Roadmap
- Socket auto-reconnect.
- Persistent logs/metrics for diagnostics.
- Regression suite for OTA and motors.

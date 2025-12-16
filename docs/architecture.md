# Architecture

High-level structure and dependencies.

## Layers
- UI: Flutter widgets themed via config/app_theme.dart.
- State: BLoC classes under lib/bloc for domain concerns (flight, connection, settings, OTA, recordings, sensors, orientation, carousel, calibration, home).
- Clients: IPlaneClient interface with TcpPlaneClient and MockPlaneClient under lib/clients.
- Repositories: lib/repositories (PlaneRepository, RecorderRepository) for data access and caching.
- Event bus: event_bus to broadcast cross-cutting events.

## Dependency injection
- Done in lib/main.dart using provider + BlocProvider.
- EventBus and IPlaneClient are provided once and read by dependent BLoCs.

## Data flow
- UI dispatches events to BLoCs.
- BLoCs call clients/repositories, update state streams consumed by UI.
- EventBus carries shared signals (e.g., plane selection, settings) across BLoCs.

## Assets
- Plane images: assets/planes/*.png
- Firmware: assets/firmware/pfw.bin

## Build targets
- Android (minSdk 21), iOS. No web/desktop targets declared.

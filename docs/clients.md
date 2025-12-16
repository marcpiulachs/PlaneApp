# Clients (TCP and mock)

How the app talks to the plane and how to switch between real and simulated backends.

## IPlaneClient
- Contract used by BLoCs to send/receive plane messages.
- Implementations: `TcpPlaneClient`, `MockPlaneClient`.
- Keep I/O async and avoid blocking the UI thread.

## TcpPlaneClient
- Default target: host 192.168.4.1, port 3333 (see lib/main.dart).
- Responsibilities: open TCP socket, send control/OTA frames, parse responses/events.
- Recommended behavior (if extending): timeouts, retries with backoff, and explicit close on app pause/exit.
- Network tips:
  - Ensure the mobile device is connected to the plane's Wi-Fi AP.
  - Handle loss of Wi-Fi gracefully; surface errors to ConnectBloc.

## MockPlaneClient
- Purpose: develop and test without hardware.
- Should simulate connection lifecycle, control acknowledgements, sensor streams, and OTA progress.
- Enable in lib/main.dart by swapping the provider from TcpPlaneClient to MockPlaneClient.

## Switching clients
- Manual: edit lib/main.dart and toggle the provider implementation.
- Optional: add an environment flag or build flavor to pick the client automatically (e.g., DEBUG -> mock, RELEASE -> TCP).
- Keep the interface stable so BLoCs remain agnostic to transport.

## Future improvements
- Auto-reconnect with capped backoff.
- Telemetry logging around connect/disconnect and socket errors.
- Pluggable transports (e.g., BLE) behind the same IPlaneClient interface.

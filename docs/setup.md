# Setup and requirements

## Prerequisites
- Flutter SDK 3.5.4 or newer.
- Android minSdk 21; iOS supported.
- Device connected to plane Wi-Fi for real hardware tests.

## Dependencies
- Get packages: `flutter pub get`
- Assets declared in pubspec.yaml are required (assets/planes/*.png, assets/firmware/pfw.bin).

## Environment selection
- In lib/main.dart choose TcpPlaneClient (real) or MockPlaneClient (simulated).
- Optionally gate by an env var or flavor: e.g., DEBUG -> mock, RELEASE -> TCP.

## Running
- `flutter run` (or `flutter run -d <device>`)
- For clean rebuilds: `flutter clean` then `flutter pub get`.

## Troubleshooting setup
- If assets missing, ensure pubspec.yaml has proper indentation and rerun `flutter pub get`.
- If TCP connect fails, verify phone is on the plane's Wi-Fi and IP/port match (default 192.168.4.1:3333).

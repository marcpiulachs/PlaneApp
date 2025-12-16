# Testing

Current status: no suites committed yet. Suggested plan:

## Unit tests
- BLoC: FlyBloc, ConnectBloc, OtaBloc, SensorBloc, PlaneSettingsBloc.
- Repositories: RecorderRepository (with in-memory/temp sqflite), PlaneRepository if logic exists.

## Widget tests
- Home/telemetry screens: render with mocked BLoCs to validate states and UI toggles.
- OTA screen: progress and error rendering.

## Integration/smoke
- MockPlaneClient end-to-end: connection -> flight commands -> sensor stream -> recording -> OTA.
- OTA failure cases: mid-transfer drop, checksum error, retry prompt.

## Tooling
- Run: `flutter test`
- Consider golden tests only after UI stabilizes.

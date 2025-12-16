# Troubleshooting

Common issues and quick checks.

## Connection fails
- Verify device is on plane Wi-Fi; confirm IP/port (default 192.168.4.1:3333).
- Try MockPlaneClient to isolate UI/BLoC from network issues.
- Add logging around ConnectBloc to capture socket errors/timeouts.

## OTA stuck or fails
- Ensure assets/firmware/pfw.bin is bundled; run `flutter pub get`.
- Require stable connection and battery; avoid auto-retry mid-transfer.
- Check for checksum/size mismatches; if so, repackage firmware.

## Sensors not updating
- Ensure SensorBloc stream is started and not blocked by errors.
- On mock, verify simulated sensor events are emitted.
- On device, confirm sensors_plus permissions and hardware availability.

## Recordings not saved
- Check sqflite initialization and storage permissions (if any platform prompts).
- Validate RecorderRepository error handling; inspect logs for exceptions.

## Assets missing in UI
- Confirm pubspec.yaml asset paths and indentation.
- Run `flutter clean` then `flutter pub get` if assets were recently added.

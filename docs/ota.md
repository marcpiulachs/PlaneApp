# OTA (firmware update)

How firmware updates flow through the app.

## Assets
- Firmware binary: assets/firmware/pfw.bin (declared in pubspec.yaml).
- Bundled with the app; replace the file to ship a new build.

## Flow
- Trigger: OtaBloc starts a transfer via IPlaneClient.
- Steps (recommended):
  1) Pre-checks: connection status, battery level on plane, sufficient device battery.
  2) Transfer: stream firmware bytes over TCP.
  3) Verification: checksum/size confirmation (client/firmware dependent).
  4) Apply/reboot: plane reboots into new firmware.
- States surfaced by OtaBloc: ready, transferring, verified, error, canceled.

## UX/guardrails
- Disable flight controls during OTA.
- Show progress with clear failure reasons (timeout, checksum mismatch, lost link).
- Require explicit user confirmation before starting.
- Block start if not connected or if battery is low (when that info is available).

## Testing
- Use MockPlaneClient to simulate success/fail and edge cases (mid-transfer drop, checksum error).
- Add a smoke test that runs OTA end-to-end in mock mode.

## Troubleshooting
- If the socket drops, surface an actionable retry; avoid auto-retries that could brick the device.
- Validate the firmware asset is packaged (flutter pub get; flutter clean if needed).
- Confirm target IP/port are reachable and the plane is in update-ready mode.

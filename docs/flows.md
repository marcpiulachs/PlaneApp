# Critical flows

Key end-to-end flows and their owners.

## Connection
- Owner: ConnectBloc
- Path: UI -> ConnectBloc -> IPlaneClient (Tcp/Mock)
- States: connecting, connected, disconnected, error
- Tips: retry with backoff; surface clear errors; close socket on dispose/app pause.

## Flight control
- Owner: FlyBloc
- Path: UI inputs -> FlyBloc -> IPlaneClient commands -> plane
- Dependencies: EventBus (plane selection/settings), SensorBloc data for validation
- Guardrails: block commands if not connected; handle ack/timeouts; debounce rapid inputs if needed.

## Sensors and orientation
- Owner: SensorBloc, OrientationBloc
- Path: IPlaneClient stream -> SensorBloc -> UI; sensors_plus -> OrientationBloc -> UI
- Consider filtering/noise handling for UI stability.

## OTA
- Owner: OtaBloc
- Path: UI -> OtaBloc -> IPlaneClient (firmware bytes) -> plane -> reboot
- Guardrails: require connected state; show progress; stop flight controls during update.

## Calibration
- Owner: CalibrationBloc
- Path: UI -> CalibrationBloc -> IPlaneClient steps -> UI feedback
- Ensure steps are sequential and cancellable.

## Recordings
- Owners: RecordedFlightsBloc, FlightDetailBloc, RecorderRepository
- Path: Sensor/flight data -> RecorderRepository (sqflite) -> RecordedFlightsBloc list -> UI; details via FlightDetailBloc
- Consider size limits and export/import in future.

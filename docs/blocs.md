# BLoC and state flows

Summary of the main BLoCs and how they interact with clients, repositories, and UI.

## FlyBloc
- Purpose: send flight commands to the plane and handle responses.
- Depends on: IPlaneClient, EventBus.
- Typical events: start/stop motor, adjust rudder/ailerons, flight modes.
- State: pending commands, send errors, confirmations.

## SensorBloc
- Purpose: stream real-time sensors (IMU, speed, altitude if available).
- Depends on: IPlaneClient.
- Events: start/stop sensor stream.
- State: raw/filtered data for UI and validations.

## OrientationBloc
- Purpose: expose plane orientation/attitude using sensors_plus.
- Depends on: IPlaneClient (for sync) and device sensor APIs.
- State: estimated roll/pitch/yaw.

## PlaneSettingsBloc
- Purpose: send and persist plane settings (trim, limits, sensitivity).
- Depends on: IPlaneClient, EventBus.
- State: current values, pending changes, errors.

## MotorSettingsBloc
- Purpose: configure motor parameters.
- Depends on: IPlaneClient.
- State: applied configs, pending, error.

## PlaneCarouselBloc
- Purpose: manage model selection and its UI representation.
- Depends on: IPlaneClient, EventBus, PlaneRepository.
- State: selected plane, model list, initial load.

## ConnectBloc
- Purpose: TCP connection lifecycle to the plane.
- Depends on: IPlaneClient.
- Events: connect, reconnect, disconnect, timeouts.
- State: connected, connecting, disconnected, error.

## OtaBloc
- Purpose: update firmware from assets/firmware/pfw.bin.
- Depends on: IPlaneClient.
- Key states: ready, transferring, verified, error, canceled.

## CalibrationBloc
- Purpose: guide sensor calibration.
- Depends on: IPlaneClient.
- States: waiting for steps, in progress, success/failure.

## RecordedFlightsBloc and FlightDetailBloc
- Purpose: manage list and detail of local recordings.
- Depends on: RecorderRepository.
- State: flights list, loading states, errors.

## HomeBloc and other UI helpers
- Purpose: orchestrate light home/navigation state.
- Depends on: UI.
- State: tabs, filters, UI options.

## Interaction between BLoCs
- EventBus synchronizes plane selection and settings with FlyBloc and PlaneCarouselBloc.
- SensorBloc and OrientationBloc feed telemetry UI and FlyBloc validations.
- ConnectBloc gates availability for FlyBloc/OtaBloc; handle errors/retries before sending commands.

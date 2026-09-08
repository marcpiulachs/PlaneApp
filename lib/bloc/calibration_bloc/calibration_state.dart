abstract class CalibrationState {}

class CalibrationInitial extends CalibrationState {}

class CalibrationInProgress extends CalibrationState {
  final String message;
  CalibrationInProgress(this.message);
}

class CalibrationSuccess extends CalibrationState {
  final String message;
  CalibrationSuccess(this.message);
}

class CalibrationFailure extends CalibrationState {
  final String error;
  CalibrationFailure(this.error);
}
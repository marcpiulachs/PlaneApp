import 'dart:async';
import 'dart:developer' as developer;
import 'package:paperwings/bloc/fly_bloc/fly_event.dart';
import 'package:paperwings/models/recorded_item.dart';
import 'package:paperwings/repositories/recorder_repository.dart';

class FlightRecorder {
  final RecorderRepository _repository = RecorderRepository();
  Timer? _timer;
  Timer? _captureTimer; // Timer para capturar datos
  int _duration = 0;
  bool _isRecording = false;
  final List<FlightData> _flightDataList = [];

  // Devuelve la duración en segundos
  int get duration => _duration;

  // Devuelve si está grabando
  bool get isRecording => _isRecording;

  // Returns the telemetry data points
  List<FlightData> get data => _flightDataList;

  // Callback para notificar que ha pasado un segundo
  void Function(int)? timerUpdated;

  // Callback para notificar que ha iniciado la grabación
  void Function()? started;

  // Callback para notificar que ha detenido la grabación
  void Function()? stopped;

  // Callback para capturar datos cada 100 milisegundos
  void Function()? captureData;

  FlightRecorder({
    required this.timerUpdated,
    required this.started,
    required this.stopped,
    required this.captureData,
  });

  // Inicia el contador
  void start() {
    if (_isRecording) return; // No hacer nada si ya está grabando
    _timer?.cancel();
    _captureTimer?.cancel(); // Cancelar el timer de captura si existe
    _duration = 0; // Reiniciar duración al iniciar
    _isRecording = true;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _duration++;
      // Notificar que ha pasado un segundo
      timerUpdated?.call(_duration);
    });
    _captureTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      // Llamar al callback para capturar datos
      captureData?.call();
    });

    started?.call();
  }

  // Detiene el contador
  void stop() {
    if (!_isRecording) return; // No hacer nada si no está grabando
    save();
    _timer?.cancel();
    _captureTimer?.cancel(); // Cancelar el timer de captura
    _isRecording = false;
    _duration = 0; // Reiniciar duración al detener
    stopped?.call();
  }

  Future<void> save() async {
    if (_duration > 5 && _flightDataList.isNotEmpty) {
      developer
          .log("Guardando vuelo con ${_flightDataList.length} puntos de datos");

      // Calcular estadísticas del vuelo
      final maxPitch = _flightDataList
          .map((f) => f.telemetry.pitch.abs())
          .reduce((a, b) => a > b ? a : b);
      final maxRoll = _flightDataList
          .map((f) => f.telemetry.roll.abs())
          .reduce((a, b) => a > b ? a : b);
      final maxSpeed = _flightDataList
          .map((f) => (f.telemetry.accelX.abs() + f.telemetry.accelY.abs()))
          .reduce((a, b) => a > b ? a : b);

      // Determinar el estado del vuelo
      String status = 'completed';
      if (maxPitch > 60 || maxRoll > 60) {
        status = 'crashed';
      } else if (maxPitch > 45 || maxRoll > 45) {
        status = 'emergency';
      }

      final flight = RecordedFlight(
        id: '0', // Se asignará automáticamente en la BD
        timestamp: DateTime.now().subtract(Duration(seconds: _duration)),
        duration: _duration,
        telemetryData: _flightDataList.map((f) => f.telemetry).toList(),
        maxSpeed: maxSpeed,
        maxPitch: maxPitch,
        maxRoll: maxRoll,
        status: status,
      );

      await _repository.saveFlight(flight);
      developer.log("Vuelo guardado correctamente");

      // Limpiar datos
      _flightDataList.clear();
    }
  }

  // Libera recursos del timer cuando ya no se necesita
  void dispose() {
    _timer?.cancel();
    _captureTimer?.cancel(); // Cancelar el timer de captura
  }

  // Agrega un punto de datos de vuelo
  void addFlightData(FlightData flightData) {
    _flightDataList.add(flightData);
  }
}

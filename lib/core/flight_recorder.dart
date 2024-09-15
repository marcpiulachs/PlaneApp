import 'dart:async';

class FlightRecorder {
  Timer? _timer;
  Timer? _captureTimer; // Timer para capturar datos
  int _duration = 0;
  bool _isRecording = false;

  // Devuelve la duración en segundos
  int get duration => _duration;

  // Devuelve si está grabando
  bool get isRecording => _isRecording;

  // Callback para notificar que ha pasado un segundo
  void Function(int)? timerUpdated;

  // Callback para notificar que ha iniciado la grabación
  void Function()? started;

  // Callback para notificar que ha detenido la grabación
  void Function()? stopped;

  // Callback para capturar datos cada 100 milisegundos
  void Function()? captureData;

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
    _timer?.cancel();
    _captureTimer?.cancel(); // Cancelar el timer de captura
    _isRecording = false;
    _duration = 0; // Reiniciar duración al detener

    stopped?.call();
  }

  // Libera recursos del timer cuando ya no se necesita
  void dispose() {
    _timer?.cancel();
    _captureTimer?.cancel(); // Cancelar el timer de captura
  }
}

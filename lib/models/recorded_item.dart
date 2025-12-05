import 'package:paperwings/models/telemetry.dart';

class RecordedFlight {
  final String id;
  final DateTime timestamp;
  final int duration; // En segundos
  final List<Telemetry> telemetryData;
  final double maxSpeed;
  final double maxPitch;
  final double maxRoll;
  final String status; // 'completed', 'crashed', 'emergency'

  RecordedFlight({
    required this.id,
    required this.timestamp,
    required this.duration,
    required this.telemetryData,
    this.maxSpeed = 0,
    this.maxPitch = 0,
    this.maxRoll = 0,
    this.status = 'completed',
  });

  String get formattedDuration {
    final minutes = duration ~/ 60;
    final seconds = duration % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  String get formattedDate {
    return '${timestamp.day}/${timestamp.month}/${timestamp.year} ${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}';
  }

  bool get hasCrash => status == 'crashed';
  bool get hasEmergency => status == 'emergency';
  bool get hasWarning => maxPitch > 45 || maxRoll > 45;

  Map<String, dynamic> toMap() {
    return {
      // 'id' intentionally omitted for auto-generation by SQLite
      'timestamp': timestamp.toIso8601String(),
      'duration': duration,
      'maxSpeed': maxSpeed,
      'maxPitch': maxPitch,
      'maxRoll': maxRoll,
      'status': status,
    };
  }

  factory RecordedFlight.fromMap(Map<String, dynamic> map) {
    return RecordedFlight(
      id: map['id'].toString(),
      timestamp: DateTime.parse(map['timestamp'] as String),
      duration: map['duration'] as int,
      telemetryData: [],
      maxSpeed: map['maxSpeed'] as double,
      maxPitch: map['maxPitch'] as double,
      maxRoll: map['maxRoll'] as double,
      status: map['status'] as String,
    );
  }
}

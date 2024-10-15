import 'package:paperwings/models/flight_settings.dart';

class PlaneItem {
  final String imageUrl;
  final String title;
  final String description;
  final double progress1;
  final double progress2;
  final double progress3;
  final FlightSettings defaultSettings;
  final FlightSettings customSettings;

  PlaneItem({
    required this.imageUrl,
    required this.title,
    required this.description,
    required this.progress1,
    required this.progress2,
    required this.progress3,
    required this.defaultSettings,
    required this.customSettings,
  });
}

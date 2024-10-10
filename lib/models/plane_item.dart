import 'package:paperwings/core/flight_settings.dart';

class PlaneItem {
  final String imageUrl;
  final String title;
  final String description;
  final double progress1;
  final double progress2;
  final double progress3;
  final FlightSettings settings;

  PlaneItem({
    required this.imageUrl,
    required this.title,
    required this.description,
    required this.progress1,
    required this.progress2,
    required this.progress3,
    required this.settings,
  });
}

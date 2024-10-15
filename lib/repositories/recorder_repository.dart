import 'package:paperwings/models/recorded_item.dart';

class RecorderRepository {
  List<RecordedFlight> fetchRecordings() {
    return List.generate(
      20,
      (index) => RecordedFlight(
        time: '0${index + 1}:00 min',
        hasIcon1: true,
        hasIcon2: false,
        hasIcon3: true,
      ),
    );
  }
}

import 'package:paperwings/models/settings_page.dart';

class SettingsCategory {
  final String title;
  final List<SettingPage> pages;

  SettingsCategory({
    required this.title,
    required this.pages,
  });
}

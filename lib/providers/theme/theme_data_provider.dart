import 'package:flutter/material.dart';

class ThemeDataProvider extends ChangeNotifier {
  ThemeDataProvider();
  Brightness? brightness;

  void setThemeData(bool isOn) {
    brightness = isOn ? Brightness.dark : Brightness.light;
    notifyListeners();
  }
}

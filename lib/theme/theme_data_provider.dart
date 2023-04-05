import 'package:flutter/material.dart';
import 'package:movie_app/theme/theme_dark.dart';
import 'package:movie_app/theme/theme_light.dart';

class ThemeDataProvider extends ChangeNotifier {
  ThemeData _themeData = LightTheme().lightTheme;
  //ThemeData _themeData = DarkTheme().darkTheme;

  ThemeData get getThemeData => _themeData;

  void setThemeData(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners();
  }
}

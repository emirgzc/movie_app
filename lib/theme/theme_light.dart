import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie_app/constants/style.dart';

class LightTheme {
  late ThemeData lightTheme;

  LightTheme() {
    lightTheme = ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: Style.whiteColor,
      drawerTheme: DrawerThemeData(
        backgroundColor: Style.blackColor,
      ),
      appBarTheme: _getAppBarTheme(),
      iconTheme: const IconThemeData(color: Style.blackColor),
      cardColor: Style.whiteColor,
      textTheme: _getTextTheme(Style.darkTextColor),
      shadowColor: Style.blackColor.withOpacity(0.2),
      
    );
  }

  AppBarTheme _getAppBarTheme() {
    return const AppBarTheme(
      elevation: 0,
      backgroundColor: Style.whiteColor,
      iconTheme: IconThemeData(
        color: Style.blackColor,
      ),
      foregroundColor: Style.blackColor,
      actionsIconTheme: IconThemeData(
        color: Style.blackColor,
      ),
    );
  }

  static TextTheme _getTextTheme(Color color) => TextTheme(
        ///  display-large
        displayLarge: TextStyle(fontSize: 288.0.sp, fontWeight: FontWeight.w300, color: color, wordSpacing: -1.5),

        ///  display-medium
        displayMedium: TextStyle(fontSize: 180.0.sp, fontWeight: FontWeight.w300, color: color, wordSpacing: -0.5),

        ///  display-small
        displaySmall: TextStyle(fontSize: 144.0.sp, fontWeight: FontWeight.w400, color: color, wordSpacing: 0.0),

        ///  headline-medium
        headlineMedium: TextStyle(fontSize: 102.0.sp, fontWeight: FontWeight.w400, color: color, wordSpacing: 0.25),

        ///  headline-small
        headlineSmall: TextStyle(fontSize: 72.0.sp, fontWeight: FontWeight.w400, color: color, wordSpacing: 0.0),

        ///  title-large
        titleLarge: TextStyle(fontSize: 60.0.sp, fontWeight: FontWeight.w500, color: color, wordSpacing: 0.15),

        ///  title-medium
        titleMedium: TextStyle(fontSize: 48.0.sp, fontWeight: FontWeight.w400, color: color, wordSpacing: 0.15),

        ///  title-small
        titleSmall: TextStyle(fontSize: 42.0.sp, fontWeight: FontWeight.w500, color: color, wordSpacing: 0.1),

        ///  body-large
        bodyLarge: TextStyle(fontSize: 44.0.sp, fontWeight: FontWeight.w400, color: color, wordSpacing: 0.5),

        ///  body-medium
        bodyMedium: TextStyle(fontSize: 40.0.sp, fontWeight: FontWeight.w400, color: color, wordSpacing: 0.25),

        ///  body-small
        bodySmall: TextStyle(fontSize: 38.0.sp, fontWeight: FontWeight.w500, color: color, wordSpacing: 1.25),

        ///  label-large
        labelLarge: TextStyle(fontSize: 36.0.sp, fontWeight: FontWeight.w400, color: color, wordSpacing: 0.4),

        ///  label-small
        labelSmall: TextStyle(fontSize: 30.0.sp, fontWeight: FontWeight.w400, color: color, wordSpacing: 1.5),
      );
}

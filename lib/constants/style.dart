import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Style {
  static EdgeInsetsGeometry pagePadding = EdgeInsets.all(40.r);
  static BorderRadius defaultRadius = BorderRadius.circular(16.r);
  static const double defaultPaddingSize = 16;
  static const double defaultElevation = 10;
  static const double defaultRadiusSize = 16;
  static EdgeInsetsGeometry defaultVerticalPadding = EdgeInsets.symmetric(
    vertical: 48.h,
  );
  static EdgeInsetsGeometry defaultHorizontalPadding = EdgeInsets.symmetric(
    horizontal: 48.h,
  );
  static EdgeInsetsGeometry defaultSymetricPadding = EdgeInsets.symmetric(
    vertical: 48.h,
    horizontal: 48.w,
  );

  static const Color dateColor = Color.fromARGB(255, 117, 117, 117);
  static const Color starColor = Colors.amber;
  static const Color whiteColor = Colors.white;
  static const Color blackColor = Colors.black;
  static Color widgetBackgroundColor = Style.blackColor.withOpacity(0.4);
  static const Color transparentColor = Colors.transparent;

  static double defaultIconsSize = 40.r;
}

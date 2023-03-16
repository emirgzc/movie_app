import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Style {
  static EdgeInsetsGeometry pagePadding = EdgeInsets.all(40.r);
  static BorderRadius defaultRadius = BorderRadius.circular(16.r);
  static double defaultPaddingSizeVertical = 48.h; //16 ya denk geliyor
  static double defaultPaddingSizeHorizontal = 48.w; //16 ya denk geliyor
  static double defaultPaddingSize = 48.r;

  static const double defaultElevation = 10;
  static double defaultRadiusSize = 48.r;
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
  static Color widgetBackgroundColor = Style.blackColor.withOpacity(0.6);
  static const Color transparentColor = Colors.transparent;

  static double defaultIconsSize = 40.r;
  static double iconSizeTv = 72.r;
  static BoxShadow defaultShadow = BoxShadow(
    offset: const Offset(5, 5),
    blurRadius: 10,
    spreadRadius: 6,
    color: Style.blackColor.withOpacity(0.1),
  );
}

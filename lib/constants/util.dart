import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

buildLastProcessCardEffect(Widget widget, BuildContext context) {
  return Shimmer.fromColors(
    baseColor: Colors.grey.withOpacity(0.2),
    highlightColor: Colors.grey.withOpacity(0.05),
    child: widget,
  );
}

class Util {
  static bool isDarkMode(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }
}

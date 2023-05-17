import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shimmer/shimmer.dart';

class Util {
  static bool isDarkMode(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }

  static exitApp() {
    if (Platform.isIOS) {
      exit(0);
    } else {
      SystemNavigator.pop();
    }
  }
}

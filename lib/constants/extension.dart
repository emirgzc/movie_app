import 'package:flutter/material.dart';
import 'package:movie_app/constants/enums.dart';

extension GetIconPath on IconPath {
  String iconPath() {
    return 'assets/icons/$name.svg';
  }
}

extension GetLogoPath on LogoPath {
  String iconPath() {
    return 'assets/logo/$name.png';
  }
}

extension ThemeContext on BuildContext {
  ThemeData publicThemeContext() {
    return Theme.of(this);
  }
  TextTheme textThemeContext() {
    return Theme.of(this).textTheme; 
  }
  IconThemeData iconThemeContext() {
    return Theme.of(this).iconTheme;
  }
  Size getSize(){
    return MediaQuery.of(this).size;
  }
}


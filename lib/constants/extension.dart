
import 'package:movie_app/constants/enums.dart';

extension GetIconPath on IconPath{
  String iconPath() {
    return 'assets/icons/$name.svg';
  }
}
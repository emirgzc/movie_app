import 'package:flutter/widgets.dart';

class ShouldWatchProvider extends ChangeNotifier {
  bool _shouldWatch = false;

  bool get getShould => _shouldWatch;

  void changeShouldGear(bool isShould) {
    _shouldWatch = isShould;
    notifyListeners();
  }
}

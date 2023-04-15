import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ScreenConfig extends ChangeNotifier {
  bool darkMode = false;

  void toggleColor() {
    darkMode = !darkMode;
    notifyListeners();
  }
}

final screenConfig = ScreenConfig();
//final videoConfig = ValueNotifier(false);

import 'package:flutter/cupertino.dart';

class VideoConfig extends ChangeNotifier {
  bool isMuted = true;
  bool isAutoplay = false;

  void toggleIsMuted() {
    isMuted = !isMuted;
    notifyListeners();
  }

  void toggleIsAutoplay() {
    isAutoplay = !isAutoplay;
    notifyListeners();
  }
}

final videoConfig = VideoConfig();
//final videoConfig = ValueNotifier(false);

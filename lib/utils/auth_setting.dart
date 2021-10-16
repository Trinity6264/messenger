import 'package:flutter/foundation.dart';

class Authsettings with ChangeNotifier {
  bool isPressed = false;

  void toggleFunc() {
    isPressed = !isPressed;
    notifyListeners();
  }

  bool isPress = false;

  void toggleToHomeFalse() {
    isPress = false;
    notifyListeners();
  }

  void toggleToHomeTrue() {
    isPress = true;
    notifyListeners();
  }

  bool isSeen = true;

  void toggleSeen() {
    isSeen = !isSeen;
    notifyListeners();
  }
}

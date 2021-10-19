import 'package:flutter/foundation.dart';
import 'package:messenger/models/meassge_model.dart';

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

  // on swipe chat Widget
  MessageModel? isSwipe;
  void toSwipe(MessageModel model) {
    isSwipe = model;
    notifyListeners();
  }

  void toCancelSwipe() {
    isSwipe = null;
    notifyListeners();
  }
}

import 'package:flutter/foundation.dart';

class Checking with ChangeNotifier {
  int counter = 0;

  couterFunc() {
    counter++;
    notifyListeners();
  }
}

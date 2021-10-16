import 'package:shared_preferences/shared_preferences.dart';

class CustomSharedPrefs {
  CustomSharedPrefs._();
  static final instance = CustomSharedPrefs._();
  // saving prefs
  Future<bool> saveName(String username) async {
    final _prefs = await SharedPreferences.getInstance();
    return _prefs.setString('name', username);
  }

  Future<bool> saveuid(String userid) async {
    final _prefs = await SharedPreferences.getInstance();
    return _prefs.setString('uid', userid);
  }

  Future<bool> saveEmail(String useremail) async {
    final _prefs = await SharedPreferences.getInstance();
    return _prefs.setString('email', useremail);
  }
}

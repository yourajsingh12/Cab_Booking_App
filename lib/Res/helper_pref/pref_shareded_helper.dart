import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsHelper {
  static const String keyPhone = "user_phone";


  static Future<void> savePhone(String phone) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(keyPhone, phone);
  }


  static Future<String?> getPhone() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(keyPhone);
  }
}

import 'package:shared_preferences/shared_preferences.dart';

class CacheHelper {
  static SharedPreferences? sharedPreferences;
  CacheHelper._();

  static init() async {
    sharedPreferences = await SharedPreferences.getInstance();
    // sharedPreferences.getBool('firstTime') == null
    //     ? await sharedPreferences.setBool('firstTime', true)
    //     : await sharedPreferences.setBool('firstTime', false);
  }

  static Future<bool?> putBoolean(
      {required String key, required bool value}) async {
    return await sharedPreferences?.setBool(key, value);
  }

  static bool getBoolean({required String key, bool ifNull = false}) {
    return sharedPreferences?.getBool(key) ?? ifNull;
  }

  static bool? getFirstTime() {
    return sharedPreferences?.getBool('firstTime');
  }

  static String getString({required String key}) {
    return sharedPreferences?.getString(key) ?? "";
  }

  static Future<bool?> putString(
      {required String key, required String value}) async {
    return await sharedPreferences?.setString(key, value);
  }
}

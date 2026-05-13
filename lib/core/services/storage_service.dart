import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static SharedPreferences? _prefs;

  static Future init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // ================= TOKEN =================

  static Future setToken(String token) async {
    await _prefs?.setString('token', token);
  }

  static String getToken() {
    return _prefs?.getString('token') ?? '';
  }

  static Future removeToken() async {
    await _prefs?.remove('token');
  }

  // ================= CLEAR ALL =================

  static Future clearAll() async {
    await _prefs?.clear();
  }
}
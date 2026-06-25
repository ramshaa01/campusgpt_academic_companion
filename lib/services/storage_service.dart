import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  SharedPreferences get prefs {
    final p = _prefs;
    if (p == null) throw StateError('StorageService not initialized');
    return p;
  }

  String? getString(String key) => prefs.getString(key);
  Future<bool> setString(String key, String value) => prefs.setString(key, value);
  Future<bool> remove(String key) => prefs.remove(key);

  double getDouble(String key, {double fallback = 0}) =>
      prefs.getDouble(key) ?? fallback;

  Future<bool> setDouble(String key, double value) => prefs.setDouble(key, value);

  int getInt(String key, {int fallback = 0}) => prefs.getInt(key) ?? fallback;

  Future<bool> setInt(String key, int value) => prefs.setInt(key, value);

  List<Map<String, dynamic>> getJsonList(String key) {
    final raw = prefs.getString(key);
    if (raw == null || raw.isEmpty) return [];
    return (jsonDecode(raw) as List<dynamic>)
        .map((e) => Map<String, dynamic>.from(e as Map))
        .toList();
  }

  Future<bool> setJsonList(String key, List<Map<String, dynamic>> value) {
    return prefs.setString(key, jsonEncode(value));
  }
}

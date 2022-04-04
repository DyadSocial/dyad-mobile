import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class UserSession {
  late SharedPreferences _sharedPrefs;
  Map _sessionContainer = {};

  UserSession() {
    _initSharedPrefs();
  }

  Future _initSharedPrefs() async {
    this._sharedPrefs = await SharedPreferences.getInstance();
  }

  Future get(key) async {
    await _initSharedPrefs();
    try {
      return json.decode(this._sharedPrefs.getString(key)!);
    } catch (e) {
      return this._sharedPrefs.get(key);
    }
  }

  Future remove(key) async {
    await _initSharedPrefs();
    this._sharedPrefs.remove(key);
  }

  Future clear() async {
    await this._sharedPrefs.clear();
  }

  Future set(key, value) async {
    await _initSharedPrefs();

    switch (value.runtimeType) {
      case String:
        this._sharedPrefs.setString(key, value);
        break;
      case int:
        this._sharedPrefs.setInt(key, value);
        break;
      case bool:
        this._sharedPrefs.setBool(key, value);
        break;
      case double:
        this._sharedPrefs.setDouble(key, value);
        break;
      case List:
        this._sharedPrefs.setStringList(key, value);
        break;
      default:
        this._sharedPrefs.setString(key, jsonEncode(value.toJson()));
    }

    this._sessionContainer.putIfAbsent(key, () => value);
  }
}

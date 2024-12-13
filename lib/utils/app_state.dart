import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppState with ChangeNotifier {
  String? _deviceId;
  String? _sessionId;
  final SharedPreferences _prefs;

  AppState(this._prefs) {
    _deviceId = _prefs.getString('device_id');
    _sessionId = _prefs.getString('session_id');
  }

  String? get deviceId => _deviceId;

  String? get sessionId => _sessionId;

  void setDeviceId(String id) {
    _deviceId = id;
    _prefs.setString('device_id', id);
    notifyListeners();
  }

  void setSessionId(String id) {
    _sessionId = id;
    _prefs.setString('session_id', id);
    notifyListeners();
  }
}

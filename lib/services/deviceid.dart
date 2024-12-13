import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class DeviceIdService {
  static const String _deviceIdKey = 'device_id';
  final SharedPreferences _prefs;

  DeviceIdService(this._prefs);

  Future<String> getDeviceId() async {
    String? deviceId = _prefs.getString(_deviceIdKey);

    if (deviceId == null) {
      deviceId = _generateDeviceId();
      await _prefs.setString(_deviceIdKey, deviceId);
    }

    return deviceId;
  }

  String _generateDeviceId() {
    // Generate a unique ID for the device
    return const Uuid().v4();
  }
}

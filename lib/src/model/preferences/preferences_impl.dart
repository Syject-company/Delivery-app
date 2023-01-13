import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
import 'package:twsl_flutter/src/model/preferences/preferences.dart';

class PreferencesImpl implements Preferences {
  late EncryptedSharedPreferences _prefs;

  static const _APP_LANGUAGE = "app_language";
  static const _TOKEN = "token";
  static const _CUSTOMER_TOKEN = "customer_token";
  static const _TRACK_ID = "track_id";
  static const _ADVERTISING_ID = "advertising_id";
  static const _IS_TRACKING_DRIVER = "is_tracking_driver";

  PreferencesImpl() {
    _prefs = EncryptedSharedPreferences();
  }

  @override
  Future<String> getAppLanguage() {
    return _prefs.getString(_APP_LANGUAGE);
  }

  @override
  saveAppLanguage(String value) {
    _prefs.setString(_APP_LANGUAGE, value);
  }

  @override
  Future<String> getToken() {
    return _prefs.getString(_TOKEN);
  }

  @override
  Future<bool> saveToken(String? token) => _prefs.setString(_TOKEN, token!);

  @override
  Future<String> getCustomerToken() {
    return _prefs.getString(_CUSTOMER_TOKEN);
  }

  @override
  Future<bool> saveCustomerToken(String? token) =>
      _prefs.setString(_CUSTOMER_TOKEN, token!);

  @override
  Future<String> getAdvertisingId() => _prefs.getString(_ADVERTISING_ID);

  @override
  Future<bool> saveAdvertisingId(String id) =>
      _prefs.setString(_ADVERTISING_ID, id);

  @override
  Future<String> getTrackId() {
    return _prefs.getString(_TRACK_ID);
  }

  @override
  Future<bool> saveTrackId(String trackId) =>
      _prefs.setString(_TRACK_ID, trackId);

  @override
  Future<bool> isTrackingDriver() async {
    return await _prefs.getString(_IS_TRACKING_DRIVER) == "1";
  }

  @override
  Future<bool> setIsTrackingDriver(bool isTracking) {
    Future<bool> res;
    if (isTracking) {
      res = _prefs.setString(_IS_TRACKING_DRIVER, "1");
    } else {
      res = _prefs.setString(_IS_TRACKING_DRIVER, "0");
    }
    return res;
  }
}

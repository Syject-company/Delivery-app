abstract class Preferences {
  Future<String> getAppLanguage();

  saveAppLanguage(String value);

  Future<String> getToken();

  Future<bool> saveToken(String? token);

  Future<String> getCustomerToken();

  Future<bool> saveCustomerToken(String? token);

  Future<String> getAdvertisingId();

  Future<bool> saveAdvertisingId(String id);

  Future<String> getTrackId();

  Future<bool> saveTrackId(String trackId);

  Future<bool> isTrackingDriver();

  Future<bool> setIsTrackingDriver(bool isTracking);
}

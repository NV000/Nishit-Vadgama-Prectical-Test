import 'package:nishit_vadgama/core/services/storage_service.dart';

class StorageHelper {
  StorageHelper._();

  // Storage Keys
  static const String _keyToken = 'auth_token';
  static const String _keyRefreshToken = 'refresh_token';
  static const String _keyUserId = 'user_id';
  static const String _keyUserData = 'user_data';
  static const String _userIsLoggedIn = 'logged_in';
  static const String _keyOnboardingSeen = 'onboarding_seen';

  /// Authentication token.
  static Future<void> saveToken(String token) async {
    await StorageService.write(_keyToken, token);
    await setLoggedIn();
  }

  static Future<String?> getToken() async =>
      await StorageService.read(_keyToken);

  /// Refresh token.
  static Future<void> saveRefreshToken(String token) async =>
      await StorageService.write(_keyRefreshToken, token);
  static Future<String?> getRefreshToken() async =>
      await StorageService.read(_keyRefreshToken);

  /// Logged In Handling
  static Future<bool> isLoggedIn() async =>
      await StorageService.readBool(_userIsLoggedIn);
  static Future<void> setLoggedIn() async =>
      await StorageService.writeBool(_userIsLoggedIn, true);

  // First time launch handling
  static Future<bool> isOnboardingSeen() async =>
      await StorageService.readBool(_keyOnboardingSeen);
  static Future<void> setOnboardingSeen() async =>
      await StorageService.writeBool(_keyOnboardingSeen, true);

  /// Saves user metadata/profile json string.
  static Future<void> saveUserData(String userDataJson) async =>
      await StorageService.write(_keyUserData, userDataJson);

  /// Gets user metadata/profile json string.
  static Future<String?> getUserData() async =>
      await StorageService.read(_keyUserData);

  /// Clears user session on logout.
  static Future<void> clearSession() async {
    await StorageService.delete(_keyToken);
    await StorageService.delete(_keyRefreshToken);
    await StorageService.delete(_keyUserId);
    await StorageService.delete(_keyUserData);
    await StorageService.writeBool(_userIsLoggedIn, false);
  }
}

import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Local secure storage helper providing persistence for tokens, user sessions,
/// and app preferences. Robustly handles errors, platform limitations, and timeouts.
class StorageService {
  StorageService._();

  static const FlutterSecureStorage _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(resetOnError: true),
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
    mOptions: MacOsOptions(accessibility: KeychainAccessibility.first_unlock),
  );

  static const Duration _timeout = Duration(seconds: 2);

  // ---------------------------------------------------------------------------
  // GENERIC CRUD METHODS
  // ---------------------------------------------------------------------------

  /// Writes a String value to secure storage.
  static Future<void> write(String key, String value) async {
    try {
      await _storage.write(key: key, value: value).timeout(_timeout);
    } catch (e) {
      debugPrint('StorageService.write error for key $key: $e');
    }
  }

  /// Reads a String value from secure storage.
  static Future<String?> read(String key) async {
    try {
      return await _storage
          .read(key: key)
          .timeout(_timeout, onTimeout: () => null);
    } catch (e) {
      debugPrint('StorageService.read error for key $key: $e');
      return null;
    }
  }

  /// Deletes a specific key.
  static Future<void> delete(String key) async {
    try {
      await _storage.delete(key: key).timeout(_timeout);
    } catch (e) {
      debugPrint('StorageService.delete error for key $key: $e');
    }
  }

  /// Clears all keys in secure storage.
  static Future<void> clearAll() async {
    try {
      await _storage.deleteAll().timeout(_timeout);
    } catch (e) {
      debugPrint('StorageService.clearAll error: $e');
    }
  }

  /// Checks if a key exists.
  static Future<bool> containsKey(String key) async {
    try {
      final exists = await _storage
          .containsKey(key: key)
          .timeout(_timeout, onTimeout: () => false);
      return exists;
    } catch (e) {
      debugPrint('StorageService.containsKey error for key $key: $e');
      return false;
    }
  }

  /// Writes a boolean value.
  static Future<void> writeBool(String key, bool value) async {
    await write(key, value.toString());
  }

  /// Reads a boolean value.
  static Future<bool> readBool(String key, {bool defaultValue = false}) async {
    try {
      final value = await read(key);
      if (value == null) return defaultValue;
      return value.toLowerCase() == 'true';
    } catch (e) {
      debugPrint('StorageService.readBool error for key $key: $e');
      return defaultValue;
    }
  }
}

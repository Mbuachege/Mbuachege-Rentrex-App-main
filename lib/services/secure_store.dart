// lib/auth/secure_store.dart
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStore {
  static const _storage = FlutterSecureStorage();

  static const kToken = 'auth.token';
  static const kTokenExp =
      'auth.tokenExpiration'; // This will store the DateTime as String
  static const kRefresh = 'auth.refreshToken';
  static const kProfile = 'auth.profile.json';

  static Future<void> saveAuth({
    required String token,
    required String tokenExpiration, // Now passed as a String
    required String refreshToken,
    required String profileJson,
  }) async {
    await _storage.write(key: kToken, value: token);
    await _storage.write(
        key: kTokenExp,
        value: tokenExpiration); // Store token expiration as String
    await _storage.write(key: kRefresh, value: refreshToken);
    await _storage.write(key: kProfile, value: profileJson);
  }

  static Future<String?> getToken() => _storage.read(key: kToken);
  static Future<String?> getRefreshToken() => _storage.read(key: kRefresh);
  static Future<String?> getTokenExpiration() =>
      _storage.read(key: kTokenExp); // Return token expiration as String
  static Future<String?> getProfileJson() => _storage.read(key: kProfile);

  static Future<void> clear() async {
    await _storage.delete(key: kToken);
    await _storage.delete(key: kTokenExp);
    await _storage.delete(key: kRefresh);
    await _storage.delete(key: kProfile);
  }

  static Future<void> logout() async {
    await clear();
    print("✅ SecureStore: user logged out, all auth data cleared");
  }
}

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  // Create storage instance (single instance used everywhere)
  static const _storage = FlutterSecureStorage();

  // Keys (avoid hardcoding keys all over the app)
  static const _accessTokenKey = 'access_token';

  // Save tokens
  static Future<void> saveToken({required String accessToken}) async {
    await _storage.write(key: _accessTokenKey, value: accessToken);
  }

  // Read access token
  static Future<String?> readToken() async {
    return await _storage.read(key: _accessTokenKey);
  }

  // Delete tokens (on logout)
  static Future<void> deleteToken() async {
    await _storage.delete(key: _accessTokenKey);
  }
}

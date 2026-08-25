import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fitsho/core/constants/storage_keys.dart';
import 'package:fitsho/core/storage/token_storage.dart';

class SecureTokenStorage implements TokenStorage {
  SecureTokenStorage(this._storage);

  final FlutterSecureStorage _storage;

  @override
  Future<String?> getAccessToken() {
    return _storage.read(key: StorageKeys.accessToken);
  }

  @override
  Future<String?> getRefreshToken() {
    return _storage.read(key: StorageKeys.refreshToken);
  }

  @override
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await Future.wait([
      _storage.write(key: StorageKeys.accessToken, value: accessToken),
      _storage.write(key: StorageKeys.refreshToken, value: refreshToken),
    ]);
  }

  @override
  Future<void> saveAccessToken(String accessToken) {
    return _storage.write(key: StorageKeys.accessToken, value: accessToken);
  }

  @override
  Future<void> clearTokens() async {
    await Future.wait([
      _storage.delete(key: StorageKeys.accessToken),
      _storage.delete(key: StorageKeys.refreshToken),
    ]);
  }

  @override
  Future<bool> hasSession() async {
    final refreshToken = await getRefreshToken();
    return refreshToken != null && refreshToken.isNotEmpty;
  }
}

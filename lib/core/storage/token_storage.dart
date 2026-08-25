abstract class TokenStorage {
  Future<String?> getAccessToken();
  Future<String?> getRefreshToken();
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  });
  Future<void> saveAccessToken(String accessToken);
  Future<void> clearTokens();
  Future<bool> hasSession();
}

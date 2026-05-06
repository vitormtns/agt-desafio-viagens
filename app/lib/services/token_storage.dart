import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../models/auth_tokens.dart';

class TokenStorage {
  TokenStorage({FlutterSecureStorage? secureStorage})
    : _secureStorage = secureStorage ?? const FlutterSecureStorage();

  static const _tokenTypeKey = 'tokenType';
  static const _accessTokenKey = 'accessToken';
  static const _refreshTokenKey = 'refreshToken';
  static const _expiresInKey = 'expiresIn';

  final FlutterSecureStorage _secureStorage;

  Future<void> saveTokens(AuthTokens tokens) async {
    await _secureStorage.write(key: _tokenTypeKey, value: tokens.tokenType);
    await _secureStorage.write(key: _accessTokenKey, value: tokens.accessToken);
    await _secureStorage.write(
      key: _refreshTokenKey,
      value: tokens.refreshToken,
    );
    await _secureStorage.write(
      key: _expiresInKey,
      value: tokens.expiresIn.toString(),
    );
  }

  Future<AuthTokens?> readTokens() async {
    final tokenType = await _secureStorage.read(key: _tokenTypeKey);
    final accessToken = await _secureStorage.read(key: _accessTokenKey);
    final refreshToken = await _secureStorage.read(key: _refreshTokenKey);
    final expiresIn = await _secureStorage.read(key: _expiresInKey);

    if (tokenType == null ||
        accessToken == null ||
        refreshToken == null ||
        expiresIn == null) {
      return null;
    }

    return AuthTokens(
      tokenType: tokenType,
      accessToken: accessToken,
      refreshToken: refreshToken,
      expiresIn: int.tryParse(expiresIn) ?? 0,
    );
  }

  Future<void> clearTokens() async {
    await _secureStorage.delete(key: _tokenTypeKey);
    await _secureStorage.delete(key: _accessTokenKey);
    await _secureStorage.delete(key: _refreshTokenKey);
    await _secureStorage.delete(key: _expiresInKey);
  }
}

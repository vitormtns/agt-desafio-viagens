import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/auth_tokens.dart';
import 'api_client.dart';
import 'token_storage.dart';

class AuthService {
  AuthService({ApiClient? apiClient, TokenStorage? tokenStorage})
    : _apiClient = apiClient ?? ApiClient(),
      _tokenStorage = tokenStorage ?? TokenStorage();

  final ApiClient _apiClient;
  final TokenStorage _tokenStorage;

  Future<AuthTokens> login({
    required String username,
    required String password,
  }) async {
    try {
      final response = await _apiClient.post(
        '/auth/login',
        authenticated: false,
        body: {'username': username, 'password': password},
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        final tokens = AuthTokens.fromJson(json);
        await _tokenStorage.saveTokens(tokens);
        return tokens;
      }

      if (response.statusCode == 401 || response.statusCode == 403) {
        throw const AuthException('Usuário ou senha inválidos.');
      }

      throw const AuthException(
        'Não foi possível entrar agora. Tente novamente em instantes.',
      );
    } on AuthException {
      rethrow;
    } on http.ClientException catch (_) {
      throw const AuthException(
        'Não foi possível conectar ao servidor. Verifique se a API está rodando.',
      );
    } on FormatException catch (_) {
      throw const AuthException(
        'A resposta do servidor veio em um formato inesperado.',
      );
    } catch (_) {
      throw const AuthException('Ocorreu um erro inesperado ao tentar entrar.');
    }
  }

  Future<AuthTokens?> readSavedTokens() {
    return _tokenStorage.readTokens();
  }

  Future<void> logout() async {
    await _tokenStorage.clearTokens();
  }
}

class AuthException implements Exception {
  const AuthException(this.message);

  final String message;
}

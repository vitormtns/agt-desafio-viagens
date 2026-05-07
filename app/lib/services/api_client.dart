import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../core/config/api_config.dart';
import 'token_storage.dart';

class ApiClient {
  ApiClient({
    http.Client? httpClient,
    TokenStorage? tokenStorage,
    this.baseUrl = ApiConfig.baseUrl,
  }) : _httpClient = httpClient ?? http.Client(),
       _tokenStorage = tokenStorage ?? TokenStorage();

  static const Duration _timeout = Duration(seconds: 10);

  final http.Client _httpClient;
  final TokenStorage _tokenStorage;
  final String baseUrl;

  Future<http.Response> get(String path) async {
    return _send(
      () async => _httpClient.get(
        Uri.parse('$baseUrl$path'),
        headers: await _headers(),
      ),
    );
  }

  Future<http.Response> post(
    String path, {
    Object? body,
    bool authenticated = true,
  }) async {
    return _send(
      () async => _httpClient.post(
        Uri.parse('$baseUrl$path'),
        headers: await _headers(authenticated: authenticated),
        body: body == null ? null : jsonEncode(body),
      ),
    );
  }

  Future<http.Response> patch(String path, {Object? body}) async {
    return _send(
      () async => _httpClient.patch(
        Uri.parse('$baseUrl$path'),
        headers: await _headers(),
        body: body == null ? null : jsonEncode(body),
      ),
    );
  }

  Future<http.Response> _send(Future<http.Response> Function() request) async {
    try {
      return await request().timeout(_timeout);
    } on TimeoutException catch (_) {
      throw const ApiException(
        'Não foi possível conectar ao servidor. Verifique sua conexão e tente novamente.',
      );
    } on http.ClientException catch (_) {
      throw const ApiException(
        'Não foi possível conectar ao servidor. Verifique sua conexão e tente novamente.',
      );
    }
  }

  Future<Map<String, String>> _headers({bool authenticated = true}) async {
    final tokens = authenticated ? await _tokenStorage.readTokens() : null;

    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (tokens != null)
        'Authorization': '${tokens.tokenType} ${tokens.accessToken}',
    };
  }
}

class ApiException implements Exception {
  const ApiException(this.message);

  final String message;
}

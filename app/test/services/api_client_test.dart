import 'package:agt_viagens/services/api_client.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  group('ApiClient', () {
    test('identifica 401 em requisição autenticada como sessão expirada', () {
      FlutterSecureStorage.setMockInitialValues({
        'tokenType': 'Bearer',
        'accessToken': 'token-expirado',
        'refreshToken': 'refresh-token',
        'expiresIn': '3600',
      });

      final apiClient = ApiClient(
        baseUrl: 'https://teste.local',
        httpClient: MockClient((request) async {
          return http.Response('', 401);
        }),
      );

      expect(
        apiClient.get('/viagens'),
        throwsA(isA<ApiUnauthorizedException>()),
      );
    });

    test('identifica 403 em requisição autenticada como sessão expirada', () {
      FlutterSecureStorage.setMockInitialValues({
        'tokenType': 'Bearer',
        'accessToken': 'token-sem-acesso',
        'refreshToken': 'refresh-token',
        'expiresIn': '3600',
      });

      final apiClient = ApiClient(
        baseUrl: 'https://teste.local',
        httpClient: MockClient((request) async {
          return http.Response('', 403);
        }),
      );

      expect(
        apiClient.get('/viagens'),
        throwsA(isA<ApiUnauthorizedException>()),
      );
    });
  });
}

import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/viagem.dart';
import 'api_client.dart';

class ViagemService {
  ViagemService({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();

  final ApiClient _apiClient;

  Future<List<Viagem>> listarViagens() async {
    try {
      final response = await _apiClient.get('/viagens');

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as List<dynamic>;
        return json
            .map((item) => Viagem.fromJson(item as Map<String, dynamic>))
            .toList();
      }

      if (response.statusCode == 401 || response.statusCode == 403) {
        throw const ViagemException(
          'Sua sessão expirou ou você não tem acesso a este recurso.',
        );
      }

      throw const ViagemException(
        'Não foi possível carregar suas viagens agora.',
      );
    } on ViagemException {
      rethrow;
    } on http.ClientException catch (_) {
      throw const ViagemException(
        'Não foi possível conectar ao servidor. Verifique se a API está rodando.',
      );
    } on FormatException catch (_) {
      throw const ViagemException(
        'A resposta do servidor veio em um formato inesperado.',
      );
    } catch (_) {
      throw const ViagemException(
        'Ocorreu um erro inesperado ao carregar suas viagens.',
      );
    }
  }
}

class ViagemException implements Exception {
  const ViagemException(this.message);

  final String message;
}

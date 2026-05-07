import 'dart:convert';

import 'api_client.dart';

class DominioService {
  DominioService({ApiClient? apiClient})
    : _apiClient = apiClient ?? ApiClient();

  final ApiClient _apiClient;

  Future<List<String>> listarFinalidades() {
    return _listarDominio('/dominios/finalidades');
  }

  Future<List<String>> listarTransportes() {
    return _listarDominio('/dominios/transportes');
  }

  Future<List<String>> _listarDominio(String path) async {
    try {
      final response = await _apiClient.get(path);

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as List<dynamic>;
        return json.map((item) => item.toString()).toList();
      }

      if (response.statusCode == 401 || response.statusCode == 403) {
        throw const DominioException(
          'Sua sessão expirou ou você não tem acesso a este recurso.',
        );
      }

      throw const DominioException('Não foi possível carregar as opções.');
    } on DominioException {
      rethrow;
    } on ApiException catch (error) {
      throw DominioException(error.message);
    } on FormatException catch (_) {
      throw const DominioException(
        'A resposta do servidor veio em um formato inesperado.',
      );
    } catch (_) {
      throw const DominioException('Não foi possível carregar as opções.');
    }
  }
}

class DominioException implements Exception {
  const DominioException(this.message);

  final String message;
}

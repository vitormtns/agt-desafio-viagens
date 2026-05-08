import 'dart:convert';

import '../core/utils/date_formatter.dart';
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
    } on ApiUnauthorizedException {
      rethrow;
    } on ApiException catch (error) {
      throw ViagemException(error.message);
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

  Future<Viagem> criarViagem({
    required String destino,
    required DateTime dataIda,
    required DateTime dataVolta,
    required String finalidade,
    required String transporte,
    String? observacoes,
  }) async {
    try {
      final response = await _apiClient.post(
        '/viagens',
        body: {
          'destino': destino,
          'dataIda': DateFormatter.apiDate(dataIda),
          'dataVolta': DateFormatter.apiDate(dataVolta),
          'finalidade': finalidade,
          'transporte': transporte,
          'observacoes': observacoes,
        },
      );

      if (response.statusCode == 201) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        return Viagem.fromJson(json);
      }

      if (response.statusCode == 400) {
        throw const ViagemException(
          'Confira os dados informados e tente novamente.',
        );
      }

      if (response.statusCode == 401 || response.statusCode == 403) {
        throw const ViagemException(
          'Sua sessão expirou ou você não tem acesso a este recurso.',
        );
      }

      throw const ViagemException('Não foi possível salvar a viagem agora.');
    } on ViagemException {
      rethrow;
    } on ApiUnauthorizedException {
      rethrow;
    } on ApiException catch (error) {
      throw ViagemException(error.message);
    } on FormatException catch (_) {
      throw const ViagemException(
        'A resposta do servidor veio em um formato inesperado.',
      );
    } catch (_) {
      throw const ViagemException(
        'Ocorreu um erro inesperado ao salvar a viagem.',
      );
    }
  }

  Future<Viagem> atualizarStatus(int id, String status) async {
    try {
      final response = await _apiClient.patch(
        '/viagens/$id/status',
        body: {'status': status},
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        return Viagem.fromJson(json);
      }

      if (response.statusCode == 401 || response.statusCode == 403) {
        throw const ViagemException(
          'Sua sessão expirou ou você não tem acesso a este recurso.',
        );
      }

      if (response.statusCode == 404) {
        throw const ViagemException('Viagem não encontrada.');
      }

      if (response.statusCode == 422) {
        throw const ViagemException(
          'Esta alteração de status não é permitida.',
        );
      }

      throw const ViagemException('Não foi possível atualizar o status agora.');
    } on ViagemException {
      rethrow;
    } on ApiUnauthorizedException {
      rethrow;
    } on ApiException catch (error) {
      throw ViagemException(error.message);
    } on FormatException catch (_) {
      throw const ViagemException(
        'A resposta do servidor veio em um formato inesperado.',
      );
    } catch (_) {
      throw const ViagemException(
        'Ocorreu um erro inesperado ao atualizar o status.',
      );
    }
  }
}

class ViagemException implements Exception {
  const ViagemException(this.message);

  final String message;
}

import 'package:flutter/foundation.dart';

import '../models/viagem.dart';
import '../services/api_client.dart';
import '../services/viagem_service.dart';

class ViagemState extends ChangeNotifier {
  ViagemState({ViagemService? viagemService})
    : _viagemService = viagemService ?? ViagemService();

  final ViagemService _viagemService;
  final List<Viagem> _viagens = [];
  bool _isLoading = false;
  bool _isSaving = false;
  bool _isUpdatingStatus = false;
  String? _errorMessage;

  List<Viagem> get viagens => List.unmodifiable(_viagens);
  bool get isLoading => _isLoading;
  bool get isSaving => _isSaving;
  bool get isUpdatingStatus => _isUpdatingStatus;
  String? get errorMessage => _errorMessage;
  bool get isEmpty => _viagens.isEmpty;

  Future<void> loadViagens() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final viagens = await _viagemService.listarViagens();
      _viagens
        ..clear()
        ..addAll(viagens);
    } on ViagemException catch (error) {
      _errorMessage = error.message;
    } on ApiUnauthorizedException {
      _errorMessage = null;
      rethrow;
    } catch (_) {
      _errorMessage = 'Ocorreu um erro inesperado ao carregar suas viagens.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> criarViagem({
    required String destino,
    required DateTime dataIda,
    required DateTime dataVolta,
    required String finalidade,
    required String transporte,
    String? observacoes,
  }) async {
    _isSaving = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _viagemService.criarViagem(
        destino: destino,
        dataIda: dataIda,
        dataVolta: dataVolta,
        finalidade: finalidade,
        transporte: transporte,
        observacoes: observacoes,
      );
      await loadViagens();
      return true;
    } on ViagemException catch (error) {
      _errorMessage = error.message;
      return false;
    } on ApiUnauthorizedException {
      _errorMessage = null;
      rethrow;
    } catch (_) {
      _errorMessage = 'Ocorreu um erro inesperado ao salvar a viagem.';
      return false;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  Future<Viagem?> atualizarStatusViagem(int id, String status) async {
    _isUpdatingStatus = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final viagemAtualizada = await _viagemService.atualizarStatus(id, status);
      final index = _viagens.indexWhere((viagem) => viagem.id == id);
      if (index >= 0) {
        _viagens[index] = viagemAtualizada;
      }
      return viagemAtualizada;
    } on ViagemException catch (error) {
      _errorMessage = error.message;
      return null;
    } on ApiUnauthorizedException {
      _errorMessage = null;
      rethrow;
    } catch (_) {
      _errorMessage = 'Ocorreu um erro inesperado ao atualizar o status.';
      return null;
    } finally {
      _isUpdatingStatus = false;
      notifyListeners();
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}

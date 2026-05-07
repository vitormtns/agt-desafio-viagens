import 'package:flutter/foundation.dart';

import '../models/viagem.dart';
import '../services/viagem_service.dart';

class ViagemState extends ChangeNotifier {
  ViagemState({ViagemService? viagemService})
    : _viagemService = viagemService ?? ViagemService();

  final ViagemService _viagemService;
  final List<Viagem> _viagens = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Viagem> get viagens => List.unmodifiable(_viagens);
  bool get isLoading => _isLoading;
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
    } catch (_) {
      _errorMessage = 'Ocorreu um erro inesperado ao carregar suas viagens.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

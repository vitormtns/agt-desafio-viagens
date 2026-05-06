import 'package:flutter/foundation.dart';

import '../models/viagem.dart';

class ViagemState extends ChangeNotifier {
  final List<Viagem> _viagens = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Viagem> get viagens => List.unmodifiable(_viagens);
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isEmpty => _viagens.isEmpty;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void setError(String? message) {
    _errorMessage = message;
    notifyListeners();
  }

  void setViagens(List<Viagem> viagens) {
    _viagens
      ..clear()
      ..addAll(viagens);
    _errorMessage = null;
    notifyListeners();
  }
}

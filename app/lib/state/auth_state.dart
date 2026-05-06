import 'package:flutter/foundation.dart';

import '../models/auth_tokens.dart';

class AuthState extends ChangeNotifier {
  AuthTokens? _tokens;
  bool _isLoading = false;
  String? _errorMessage;

  AuthTokens? get tokens => _tokens;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _tokens != null;

  void setTokens(AuthTokens tokens) {
    _tokens = tokens;
    _errorMessage = null;
    notifyListeners();
  }

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void setError(String? message) {
    _errorMessage = message;
    notifyListeners();
  }

  void clear() {
    _tokens = null;
    _errorMessage = null;
    notifyListeners();
  }
}

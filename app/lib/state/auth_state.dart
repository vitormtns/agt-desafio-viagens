import 'package:flutter/foundation.dart';

import '../models/auth_tokens.dart';
import '../services/auth_service.dart';

class AuthState extends ChangeNotifier {
  AuthState({AuthService? authService})
    : _authService = authService ?? AuthService();

  final AuthService _authService;
  AuthTokens? _tokens;
  bool _isLoading = false;
  bool _isCheckingAuth = true;
  String? _errorMessage;

  AuthTokens? get tokens => _tokens;
  bool get isLoading => _isLoading;
  bool get isCheckingAuth => _isCheckingAuth;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _tokens != null;

  Future<void> checkAuthStatus() async {
    _isCheckingAuth = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _tokens = await _authService.readSavedTokens();
    } catch (_) {
      _tokens = null;
      _errorMessage = 'Não foi possível verificar sua sessão salva.';
    } finally {
      _isCheckingAuth = false;
      notifyListeners();
    }
  }

  Future<void> login(String username, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _tokens = await _authService.login(
        username: username,
        password: password,
      );
    } on AuthException catch (error) {
      _tokens = null;
      _errorMessage = error.message;
    } catch (_) {
      _tokens = null;
      _errorMessage = 'Ocorreu um erro inesperado ao tentar entrar.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    await _authService.logout();
    _tokens = null;
    _errorMessage = null;
    _isLoading = false;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}

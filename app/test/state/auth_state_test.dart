import 'package:agt_viagens/models/auth_tokens.dart';
import 'package:agt_viagens/services/auth_service.dart';
import 'package:agt_viagens/state/auth_state.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AuthState', () {
    test('limpa a sessão ao expirar e guarda mensagem para o login', () async {
      final authService = _FakeAuthService();
      final authState = AuthState(authService: authService);

      await authState.login('usuario.teste', 'senha');
      await authState.expireSession();

      expect(authService.logoutCalled, isTrue);
      expect(authState.isAuthenticated, isFalse);
      expect(authState.isLoading, isFalse);
      expect(authState.isCheckingAuth, isFalse);
      expect(authState.errorMessage, AuthState.sessionExpiredMessage);
    });
  });
}

class _FakeAuthService extends AuthService {
  bool logoutCalled = false;

  @override
  Future<AuthTokens> login({
    required String username,
    required String password,
  }) async {
    return const AuthTokens(
      tokenType: 'Bearer',
      accessToken: 'access-token',
      refreshToken: 'refresh-token',
      expiresIn: 3600,
    );
  }

  @override
  Future<void> logout() async {
    logoutCalled = true;
  }
}

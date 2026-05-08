import 'package:agt_viagens/models/auth_tokens.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AuthTokens', () {
    test('cria objeto a partir de JSON com todos os campos', () {
      final tokens = AuthTokens.fromJson({
        'tokenType': 'Bearer',
        'accessToken': 'access-token',
        'refreshToken': 'refresh-token',
        'expiresIn': 3600,
      });

      expect(tokens.tokenType, 'Bearer');
      expect(tokens.accessToken, 'access-token');
      expect(tokens.refreshToken, 'refresh-token');
      expect(tokens.expiresIn, 3600);
    });
  });
}

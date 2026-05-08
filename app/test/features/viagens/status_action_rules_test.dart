import 'package:agt_viagens/features/viagens/status_action_rules.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Regras de ações por status', () {
    test('AGENDADA permite iniciar e cancelar', () {
      final actions = statusActionsFor('AGENDADA');

      expect(actions.map((action) => action.nextStatus), [
        'EM_ANDAMENTO',
        'CANCELADA',
      ]);
    });

    test('EM_ANDAMENTO permite concluir e cancelar', () {
      final actions = statusActionsFor('EM_ANDAMENTO');

      expect(actions.map((action) => action.nextStatus), [
        'CONCLUIDA',
        'CANCELADA',
      ]);
    });

    test('CONCLUIDA não permite nenhuma ação', () {
      final actions = statusActionsFor('CONCLUIDA');

      expect(actions, isEmpty);
    });

    test('CANCELADA não permite nenhuma ação', () {
      final actions = statusActionsFor('CANCELADA');

      expect(actions, isEmpty);
    });
  });
}

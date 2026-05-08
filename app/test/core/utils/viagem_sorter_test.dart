import 'package:agt_viagens/core/utils/viagem_sorter.dart';
import 'package:agt_viagens/models/viagem.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('sortViagensForDisplay', () {
    test('ordena viagens por prioridade de status', () {
      final viagens = [
        _viagem(id: 1, status: 'CANCELADA'),
        _viagem(id: 2, status: 'CONCLUIDA'),
        _viagem(id: 3, status: 'AGENDADA'),
        _viagem(id: 4, status: 'EM_ANDAMENTO'),
      ];

      final sortedStatuses = sortViagensForDisplay(
        viagens,
      ).map((viagem) => viagem.status);

      expect(sortedStatuses, [
        'EM_ANDAMENTO',
        'AGENDADA',
        'CONCLUIDA',
        'CANCELADA',
      ]);
    });

    test('mantém viagens mais recentes primeiro dentro do mesmo status', () {
      final viagens = [
        _viagem(id: 1, status: 'AGENDADA', criadoEm: DateTime(2026, 5, 1)),
        _viagem(id: 2, status: 'AGENDADA', criadoEm: DateTime(2026, 5, 3)),
        _viagem(id: 3, status: 'AGENDADA', criadoEm: DateTime(2026, 5, 2)),
      ];

      final sortedIds = sortViagensForDisplay(
        viagens,
      ).map((viagem) => viagem.id);

      expect(sortedIds, [2, 3, 1]);
    });
  });
}

Viagem _viagem({required int id, required String status, DateTime? criadoEm}) {
  return Viagem(
    id: id,
    destino: 'São Paulo',
    dataIda: DateTime(2026, 5, 10),
    dataVolta: DateTime(2026, 5, 12),
    finalidade: 'Reunião',
    transporte: 'Aéreo',
    status: status,
    criadoEm: criadoEm ?? DateTime(2026, 5, 8),
  );
}

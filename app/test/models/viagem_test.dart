import 'package:agt_viagens/models/viagem.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Viagem', () {
    test('cria objeto a partir de JSON com todos os campos', () {
      final viagem = Viagem.fromJson({
        'id': 1,
        'destino': 'São Paulo',
        'dataIda': '2026-05-10',
        'dataVolta': '2026-05-12',
        'finalidade': 'Reunião com cliente',
        'transporte': 'Aéreo',
        'observacoes': 'Levar documentos da proposta.',
        'status': 'AGENDADA',
        'criadoEm': '2026-05-08T10:30:00',
      });

      expect(viagem.id, 1);
      expect(viagem.destino, 'São Paulo');
      expect(viagem.dataIda, DateTime(2026, 5, 10));
      expect(viagem.dataVolta, DateTime(2026, 5, 12));
      expect(viagem.finalidade, 'Reunião com cliente');
      expect(viagem.transporte, 'Aéreo');
      expect(viagem.observacoes, 'Levar documentos da proposta.');
      expect(viagem.status, 'AGENDADA');
      expect(viagem.criadoEm, DateTime(2026, 5, 8, 10, 30));
    });

    test('aceita observações nulas', () {
      final viagem = Viagem.fromJson({
        'id': 2,
        'destino': 'Curitiba',
        'dataIda': '2026-06-01',
        'dataVolta': '2026-06-03',
        'finalidade': 'Treinamento',
        'transporte': 'Rodoviário',
        'observacoes': null,
        'status': 'AGENDADA',
        'criadoEm': '2026-05-08T11:00:00',
      });

      expect(viagem.observacoes, isNull);
    });

    test('aceita observações vazias', () {
      final viagem = Viagem.fromJson({
        'id': 3,
        'destino': 'Belo Horizonte',
        'dataIda': '2026-07-01',
        'dataVolta': '2026-07-02',
        'finalidade': 'Visita técnica',
        'transporte': 'Carro',
        'observacoes': '',
        'status': 'AGENDADA',
        'criadoEm': '2026-05-08T12:00:00',
      });

      expect(viagem.observacoes, isEmpty);
    });
  });
}

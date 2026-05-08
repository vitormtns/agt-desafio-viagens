import 'package:agt_viagens/core/utils/date_formatter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DateFormatter', () {
    test('formata data no padrão dd/MM/yyyy', () {
      final result = DateFormatter.date(DateTime(2026, 5, 8));

      expect(result, '08/05/2026');
    });

    test('formata data e hora no padrão dd/MM/yyyy HH:mm', () {
      final result = DateFormatter.dateTime(DateTime(2026, 5, 8, 9, 5));

      expect(result, '08/05/2026 09:05');
    });

    test('formata data para envio à API no padrão yyyy-MM-dd', () {
      final result = DateFormatter.apiDate(DateTime(2026, 5, 8));

      expect(result, '2026-05-08');
    });
  });
}

import 'package:agt_viagens/app.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('exibe tela inicial temporaria', (tester) async {
    await tester.pumpWidget(const App());

    expect(find.text('AGT Viagens'), findsOneWidget);
    expect(find.text('Controle de viagens corporativas'), findsOneWidget);
  });
}

import 'package:agt_viagens/app.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('exibe tela de login quando não há token salvo', (tester) async {
    FlutterSecureStorage.setMockInitialValues({});

    await tester.pumpWidget(const App());
    await tester.pumpAndSettle();

    expect(find.text('AGT Viagens'), findsOneWidget);
    expect(find.text('Entrar'), findsOneWidget);
  });
}

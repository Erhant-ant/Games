import 'package:flutter_test/flutter_test.dart';
import 'package:dokuz_tas/main.dart';

void main() {
  testWidgets('Dokuz Taş uygulaması başlangıç ekranını gösterir', (WidgetTester tester) async {
    await tester.pumpWidget(const DokuzTasApp());
    await tester.pumpAndSettle();

    expect(find.textContaining('DOKUZ TAŞ'), findsOneWidget);
    expect(find.textContaining('OYUNA BAŞLA'), findsOneWidget);
    expect(find.textContaining('NASIL OYNANIR?'), findsOneWidget);
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:uts_2415051077_paulus/main.dart';

void main() {
  testWidgets('KosFinder App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    expect(find.byType(MyApp), findsOneWidget);
  });
}

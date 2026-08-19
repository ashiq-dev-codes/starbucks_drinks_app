import 'package:flutter_test/flutter_test.dart';

import 'package:starbucks_drinks_app/app.dart';

void main() {
  testWidgets('App renders the drink carousel and the Get it button', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const App());
    await tester.pump();

    expect(find.text('Chocolate Cream Chip Frappuccino'), findsOneWidget);
    expect(find.text('Get it'), findsOneWidget);
  });
}

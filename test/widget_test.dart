import 'package:flutter_test/flutter_test.dart';

import 'package:starbucks_drinks_app/app.dart';

void main() {
  testWidgets('App renders the placeholder home screen', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const App());

    expect(find.text('Starbucks Drinks App'), findsOneWidget);
  });
}

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:starbucks_drinks_app/feature/drink/presentation/page/drink_page.dart';

void main() {
  testWidgets('dragging the vertical info card also moves the horizontal carousel', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: DrinkPage()));
    await tester.pumpAndSettle();

    final horizontalFinder = find.byWidgetPredicate(
      (w) => w is PageView && w.scrollDirection == Axis.horizontal,
    );
    final verticalFinder = find.byWidgetPredicate(
      (w) => w is PageView && w.scrollDirection == Axis.vertical,
    );

    expect(horizontalFinder, findsOneWidget, reason: 'horizontal carousel PageView should exist');
    expect(verticalFinder, findsOneWidget, reason: 'vertical info-card PageView should exist');

    PageController hCtrl() => (tester.widget(horizontalFinder) as PageView).controller!;
    PageController vCtrl() => (tester.widget(verticalFinder) as PageView).controller!;

    final beforeH = hCtrl().page;
    final beforeV = vCtrl().page;
    // ignore: avoid_print
    print('BEFORE horizontal.page=$beforeH vertical.page=$beforeV');

    await tester.drag(verticalFinder, const Offset(0, -300));
    await tester.pump();
    await tester.pumpAndSettle(const Duration(milliseconds: 50));

    final afterDragH = hCtrl().page;
    final afterDragV = vCtrl().page;
    // ignore: avoid_print
    print('AFTER DRAG (pre-settle) horizontal.page=$afterDragH vertical.page=$afterDragV');

    await tester.pumpAndSettle();

    final afterH = hCtrl().page;
    final afterV = vCtrl().page;
    // ignore: avoid_print
    print('AFTER SETTLE horizontal.page=$afterH vertical.page=$afterV');

    expect(afterV, isNot(closeTo(beforeV ?? 0, 0.001)), reason: 'vertical PageView should have moved from the drag');
    expect(afterH, isNot(closeTo(beforeH ?? 0, 0.001)), reason: 'horizontal PageView should follow the vertical drag');
  });

  testWidgets(
    'a residual settle on one PageView does not steal control while the other is being actively dragged',
    (tester) async {
      await tester.pumpWidget(const MaterialApp(home: DrinkPage()));
      await tester.pumpAndSettle();

      final horizontalFinder = find.byWidgetPredicate(
        (w) => w is PageView && w.scrollDirection == Axis.horizontal,
      );
      final verticalFinder = find.byWidgetPredicate(
        (w) => w is PageView && w.scrollDirection == Axis.vertical,
      );

      PageController hCtrl() => (tester.widget(horizontalFinder) as PageView).controller!;
      PageController vCtrl() => (tester.widget(verticalFinder) as PageView).controller!;

      // A small vertical drag that won't cross the snap threshold: on
      // release it settles BACK to page 0 via its own native ballistic
      // physics, independent of anything else.
      final verticalGesture = await tester.startGesture(tester.getCenter(verticalFinder));
      await verticalGesture.moveBy(const Offset(0, -30));
      await tester.pump();
      await verticalGesture.up();
      // Only a couple of frames: the vertical's snap-back settle animation
      // is still mid-flight here, not finished.
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 16));

      // While that residual settle is still playing out, the user starts a
      // brand new, real drag on the horizontal carousel, all the way to the
      // next page.
      await tester.drag(horizontalFinder, const Offset(-400, 0));
      await tester.pumpAndSettle();

      final finalH = hCtrl().page!;
      final finalV = vCtrl().page!;
      // ignore: avoid_print
      print('FINAL horizontal.page=$finalH vertical.page=$finalV');

      expect(finalH, closeTo(1.0, 0.01), reason: 'horizontal should have fully advanced to page 1 from the real drag');
      expect(
        finalV,
        closeTo(finalH, 0.01),
        reason: 'vertical should end up in sync with horizontal, not stuck near its own residual settle target',
      );
    },
  );
}

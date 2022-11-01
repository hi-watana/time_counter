import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:time_counter/countdown_list_view.dart';
import 'package:time_counter/main.dart' as app;

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  binding.framePolicy = LiveTestWidgetsFlutterBindingFramePolicy.fullyLive;

  testWidgets('Integration test', (tester) async {

    app.main();
    await tester.pumpAndSettle(const Duration(seconds: 3));

    var countdownFinder = find.byType(CountdownElement);
    var countdownElements = tester.widgetList<CountdownElement>(countdownFinder);
    expect(countdownElements, isEmpty);

    const maxCount = 100;
    for (var i = 0; i < maxCount; i++) {
      final fabFinder = find.byType(FloatingActionButton);
      expect(fabFinder, findsOneWidget);

      await tester.tap(fabFinder);
      await tester.pump(const Duration(seconds: 1));

      final textFieldFinder = find.byType(TextField);
      await tester.enterText(textFieldFinder, 'created $i');
      await tester.pump();

      final saveButtonFinder = find.byType(OutlinedButton);
      expect(saveButtonFinder, findsOneWidget);
      await tester.tap(saveButtonFinder);
      await tester.pump(const Duration(seconds: 1));
    }

    countdownFinder = find.ancestor(of: find.text('created ${maxCount - 1}'), matching: find.byType(CountdownElement));
    await tester.scrollUntilVisible(countdownFinder, 500, duration: const Duration(seconds: 1));
    expect(countdownFinder, findsOneWidget);
    await tester.pump();
    await tester.tap(countdownFinder);
    await tester.pump(const Duration(seconds: 1));

    final textFieldFinder = find.byType(TextField);
    await tester.enterText(textFieldFinder, 'updated ${maxCount - 1}');
    await tester.pump();

    final saveButtonFinder = find.byType(OutlinedButton);
    expect(saveButtonFinder, findsOneWidget);
    await tester.tap(saveButtonFinder);
    await tester.pump(const Duration(seconds: 1));

    countdownFinder = find.ancestor(of: find.text('created 0'), matching: find.byType(CountdownElement));
    await tester.scrollUntilVisible(countdownFinder, -500, duration: const Duration(seconds: 1));
    expect(countdownFinder, findsOneWidget);
    await tester.pump();

    for (var i = 0; i < maxCount; i++) {
      final countdownFinder = find.byType(Dismissible).first;
      await tester.drag(countdownFinder, const Offset(-500, 0));
      await tester.pump(const Duration(seconds: 1));
    }

    countdownFinder = find.byType(CountdownElement);
    countdownElements = tester.widgetList<CountdownElement>(countdownFinder);
    expect(countdownElements, isEmpty);
  });
}
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:time_counter/countdown_text.dart';
import 'package:time_counter_flutter_library/time_counter.dart';

import 'goal_setter_test.mocks.dart';

Future<void> _pumpWidget(WidgetTester tester, TimeCounter mockTimeCounter) async {
  await tester.pumpWidget(
    MaterialApp(
        home: ChangeNotifierProvider<TimeCounter>(
          create: (_) => mockTimeCounter,
          builder: (context, child) => CountdownText(goal: DateTime(2002, 7, 4)),
        )
    ),
  );
}

@GenerateMocks([TimeCounter])
void main() {
  testWidgets('Future goal should be displayed correctly', (WidgetTester tester) async {
    final mockTimeCounter = MockTimeCounter();
    when(mockTimeCounter.getDateTime()).thenReturn(DateTime(2002, 7, 3));

    await _pumpWidget(tester, mockTimeCounter);

    final textFind = find.text('+ 01d 00:00:00');

    final BuildContext context = tester.element(find.byType(MaterialApp));

    expect(textFind, findsOneWidget);
    final text = tester.firstWidget<Text>(textFind);
    expect(text.style?.color?.alpha, Theme.of(context).textTheme.headline4?.color?.alpha);
  });

  testWidgets('Past goal should be displayed correctly', (WidgetTester tester) async {
    final mockTimeCounter = MockTimeCounter();
    when(mockTimeCounter.getDateTime()).thenReturn(DateTime(2002, 7, 5));

    await _pumpWidget(tester, mockTimeCounter);

    final textFind = find.text('- 01d 00:00:00');

    expect(textFind, findsOneWidget);
    final text = tester.firstWidget<Text>(textFind);
    expect(text.style?.color?.alpha, 60);
  });
}

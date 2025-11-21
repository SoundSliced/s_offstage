import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:s_offstage/s_offstage.dart';

void main() {
  testWidgets('SOffstage shows child when not offstage',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: SOffstage(
          isOffstage: false,
          child: const Text('Visible'),
        ),
      ),
    );
    expect(find.text('Visible'), findsOneWidget);
  });

  testWidgets('SOffstage hides child when offstage',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: SOffstage(
          isOffstage: true,
          child: const Text('Hidden'),
        ),
      ),
    );
    expect(find.text('Hidden'), findsNothing);
  });
}

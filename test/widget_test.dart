import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:signup_app/main.dart';
import 'package:signup_app/screens/signup_screen.dart';

void main() {
  testWidgets('app opens on welcome screen', (WidgetTester tester) async {
    await tester.pumpWidget(const HauntedMansionApp());

    expect(find.text('Enter the Registry'), findsOneWidget);
  });

  testWidgets('empty signup form shows errors', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: SignupScreen(),
      ),
    );

    await tester.ensureVisible(find.text('Register Creature'));
    await tester.tap(find.text('Register Creature'));
    await tester.pump();

    expect(find.text('Please enter your name'), findsOneWidget);
    expect(find.text('Please enter your email'), findsOneWidget);
    expect(find.text('Please enter a password'), findsOneWidget);
    expect(find.text('Please select a creature'), findsOneWidget);
    expect(find.text('Pick your birth date'), findsOneWidget);
  });

  testWidgets('invalid email shows error', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: SignupScreen(),
      ),
    );

    await tester.enterText(find.byType(TextFormField).at(0), 'Sara');
    await tester.enterText(find.byType(TextFormField).at(1), 'sara.email');
    await tester.enterText(find.byType(TextFormField).at(2), 'secret1');

    await tester.ensureVisible(find.text('Register Creature'));
    await tester.tap(find.text('Register Creature'));
    await tester.pump();

    expect(find.text('Please enter a valid email'), findsOneWidget);
  });

  testWidgets('short password shows error', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: SignupScreen(),
      ),
    );

    await tester.enterText(find.byType(TextFormField).at(0), 'Sara');
    await tester.enterText(
      find.byType(TextFormField).at(1),
      'sara@email.com',
    );
    await tester.enterText(find.byType(TextFormField).at(2), '12345');

    await tester.ensureVisible(find.text('Register Creature'));
    await tester.tap(find.text('Register Creature'));
    await tester.pump();

    expect(
      find.text('Password must be at least 6 characters'),
      findsOneWidget,
    );
  });
}
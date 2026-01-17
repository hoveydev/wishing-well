import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wishing_well/screens/confirmation/confirmation_header.dart';
import 'package:wishing_well/theme/app_theme.dart';

void main() {
  group('ConfirmationHeader', () {
    testWidgets('renders header text', (tester) async {
      const testHeaderText = 'Account Created';

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: const Scaffold(
            body: ConfirmationHeader(headerText: testHeaderText),
          ),
        ),
      );

      expect(find.text(testHeaderText), findsOneWidget);
    });

    testWidgets('uses headlineLarge text style', (tester) async {
      const testHeaderText = 'Success';

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: const Scaffold(
            body: ConfirmationHeader(headerText: testHeaderText),
          ),
        ),
      );

      final textFinder = find.text(testHeaderText);
      final textWidget = tester.widget<Text>(textFinder);

      expect(textWidget.style?.fontSize, isNotNull);
      expect(textWidget.style?.fontWeight, isNotNull);
    });

    testWidgets('centers text', (tester) async {
      const testHeaderText = 'Centered';

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: const Scaffold(
            body: ConfirmationHeader(headerText: testHeaderText),
          ),
        ),
      );

      final textFinder = find.text(testHeaderText);
      final textWidget = tester.widget<Text>(textFinder);

      expect(textWidget.textAlign, TextAlign.center);
    });

    testWidgets('has correct semantics label', (tester) async {
      const testHeaderText = 'Test Header';

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: const Scaffold(
            body: ConfirmationHeader(headerText: testHeaderText),
          ),
        ),
      );

      final textFinder = find.text(testHeaderText);
      final textWidget = tester.widget<Text>(textFinder);

      expect(textWidget.semanticsLabel, testHeaderText);
    });

    testWidgets('handles empty header text', (tester) async {
      const testHeaderText = '';

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: const Scaffold(
            body: ConfirmationHeader(headerText: testHeaderText),
          ),
        ),
      );

      expect(find.text(''), findsOneWidget);
    });

    testWidgets('handles long header text', (tester) async {
      const testHeaderText =
          'This is a very long header text that should wrap to multiple lines';

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: const Scaffold(
            body: ConfirmationHeader(headerText: testHeaderText),
          ),
        ),
      );

      expect(find.text(testHeaderText), findsOneWidget);
    });
  });
}

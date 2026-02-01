import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wishing_well/l10n/app_localizations.dart';
import 'package:wishing_well/screens/home/components/home_header.dart';
import 'package:wishing_well/theme/app_theme.dart';

void main() {
  group('HomeHeader', () {
    Widget createTestWidget(Widget child) => MaterialApp(
      theme: AppTheme.lightTheme,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(body: child),
    );

    testWidgets('renders welcome text without firstName', (tester) async {
      await tester.pumpWidget(createTestWidget(const HomeHeader()));

      expect(find.text('Welcome!'), findsOneWidget);
    });

    testWidgets('renders welcome text with firstName', (tester) async {
      const firstName = 'John';

      await tester.pumpWidget(
        createTestWidget(const HomeHeader(firstName: firstName)),
      );

      expect(find.text('Welcome, $firstName!'), findsOneWidget);
    });

    testWidgets('uses titleLarge text style', (tester) async {
      await tester.pumpWidget(createTestWidget(const HomeHeader()));

      final textFinder = find.text('Welcome!');
      final textWidget = tester.widget<Text>(textFinder);

      expect(textWidget.style?.fontSize, isNotNull);
      expect(textWidget.style?.fontWeight, FontWeight.w400);
    });

    testWidgets('has correct semantics label', (tester) async {
      const firstName = 'Jane';

      await tester.pumpWidget(
        createTestWidget(const HomeHeader(firstName: firstName)),
      );

      final textFinder = find.text('Welcome, $firstName!');
      final textWidget = tester.widget<Text>(textFinder);

      expect(textWidget.semanticsLabel, 'Welcome, $firstName!');
    });

    testWidgets('handles empty string firstName', (tester) async {
      await tester.pumpWidget(
        createTestWidget(const HomeHeader(firstName: '')),
      );

      expect(find.text('Welcome, !'), findsOneWidget);
    });
  });
}

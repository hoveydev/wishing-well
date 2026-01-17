import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wishing_well/l10n/app_localizations.dart';
import 'package:wishing_well/screens/home/home_coming_up.dart';
import 'package:wishing_well/theme/app_theme.dart';

void main() {
  group('HomeComingUp', () {
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

    testWidgets('renders Coming Up header', (tester) async {
      await tester.pumpWidget(createTestWidget(const HomeComingUp()));

      expect(find.text('Coming Up'), findsOneWidget);
    });

    testWidgets('renders Card component', (tester) async {
      await tester.pumpWidget(createTestWidget(const HomeComingUp()));

      expect(find.byType(Card), findsOneWidget);
    });

    testWidgets('renders placeholder text', (tester) async {
      await tester.pumpWidget(createTestWidget(const HomeComingUp()));

      expect(find.text('Nothing yet :)'), findsOneWidget);
    });

    testWidgets('has header semantics', (tester) async {
      await tester.pumpWidget(createTestWidget(const HomeComingUp()));

      expect(find.byType(Semantics), findsWidgets);
    });

    testWidgets('uses titleMedium for header text', (tester) async {
      await tester.pumpWidget(createTestWidget(const HomeComingUp()));

      final textFinder = find.text('Coming Up');
      final textWidget = tester.widget<Text>(textFinder);

      expect(textWidget.style?.fontSize, isNotNull);
    });

    testWidgets('uses bodySmall for placeholder text', (tester) async {
      await tester.pumpWidget(createTestWidget(const HomeComingUp()));

      final textFinder = find.text('Nothing yet :)');
      final textWidget = tester.widget<Text>(textFinder);

      expect(textWidget.style?.fontSize, isNotNull);
    });

    testWidgets('renders as Column', (tester) async {
      await tester.pumpWidget(createTestWidget(const HomeComingUp()));

      expect(find.byType(Column), findsOneWidget);
    });

    testWidgets('Card has full width', (tester) async {
      await tester.pumpWidget(createTestWidget(const HomeComingUp()));

      final sizedBoxFinder = find.byType(SizedBox);
      final sizedBox = tester.widget<SizedBox>(sizedBoxFinder);

      expect(sizedBox.width, double.infinity);
    });

    testWidgets('Card has no elevation', (tester) async {
      await tester.pumpWidget(createTestWidget(const HomeComingUp()));

      final cardFinder = find.byType(Card);
      final cardWidget = tester.widget<Card>(cardFinder);

      expect(cardWidget.elevation, 0);
    });
  });
}

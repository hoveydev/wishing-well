import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wishing_well/l10n/app_localizations.dart';
import 'package:wishing_well/screens/add_wisher/add_wisher_description.dart';
import 'package:wishing_well/theme/app_theme.dart';

void main() {
  group('AddWisherDescription', () {
    testWidgets('renders description text correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: const Scaffold(body: AddWisherDescription()),
        ),
      );

      expect(
        find.text(
          'A wisher is someone special in your life whose special occasions '
          'you want to remember and celebrate. Add friends, family, or loved '
          'ones to never miss an important moment.',
        ),
        findsOneWidget,
      );
    });

    testWidgets('uses styled text widget', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: const Scaffold(body: AddWisherDescription()),
        ),
      );

      expect(find.byType(Text), findsOneWidget);
      expect(
        find.textContaining('A wisher is someone special'),
        findsOneWidget,
      );
    });

    testWidgets('has correct semantics label', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: const Scaffold(body: AddWisherDescription()),
        ),
      );

      expect(
        find.bySemanticsLabel(
          'A wisher is someone special in your life whose special occasions '
          'you want to remember and celebrate. Add friends, family, or loved '
          'ones to never miss an important moment.',
        ),
        findsOneWidget,
      );
    });
  });
}

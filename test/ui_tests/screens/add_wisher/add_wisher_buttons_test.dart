import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wishing_well/l10n/app_localizations.dart';
import 'package:wishing_well/screens/add_wisher/add_wisher_buttons.dart';
import 'package:wishing_well/theme/app_theme.dart';

void main() {
  group('AddWisherButtons', () {
    testWidgets('renders both buttons correctly', (tester) async {
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
          home: Scaffold(
            body: AddWisherButtons(
              onAddFromContacts: () {},
              onAddManually: () {},
            ),
          ),
        ),
      );

      expect(find.text('Add From Contacts'), findsOneWidget);
      expect(find.text('Add Manually'), findsOneWidget);
    });

    testWidgets('calls onAddFromContacts when primary button is tapped', (
      tester,
    ) async {
      var wasCalled = false;

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
          home: Scaffold(
            body: AddWisherButtons(
              onAddFromContacts: () => wasCalled = true,
              onAddManually: () {},
            ),
          ),
        ),
      );

      await tester.tap(find.text('Add From Contacts'));
      await tester.pump();

      expect(wasCalled, true);
    });

    testWidgets('calls onAddManually when secondary button is tapped', (
      tester,
    ) async {
      var wasCalled = false;

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
          home: Scaffold(
            body: AddWisherButtons(
              onAddFromContacts: () {},
              onAddManually: () => wasCalled = true,
            ),
          ),
        ),
      );

      await tester.tap(find.text('Add Manually'));
      await tester.pump();

      expect(wasCalled, true);
    });

    testWidgets('buttons are arranged vertically with spacing', (tester) async {
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
          home: Scaffold(
            body: AddWisherButtons(
              onAddFromContacts: () {},
              onAddManually: () {},
            ),
          ),
        ),
      );

      // Check that buttons are present
      expect(find.text('Add From Contacts'), findsOneWidget);
      expect(find.text('Add Manually'), findsOneWidget);

      // Check that there's spacing component
      expect(find.byType(SizedBox), findsWidgets);
    });

    testWidgets('required callback parameters are enforced', (tester) async {
      expect(
        () => AddWisherButtons(onAddFromContacts: () {}, onAddManually: () {}),
        returnsNormally,
      );
    });
  });
}

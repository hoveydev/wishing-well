import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wishing_well/l10n/app_localizations.dart';
import 'package:wishing_well/screens/confirmation/components/confirmation_header.dart';
import 'package:wishing_well/screens/confirmation/confirmation_screen.dart';
import 'package:wishing_well/theme/app_theme.dart';

void main() {
  group('ConfirmationHeader', () {
    testWidgets('renders account confirmation header', (tester) async {
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
          home: const Scaffold(
            body: ConfirmationHeader(flavor: ConfirmationScreenFlavor.account),
          ),
        ),
      );

      expect(find.text('Account Confirmed!'), findsOneWidget);
    });

    testWidgets('renders create account confirmation header', (tester) async {
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
          home: const Scaffold(
            body: ConfirmationHeader(
              flavor: ConfirmationScreenFlavor.createAccount,
            ),
          ),
        ),
      );

      expect(find.text('Account Successfully Created!'), findsOneWidget);
    });

    testWidgets('uses headlineLarge text style', (tester) async {
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
          home: const Scaffold(
            body: ConfirmationHeader(
              flavor: ConfirmationScreenFlavor.forgotPassword,
            ),
          ),
        ),
      );

      final textFinder = find.text('Reset Password Request Sent!');
      final textWidget = tester.widget<Text>(textFinder);

      expect(textWidget.style?.fontSize, isNotNull);
      expect(textWidget.style?.fontWeight, isNotNull);
    });

    testWidgets('centers text', (tester) async {
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
          home: const Scaffold(
            body: ConfirmationHeader(
              flavor: ConfirmationScreenFlavor.resetPassword,
            ),
          ),
        ),
      );

      final textFinder = find.text('Password Successfully Reset!');
      final textWidget = tester.widget<Text>(textFinder);

      expect(textWidget.textAlign, TextAlign.center);
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
          home: const Scaffold(
            body: ConfirmationHeader(flavor: ConfirmationScreenFlavor.account),
          ),
        ),
      );

      final textFinder = find.text('Account Confirmed!');
      final textWidget = tester.widget<Text>(textFinder);

      expect(textWidget.semanticsLabel, 'Account Confirmed!');
    });
  });
}

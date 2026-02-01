import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:wishing_well/l10n/app_localizations.dart';
import 'package:wishing_well/screens/confirmation/confirmation_screen.dart';
import 'package:wishing_well/utils/loading_controller.dart';
import 'package:wishing_well/theme/app_theme.dart';

dynamic startAppWithForgotPasswordConfirmationScreen(
  WidgetTester tester,
) async {
  final controller = LoadingController();
  final ChangeNotifierProvider app =
      ChangeNotifierProvider<LoadingController>.value(
        value: controller,
        child: MaterialApp(
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: const ConfirmationScreen.forgotPassword(),
        ),
      );
  await tester.pumpWidget(app);
  await tester.pumpAndSettle();
}

void main() {
  group('create account screen tests', () {
    testWidgets('renders screen with all elements', (
      WidgetTester tester,
    ) async {
      await startAppWithForgotPasswordConfirmationScreen(tester);
      expect(find.byIcon(Icons.close), findsOneWidget);
      expect(find.text('Reset Password Request Sent!'), findsOneWidget);

      expect(
        find.text('Please check your email for password reset instructions.'),
        findsOneWidget,
      );
    });
  });
}

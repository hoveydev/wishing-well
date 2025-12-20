import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:wishing_well/l10n/app_localizations.dart';
import 'package:wishing_well/utils/loading_controller.dart';
import 'package:wishing_well/screens/create_account_confirmation/create_account_confirmation_screen.dart';
import 'package:wishing_well/theme/app_theme.dart';

dynamic startAppWithCreateAccountConfirmationScreen(WidgetTester tester) async {
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
          home: const CreateAccountConfirmationScreen(),
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
      await startAppWithCreateAccountConfirmationScreen(tester);
      expect(find.byIcon(Icons.close), findsOneWidget);
      expect(find.text('Account Successfully Created!'), findsOneWidget);
      final iconWidgetFinder = find.byWidgetPredicate(
        (widget) => widget is Icon && widget.icon == Icons.check_circle,
      );
      expect(iconWidgetFinder, findsOneWidget);
      expect(
        find.text(
          'Please check your email to confirm your account. Your account must be confirmed before you are able to log in.',
        ),
        findsOneWidget,
      );
    });
  });
}

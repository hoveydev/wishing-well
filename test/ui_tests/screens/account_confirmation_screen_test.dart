import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:wishing_well/l10n/app_localizations.dart';
import 'package:wishing_well/screens/confirmation/confirmation_screen.dart';
import 'package:wishing_well/theme/app_theme.dart';
import 'package:wishing_well/utils/loading_controller.dart';

dynamic startAppWithAccountConfirmationScreen(WidgetTester tester) async {
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
          home: const ConfirmationScreen.account(),
        ),
      );
  await tester.pumpWidget(app);
  await tester.pumpAndSettle();
}

void main() {
  group('Account Confirmation Screen Tests', () {
    testWidgets('renders screen with all elements', (
      WidgetTester tester,
    ) async {
      await startAppWithAccountConfirmationScreen(tester);
      expect(find.text('Account Confirmed!'), findsOneWidget);
      final checkIconWidgetFinder = find.byWidgetPredicate(
        (widget) => widget is Icon && widget.icon == Icons.check_circle,
      );
      expect(checkIconWidgetFinder, findsOneWidget);
      expect(
        find.text('You may now securely log in to WishingWell'),
        findsOneWidget,
      );
      final closeIconWidgetFinder = find.byWidgetPredicate(
        (widget) => widget is Icon && widget.icon == Icons.close,
      );
      expect(closeIconWidgetFinder, findsOneWidget);
    });
  });
}

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wishing_well/l10n/app_localizations.dart';
import 'package:wishing_well/screens/login_screen.dart';
import 'package:wishing_well/screens/login_viewmodel.dart';

startAppWithLoginScreen(WidgetTester tester) async {
  MaterialApp app = MaterialApp(
    localizationsDelegates: [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: AppLocalizations.supportedLocales,
    home: LoginScreen(viewModel: LoginViewModel())
  );
  await tester.pumpWidget(app);
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('renders screen with all elements', (WidgetTester tester) async {
    await startAppWithLoginScreen(tester);
    expect(find.image(AssetImage('assets/images/logo.png')), findsOneWidget);
    expect(find.text('WishingWell'), findsOneWidget);
    expect(find.text('Your personal well for thoughtful giving'), findsOneWidget);
    expect(find.widgetWithText(TextField, 'Email'), findsOneWidget);
    expect(find.widgetWithText(TextField, 'Password'), findsOneWidget);
    expect(find.text('Forgot Password?'), findsOneWidget);
    expect(find.text('Sign In'), findsOneWidget);
    expect(find.text('Create an Account'), findsOneWidget);
  });
}
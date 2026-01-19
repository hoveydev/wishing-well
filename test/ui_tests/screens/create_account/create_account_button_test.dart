import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wishing_well/l10n/app_localizations.dart';
import 'package:wishing_well/screens/create_account/create_account_viewmodel.dart';
import 'package:wishing_well/screens/create_account/create_account_button.dart';
import 'package:wishing_well/theme/app_theme.dart';

import '../../../../testing_resources/mocks/repositories/mock_auth_repository.dart';

class MockCreateAccountViewmodel extends CreateAccountViewmodel {
  MockCreateAccountViewmodel() : super(authRepository: MockAuthRepository());

  bool _buttonTapped = false;

  bool get buttonTapped => _buttonTapped;

  @override
  Future<void> tapCreateAccountButton(BuildContext context) async {
    _buttonTapped = true;
  }
}

void main() {
  group('CreateAccountButton', () {
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

    testWidgets('renders button', (tester) async {
      final viewModel = MockCreateAccountViewmodel();

      await tester.pumpWidget(
        createTestWidget(CreateAccountButton(viewModel: viewModel)),
      );

      expect(find.text('Create Account'), findsOneWidget);
    });

    testWidgets('calls tapCreateAccountButton when tapped', (tester) async {
      final viewModel = MockCreateAccountViewmodel();

      await tester.pumpWidget(
        createTestWidget(CreateAccountButton(viewModel: viewModel)),
      );

      await tester.tap(find.text('Create Account'));
      expect(viewModel.buttonTapped, true);
    });
  });
}

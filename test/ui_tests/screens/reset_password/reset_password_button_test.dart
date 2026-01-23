import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wishing_well/l10n/app_localizations.dart';
import 'package:wishing_well/screens/reset_password/reset_password_view_model.dart';
import 'package:wishing_well/screens/reset_password/reset_password_button.dart';
import 'package:wishing_well/theme/app_theme.dart';

import '../../../../testing_resources/mocks/repositories/mock_auth_repository.dart';

class MockResetPasswordViewModel extends ResetPasswordViewModel {
  MockResetPasswordViewModel()
    : super(
        authRepository: MockAuthRepository(),
        email: 'test@example.com',
        token: 'test-token',
      );

  bool _buttonTapped = false;

  bool get buttonTapped => _buttonTapped;

  @override
  Future<void> tapResetPasswordButton(BuildContext context) async {
    _buttonTapped = true;
  }
}

void main() {
  group('ResetPasswordButton', () {
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
      final viewModel = MockResetPasswordViewModel();

      await tester.pumpWidget(
        createTestWidget(ResetPasswordButton(viewModel: viewModel)),
      );

      expect(find.text('Reset Password'), findsOneWidget);
    });

    testWidgets('calls tapResetPasswordButton when tapped', (tester) async {
      final viewModel = MockResetPasswordViewModel();

      await tester.pumpWidget(
        createTestWidget(ResetPasswordButton(viewModel: viewModel)),
      );

      await tester.tap(find.text('Reset Password'));
      expect(viewModel.buttonTapped, true);
    });
  });
}

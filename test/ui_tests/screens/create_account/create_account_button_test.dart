import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wishing_well/l10n/app_localizations.dart';
import 'package:wishing_well/screens/create_account/create_account_viewmodel.dart';
import 'package:wishing_well/screens/create_account/create_account_button.dart';
import 'package:wishing_well/theme/app_theme.dart';
import 'package:wishing_well/data/respositories/auth/auth_repository.dart';
import 'package:wishing_well/utils/result.dart';

class MockAuthRepository extends AuthRepository {
  @override
  bool get isAuthenticated => false;

  @override
  String? get userFirstName => null;

  @override
  Future<Result<void>> login({
    required String email,
    required String password,
  }) async => const Result.ok(null);

  @override
  Future<Result<void>> logout() async => const Result.ok(null);

  @override
  Future<Result<void>> createAccount({
    required String email,
    required String password,
  }) async => const Result.ok(null);

  @override
  Future<Result<void>> sendPasswordResetRequest({
    required String email,
  }) async => const Result.ok(null);

  @override
  Future<Result<void>> resetUserPassword({
    required String email,
    required String newPassword,
    required String token,
  }) async => const Result.ok(null);
}

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

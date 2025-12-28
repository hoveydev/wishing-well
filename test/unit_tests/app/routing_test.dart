import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:wishing_well/components/button/app_button.dart';
import 'package:wishing_well/components/button/app_button_type.dart';
import 'package:wishing_well/components/input/app_input.dart';
import 'package:wishing_well/components/input/app_input_type.dart';
import 'package:wishing_well/l10n/app_localizations.dart';
import 'package:wishing_well/screens/account_confirmation/account_confirmation_screen.dart';
import 'package:wishing_well/screens/reset_password/reset_password_screen.dart';
import 'package:wishing_well/screens/reset_password/reset_password_viewmodel.dart';
import 'package:wishing_well/screens/reset_password_confirmation/reset_password_confirmation_screen.dart';
import 'package:wishing_well/utils/deep_links/deep_link_handler.dart';
import 'package:wishing_well/utils/loading_controller.dart';
import 'package:wishing_well/screens/create_account/create_account_screen.dart';
import 'package:wishing_well/screens/create_account/create_account_viewmodel.dart';
import 'package:wishing_well/screens/create_account_confirmation/create_account_confirmation_screen.dart';
import 'package:wishing_well/screens/forgot_password/forgot_password_screen.dart';
import 'package:wishing_well/screens/forgot_password/forgot_password_viewmodel.dart';
import 'package:wishing_well/screens/forgot_password_confirmation/forgot_password_confirmation_screen.dart';
import 'package:wishing_well/screens/login/login_screen.dart';
import 'package:wishing_well/screens/login/login_viewmodel.dart';
import 'package:wishing_well/theme/app_theme.dart';

import '../../../testing_resources/mocks/deep_link/mock_deep_link_source.dart';
import '../../../testing_resources/mocks/repositories/mock_auth_repository.dart';

GoRouter createMockRouter() => GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(
      path: '/login',
      name: 'login',
      builder: (context, state) => LoginScreen(
        viewModel: LoginViewModel(authRepository: MockAuthRepository()),
      ),
    ),
    GoRoute(
      path: '/forgot-password',
      name: 'forgot-password',
      builder: (context, state) => ForgotPasswordScreen(
        viewModel: ForgotPasswordViewModel(
          authRepository: MockAuthRepository(),
        ),
      ),
      routes: [
        GoRoute(
          path: 'confirm',
          name: 'forgot-password-confirm',
          builder: (context, state) => const ForgotPasswordConfirmationScreen(),
        ),
        GoRoute(
          path: 'reset',
          name: 'reset-password',
          builder: (context, state) => ResetPasswordScreen(
            viewmodel: ResetPasswordViewmodel(
              authRepository: MockAuthRepository(),
              email: 'reset.password@email.com',
              token: 'valid-token',
            ),
          ),
          routes: [
            GoRoute(
              path: 'confirm',
              name: 'reset-password-confirmation',
              builder: (context, state) =>
                  const ResetPasswordConfirmationScreen(),
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      path: '/create-account',
      name: 'create-account',
      builder: (context, state) => CreateAccountScreen(
        viewModel: CreateAccountViewmodel(authRepository: MockAuthRepository()),
      ),
      routes: [
        GoRoute(
          path: 'confirm',
          name: 'create-account-confirm',
          builder: (context, state) => const CreateAccountConfirmationScreen(),
        ),
        GoRoute(
          path: 'account-confirm',
          name: 'account-confirm',
          builder: (context, state) => const AccountConfirmationScreen(),
        ),
      ],
    ),
    GoRoute(
      path: '/home',
      name: 'home',
      builder: (context, state) => const Placeholder(),
    ),
  ],
);

dynamic startAppWithLoginScreen(
  WidgetTester tester,
  GoRouter router,
  MockDeepLinkSource source,
) async {
  final deepLinkHandler = DeepLinkHandler(
    (name, queryParameters) =>
        router.goNamed(name, queryParameters: queryParameters ?? const {}),
    source: source,
  );
  final Widget app = MultiProvider(
    providers: [ChangeNotifierProvider(create: (_) => LoadingController())],
    child: MaterialApp.router(
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: router,
    ),
  );
  await tester.pumpWidget(app);
  deepLinkHandler.init();
  await tester.pumpAndSettle();
}

void main() {
  group('Login Flow Routing', () {
    testWidgets('Login > Forgot Password > Login', (WidgetTester tester) async {
      final mockRouter = createMockRouter();
      final mockSource = MockDeepLinkSource(
        initialUri: Uri.parse('not_needed'),
      );
      await startAppWithLoginScreen(tester, mockRouter, mockSource);
      await tester.tap(find.text('Forgot Password?'));
      await tester.pumpAndSettle();
      expect(mockRouter.state.uri.path, '/forgot-password');
      await tester.tap(find.byIcon(Icons.keyboard_arrow_down));
      await tester.pumpAndSettle();
      expect(mockRouter.state.uri.path, '/login');
    });

    testWidgets('Login > Forgot Password > Confirm > Login', (
      WidgetTester tester,
    ) async {
      final mockRouter = createMockRouter();
      final mockSource = MockDeepLinkSource(
        initialUri: Uri.parse('not_needed'),
      );
      await startAppWithLoginScreen(tester, mockRouter, mockSource);
      await tester.tap(find.text('Forgot Password?'));
      await tester.pumpAndSettle();
      expect(mockRouter.state.uri.path, '/forgot-password');
      final emailWidgetFinder = find.byWidgetPredicate(
        (widget) => widget is AppInput && widget.type == AppInputType.email,
      );
      await tester.enterText(emailWidgetFinder, 'forgot.password@email.com');
      await tester.tap(find.text('Submit'));
      await tester.pumpAndSettle();
      expect(mockRouter.state.uri.path, '/forgot-password/confirm');
      await tester.tap(find.byIcon(Icons.close));
      await tester.pumpAndSettle();
      expect(mockRouter.state.uri.path, '/login');
    });

    testWidgets('Login > Create Account > Login', (WidgetTester tester) async {
      final mockRouter = createMockRouter();
      final mockSource = MockDeepLinkSource(
        initialUri: Uri.parse('not_needed'),
      );
      await startAppWithLoginScreen(tester, mockRouter, mockSource);
      await tester.tap(find.text('Create an Account'));
      await tester.pumpAndSettle();
      expect(mockRouter.state.uri.path, '/create-account');
      await tester.tap(find.byIcon(Icons.keyboard_arrow_down));
      await tester.pumpAndSettle();
      expect(mockRouter.state.uri.path, '/login');
    });

    testWidgets('Login > Home', (WidgetTester tester) async {
      final mockRouter = createMockRouter();
      final mockSource = MockDeepLinkSource(
        initialUri: Uri.parse('not_needed'),
      );
      await startAppWithLoginScreen(tester, mockRouter, mockSource);
      final emailWidgetFinder = find.byWidgetPredicate(
        (widget) => widget is AppInput && widget.type == AppInputType.email,
      );
      await tester.enterText(emailWidgetFinder, 'email@email.com');
      final passwordWidgetFinder = find.byWidgetPredicate(
        (widget) => widget is AppInput && widget.type == AppInputType.password,
      );
      await tester.enterText(passwordWidgetFinder, 'password');
      await tester.tap(find.text('Sign In'));
      await tester.pumpAndSettle();
      expect(mockRouter.state.uri.path, '/home');
    });

    testWidgets('Login > Create Account > Confirm > Login', (
      WidgetTester tester,
    ) async {
      final mockRouter = createMockRouter();
      final mockSource = MockDeepLinkSource(
        initialUri: Uri.parse('not_needed'),
      );
      await startAppWithLoginScreen(tester, mockRouter, mockSource);
      await tester.tap(find.text('Create an Account'));
      await tester.pumpAndSettle();
      expect(mockRouter.state.uri.path, '/create-account');
      final emailWidgetFinder = find.byWidgetPredicate(
        (widget) => widget is AppInput && widget.type == AppInputType.email,
      );
      await tester.enterText(emailWidgetFinder, 'new.account@email.com');
      final passwordWidgetFinder = find.byWidgetPredicate(
        (widget) =>
            widget is AppInput &&
            widget.type == AppInputType.password &&
            widget.placeholder == 'Password',
      );
      await tester.enterText(passwordWidgetFinder, 'Password123!');
      final confirmPasswordWidgetFinder = find.byWidgetPredicate(
        (widget) =>
            widget is AppInput &&
            widget.type == AppInputType.password &&
            widget.placeholder == 'Confirm Password',
      );
      await tester.enterText(confirmPasswordWidgetFinder, 'Password123!');
      await tester.tap(find.text('Create Account'));
      await tester.pumpAndSettle();
      expect(mockRouter.state.uri.path, '/create-account/confirm');
      await tester.tap(find.byIcon(Icons.close));
      await tester.pumpAndSettle();
      expect(mockRouter.state.uri.path, '/login');
    });
  });

  testWidgets('Login > Reset Password (deep link) > Login', (tester) async {
    final mockRouter = createMockRouter();
    final source = MockDeepLinkSource(
      initialUri: Uri.parse('https://wishingwell.app/auth/password-reset'),
    );
    await startAppWithLoginScreen(tester, mockRouter, source);
    await tester.pumpAndSettle();
    expect(mockRouter.state.uri.path, '/forgot-password/reset');
    await tester.tap(find.byIcon(Icons.close));
    await tester.pumpAndSettle();
    expect(mockRouter.state.uri.path, '/login');
  });

  testWidgets('Login > Reset Password (deep link) > Confirm > Login', (
    tester,
  ) async {
    final mockRouter = createMockRouter();
    final source = MockDeepLinkSource(
      initialUri: Uri.parse('https://wishingwell.app/auth/password-reset'),
    );
    await startAppWithLoginScreen(tester, mockRouter, source);
    await tester.pumpAndSettle();
    expect(mockRouter.state.uri.path, '/forgot-password/reset');
    final passwordWidgetFinder = find.byWidgetPredicate(
      (widget) =>
          widget is AppInput &&
          widget.type == AppInputType.password &&
          widget.placeholder == 'Password',
    );
    await tester.enterText(passwordWidgetFinder, 'Password123!*()');
    final confirmPasswordWidgetFinder = find.byWidgetPredicate(
      (widget) =>
          widget is AppInput &&
          widget.type == AppInputType.password &&
          widget.placeholder == 'Confirm Password',
    );
    await tester.enterText(confirmPasswordWidgetFinder, 'Password123!*()');
    final resetPasswordButtonWidgetFinder = find.byWidgetPredicate(
      (widget) =>
          widget is AppButton &&
          widget.type == AppButtonType.primary &&
          widget.label == 'Reset Password',
    );
    await tester.tap(resetPasswordButtonWidgetFinder);
    await tester.pumpAndSettle();
    expect(mockRouter.state.uri.path, '/forgot-password/reset/confirm');
    await tester.tap(find.byIcon(Icons.close));
    await tester.pumpAndSettle();
    expect(mockRouter.state.uri.path, '/login');
  });

  testWidgets('Login > Account Confirmation (deep link) > Login', (
    tester,
  ) async {
    final mockRouter = createMockRouter();
    final source = MockDeepLinkSource(
      initialUri: Uri.parse(
        'https://wishingwell.app/auth/account-confirm?type=signup',
      ),
    );
    await startAppWithLoginScreen(tester, mockRouter, source);
    await tester.pumpAndSettle();
    expect(mockRouter.state.uri.path, '/create-account/account-confirm');
    await tester.tap(find.byIcon(Icons.close));
    await tester.pumpAndSettle();
    expect(mockRouter.state.uri.path, '/login');
  });
}

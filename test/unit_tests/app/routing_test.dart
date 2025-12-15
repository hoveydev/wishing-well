import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:wishing_well/components/input/app_input.dart';
import 'package:wishing_well/components/input/app_input_type.dart';
import 'package:wishing_well/l10n/app_localizations.dart';
import 'package:wishing_well/loading_controller.dart';
import 'package:wishing_well/screens/create_account/create_account_screen.dart';
import 'package:wishing_well/screens/create_account/create_account_viewmodel.dart';
import 'package:wishing_well/screens/forgot_password/forgot_password_screen.dart';
import 'package:wishing_well/screens/forgot_password/forgot_password_viewmodel.dart';
import 'package:wishing_well/screens/login/login_screen.dart';
import 'package:wishing_well/screens/login/login_viewmodel.dart';

import '../../../testing_resources/mocks/repositories/mock_auth_repository.dart';

GoRouter createMockRouter() => GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(
      path: '/login',
      builder: (context, state) => LoginScreen(
        viewModel: LoginViewModel(authRepository: MockAuthRepository()),
      ),
    ),
    GoRoute(
      path: '/forgot-password',
      builder: (context, state) =>
          ForgotPasswordScreen(viewModel: ForgotPasswordViewModel()),
    ),
    GoRoute(
      path: '/sign-up',
      builder: (context, state) =>
          CreateAccountScreen(viewModel: CreateAccountViewmodel()),
    ),
    GoRoute(path: '/home', builder: (context, state) => const Placeholder()),
  ],
);

dynamic startAppWithLoginScreen(WidgetTester tester, GoRouter router) async {
  final Widget app = MultiProvider(
    providers: [ChangeNotifierProvider(create: (_) => LoadingController())],
    child: MaterialApp.router(
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
  await tester.pumpAndSettle();
}

void main() {
  group('Login Flow Routing', () {
    testWidgets('Login > Forgot Password > Login', (WidgetTester tester) async {
      final mockRouter = createMockRouter();
      await startAppWithLoginScreen(tester, mockRouter);
      await tester.tap(find.text('Forgot Password?'));
      await tester.pumpAndSettle();
      expect(mockRouter.state.uri.path, '/forgot-password');
      await tester.tap(find.byIcon(Icons.keyboard_arrow_down));
      await tester.pumpAndSettle();
      expect(mockRouter.state.uri.path, '/login');
    });

    testWidgets('Login > Create Account > Login', (WidgetTester tester) async {
      final mockRouter = createMockRouter();
      await startAppWithLoginScreen(tester, mockRouter);
      await tester.tap(find.text('Create an Account'));
      await tester.pumpAndSettle();
      expect(mockRouter.state.uri.path, '/sign-up');
      await tester.tap(find.byIcon(Icons.keyboard_arrow_down));
      await tester.pumpAndSettle();
      expect(mockRouter.state.uri.path, '/login');
    });

    testWidgets('Login > Home', (WidgetTester tester) async {
      final mockRouter = createMockRouter();
      await startAppWithLoginScreen(tester, mockRouter);
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
  });
}

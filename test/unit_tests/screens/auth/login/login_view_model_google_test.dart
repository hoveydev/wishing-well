import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:wishing_well/features/auth/login/login_view_model.dart';
import 'package:wishing_well/l10n/app_localizations.dart';
import 'package:wishing_well/test_helpers/helpers/test_helpers.dart';
import 'package:wishing_well/test_helpers/mocks/repositories/mock_auth_repository.dart';
import 'package:wishing_well/theme/app_theme.dart';
import 'package:wishing_well/utils/result.dart';
import 'package:wishing_well/utils/status_overlay_controller.dart';

Widget buildGoogleSignInTestWidget({
  required LoginViewModel viewModel,
  required StatusOverlayController loadingController,
}) {
  final goRouter = GoRouter(
    initialLocation: '/login',
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => Scaffold(
          body: Builder(
            builder: (context) => ElevatedButton(
              key: const Key('google-btn'),
              onPressed: () => viewModel.tapGoogleSignInButton(context),
              child: const Text('Google Sign In'),
            ),
          ),
        ),
      ),
      GoRoute(
        path: '/home',
        name: 'home',
        builder: (context, state) => const Scaffold(body: Text('Home Screen')),
      ),
    ],
  );

  return ChangeNotifierProvider<StatusOverlayController>.value(
    value: loadingController,
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
      routerConfig: goRouter,
    ),
  );
}

void main() {
  group('LoginViewModel - tapGoogleSignInButton', () {
    late StatusOverlayController loadingController;

    setUp(() {
      loadingController = StatusOverlayController();
    });

    tearDown(() {
      loadingController.dispose();
    });

    group('Success', () {
      testWidgets('navigates to home screen on successful Google login', (
        WidgetTester tester,
      ) async {
        final viewModel = LoginViewModel(
          authRepository: MockAuthRepository(
            loginWithGoogleResult: const Result.ok(null),
          ),
        );
        addTearDown(viewModel.dispose);

        await tester.pumpWidget(
          buildGoogleSignInTestWidget(
            viewModel: viewModel,
            loadingController: loadingController,
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        await tester.tap(find.byKey(const Key('google-btn')));
        await tester.pumpAndSettle();

        expect(find.text('Home Screen'), findsOneWidget);
        expect(loadingController.isError, isFalse);
      });

      testWidgets('hides loading overlay on successful Google login', (
        WidgetTester tester,
      ) async {
        final viewModel = LoginViewModel(
          authRepository: MockAuthRepository(
            loginWithGoogleResult: const Result.ok(null),
          ),
        );
        addTearDown(viewModel.dispose);

        await tester.pumpWidget(
          buildGoogleSignInTestWidget(
            viewModel: viewModel,
            loadingController: loadingController,
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        await tester.tap(find.byKey(const Key('google-btn')));
        await tester.pumpAndSettle();

        expect(loadingController.isLoading, isFalse);
        expect(loadingController.isError, isFalse);
      });
    });

    group('Error - Non-cancellation', () {
      testWidgets('shows error overlay on non-cancellation error', (
        WidgetTester tester,
      ) async {
        final viewModel = LoginViewModel(
          authRepository: MockAuthRepository(
            loginWithGoogleResult: Result.error(Exception('Network error')),
          ),
        );
        addTearDown(viewModel.dispose);

        await tester.pumpWidget(
          buildGoogleSignInTestWidget(
            viewModel: viewModel,
            loadingController: loadingController,
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        await tester.tap(find.byKey(const Key('google-btn')));
        await tester.pumpAndSettle();

        expect(loadingController.isError, isTrue);
        expect(
          loadingController.message,
          'An unknown error occurred. Please try again',
        );
      });

      testWidgets('does not navigate to home on error', (
        WidgetTester tester,
      ) async {
        final viewModel = LoginViewModel(
          authRepository: MockAuthRepository(
            loginWithGoogleResult: Result.error(Exception('Network error')),
          ),
        );
        addTearDown(viewModel.dispose);

        await tester.pumpWidget(
          buildGoogleSignInTestWidget(
            viewModel: viewModel,
            loadingController: loadingController,
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        await tester.tap(find.byKey(const Key('google-btn')));
        await tester.pumpAndSettle();

        expect(find.text('Home Screen'), findsNothing);
      });
    });

    group('Error - Cancellation', () {
      testWidgets(
        'shows cancellation error overlay when user cancels Google sign-in',
        (WidgetTester tester) async {
          final viewModel = LoginViewModel(
            authRepository: MockAuthRepository(
              loginWithGoogleResult: Result.error(
                Exception('Google sign-in cancelled'),
              ),
            ),
          );
          addTearDown(viewModel.dispose);

          await tester.pumpWidget(
            buildGoogleSignInTestWidget(
              viewModel: viewModel,
              loadingController: loadingController,
            ),
          );
          await TestHelpers.pumpAndSettle(tester);

          await tester.tap(find.byKey(const Key('google-btn')));
          await tester.pumpAndSettle();

          expect(loadingController.isLoading, isFalse);
          expect(loadingController.isError, isTrue);
          expect(loadingController.message, 'Google sign-in was cancelled');
        },
      );

      testWidgets('does not navigate to home when user cancels', (
        WidgetTester tester,
      ) async {
        final viewModel = LoginViewModel(
          authRepository: MockAuthRepository(
            loginWithGoogleResult: Result.error(
              Exception('sign-in cancelled by user'),
            ),
          ),
        );
        addTearDown(viewModel.dispose);

        await tester.pumpWidget(
          buildGoogleSignInTestWidget(
            viewModel: viewModel,
            loadingController: loadingController,
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        await tester.tap(find.byKey(const Key('google-btn')));
        await tester.pumpAndSettle();

        expect(loadingController.isError, isTrue);
        expect(find.text('Home Screen'), findsNothing);
      });
    });
  });
}

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:wishing_well/features/auth/deep_link_error/deep_link_error_view_model.dart';
import 'package:wishing_well/l10n/app_localizations.dart';
import 'package:wishing_well/routing/routes.dart';
import 'package:wishing_well/test_helpers/helpers/test_helpers.dart';
import 'package:wishing_well/theme/app_theme.dart';

void main() {
  group('DeepLinkErrorViewModel', () {
    group(TestGroups.initialState, () {
      test('implements DeepLinkErrorViewModelContract', () {
        final vm = DeepLinkErrorViewModel(errorType: DeepLinkErrorType.unknown);
        expect(vm, isA<DeepLinkErrorViewModelContract>());
      });

      test('errorType matches constructor argument for passwordReset', () {
        final vm = DeepLinkErrorViewModel(
          errorType: DeepLinkErrorType.passwordReset,
        );
        expect(vm.errorType, DeepLinkErrorType.passwordReset);
      });

      test('errorType matches constructor argument for accountConfirm', () {
        final vm = DeepLinkErrorViewModel(
          errorType: DeepLinkErrorType.accountConfirm,
        );
        expect(vm.errorType, DeepLinkErrorType.accountConfirm);
      });

      test('errorType matches constructor argument for unknown', () {
        final vm = DeepLinkErrorViewModel(errorType: DeepLinkErrorType.unknown);
        expect(vm.errorType, DeepLinkErrorType.unknown);
      });
    });

    group('DeepLinkErrorType.fromString', () {
      test('parses password-reset string', () {
        expect(
          DeepLinkErrorType.fromString('password-reset'),
          DeepLinkErrorType.passwordReset,
        );
      });

      test('parses account-confirm string', () {
        expect(
          DeepLinkErrorType.fromString('account-confirm'),
          DeepLinkErrorType.accountConfirm,
        );
      });

      test('returns unknown for unrecognized string', () {
        expect(
          DeepLinkErrorType.fromString('something-else'),
          DeepLinkErrorType.unknown,
        );
      });

      test('returns unknown for null', () {
        expect(DeepLinkErrorType.fromString(null), DeepLinkErrorType.unknown);
      });

      test('returns unknown for empty string', () {
        expect(DeepLinkErrorType.fromString(''), DeepLinkErrorType.unknown);
      });
    });

    group(TestGroups.behavior, () {
      Widget buildTestWidget({
        required DeepLinkErrorType errorType,
        required void Function(BuildContext) onTapAction,
        required void Function(BuildContext) onTapClose,
      }) {
        late GoRouter router;
        router = GoRouter(
          initialLocation: Routes.deepLinkError.path,
          routes: [
            GoRoute(
              path: Routes.deepLinkError.path,
              name: Routes.deepLinkError.name,
              builder: (context, state) => Scaffold(
                body: Column(
                  children: [
                    ElevatedButton(
                      key: const Key('action-btn'),
                      onPressed: () => onTapAction(context),
                      child: const Text('Action'),
                    ),
                    ElevatedButton(
                      key: const Key('close-btn'),
                      onPressed: () => onTapClose(context),
                      child: const Text('Close'),
                    ),
                  ],
                ),
              ),
            ),
            GoRoute(
              path: Routes.login.path,
              name: Routes.login.name,
              builder: (context, state) =>
                  const Scaffold(body: Text('Login Screen')),
            ),
            GoRoute(
              path: Routes.forgotPassword.path,
              name: Routes.forgotPassword.name,
              builder: (context, state) =>
                  const Scaffold(body: Text('Forgot Password Screen')),
            ),
          ],
        );

        return MaterialApp.router(
          theme: AppTheme.lightTheme,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          routerConfig: router,
        );
      }

      testWidgets(
        'tapActionButton navigates to forgot-password for passwordReset',
        (tester) async {
          final vm = DeepLinkErrorViewModel(
            errorType: DeepLinkErrorType.passwordReset,
          );
          addTearDown(vm.dispose);

          await tester.pumpWidget(
            buildTestWidget(
              errorType: DeepLinkErrorType.passwordReset,
              onTapAction: vm.tapActionButton,
              onTapClose: vm.tapCloseButton,
            ),
          );
          await TestHelpers.pumpAndSettle(tester);

          await TestHelpers.tapAndSettle(
            tester,
            find.byKey(const Key('action-btn')),
          );

          expect(find.text('Forgot Password Screen'), findsOneWidget);
        },
      );

      testWidgets('tapActionButton navigates to login for accountConfirm', (
        tester,
      ) async {
        final vm = DeepLinkErrorViewModel(
          errorType: DeepLinkErrorType.accountConfirm,
        );
        addTearDown(vm.dispose);

        await tester.pumpWidget(
          buildTestWidget(
            errorType: DeepLinkErrorType.accountConfirm,
            onTapAction: vm.tapActionButton,
            onTapClose: vm.tapCloseButton,
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        await TestHelpers.tapAndSettle(
          tester,
          find.byKey(const Key('action-btn')),
        );

        expect(find.text('Login Screen'), findsOneWidget);
      });

      testWidgets('tapActionButton navigates to login for unknown', (
        tester,
      ) async {
        final vm = DeepLinkErrorViewModel(errorType: DeepLinkErrorType.unknown);
        addTearDown(vm.dispose);

        await tester.pumpWidget(
          buildTestWidget(
            errorType: DeepLinkErrorType.unknown,
            onTapAction: vm.tapActionButton,
            onTapClose: vm.tapCloseButton,
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        await TestHelpers.tapAndSettle(
          tester,
          find.byKey(const Key('action-btn')),
        );

        expect(find.text('Login Screen'), findsOneWidget);
      });

      testWidgets('tapCloseButton navigates to login for passwordReset', (
        tester,
      ) async {
        final vm = DeepLinkErrorViewModel(
          errorType: DeepLinkErrorType.passwordReset,
        );
        addTearDown(vm.dispose);

        await tester.pumpWidget(
          buildTestWidget(
            errorType: DeepLinkErrorType.passwordReset,
            onTapAction: vm.tapActionButton,
            onTapClose: vm.tapCloseButton,
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        await TestHelpers.tapAndSettle(
          tester,
          find.byKey(const Key('close-btn')),
        );

        expect(find.text('Login Screen'), findsOneWidget);
      });

      testWidgets('tapCloseButton navigates to login for accountConfirm', (
        tester,
      ) async {
        final vm = DeepLinkErrorViewModel(
          errorType: DeepLinkErrorType.accountConfirm,
        );
        addTearDown(vm.dispose);

        await tester.pumpWidget(
          buildTestWidget(
            errorType: DeepLinkErrorType.accountConfirm,
            onTapAction: vm.tapActionButton,
            onTapClose: vm.tapCloseButton,
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        await TestHelpers.tapAndSettle(
          tester,
          find.byKey(const Key('close-btn')),
        );

        expect(find.text('Login Screen'), findsOneWidget);
      });

      testWidgets('tapCloseButton navigates to login for unknown', (
        tester,
      ) async {
        final vm = DeepLinkErrorViewModel(errorType: DeepLinkErrorType.unknown);
        addTearDown(vm.dispose);

        await tester.pumpWidget(
          buildTestWidget(
            errorType: DeepLinkErrorType.unknown,
            onTapAction: vm.tapActionButton,
            onTapClose: vm.tapCloseButton,
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        await TestHelpers.tapAndSettle(
          tester,
          find.byKey(const Key('close-btn')),
        );

        expect(find.text('Login Screen'), findsOneWidget);
      });
    });
  });
}

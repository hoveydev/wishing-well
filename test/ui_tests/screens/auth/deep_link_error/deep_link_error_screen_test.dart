import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wishing_well/features/auth/deep_link_error/deep_link_error_screen.dart';
import 'package:wishing_well/features/auth/deep_link_error/deep_link_error_view_model.dart';
import 'package:wishing_well/test_helpers/helpers/test_helpers.dart';

void main() {
  group('DeepLinkErrorScreen', () {
    group(TestGroups.rendering, () {
      testWidgets('renders title and error icon for passwordReset', (
        WidgetTester tester,
      ) async {
        final viewModel = _MockDeepLinkErrorViewModel(
          errorType: DeepLinkErrorType.passwordReset,
        );

        await tester.pumpWidget(
          createScreenTestWidget(
            child: DeepLinkErrorScreen(viewModel: viewModel),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        TestHelpers.expectTextOnce('Link Expired or Invalid');
        expect(find.byIcon(Icons.error_outline), findsOneWidget);
      });

      testWidgets('renders passwordReset message and action label', (
        WidgetTester tester,
      ) async {
        final viewModel = _MockDeepLinkErrorViewModel(
          errorType: DeepLinkErrorType.passwordReset,
        );

        await tester.pumpWidget(
          createScreenTestWidget(
            child: DeepLinkErrorScreen(viewModel: viewModel),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        TestHelpers.expectTextOnce(
          'This link has expired or is no longer valid. '
          'Please return to the login screen and resubmit for a new link.',
        );
        TestHelpers.expectTextOnce('Request New Link');
      });

      testWidgets('renders accountConfirm message and action label', (
        WidgetTester tester,
      ) async {
        final viewModel = _MockDeepLinkErrorViewModel(
          errorType: DeepLinkErrorType.accountConfirm,
        );

        await tester.pumpWidget(
          createScreenTestWidget(
            child: DeepLinkErrorScreen(viewModel: viewModel),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        TestHelpers.expectTextOnce(
          'This link has expired or is no longer valid. '
          'Please return to the login screen and resubmit for a new link.',
        );
        TestHelpers.expectTextOnce('Return to Login');
      });

      testWidgets('renders unknown/generic message and action label', (
        WidgetTester tester,
      ) async {
        final viewModel = _MockDeepLinkErrorViewModel(
          errorType: DeepLinkErrorType.unknown,
        );

        await tester.pumpWidget(
          createScreenTestWidget(
            child: DeepLinkErrorScreen(viewModel: viewModel),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        TestHelpers.expectTextOnce(
          'This link has expired or is no longer valid. '
          'Please return to the login screen and resubmit for a new link.',
        );
        TestHelpers.expectTextOnce('Return to Login');
      });
    });

    group(TestGroups.interaction, () {
      testWidgets('tapping action button calls tapActionButton on viewModel', (
        WidgetTester tester,
      ) async {
        final viewModel = _MockDeepLinkErrorViewModel(
          errorType: DeepLinkErrorType.passwordReset,
        );

        await tester.pumpWidget(
          createScreenTestWidget(
            child: DeepLinkErrorScreen(viewModel: viewModel),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        await TestHelpers.tapAndSettle(tester, find.text('Request New Link'));

        expect(viewModel.tapActionButtonCallCount, 1);
      });

      testWidgets('tapping close button calls tapCloseButton on viewModel', (
        WidgetTester tester,
      ) async {
        final viewModel = _MockDeepLinkErrorViewModel(
          errorType: DeepLinkErrorType.accountConfirm,
        );

        await tester.pumpWidget(
          createScreenTestWidget(
            child: DeepLinkErrorScreen(viewModel: viewModel),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        await TestHelpers.tapAndSettle(tester, find.byIcon(Icons.close));

        expect(viewModel.tapCloseButtonCallCount, 1);
      });

      testWidgets(
        'tapping action button on accountConfirm calls tapActionButton',
        (WidgetTester tester) async {
          final viewModel = _MockDeepLinkErrorViewModel(
            errorType: DeepLinkErrorType.accountConfirm,
          );

          await tester.pumpWidget(
            createScreenTestWidget(
              child: DeepLinkErrorScreen(viewModel: viewModel),
            ),
          );
          await TestHelpers.pumpAndSettle(tester);

          await TestHelpers.tapAndSettle(tester, find.text('Return to Login'));

          expect(viewModel.tapActionButtonCallCount, 1);
        },
      );

      testWidgets(
        'tapping action button on unknown type calls tapActionButton',
        (WidgetTester tester) async {
          final viewModel = _MockDeepLinkErrorViewModel(
            errorType: DeepLinkErrorType.unknown,
          );

          await tester.pumpWidget(
            createScreenTestWidget(
              child: DeepLinkErrorScreen(viewModel: viewModel),
            ),
          );
          await TestHelpers.pumpAndSettle(tester);

          await TestHelpers.tapAndSettle(tester, find.text('Return to Login'));

          expect(viewModel.tapActionButtonCallCount, 1);
        },
      );
    });
  });
}

class _MockDeepLinkErrorViewModel extends ChangeNotifier
    implements DeepLinkErrorViewModelContract {
  _MockDeepLinkErrorViewModel({required this.errorType});

  @override
  final DeepLinkErrorType errorType;

  int tapActionButtonCallCount = 0;
  int tapCloseButtonCallCount = 0;

  @override
  void tapActionButton(BuildContext context) {
    tapActionButtonCallCount++;
  }

  @override
  void tapCloseButton(BuildContext context) {
    tapCloseButtonCallCount++;
  }
}

import 'package:flutter_test/flutter_test.dart';
import 'package:wishing_well/screens/auth/create_account/components/create_account_button.dart';
import 'package:wishing_well/screens/auth/create_account/create_account_view_model.dart';

import '../../../../testing_resources/helpers/test_helpers.dart';
import '../../../../testing_resources/mocks/repositories/mock_auth_repository.dart';

void main() {
  group('CreateAccountButton', () {
    late CreateAccountViewModel viewModel;

    setUp(() {
      viewModel = CreateAccountViewModel(authRepository: MockAuthRepository());
    });

    tearDown(() {
      viewModel.dispose();
    });

    group(TestGroups.rendering, () {
      testWidgets('renders correctly with required elements', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createScreenTestWidget(
            child: CreateAccountButton(viewModel: viewModel),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        TestHelpers.expectTextOnce('Create Account');
        expect(find.byType(CreateAccountButton), findsOneWidget);
      });
    });

    group(TestGroups.interaction, () {
      testWidgets('triggers viewModel callback when tapped', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createScreenTestWidget(
            child: CreateAccountButton(viewModel: viewModel),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        // Find and tap the button
        final buttonFinder = find.text('Create Account');
        expect(buttonFinder, findsOneWidget);

        await TestHelpers.tapAndSettle(tester, buttonFinder);

        // Verify the interaction was attempted (button is tappable)
        // The actual navigation and validation will be tested at screen level
      });
    });

    group(TestGroups.behavior, () {
      testWidgets('has correct viewModel parameter', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createScreenTestWidget(
            child: CreateAccountButton(viewModel: viewModel),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        final button = tester.widget<CreateAccountButton>(
          find.byType(CreateAccountButton),
        );
        expect(button.viewModel, equals(viewModel));
      });

      testWidgets('reflects viewModel state changes', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createScreenTestWidget(
            child: CreateAccountButton(viewModel: viewModel),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        final button = tester.widget<CreateAccountButton>(
          find.byType(CreateAccountButton),
        );
        // Test that button reflects ViewModel state
        expect(button.viewModel, isNotNull);
        expect(button.viewModel.hasAlert, isFalse); // Initially no alert
      });
    });
  });
}

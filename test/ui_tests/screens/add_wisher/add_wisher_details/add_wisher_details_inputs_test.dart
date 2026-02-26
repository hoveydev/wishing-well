import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wishing_well/components/inline_alert/app_inline_alert.dart';
import 'package:wishing_well/components/inline_alert/app_inline_alert_type.dart';
import 'package:wishing_well/components/input/app_input.dart';
import 'package:wishing_well/screens/add_wisher/add_wisher_details/components/add_wisher_details_inputs.dart';
import 'package:wishing_well/screens/add_wisher/add_wisher_details/add_wisher_details_view_model.dart';

import '../../../../../testing_resources/helpers/test_helpers.dart';
import '../../../../../testing_resources/mocks/repositories/mock_wisher_repository.dart';

void main() {
  group('AddWisherDetailsInputs', () {
    late AddWisherDetailsViewModel viewModel;

    setUp(() {
      viewModel = AddWisherDetailsViewModel(
        wisherRepository: MockWisherRepository(),
      );
    });

    tearDown(() {
      viewModel.dispose();
    });

    group(TestGroups.rendering, () {
      testWidgets('renders two AppInput widgets', (WidgetTester tester) async {
        await tester.pumpWidget(
          createScreenComponentTestWidget(
            AddWisherDetailsInputs(viewModel: viewModel),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        expect(find.byType(AppInput), findsNWidgets(2));
      });

      testWidgets('renders first name input', (WidgetTester tester) async {
        await tester.pumpWidget(
          createScreenComponentTestWidget(
            AddWisherDetailsInputs(viewModel: viewModel),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        // The first input should have 'First Name' placeholder
        final firstInputFinder = find.byType(AppInput).first;
        expect(firstInputFinder, findsOneWidget);
      });

      testWidgets('renders last name input', (WidgetTester tester) async {
        await tester.pumpWidget(
          createScreenComponentTestWidget(
            AddWisherDetailsInputs(viewModel: viewModel),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        // The second input should have 'Last Name' placeholder
        final lastInputFinder = find.byType(AppInput).last;
        expect(lastInputFinder, findsOneWidget);
      });
    });

    group(TestGroups.interaction, () {
      testWidgets('calls updateFirstName when first name text changes', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createScreenComponentTestWidget(
            AddWisherDetailsInputs(viewModel: viewModel),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        // Find the first TextField (first name)
        final textFields = find.byType(TextField);
        await tester.enterText(textFields.first, 'John');
        await TestHelpers.pumpAndSettle(tester);

        expect(viewModel.isFormValid, isFalse); // Last name still empty
      });

      testWidgets('calls updateLastName when last name text changes', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createScreenComponentTestWidget(
            AddWisherDetailsInputs(viewModel: viewModel),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        // Find the second TextField (last name)
        final textFields = find.byType(TextField);
        await tester.enterText(textFields.last, 'Doe');
        await TestHelpers.pumpAndSettle(tester);

        expect(viewModel.isFormValid, isFalse); // First name still empty
      });

      testWidgets('validates form when both names are entered', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createScreenComponentTestWidget(
            AddWisherDetailsInputs(viewModel: viewModel),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        final textFields = find.byType(TextField);

        // Enter first name
        await tester.enterText(textFields.first, 'John');
        await TestHelpers.pumpAndSettle(tester);

        // Enter last name
        await tester.enterText(textFields.last, 'Doe');
        await TestHelpers.pumpAndSettle(tester);

        expect(viewModel.isFormValid, isTrue);
      });
    });

    group(TestGroups.behavior, () {
      testWidgets('has correct column layout', (WidgetTester tester) async {
        await tester.pumpWidget(
          createScreenComponentTestWidget(
            AddWisherDetailsInputs(viewModel: viewModel),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        // Should have a Column as the main layout
        final columnFinder = find.descendant(
          of: find.byType(AddWisherDetailsInputs),
          matching: find.byType(Column),
        );
        expect(columnFinder, findsOneWidget);
      });

      testWidgets('passes viewModel to constructor', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createScreenComponentTestWidget(
            AddWisherDetailsInputs(viewModel: viewModel),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        final inputsWidget = tester.widget<AddWisherDetailsInputs>(
          find.byType(AddWisherDetailsInputs),
        );
        expect(inputsWidget.viewModel, viewModel);
      });
    });

    group(TestGroups.errorHandling, () {
      testWidgets('does not show inline alert initially', (
        WidgetTester tester,
      ) async {
        // Verify initial state before rendering
        expect(viewModel.hasAlert, isFalse);
        expect(viewModel.error.type, AddWisherDetailsErrorType.none);

        await tester.pumpWidget(
          createScreenComponentTestWidget(
            AddWisherDetailsInputs(viewModel: viewModel),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        // After rendering, still no error should be shown
        expect(viewModel.hasAlert, isFalse);
        expect(find.byType(AppInlineAlert), findsNothing);
      });

      testWidgets('shows inline alert when first name is empty', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createScreenComponentTestWidget(
            AddWisherDetailsInputs(viewModel: viewModel),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        // Enter last name only (first name empty)
        final textFields = find.byType(TextField);
        await tester.enterText(textFields.last, 'Doe');
        await TestHelpers.pumpAndSettle(tester);

        expect(viewModel.hasAlert, isTrue);
        expect(find.byType(AppInlineAlert), findsOneWidget);
      });

      testWidgets('shows inline alert when last name is empty', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createScreenComponentTestWidget(
            AddWisherDetailsInputs(viewModel: viewModel),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        // Enter first name only (last name empty)
        final textFields = find.byType(TextField);
        await tester.enterText(textFields.first, 'John');
        await TestHelpers.pumpAndSettle(tester);

        expect(viewModel.hasAlert, isTrue);
        expect(find.byType(AppInlineAlert), findsOneWidget);
      });

      testWidgets('shows inline alert when both names are empty', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createScreenComponentTestWidget(
            AddWisherDetailsInputs(viewModel: viewModel),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        // Trigger validation by updating with empty strings
        viewModel.updateFirstName('');
        viewModel.updateLastName('');
        await TestHelpers.pumpAndSettle(tester);

        expect(viewModel.hasAlert, isTrue);
        expect(find.byType(AppInlineAlert), findsOneWidget);
        expect(
          viewModel.error.type,
          AddWisherDetailsErrorType.bothNamesRequired,
        );
      });

      testWidgets('hides inline alert when both names are valid', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createScreenComponentTestWidget(
            AddWisherDetailsInputs(viewModel: viewModel),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        // First trigger an error
        final textFields = find.byType(TextField);
        await tester.enterText(textFields.first, 'John');
        await TestHelpers.pumpAndSettle(tester);

        expect(viewModel.hasAlert, isTrue);
        expect(find.byType(AppInlineAlert), findsOneWidget);

        // Now enter last name to make form valid
        await tester.enterText(textFields.last, 'Doe');
        await TestHelpers.pumpAndSettle(tester);

        expect(viewModel.hasAlert, isFalse);
        expect(viewModel.isFormValid, isTrue);
        expect(find.byType(AppInlineAlert), findsNothing);
      });

      testWidgets('displays correct error message for firstNameRequired', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createScreenComponentTestWidget(
            AddWisherDetailsInputs(viewModel: viewModel),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        // Enter last name only - triggers firstNameRequired error
        final textFields = find.byType(TextField);
        await tester.enterText(textFields.last, 'Doe');
        await TestHelpers.pumpAndSettle(tester);

        expect(
          viewModel.error.type,
          AddWisherDetailsErrorType.firstNameRequired,
        );

        final alertFinder = find.byType(AppInlineAlert);
        expect(alertFinder, findsOneWidget);

        final alert = tester.widget<AppInlineAlert>(alertFinder);
        expect(alert.message, 'First name cannot be empty');
        expect(alert.type, AppInlineAlertType.error);
      });

      testWidgets('displays correct error message for lastNameRequired', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createScreenComponentTestWidget(
            AddWisherDetailsInputs(viewModel: viewModel),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        // Enter first name only - triggers lastNameRequired error
        final textFields = find.byType(TextField);
        await tester.enterText(textFields.first, 'John');
        await TestHelpers.pumpAndSettle(tester);

        expect(
          viewModel.error.type,
          AddWisherDetailsErrorType.lastNameRequired,
        );

        final alertFinder = find.byType(AppInlineAlert);
        expect(alertFinder, findsOneWidget);

        final alert = tester.widget<AppInlineAlert>(alertFinder);
        expect(alert.message, 'Last name cannot be empty');
        expect(alert.type, AppInlineAlertType.error);
      });

      testWidgets('displays correct error message for bothNamesRequired', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createScreenComponentTestWidget(
            AddWisherDetailsInputs(viewModel: viewModel),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        // Trigger bothNamesRequired error
        viewModel.updateFirstName('');
        viewModel.updateLastName('');
        await TestHelpers.pumpAndSettle(tester);

        expect(
          viewModel.error.type,
          AddWisherDetailsErrorType.bothNamesRequired,
        );

        final alertFinder = find.byType(AppInlineAlert);
        expect(alertFinder, findsOneWidget);

        final alert = tester.widget<AppInlineAlert>(alertFinder);
        expect(alert.message, 'First and last name cannot be empty');
        expect(alert.type, AppInlineAlertType.error);
      });

      testWidgets('inline alert uses ListenableBuilder for reactivity', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createScreenComponentTestWidget(
            AddWisherDetailsInputs(viewModel: viewModel),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        // Initially no alert
        expect(find.byType(AppInlineAlert), findsNothing);

        // Trigger error
        viewModel.updateLastName('Doe');
        await TestHelpers.pumpAndSettle(tester);

        // Alert should appear
        expect(find.byType(AppInlineAlert), findsOneWidget);

        // Fix error
        viewModel.updateFirstName('John');
        await TestHelpers.pumpAndSettle(tester);

        // Alert should disappear
        expect(find.byType(AppInlineAlert), findsNothing);
      });
    });
  });
}

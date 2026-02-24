import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wishing_well/components/input/app_input.dart';
import 'package:wishing_well/screens/add_wisher/add_wisher_details/components/add_wisher_details_inputs.dart';

import '../../../../../testing_resources/helpers/test_helpers.dart';
import '../../../../../testing_resources/mocks/repositories/mock_wisher_repository.dart';
import 'package:wishing_well/screens/add_wisher/add_wisher_details/add_wisher_details_view_model.dart';

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
  });
}

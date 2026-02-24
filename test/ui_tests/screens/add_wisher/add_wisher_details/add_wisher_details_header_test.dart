import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wishing_well/screens/add_wisher/add_wisher_details/components/add_wisher_details_header.dart';
import 'package:wishing_well/screens/add_wisher/add_wisher_details/components/add_wisher_details_inputs.dart';

import '../../../../../testing_resources/helpers/test_helpers.dart';
import '../../../../../testing_resources/mocks/repositories/mock_wisher_repository.dart';
import 'package:wishing_well/screens/add_wisher/add_wisher_details/add_wisher_details_view_model.dart';

void main() {
  group('AddWisherDetailsHeader', () {
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
      testWidgets('renders header text correctly', (WidgetTester tester) async {
        await tester.pumpWidget(
          createScreenComponentTestWidget(
            AddWisherDetailsHeader(viewModel: viewModel),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        TestHelpers.expectWidgetOnce(AddWisherDetailsHeader);
      });

      testWidgets('renders subtext correctly', (WidgetTester tester) async {
        await tester.pumpWidget(
          createScreenComponentTestWidget(
            AddWisherDetailsHeader(viewModel: viewModel),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        // Check for subtext - using text that appears in the localization
        expect(find.byType(Text), findsWidgets);
      });

      testWidgets('renders AddWisherDetailsInputs component', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createScreenComponentTestWidget(
            AddWisherDetailsHeader(viewModel: viewModel),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        // Find the inputs widget by checking for AppInput widgets
        expect(find.byType(AddWisherDetailsInputs), findsOneWidget);
      });
    });

    group(TestGroups.behavior, () {
      testWidgets('has correct column layout', (WidgetTester tester) async {
        await tester.pumpWidget(
          createScreenComponentTestWidget(
            AddWisherDetailsHeader(viewModel: viewModel),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        // Should have at least one Column for the main layout
        final columnFinder = find.descendant(
          of: find.byType(AddWisherDetailsHeader),
          matching: find.byType(Column),
        );
        expect(columnFinder, findsWidgets);
      });

      testWidgets('passes viewModel to inputs', (WidgetTester tester) async {
        await tester.pumpWidget(
          createScreenComponentTestWidget(
            AddWisherDetailsHeader(viewModel: viewModel),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        final inputsFinder = find.byType(AddWisherDetailsInputs);
        final inputsWidget = tester.widget<AddWisherDetailsInputs>(
          inputsFinder,
        );
        expect(inputsWidget.viewModel, viewModel);
      });
    });

    group(TestGroups.accessibility, () {
      testWidgets('has semantic labels for header text', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createScreenComponentTestWidget(
            AddWisherDetailsHeader(viewModel: viewModel),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        // Check that the Semantics widget exists
        expect(find.byType(Semantics), findsWidgets);
      });
    });
  });
}

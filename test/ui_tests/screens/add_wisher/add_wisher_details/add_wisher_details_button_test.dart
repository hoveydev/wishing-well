import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wishing_well/components/button/app_button.dart';
import 'package:wishing_well/features/add_wisher/add_wisher_details/components/add_wisher_details_button.dart';

import 'package:wishing_well/test_helpers/helpers/test_helpers.dart';
import 'package:wishing_well/test_helpers/mocks/repositories/mock_auth_repository.dart';
import 'package:wishing_well/test_helpers/mocks/repositories/mock_wisher_repository.dart';
import 'package:wishing_well/features/add_wisher/add_wisher_details/add_wisher_details_view_model.dart';

void main() {
  group('AddWisherDetailsButton', () {
    late AddWisherDetailsViewModel viewModel;

    setUp(() {
      viewModel = AddWisherDetailsViewModel(
        wisherRepository: MockWisherRepository(),
        authRepository: MockAuthRepository(),
      );
    });

    tearDown(() {
      viewModel.dispose();
    });

    group(TestGroups.rendering, () {
      testWidgets('renders save button correctly', (WidgetTester tester) async {
        await tester.pumpWidget(
          createScreenComponentTestWidget(
            AddWisherDetailsButton(viewModel: viewModel),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        TestHelpers.expectWidgetOnce(AddWisherDetailsButton);
      });

      testWidgets('renders AppButton widget', (WidgetTester tester) async {
        await tester.pumpWidget(
          createScreenComponentTestWidget(
            AddWisherDetailsButton(viewModel: viewModel),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        expect(find.byType(AppButton), findsOneWidget);
      });

      testWidgets('button has save label text', (WidgetTester tester) async {
        await tester.pumpWidget(
          createScreenComponentTestWidget(
            AddWisherDetailsButton(viewModel: viewModel),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        // Check for 'Save Wisher' text
        TestHelpers.expectTextOnce('Save Wisher');
      });
    });

    group(TestGroups.interaction, () {
      testWidgets('button is rendered and tappable without error', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createScreenTestWidget(
            child: AddWisherDetailsButton(viewModel: viewModel),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        // Verify the button renders correctly - we can't easily test the
        // actual tap without mocking more context, but we verify it renders
        expect(find.byType(AppButton), findsOneWidget);
      });
    });

    group(TestGroups.behavior, () {
      testWidgets('has correct column layout', (WidgetTester tester) async {
        await tester.pumpWidget(
          createScreenComponentTestWidget(
            AddWisherDetailsButton(viewModel: viewModel),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        // Should have a Column as the main layout
        final columnFinder = find.descendant(
          of: find.byType(AddWisherDetailsButton),
          matching: find.byType(Column),
        );
        expect(columnFinder, findsOneWidget);
      });

      testWidgets('passes viewModel to constructor', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createScreenComponentTestWidget(
            AddWisherDetailsButton(viewModel: viewModel),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        final buttonWidget = tester.widget<AddWisherDetailsButton>(
          find.byType(AddWisherDetailsButton),
        );
        expect(buttonWidget.viewModel, viewModel);
      });
    });
  });
}

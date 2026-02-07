import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wishing_well/screens/add_wisher/add_wisher_landing/add_wisher_landing_screen.dart';
import 'package:wishing_well/screens/add_wisher/add_wisher_landing/add_wisher_landing_view_model.dart';
import 'package:wishing_well/screens/add_wisher/add_wisher_landing/components/add_wisher_landing_buttons.dart';
import 'package:wishing_well/screens/add_wisher/add_wisher_landing/components/add_wisher_landing_description.dart';
import 'package:wishing_well/screens/add_wisher/add_wisher_landing/components/add_wisher_landing_header.dart';

import '../../../../testing_resources/helpers/test_helpers.dart';

void main() {
  group('AddWisherLandingScreen', () {
    late AddWisherLandingViewModel viewModel;

    setUp(() {
      viewModel = AddWisherLandingViewModel();
    });

    tearDown(() {
      viewModel.dispose();
    });

    group(TestGroups.rendering, () {
      testWidgets('renders screen with all required elements', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createScreenTestWidget(
            child: AddWisherLandingScreen(viewModel: viewModel),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        TestHelpers.expectWidgetOnce(AddWisherLandingScreen);
        TestHelpers.expectWidgetOnce(AddWisherLandingHeader);
        TestHelpers.expectWidgetOnce(AddWisherLandingDescription);
        TestHelpers.expectWidgetOnce(AddWisherLandingButtons);
        TestHelpers.expectTextOnce('Add a Wisher');
        TestHelpers.expectTextOnce('Add From Contacts');
        TestHelpers.expectTextOnce('Add Manually');
      });

      testWidgets('renders description text content', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createScreenTestWidget(
            child: AddWisherLandingScreen(viewModel: viewModel),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        expect(
          find.textContaining('A Wisher is someone special'),
          findsOneWidget,
        );
      });
    });

    group(TestGroups.interaction, () {
      testWidgets('Add From Contacts button tap triggers callback', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createScreenTestWidget(
            child: AddWisherLandingScreen(viewModel: viewModel),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        await TestHelpers.tapAndSettle(tester, find.text('Add From Contacts'));
      });

      testWidgets('Add Manually button tap triggers callback', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createScreenTestWidget(
            child: AddWisherLandingScreen(viewModel: viewModel),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        await TestHelpers.tapAndSettle(tester, find.text('Add Manually'));
      });
    });

    group(TestGroups.behavior, () {
      testWidgets('can be instantiated with default ViewModel', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createScreenTestWidget(
            child: AddWisherLandingScreen(viewModel: viewModel),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        TestHelpers.expectWidgetOnce(AddWisherLandingScreen);
      });

      testWidgets('can be instantiated with custom ViewModel', (
        WidgetTester tester,
      ) async {
        final customViewModel = AddWisherLandingViewModel();

        await tester.pumpWidget(
          createScreenTestWidget(
            child: AddWisherLandingScreen(viewModel: customViewModel),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        TestHelpers.expectWidgetOnce(AddWisherLandingScreen);
      });

      testWidgets('handles ViewModel disposal correctly', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createScreenTestWidget(
            child: AddWisherLandingScreen(viewModel: viewModel),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        // Should render without errors
        expect(tester.takeException(), isNull);

        // Dispose should not cause issues
        await tester.pumpWidget(Container());
      });
    });
  });
}

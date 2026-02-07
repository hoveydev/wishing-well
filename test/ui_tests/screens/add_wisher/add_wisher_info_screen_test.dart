import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wishing_well/screens/add_wisher/add_wisher_info_screen.dart';
import 'package:wishing_well/screens/add_wisher/add_wisher_view_model.dart';
import 'package:wishing_well/screens/add_wisher/components/add_wisher_buttons.dart';
import 'package:wishing_well/screens/add_wisher/components/add_wisher_description.dart';
import 'package:wishing_well/screens/add_wisher/components/add_wisher_header.dart';

import '../../../../testing_resources/helpers/test_helpers.dart';

void main() {
  group('AddWisherInfoScreen', () {
    late AddWisherViewModel viewModel;

    setUp(() {
      viewModel = AddWisherViewModel();
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
            child: AddWisherInfoScreen(viewModel: viewModel),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        TestHelpers.expectWidgetOnce(AddWisherInfoScreen);
        TestHelpers.expectWidgetOnce(AddWisherHeader);
        TestHelpers.expectWidgetOnce(AddWisherDescription);
        TestHelpers.expectWidgetOnce(AddWisherButtons);
        TestHelpers.expectTextOnce('Add a Wisher');
        TestHelpers.expectTextOnce('Add From Contacts');
        TestHelpers.expectTextOnce('Add Manually');
      });

      testWidgets('renders description text content', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createScreenTestWidget(
            child: AddWisherInfoScreen(viewModel: viewModel),
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
            child: AddWisherInfoScreen(viewModel: viewModel),
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
            child: AddWisherInfoScreen(viewModel: viewModel),
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
            child: AddWisherInfoScreen(viewModel: viewModel),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        TestHelpers.expectWidgetOnce(AddWisherInfoScreen);
      });

      testWidgets('can be instantiated with custom ViewModel', (
        WidgetTester tester,
      ) async {
        final customViewModel = AddWisherViewModel();

        await tester.pumpWidget(
          createScreenTestWidget(
            child: AddWisherInfoScreen(viewModel: customViewModel),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        TestHelpers.expectWidgetOnce(AddWisherInfoScreen);
      });

      testWidgets('handles ViewModel disposal correctly', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createScreenTestWidget(
            child: AddWisherInfoScreen(viewModel: viewModel),
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

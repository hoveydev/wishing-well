import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wishing_well/components/throbber/app_throbber.dart';
import 'package:wishing_well/components/throbber/app_throbber_size.dart';

import '../../../../testing_resources/helpers/test_helpers.dart';

void main() {
  group('AppThrobber', () {
    group(TestGroups.rendering, () {
      testWidgets('renders correctly with xsmall size', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createComponentTestWidget(const AppThrobber.xsmall()),
        );
        await tester
            .pump(); // pump instead of pumpAndSettle for infinite animations

        TestHelpers.expectWidgetOnce(AppThrobber);

        final throbber = tester.widget<AppThrobber>(find.byType(AppThrobber));
        expect(throbber.size, AppThrobberSize.xsmall);
      });

      testWidgets('renders correctly with small size', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createComponentTestWidget(const AppThrobber.small()),
        );
        await tester
            .pump(); // pump instead of pumpAndSettle for infinite animations

        TestHelpers.expectWidgetOnce(AppThrobber);

        final throbber = tester.widget<AppThrobber>(find.byType(AppThrobber));
        expect(throbber.size, AppThrobberSize.small);
      });

      testWidgets('renders correctly with medium size', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createComponentTestWidget(const AppThrobber.medium()),
        );
        await tester
            .pump(); // pump instead of pumpAndSettle for infinite animations

        TestHelpers.expectWidgetOnce(AppThrobber);

        final throbber = tester.widget<AppThrobber>(find.byType(AppThrobber));
        expect(throbber.size, AppThrobberSize.medium);
      });

      testWidgets('renders correctly with large size', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createComponentTestWidget(const AppThrobber.large()),
        );
        await tester
            .pump(); // pump instead of pumpAndSettle for infinite animations

        TestHelpers.expectWidgetOnce(AppThrobber);

        final throbber = tester.widget<AppThrobber>(find.byType(AppThrobber));
        expect(throbber.size, AppThrobberSize.large);
      });

      testWidgets('renders correctly with xlarge size', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createComponentTestWidget(const AppThrobber.xlarge()),
        );
        await tester
            .pump(); // pump instead of pumpAndSettle for infinite animations

        TestHelpers.expectWidgetOnce(AppThrobber);

        final throbber = tester.widget<AppThrobber>(find.byType(AppThrobber));
        expect(throbber.size, AppThrobberSize.xlarge);
      });
    });

    group(TestGroups.behavior, () {
      testWidgets('has correct size properties for each variant', (
        WidgetTester tester,
      ) async {
        // Test xsmall
        await tester.pumpWidget(
          createComponentTestWidget(const AppThrobber.xsmall()),
        );
        await tester
            .pump(); // pump instead of pumpAndSettle for infinite animations

        final xsmallThrobber = tester.widget<AppThrobber>(
          find.byType(AppThrobber),
        );
        expect(xsmallThrobber.size, equals(4.0));

        // Test small
        await tester.pumpWidget(
          createComponentTestWidget(const AppThrobber.small()),
        );
        await tester
            .pump(); // pump instead of pumpAndSettle for infinite animations

        final smallThrobber = tester.widget<AppThrobber>(
          find.byType(AppThrobber),
        );
        expect(smallThrobber.size, equals(8.0));

        // Test medium
        await tester.pumpWidget(
          createComponentTestWidget(const AppThrobber.medium()),
        );
        await tester
            .pump(); // pump instead of pumpAndSettle for infinite animations

        final mediumThrobber = tester.widget<AppThrobber>(
          find.byType(AppThrobber),
        );
        expect(mediumThrobber.size, equals(16.0));

        // Test large
        await tester.pumpWidget(
          createComponentTestWidget(const AppThrobber.large()),
        );
        await tester
            .pump(); // pump instead of pumpAndSettle for infinite animations

        final largeThrobber = tester.widget<AppThrobber>(
          find.byType(AppThrobber),
        );
        expect(largeThrobber.size, equals(24.0));

        // Test xlarge
        await tester.pumpWidget(
          createComponentTestWidget(const AppThrobber.xlarge()),
        );
        await tester
            .pump(); // pump instead of pumpAndSettle for infinite animations

        final xlargeThrobber = tester.widget<AppThrobber>(
          find.byType(AppThrobber),
        );
        expect(xlargeThrobber.size, equals(48.0));
      });

      testWidgets('renders with SizedBox wrapper', (WidgetTester tester) async {
        await tester.pumpWidget(
          createComponentTestWidget(const AppThrobber.medium()),
        );
        await tester
            .pump(); // pump instead of pumpAndSettle for infinite animations

        TestHelpers.expectWidgetOnce(SizedBox);

        final sizedBox = tester.widget<SizedBox>(find.byType(SizedBox));
        expect(sizedBox.width, equals(16.0));
        expect(sizedBox.height, equals(16.0));
      });
    });
  });
}

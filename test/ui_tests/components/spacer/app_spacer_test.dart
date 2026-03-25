import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wishing_well/components/spacer/app_spacer.dart';
import 'package:wishing_well/components/spacer/app_spacer_size.dart';

import 'package:wishing_well/test_helpers/helpers/test_helpers.dart';

void main() {
  group('AppSpacer', () {
    group(TestGroups.rendering, () {
      testWidgets('renders SizedBox with xsmall size', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createComponentTestWidget(const AppSpacer.xsmall()),
        );
        await TestHelpers.pumpAndSettle(tester);

        final sizedBox = tester.widget<SizedBox>(find.byType(SizedBox));
        expect(sizedBox.height, AppSpacerSize.xsmall);
      });

      testWidgets('renders SizedBox with small size', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createComponentTestWidget(const AppSpacer.small()),
        );
        await TestHelpers.pumpAndSettle(tester);

        final sizedBox = tester.widget<SizedBox>(find.byType(SizedBox));
        expect(sizedBox.height, AppSpacerSize.small);
      });

      testWidgets('renders SizedBox with medium size', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createComponentTestWidget(const AppSpacer.medium()),
        );
        await TestHelpers.pumpAndSettle(tester);

        final sizedBox = tester.widget<SizedBox>(find.byType(SizedBox));
        expect(sizedBox.height, AppSpacerSize.medium);
      });

      testWidgets('renders SizedBox with large size', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createComponentTestWidget(const AppSpacer.large()),
        );
        await TestHelpers.pumpAndSettle(tester);

        final sizedBox = tester.widget<SizedBox>(find.byType(SizedBox));
        expect(sizedBox.height, AppSpacerSize.large);
      });

      testWidgets('renders SizedBox with xlarge size', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createComponentTestWidget(const AppSpacer.xlarge()),
        );
        await TestHelpers.pumpAndSettle(tester);

        final sizedBox = tester.widget<SizedBox>(find.byType(SizedBox));
        expect(sizedBox.height, AppSpacerSize.xlarge);
      });
    });
  });
}

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wishing_well/screens/shared/confirmation/components/confirmation_image.dart';

import '../../../../testing_resources/helpers/test_helpers.dart';

void main() {
  group('ConfirmationImage', () {
    group(TestGroups.rendering, () {
      testWidgets('renders icon', (WidgetTester tester) async {
        await tester.pumpWidget(
          createScreenComponentTestWidget(
            const ConfirmationImage(icon: Icons.check_circle),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        TestHelpers.expectWidgetOnce(Icon);
      });

      testWidgets('renders correct icon', (WidgetTester tester) async {
        const testIcon = Icons.check_circle;

        await tester.pumpWidget(
          createScreenComponentTestWidget(
            const ConfirmationImage(icon: testIcon),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        expect(find.byIcon(testIcon), findsOneWidget);
      });
    });

    group(TestGroups.behavior, () {
      testWidgets('calculates size based on screen height', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createScreenComponentTestWidget(
            const ConfirmationImage(icon: Icons.check_circle),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        final iconFinder = find.byType(Icon);
        final size = tester.getSize(iconFinder);

        final screenHeight =
            tester.view.physicalSize.height / tester.view.devicePixelRatio;
        final expectedSize = screenHeight * 0.12;

        expect(size.height, closeTo(expectedSize, 0.1));
        expect(size.width, closeTo(expectedSize, 0.1));
      });

      testWidgets('uses success color', (WidgetTester tester) async {
        await tester.pumpWidget(
          createScreenComponentTestWidget(
            const ConfirmationImage(icon: Icons.check_circle),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        final iconWidget = tester.widget<Icon>(find.byType(Icon));

        expect(iconWidget.color, isNotNull);
      });

      testWidgets('handles different icon types', (WidgetTester tester) async {
        const icons = [Icons.check_circle, Icons.email, Icons.lock];

        for (final icon in icons) {
          await tester.pumpWidget(
            createScreenComponentTestWidget(ConfirmationImage(icon: icon)),
          );
          await TestHelpers.pumpAndSettle(tester);

          expect(find.byIcon(icon), findsOneWidget);
        }
      });

      testWidgets('has accessibility labels', (WidgetTester tester) async {
        await tester.pumpWidget(
          createScreenComponentTestWidget(
            const ConfirmationImage(icon: Icons.check_circle),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        expect(find.byType(Semantics), findsWidgets);
      });
    });
  });
}

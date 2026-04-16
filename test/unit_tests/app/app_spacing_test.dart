import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wishing_well/theme/app_spacing.dart';

import 'package:wishing_well/test_helpers/helpers/test_helpers.dart';

void main() {
  group('AppSpacing', () {
    testWidgets('wisherListItemHeightFor grows with text scale', (
      WidgetTester tester,
    ) async {
      double? measuredHeight;

      await tester.pumpWidget(
        createComponentTestWidget(
          MediaQuery(
            data: const MediaQueryData(textScaler: TextScaler.linear(1.5)),
            child: Builder(
              builder: (context) {
                measuredHeight = AppSpacing.wisherListItemHeightFor(context);
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      );

      expect(measuredHeight, isNotNull);
      expect(measuredHeight!, greaterThan(AppSpacing.wisherListItemHeight));
    });
  });
}

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wishing_well/components/wishers/wisher_sizing.dart';

import 'package:wishing_well/test_helpers/helpers/test_helpers.dart';

void main() {
  group('WisherSizing', () {
    testWidgets('listItemHeightFor grows with text scale', (
      WidgetTester tester,
    ) async {
      double? measuredHeight;

      await tester.pumpWidget(
        createComponentTestWidget(
          MediaQuery(
            data: const MediaQueryData(textScaler: TextScaler.linear(1.5)),
            child: Builder(
              builder: (context) {
                measuredHeight = WisherSizing.listItemHeightFor(context);
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      );

      expect(measuredHeight, isNotNull);
      expect(measuredHeight!, greaterThan(WisherSizing.listItemHeight));
    });
  });
}

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wishing_well/components/app_error_card/app_error_card.dart';

import 'package:wishing_well/test_helpers/helpers/test_helpers.dart';

void main() {
  group('AppErrorCard', () {
    testWidgets('renders the error content', (WidgetTester tester) async {
      await tester.pumpWidget(
        createComponentTestWidget(
          const AppErrorCard(
            onRetry: null,
            title: 'Title',
            message: 'Message',
            retryText: 'Retry',
          ),
        ),
      );

      TestHelpers.expectWidgetOnce(AppErrorCard);
      TestHelpers.expectTextOnce('Title');
      TestHelpers.expectTextOnce('Message');
    });

    testWidgets('calls onRetry when tapped', (WidgetTester tester) async {
      var tapped = false;

      await tester.pumpWidget(
        createComponentTestWidget(
          AppErrorCard(
            onRetry: () => tapped = true,
            title: 'Title',
            message: 'Message',
            retryText: 'Retry',
          ),
        ),
      );

      await tester.tap(find.byIcon(Icons.refresh));
      await tester.pumpAndSettle();

      expect(tapped, isTrue);
    });
  });
}

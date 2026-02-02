import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wishing_well/components/app_alert/app_alert.dart';
import 'package:wishing_well/components/app_alert/app_alert_type.dart';

import '../../../../testing_resources/helpers/test_helpers.dart';

void main() {
  group('AppAlert', () {
    group(TestGroups.rendering, () {
      testWidgets('renders error alert correctly', (WidgetTester tester) async {
        await tester.pumpWidget(
          createComponentTestWidget(
            const AppAlert(
              title: 'Error Title',
              message: 'errorMessage',
              confirmLabel: 'OK',
            ),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        TestHelpers.expectWidgetOnce(AlertDialog);
        TestHelpers.expectTextOnce('Error Title');
        TestHelpers.expectTextOnce('errorMessage');
        TestHelpers.expectTextOnce('OK');
        expect(find.byIcon(Icons.error_outline), findsOneWidget);
      });

      testWidgets('renders warning alert correctly', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createComponentTestWidget(
            const AppAlert(
              title: 'Warning Title',
              message: 'warningMessage',
              confirmLabel: 'Continue',
              type: AppAlertType.warning,
            ),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        TestHelpers.expectWidgetOnce(AlertDialog);
        TestHelpers.expectTextOnce('Warning Title');
        TestHelpers.expectTextOnce('warningMessage');
        TestHelpers.expectTextOnce('Continue');
        expect(find.byIcon(Icons.warning_amber_outlined), findsOneWidget);
      });

      testWidgets('renders success alert correctly', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createComponentTestWidget(
            const AppAlert(
              title: 'Success Title',
              message: 'successMessage',
              confirmLabel: 'Great',
              type: AppAlertType.success,
            ),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        TestHelpers.expectWidgetOnce(AlertDialog);
        TestHelpers.expectTextOnce('Success Title');
        TestHelpers.expectTextOnce('successMessage');
        TestHelpers.expectTextOnce('Great');
        expect(find.byIcon(Icons.check_circle_outline), findsOneWidget);
      });

      testWidgets('renders info alert correctly', (WidgetTester tester) async {
        await tester.pumpWidget(
          createComponentTestWidget(
            const AppAlert(
              title: 'Info Title',
              message: 'infoMessage',
              confirmLabel: 'Got it',
              type: AppAlertType.info,
            ),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        TestHelpers.expectWidgetOnce(AlertDialog);
        TestHelpers.expectTextOnce('Info Title');
        TestHelpers.expectTextOnce('infoMessage');
        TestHelpers.expectTextOnce('Got it');
        expect(find.byIcon(Icons.info_outline), findsOneWidget);
      });
    });

    group(TestGroups.interaction, () {
      testWidgets('calls onConfirm callback when confirm button is tapped', (
        WidgetTester tester,
      ) async {
        bool confirmCalled = false;

        await tester.pumpWidget(
          createComponentTestWidget(
            AppAlert(
              title: 'Test',
              message: 'Test message',
              confirmLabel: 'OK',
              onConfirm: () {
                confirmCalled = true;
              },
            ),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        await TestHelpers.tapAndSettle(tester, find.text('OK'));

        expect(confirmCalled, isTrue);
      });

      testWidgets('dismisses when confirm button is tapped without callback', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createComponentTestWidget(
            const AppAlert(
              title: 'Test',
              message: 'Test message',
              confirmLabel: 'OK',
            ),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        TestHelpers.expectWidgetOnce(AlertDialog);

        await TestHelpers.tapAndSettle(tester, find.text('OK'));

        expect(find.byType(AlertDialog), findsNothing);
      });
    });

    group(TestGroups.behavior, () {
      testWidgets('has correct text alignment properties', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createComponentTestWidget(
            const AppAlert(
              title: 'Title',
              message: 'Message',
              confirmLabel: 'OK',
            ),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        final titleText = tester.widget<Text>(find.text('Title'));
        expect(titleText.textAlign, TextAlign.center);

        final messageText = tester.widget<Text>(find.text('Message'));
        expect(messageText.textAlign, TextAlign.center);
      });
    });
  });
}

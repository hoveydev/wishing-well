import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wishing_well/components/app_alert/app_alert.dart';
import 'package:wishing_well/components/app_alert/app_alert_type.dart';
import 'package:wishing_well/test_helpers/helpers/create_test_widget.dart';
import 'package:wishing_well/test_helpers/helpers/test_helpers.dart';

void main() {
  group('AppAlert', () {
    Widget buildInDialog({
      String title = 'Test Title',
      String message = 'Test message',
      String confirmLabel = 'OK',
      AppAlertType type = AppAlertType.error,
      String? cancelLabel,
      bool isDestructive = false,
      VoidCallback? onConfirm,
      VoidCallback? onCancel,
    }) => createTestWidget(
      Builder(
        builder: (context) => TextButton(
          onPressed: () => showDialog<void>(
            context: context,
            builder: (_) => AppAlert(
              title: title,
              message: message,
              confirmLabel: confirmLabel,
              type: type,
              cancelLabel: cancelLabel,
              isDestructive: isDestructive,
              onConfirm: onConfirm,
              onCancel: onCancel,
            ),
          ),
          child: const Text('Open'),
        ),
      ),
    );

    group(TestGroups.rendering, () {
      testWidgets('renders error alert correctly', (WidgetTester tester) async {
        await tester.pumpWidget(
          buildInDialog(
            title: 'Error Title',
            message: 'errorMessage',
          ),
        );
        await tester.tap(find.text('Open'));
        await TestHelpers.pumpAndSettle(tester);

        TestHelpers.expectWidgetOnce(Dialog);
        TestHelpers.expectTextOnce('Error Title');
        TestHelpers.expectTextOnce('errorMessage');
        TestHelpers.expectTextOnce('OK');
        expect(find.byIcon(Icons.error_outline), findsOneWidget);
      });

      testWidgets('renders warning alert correctly', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          buildInDialog(
            title: 'Warning Title',
            message: 'warningMessage',
            confirmLabel: 'Continue',
            type: AppAlertType.warning,
          ),
        );
        await tester.tap(find.text('Open'));
        await TestHelpers.pumpAndSettle(tester);

        TestHelpers.expectTextOnce('Warning Title');
        TestHelpers.expectTextOnce('warningMessage');
        TestHelpers.expectTextOnce('Continue');
        expect(find.byIcon(Icons.warning_amber_outlined), findsOneWidget);
      });

      testWidgets('renders success alert correctly', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          buildInDialog(
            title: 'Success Title',
            message: 'successMessage',
            confirmLabel: 'Great',
            type: AppAlertType.success,
          ),
        );
        await tester.tap(find.text('Open'));
        await TestHelpers.pumpAndSettle(tester);

        TestHelpers.expectTextOnce('Success Title');
        TestHelpers.expectTextOnce('successMessage');
        TestHelpers.expectTextOnce('Great');
        expect(find.byIcon(Icons.check_circle_outline), findsOneWidget);
      });

      testWidgets('renders info alert correctly', (WidgetTester tester) async {
        await tester.pumpWidget(
          buildInDialog(
            title: 'Info Title',
            message: 'infoMessage',
            confirmLabel: 'Got it',
            type: AppAlertType.info,
          ),
        );
        await tester.tap(find.text('Open'));
        await TestHelpers.pumpAndSettle(tester);

        TestHelpers.expectTextOnce('Info Title');
        TestHelpers.expectTextOnce('infoMessage');
        TestHelpers.expectTextOnce('Got it');
        expect(find.byIcon(Icons.info_outline), findsOneWidget);
      });

      testWidgets('renders cancel button when cancelLabel is provided', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          buildInDialog(
            cancelLabel: 'Cancel',
            confirmLabel: 'Confirm',
            type: AppAlertType.warning,
          ),
        );
        await tester.tap(find.text('Open'));
        await TestHelpers.pumpAndSettle(tester);

        TestHelpers.expectTextOnce('Confirm');
        TestHelpers.expectTextOnce('Cancel');
      });

      testWidgets('does not render cancel button when cancelLabel is null', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(buildInDialog());
        await tester.tap(find.text('Open'));
        await TestHelpers.pumpAndSettle(tester);

        TestHelpers.expectTextOnce('OK');
        expect(find.text('Cancel'), findsNothing);
      });
    });

    group(TestGroups.interaction, () {
      testWidgets('calls onConfirm callback when confirm button is tapped', (
        WidgetTester tester,
      ) async {
        bool confirmCalled = false;

        await tester.pumpWidget(
          buildInDialog(
            onConfirm: () {
              confirmCalled = true;
            },
          ),
        );
        await tester.tap(find.text('Open'));
        await TestHelpers.pumpAndSettle(tester);

        await TestHelpers.tapAndSettle(tester, find.text('OK'));

        expect(confirmCalled, isTrue);
      });

      testWidgets('dismisses when confirm button is tapped without callback', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(buildInDialog());
        await tester.tap(find.text('Open'));
        await TestHelpers.pumpAndSettle(tester);

        TestHelpers.expectWidgetOnce(Dialog);

        await TestHelpers.tapAndSettle(tester, find.text('OK'));

        expect(find.byType(Dialog), findsNothing);
      });

      testWidgets('calls onCancel callback when cancel button is tapped', (
        WidgetTester tester,
      ) async {
        bool cancelCalled = false;

        await tester.pumpWidget(
          buildInDialog(
            cancelLabel: 'Cancel',
            onCancel: () {
              cancelCalled = true;
            },
          ),
        );
        await tester.tap(find.text('Open'));
        await TestHelpers.pumpAndSettle(tester);

        await TestHelpers.tapAndSettle(tester, find.text('Cancel'));

        expect(cancelCalled, isTrue);
      });

      testWidgets('dismisses when cancel button is tapped', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(buildInDialog(cancelLabel: 'Cancel'));
        await tester.tap(find.text('Open'));
        await TestHelpers.pumpAndSettle(tester);

        TestHelpers.expectWidgetOnce(Dialog);

        await TestHelpers.tapAndSettle(tester, find.text('Cancel'));

        expect(find.byType(Dialog), findsNothing);
      });
    });

    group(TestGroups.behavior, () {
      testWidgets('has correct text alignment properties', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          buildInDialog(title: 'Title', message: 'Message'),
        );
        await tester.tap(find.text('Open'));
        await TestHelpers.pumpAndSettle(tester);

        final titleText = tester.widget<Text>(find.text('Title'));
        expect(titleText.textAlign, TextAlign.center);

        final messageText = tester.widget<Text>(find.text('Message'));
        expect(messageText.textAlign, TextAlign.center);
      });
    });

    group('show() static helper', () {
      testWidgets('show() displays the alert', (WidgetTester tester) async {
        await tester.pumpWidget(
          createTestWidget(
            Builder(
              builder: (context) => TextButton(
                onPressed: () => AppAlert.show(
                  context: context,
                  title: 'Confirm?',
                  message: 'Proceed?',
                  confirmLabel: 'Yes',
                  cancelLabel: 'No',
                  type: AppAlertType.warning,
                ),
                child: const Text('Open'),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Open'));
        await tester.pumpAndSettle();

        expect(find.byType(Dialog), findsOneWidget);
        expect(find.text('Confirm?'), findsOneWidget);
        expect(find.text('Proceed?'), findsOneWidget);
        expect(find.text('Yes'), findsOneWidget);
        expect(find.text('No'), findsOneWidget);
      });
    });
  });
}

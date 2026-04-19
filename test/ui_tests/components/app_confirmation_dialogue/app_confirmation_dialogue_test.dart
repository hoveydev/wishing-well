import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wishing_well/components/app_confirmation_dialogue/app_confirmation_dialogue.dart';
import 'package:wishing_well/test_helpers/helpers/create_test_widget.dart';

void main() {
  group('AppConfirmationDialogue', () {
    Widget buildInDialog({
      String title = 'Confirm Action',
      String message = 'Are you sure?',
      String confirmLabel = 'Confirm',
      String cancelLabel = 'Cancel',
      bool isDestructive = false,
      VoidCallback? onConfirm,
      VoidCallback? onCancel,
    }) => createTestWidget(
      Builder(
        builder: (context) => TextButton(
          onPressed: () => showDialog<void>(
            context: context,
            builder: (_) => AppConfirmationDialogue(
              title: title,
              message: message,
              confirmLabel: confirmLabel,
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

    group('Rendering', () {
      testWidgets('renders title text', (WidgetTester tester) async {
        await tester.pumpWidget(buildInDialog(title: 'Delete Wisher?'));
        await tester.tap(find.text('Open'));
        await tester.pumpAndSettle();

        expect(find.text('Delete Wisher?'), findsOneWidget);
      });

      testWidgets('renders message text', (WidgetTester tester) async {
        await tester.pumpWidget(
          buildInDialog(message: 'This cannot be undone.'),
        );
        await tester.tap(find.text('Open'));
        await tester.pumpAndSettle();

        expect(find.text('This cannot be undone.'), findsOneWidget);
      });

      testWidgets('renders confirm button with correct label', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(buildInDialog(confirmLabel: 'Delete'));
        await tester.tap(find.text('Open'));
        await tester.pumpAndSettle();

        expect(find.text('Delete'), findsOneWidget);
      });

      testWidgets('renders cancel button with correct label', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(buildInDialog(cancelLabel: 'No thanks'));
        await tester.tap(find.text('Open'));
        await tester.pumpAndSettle();

        expect(find.text('No thanks'), findsOneWidget);
      });

      testWidgets('renders as AlertDialog', (WidgetTester tester) async {
        await tester.pumpWidget(buildInDialog());
        await tester.tap(find.text('Open'));
        await tester.pumpAndSettle();

        expect(find.byType(AlertDialog), findsOneWidget);
      });
    });

    group('Interaction', () {
      testWidgets('tapping confirm calls onConfirm callback', (
        WidgetTester tester,
      ) async {
        var confirmed = false;
        await tester.pumpWidget(
          buildInDialog(confirmLabel: 'Yes', onConfirm: () => confirmed = true),
        );
        await tester.tap(find.text('Open'));
        await tester.pumpAndSettle();

        await tester.tap(find.text('Yes'));
        await tester.pumpAndSettle();

        expect(confirmed, isTrue);
      });

      testWidgets('tapping cancel calls onCancel callback', (
        WidgetTester tester,
      ) async {
        var cancelled = false;
        await tester.pumpWidget(
          buildInDialog(cancelLabel: 'No', onCancel: () => cancelled = true),
        );
        await tester.tap(find.text('Open'));
        await tester.pumpAndSettle();

        await tester.tap(find.text('No'));
        await tester.pumpAndSettle();

        expect(cancelled, isTrue);
      });

      testWidgets('tapping confirm dismisses the dialog', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(buildInDialog(confirmLabel: 'OK'));
        await tester.tap(find.text('Open'));
        await tester.pumpAndSettle();

        await tester.tap(find.text('OK'));
        await tester.pumpAndSettle();

        expect(find.byType(AlertDialog), findsNothing);
      });

      testWidgets('tapping cancel dismisses the dialog', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(buildInDialog());
        await tester.tap(find.text('Open'));
        await tester.pumpAndSettle();

        await tester.tap(find.text('Cancel'));
        await tester.pumpAndSettle();

        expect(find.byType(AlertDialog), findsNothing);
      });
    });

    group('show() static helper', () {
      testWidgets('show() displays the dialogue', (WidgetTester tester) async {
        await tester.pumpWidget(
          createTestWidget(
            Builder(
              builder: (context) => TextButton(
                onPressed: () => AppConfirmationDialogue.show(
                  context: context,
                  title: 'Confirm?',
                  message: 'Proceed?',
                  confirmLabel: 'Yes',
                  cancelLabel: 'No',
                ),
                child: const Text('Open'),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Open'));
        await tester.pumpAndSettle();

        expect(find.byType(AlertDialog), findsOneWidget);
        expect(find.text('Confirm?'), findsOneWidget);
        expect(find.text('Proceed?'), findsOneWidget);
      });
    });
  });
}

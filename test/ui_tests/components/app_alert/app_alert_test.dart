import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wishing_well/components/app_alert/app_alert.dart';
import 'package:wishing_well/components/app_alert/app_alert_type.dart';

import '../../../../testing_resources/helpers/create_test_widget.dart';

void main() {
  group('app alert types', () {
    testWidgets('error', (tester) async {
      final errorAlert = createTestWidget(
        const AppAlert(
          title: 'Error Title',
          message: 'errorMessage',
          confirmLabel: 'OK',
        ),
      );
      await tester.pumpWidget(errorAlert);

      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.text('Error Title'), findsOneWidget);
      expect(find.text('errorMessage'), findsOneWidget);
      expect(find.text('OK'), findsOneWidget);
      expect(find.byIcon(Icons.error_outline), findsOneWidget);
    });

    testWidgets('warning', (tester) async {
      final warningAlert = createTestWidget(
        const AppAlert(
          title: 'Warning Title',
          message: 'warningMessage',
          confirmLabel: 'Continue',
          type: AppAlertType.warning,
        ),
      );
      await tester.pumpWidget(warningAlert);

      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.text('Warning Title'), findsOneWidget);
      expect(find.text('warningMessage'), findsOneWidget);
      expect(find.text('Continue'), findsOneWidget);
      expect(find.byIcon(Icons.warning_amber_outlined), findsOneWidget);
    });

    testWidgets('success', (tester) async {
      final successAlert = createTestWidget(
        const AppAlert(
          title: 'Success Title',
          message: 'successMessage',
          confirmLabel: 'Great',
          type: AppAlertType.success,
        ),
      );
      await tester.pumpWidget(successAlert);

      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.text('Success Title'), findsOneWidget);
      expect(find.text('successMessage'), findsOneWidget);
      expect(find.text('Great'), findsOneWidget);
      expect(find.byIcon(Icons.check_circle_outline), findsOneWidget);
    });

    testWidgets('info', (tester) async {
      final infoAlert = createTestWidget(
        const AppAlert(
          title: 'Info Title',
          message: 'infoMessage',
          confirmLabel: 'Got it',
          type: AppAlertType.info,
        ),
      );
      await tester.pumpWidget(infoAlert);

      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.text('Info Title'), findsOneWidget);
      expect(find.text('infoMessage'), findsOneWidget);
      expect(find.text('Got it'), findsOneWidget);
      expect(find.byIcon(Icons.info_outline), findsOneWidget);
    });
  });

  group('app alert callbacks', () {
    testWidgets('onConfirm callback is called', (tester) async {
      bool confirmCalled = false;

      final alert = createTestWidget(
        AppAlert(
          title: 'Test',
          message: 'Test message',
          confirmLabel: 'OK',
          onConfirm: () {
            confirmCalled = true;
          },
        ),
      );
      await tester.pumpWidget(alert);

      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      expect(confirmCalled, true);
    });

    testWidgets('onConfirm callback is optional', (tester) async {
      final alert = createTestWidget(
        const AppAlert(
          title: 'Test',
          message: 'Test message',
          confirmLabel: 'OK',
        ),
      );
      await tester.pumpWidget(alert);

      expect(find.byType(AlertDialog), findsOneWidget);

      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsNothing);
    });
  });

  group('app alert layout', () {
    testWidgets('text is centered', (tester) async {
      final alert = createTestWidget(
        const AppAlert(title: 'Title', message: 'Message', confirmLabel: 'OK'),
      );
      await tester.pumpWidget(alert);

      final titleText = tester.widget<Text>(find.text('Title'));
      expect(titleText.textAlign, TextAlign.center);

      final messageText = tester.widget<Text>(find.text('Message'));
      expect(messageText.textAlign, TextAlign.center);
    });
  });
}

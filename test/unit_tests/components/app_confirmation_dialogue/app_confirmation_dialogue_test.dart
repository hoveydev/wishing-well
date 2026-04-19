import 'package:flutter_test/flutter_test.dart';
import 'package:wishing_well/components/app_confirmation_dialogue/app_confirmation_dialogue.dart';

void main() {
  group('AppConfirmationDialogue', () {
    test('can be instantiated with required props', () {
      const widget = AppConfirmationDialogue(
        title: 'Delete?',
        message: 'This cannot be undone.',
        confirmLabel: 'Delete',
        cancelLabel: 'Cancel',
      );

      expect(widget, isA<AppConfirmationDialogue>());
    });

    test('isDestructive defaults to false', () {
      const widget = AppConfirmationDialogue(
        title: 'Confirm',
        message: 'Are you sure?',
        confirmLabel: 'Yes',
        cancelLabel: 'No',
      );

      expect(widget.isDestructive, isFalse);
    });

    test('isDestructive can be set to true', () {
      const widget = AppConfirmationDialogue(
        title: 'Delete?',
        message: 'This cannot be undone.',
        confirmLabel: 'Delete',
        cancelLabel: 'Cancel',
        isDestructive: true,
      );

      expect(widget.isDestructive, isTrue);
    });

    test('exposes all required properties', () {
      const widget = AppConfirmationDialogue(
        title: 'My Title',
        message: 'My Message',
        confirmLabel: 'OK',
        cancelLabel: 'Cancel',
      );

      expect(widget.title, 'My Title');
      expect(widget.message, 'My Message');
      expect(widget.confirmLabel, 'OK');
      expect(widget.cancelLabel, 'Cancel');
    });
  });
}

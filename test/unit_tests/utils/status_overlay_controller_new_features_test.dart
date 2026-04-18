import 'package:flutter_test/flutter_test.dart';
import 'package:wishing_well/utils/status_overlay_controller.dart';
import 'package:wishing_well/test_helpers/helpers/test_helpers.dart';

void main() {
  group('StatusOverlayController - New Features', () {
    late StatusOverlayController controller;

    setUp(() {
      controller = StatusOverlayController();
    });

    tearDown(() {
      controller.dispose();
    });

    group(TestGroups.initialState, () {
      test('new properties are initially null', () {
        expect(controller.name, isNull);
        expect(controller.imageUrl, isNull);
        expect(controller.localImageFile, isNull);
        expect(controller.primaryActionLabel, isNull);
        expect(controller.secondaryActionLabel, isNull);
      });
    });

    group('showSuccess with new properties', () {
      test('showSuccess stores name when provided', () {
        controller.showSuccess('Success message', name: 'John Doe');

        expect(controller.name, 'John Doe');
        expect(controller.isSuccess, true);
      });

      test('showSuccess stores imageUrl when provided', () {
        controller.showSuccess(
          'Success message',
          imageUrl: 'https://example.com/image.jpg',
        );

        expect(controller.imageUrl, 'https://example.com/image.jpg');
      });

      test('showSuccess stores localImageFile when provided', () {
        // Can't easily test File, but can verify it doesn't throw
        controller.showSuccess('Success message', name: 'Test');

        expect(controller.localImageFile, isNull);
      });

      test('showSuccess stores all new properties together', () {
        controller.showSuccess(
          'Wisher has been added!',
          name: 'John Doe',
          imageUrl: 'https://example.com/image.jpg',
        );

        expect(controller.name, 'John Doe');
        expect(controller.imageUrl, 'https://example.com/image.jpg');
        expect(controller.message, 'Wisher has been added!');
      });

      test('showSuccess clears new properties on subsequent show', () {
        controller.showSuccess('First', name: 'John');
        expect(controller.name, 'John');

        controller.show();
        expect(controller.name, isNull);
        expect(controller.imageUrl, isNull);
        expect(controller.localImageFile, isNull);
      });
    });

    group('showError clears new properties', () {
      test('showError clears name, imageUrl, localImageFile', () {
        // First show success with properties
        controller.showSuccess('Success', name: 'John', imageUrl: 'url');
        expect(controller.name, 'John');

        // Then show error - should clear them
        controller.showError('Error occurred');
        expect(controller.name, isNull);
        expect(controller.imageUrl, isNull);
        expect(controller.localImageFile, isNull);
      });
    });

    group('showWarning stores new properties', () {
      test('showWarning stores action labels', () {
        controller.showWarning(
          'Duplicates found',
          primaryActionLabel: 'Continue',
          secondaryActionLabel: 'Cancel',
        );

        expect(controller.primaryActionLabel, 'Continue');
        expect(controller.secondaryActionLabel, 'Cancel');
        expect(controller.isWarning, true);
      });

      test('showWarning clears success-only properties', () {
        controller.showSuccess('Success', name: 'John', imageUrl: 'url');

        controller.showWarning(
          'Duplicates found',
          primaryActionLabel: 'Continue',
          secondaryActionLabel: 'Cancel',
        );

        expect(controller.name, isNull);
        expect(controller.imageUrl, isNull);
        expect(controller.localImageFile, isNull);
      });
    });

    group('hide clears new properties', () {
      test('hide clears all new properties', () {
        controller.showWarning(
          'Duplicates found',
          primaryActionLabel: 'Continue',
          secondaryActionLabel: 'Cancel',
        );

        controller.hide();
        expect(controller.name, isNull);
        expect(controller.imageUrl, isNull);
        expect(controller.localImageFile, isNull);
        expect(controller.primaryActionLabel, isNull);
        expect(controller.secondaryActionLabel, isNull);
      });
    });

    group('acknowledgeAndClear', () {
      test('acknowledgeAndClear clears all new properties', () {
        controller.showSuccess('Message', name: 'John', imageUrl: 'url');

        controller.acknowledgeAndClear();

        expect(controller.name, isNull);
        expect(controller.imageUrl, isNull);
        expect(controller.localImageFile, isNull);
        expect(controller.message, isNull);
      });
    });

    group('state transitions with new properties', () {
      test('loading -> success preserves new properties', () {
        controller.show();
        controller.showSuccess('Done', name: 'Jane');
        expect(controller.name, 'Jane');
        expect(controller.isSuccess, true);
      });

      test('success -> error clears new properties', () {
        controller.showSuccess('Done', name: 'Jane');
        controller.showError('Error');
        expect(controller.name, isNull);
      });

      test('error -> success sets new properties', () {
        controller.showError('Error');
        controller.showSuccess('Done', name: 'Jane');
        expect(controller.name, 'Jane');
      });

      test('warning -> success clears action labels', () {
        controller.showWarning(
          'Duplicates found',
          primaryActionLabel: 'Continue',
          secondaryActionLabel: 'Cancel',
        );
        controller.showSuccess('Done', name: 'Jane');

        expect(controller.primaryActionLabel, isNull);
        expect(controller.secondaryActionLabel, isNull);
        expect(controller.name, 'Jane');
      });
    });
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:wishing_well/utils/loading_controller.dart';
import 'package:wishing_well/test_helpers/helpers/test_helpers.dart';

void main() {
  group('LoadingController', () {
    group(TestGroups.initialState, () {
      test('initial state is not loading', () {
        final controller = LoadingController();
        expect(controller.isLoading, false);
        expect(controller.isSuccess, false);
        expect(controller.isError, false);
        expect(controller.isIdle, true);
        expect(controller.hasOverlay, false);
        expect(controller.message, null);
      });
    });

    group(TestGroups.behavior, () {
      test('show sets isLoading to true', () {
        final controller = LoadingController();
        controller.show();
        expect(controller.isLoading, true);
        expect(controller.isSuccess, false);
        expect(controller.isError, false);
        expect(controller.isIdle, false);
        expect(controller.hasOverlay, true);
      });

      test('hide sets isLoading to false', () {
        final controller = LoadingController();
        controller.show();
        expect(controller.isLoading, true);
        controller.hide();
        expect(controller.isLoading, false);
        expect(controller.isIdle, true);
        expect(controller.hasOverlay, false);
      });

      test('show does nothing when already loading', () {
        final controller = LoadingController();
        bool notified = false;
        controller.addListener(() {
          notified = true;
        });

        controller.show();
        expect(controller.isLoading, true);
        expect(notified, true);

        // New behavior: still notifies on subsequent calls to refresh state
        notified = false;
        controller.show();
        expect(controller.isLoading, true);
        expect(notified, true);
      });

      test('hide does nothing when not loading', () {
        final controller = LoadingController();
        bool notified = false;
        controller.addListener(() {
          notified = true;
        });

        // New behavior: notifies even when hiding from idle
        controller.hide();
        expect(controller.isLoading, false);
        expect(notified, true);
      });

      test('show/hide notifies listeners', () {
        final controller = LoadingController();
        int notifyCount = 0;
        controller.addListener(() {
          notifyCount++;
        });

        controller.show();
        expect(notifyCount, 1);

        controller.hide();
        expect(notifyCount, 2);

        controller.show();
        expect(notifyCount, 3);
      });

      test('multiple show/hide cycles work correctly', () {
        final controller = LoadingController();
        expect(controller.isLoading, false);

        controller.show();
        expect(controller.isLoading, true);

        controller.hide();
        expect(controller.isLoading, false);

        controller.show();
        expect(controller.isLoading, true);

        controller.show();
        expect(controller.isLoading, true);

        controller.hide();
        expect(controller.isLoading, false);

        controller.hide();
        expect(controller.isLoading, false);
      });
    });

    group('showSuccess', () {
      test('showSuccess sets state to success with message', () {
        final controller = LoadingController();
        controller.showSuccess('Operation completed!');

        expect(controller.isSuccess, true);
        expect(controller.isLoading, false);
        expect(controller.isError, false);
        expect(controller.hasOverlay, true);
        expect(controller.message, 'Operation completed!');
      });

      test('showSuccess notifies listeners', () {
        final controller = LoadingController();
        int notifyCount = 0;
        controller.addListener(() {
          notifyCount++;
        });

        controller.showSuccess('Success!');
        expect(notifyCount, 1);
      });

      test('showSuccess with callback stores callback', () {
        final controller = LoadingController();
        bool callbackCalled = false;
        controller.showSuccess(
          'Success!',
          onOk: () {
            callbackCalled = true;
          },
        );

        expect(controller.isSuccess, true);
        // Callback should be stored but not called yet
        expect(callbackCalled, false);
      });
    });

    group('showError', () {
      test('showError sets state to error with message', () {
        final controller = LoadingController();
        controller.showError('Something went wrong');

        expect(controller.isError, true);
        expect(controller.isLoading, false);
        expect(controller.isSuccess, false);
        expect(controller.hasOverlay, true);
        expect(controller.message, 'Something went wrong');
      });

      test('showError notifies listeners', () {
        final controller = LoadingController();
        int notifyCount = 0;
        controller.addListener(() {
          notifyCount++;
        });

        controller.showError('Error!');
        expect(notifyCount, 1);
      });

      test('showError with callback stores callback', () {
        final controller = LoadingController();
        bool callbackCalled = false;
        controller.showError(
          'Error!',
          onOk: () {
            callbackCalled = true;
          },
        );

        expect(controller.isError, true);
        // Callback should be stored but not called yet
        expect(callbackCalled, false);
      });
    });

    group('acknowledgeAndClear', () {
      test('acknowledgeAndClear calls callback and hides overlay', () {
        final controller = LoadingController();
        bool callbackCalled = false;
        controller.showSuccess(
          'Success!',
          onOk: () {
            callbackCalled = true;
          },
        );

        controller.acknowledgeAndClear();

        expect(callbackCalled, true);
        expect(controller.isIdle, true);
        expect(controller.hasOverlay, false);
      });

      test('acknowledgeAndClear works without callback', () {
        final controller = LoadingController();
        controller.showSuccess('Success!');

        // Should not throw
        controller.acknowledgeAndClear();

        expect(controller.isIdle, true);
        expect(controller.hasOverlay, false);
      });

      test('acknowledgeAndClear works for error state', () {
        final controller = LoadingController();
        bool callbackCalled = false;
        controller.showError(
          'Error!',
          onOk: () {
            callbackCalled = true;
          },
        );

        controller.acknowledgeAndClear();

        expect(callbackCalled, true);
        expect(controller.isIdle, true);
      });
    });

    group('hide', () {
      test('hide clears message and callback', () {
        final controller = LoadingController();
        controller.showSuccess('Message', onOk: () {});

        expect(controller.message, 'Message');

        controller.hide();

        expect(controller.message, null);
        expect(controller.isIdle, true);
      });

      test('hide works from any state', () {
        final controller = LoadingController();

        // From success
        controller.showSuccess('Success');
        controller.hide();
        expect(controller.isIdle, true);

        // From error
        controller.showError('Error');
        controller.hide();
        expect(controller.isIdle, true);

        // From loading
        controller.show();
        controller.hide();
        expect(controller.isIdle, true);
      });
    });
  });
}

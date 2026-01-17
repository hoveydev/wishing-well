import 'package:flutter_test/flutter_test.dart';
import 'package:wishing_well/utils/loading_controller.dart';

void main() {
  group('LoadingController', () {
    test('initial state is not loading', () {
      final controller = LoadingController();
      expect(controller.isLoading, false);
    });

    test('show sets isLoading to true', () {
      final controller = LoadingController();
      controller.show();
      expect(controller.isLoading, true);
    });

    test('hide sets isLoading to false', () {
      final controller = LoadingController();
      controller.show();
      expect(controller.isLoading, true);
      controller.hide();
      expect(controller.isLoading, false);
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

      notified = false;
      controller.show();
      expect(controller.isLoading, true);
      expect(notified, false);
    });

    test('hide does nothing when not loading', () {
      final controller = LoadingController();
      bool notified = false;
      controller.addListener(() {
        notified = true;
      });

      controller.hide();
      expect(controller.isLoading, false);
      expect(notified, false);
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
}

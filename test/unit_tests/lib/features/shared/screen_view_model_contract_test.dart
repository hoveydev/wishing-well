import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wishing_well/features/shared/screen_view_model_contract.dart';

void main() {
  group('ScreenViewModelContract', () {
    test('supports listenable behavior and explicit disposal', () {
      final viewModel = _TestScreenViewModel();
      var notificationCount = 0;

      void listener() => notificationCount += 1;

      viewModel.addListener(listener);
      viewModel.notifyListeners();
      viewModel.removeListener(listener);
      viewModel.dispose();

      expect(notificationCount, 1);
      expect(viewModel.disposeCallCount, 1);
    });
  });
}

class _TestScreenViewModel extends ChangeNotifier
    implements ScreenViewModelContract {
  int disposeCallCount = 0;

  @override
  void dispose() {
    disposeCallCount += 1;
    super.dispose();
  }
}

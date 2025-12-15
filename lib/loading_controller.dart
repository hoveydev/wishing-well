import 'package:flutter/foundation.dart';

class LoadingController extends ChangeNotifier {
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  void show() {
    if (!_isLoading) {
      _isLoading = true;
      notifyListeners();
    }
  }

  void hide() {
    if (_isLoading) {
      _isLoading = false;
      notifyListeners();
    }
  }
}

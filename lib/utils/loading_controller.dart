import 'package:flutter/foundation.dart';

enum LoadingState { idle, loading, success, error }

class LoadingController extends ChangeNotifier {
  LoadingState _state = LoadingState.idle;
  String? _message;
  VoidCallback? _onOkPressed;

  LoadingState get state => _state;
  String? get message => _message;

  bool get isLoading => _state == LoadingState.loading;
  bool get isSuccess => _state == LoadingState.success;
  bool get isError => _state == LoadingState.error;
  bool get isIdle => _state == LoadingState.idle;
  bool get hasOverlay => _state != LoadingState.idle;

  void show() {
    _state = LoadingState.loading;
    _message = null;
    _onOkPressed = null;
    notifyListeners();
  }

  void showSuccess(String message, {VoidCallback? onOk}) {
    _state = LoadingState.success;
    _message = message;
    _onOkPressed = onOk;
    notifyListeners();
  }

  void showError(String message, {VoidCallback? onOk}) {
    _state = LoadingState.error;
    _message = message;
    _onOkPressed = onOk;
    notifyListeners();
  }

  void hide() {
    _state = LoadingState.idle;
    _message = null;
    _onOkPressed = null;
    notifyListeners();
  }

  void handleOkPressed() {
    _onOkPressed?.call();
    hide();
  }
}

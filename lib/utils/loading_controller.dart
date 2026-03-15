import 'dart:io';

import 'package:flutter/foundation.dart';

enum LoadingState { idle, loading, success, error }

/// Controller for managing loading overlay state.
///
/// Provides methods to show loading, success, and error states with optional
/// callback handlers for user acknowledgment.
///
/// Example usage:
/// ```dart
/// final loading = context.read<LoadingController>();
/// loading.show();
/// // ... perform async operation ...
/// loading.showSuccess('Operation complete!', name: 'User');
/// ```
class LoadingController extends ChangeNotifier {
  LoadingState _state = LoadingState.idle;
  String? _message;

  /// Optional name to display in success overlays.
  ///
  /// Used for personalization, e.g., "John has been added!"
  String? _name;

  /// Optional URL for an image to display in success overlays.
  ///
  /// When provided along with [name], displays a CircleAvatar with the image.
  String? _imageUrl;

  /// Optional local file for an image to display in success overlays.
  ///
  /// Alternative to [imageUrl] for local files.
  File? _localImageFile;
  VoidCallback? _onOkPressed;

  LoadingState get state => _state;
  String? get message => _message;

  /// The name to display in success overlays.
  String? get name => _name;

  /// The image URL for success overlay avatar.
  String? get imageUrl => _imageUrl;

  /// The local image file for success overlay avatar.
  File? get localImageFile => _localImageFile;

  bool get isLoading => _state == LoadingState.loading;
  bool get isSuccess => _state == LoadingState.success;
  bool get isError => _state == LoadingState.error;
  bool get isIdle => _state == LoadingState.idle;
  bool get hasOverlay => _state != LoadingState.idle;

  /// Shows the loading overlay with a loading spinner.
  ///
  /// Clears any previous success/error properties.
  void show() {
    _state = LoadingState.loading;
    _message = null;
    _name = null;
    _imageUrl = null;
    _localImageFile = null;
    _onOkPressed = null;
    notifyListeners();
  }

  /// Shows a success overlay with an optional name and image.
  ///
  /// [message] - The success message to display.
  /// [name] - Optional name to display in bold at the start of the message.
  /// [imageUrl] - Optional URL for an avatar image.
  /// [localImageFile] - Optional local file for an avatar image.
  /// [onOk] - Optional callback when the OK button is pressed.
  void showSuccess(
    String message, {
    String? name,
    String? imageUrl,
    File? localImageFile,
    VoidCallback? onOk,
  }) {
    _state = LoadingState.success;
    _message = message;
    _name = name;
    _imageUrl = imageUrl;
    _localImageFile = localImageFile;
    _onOkPressed = onOk;
    notifyListeners();
  }

  /// Shows an error overlay.
  ///
  /// [message] - The error message to display.
  /// [onOk] - Optional callback when the OK button is pressed.
  void showError(String message, {VoidCallback? onOk}) {
    _state = LoadingState.error;
    _message = message;
    _name = null;
    _imageUrl = null;
    _localImageFile = null;
    _onOkPressed = onOk;
    notifyListeners();
  }

  void hide() {
    _state = LoadingState.idle;
    _message = null;
    _name = null;
    _imageUrl = null;
    _localImageFile = null;
    _onOkPressed = null;
    notifyListeners();
  }

  /// Hides the overlay and calls the OK callback if one was provided.
  ///
  /// This method captures the callback before clearing state, ensuring
  /// the callback is called even after the overlay is hidden.
  void acknowledgeAndClear() {
    // Capture callback before clearing
    final callback = _onOkPressed;
    hide();
    callback?.call();
  }
}

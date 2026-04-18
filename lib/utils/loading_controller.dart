import 'dart:io';

import 'package:flutter/foundation.dart';

enum LoadingState { idle, loading, success, error, warning }

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
  static const Duration _onHideCallbackDelay = Duration(milliseconds: 120);

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
  VoidCallback? _onHide;
  String? _primaryActionLabel;
  String? _secondaryActionLabel;
  VoidCallback? _onPrimaryActionPressed;
  VoidCallback? _onSecondaryActionPressed;

  LoadingState get state => _state;
  String? get message => _message;

  /// The name to display in success overlays.
  String? get name => _name;

  /// The image URL for success overlay avatar.
  String? get imageUrl => _imageUrl;

  /// The local image file for success overlay avatar.
  File? get localImageFile => _localImageFile;
  String? get primaryActionLabel => _primaryActionLabel;
  String? get secondaryActionLabel => _secondaryActionLabel;

  bool get isLoading => _state == LoadingState.loading;
  bool get isSuccess => _state == LoadingState.success;
  bool get isError => _state == LoadingState.error;
  bool get isWarning => _state == LoadingState.warning;
  bool get isIdle => _state == LoadingState.idle;
  bool get hasOverlay => _state != LoadingState.idle;

  /// Shows the loading overlay with a loading spinner.
  ///
  /// Clears any previous success/error properties.
  void show() {
    final previousOnHide = _onHide;
    _state = LoadingState.loading;
    _message = null;
    _name = null;
    _imageUrl = null;
    _localImageFile = null;
    _onOkPressed = null;
    _onHide = null;
    _primaryActionLabel = null;
    _secondaryActionLabel = null;
    _onPrimaryActionPressed = null;
    _onSecondaryActionPressed = null;
    notifyListeners();
    _callOnHideAfterTransition(previousOnHide);
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
    VoidCallback? onHide,
  }) {
    final previousOnHide = _onHide;
    _state = LoadingState.success;
    _message = message;
    _name = name;
    _imageUrl = imageUrl;
    _localImageFile = localImageFile;
    _onOkPressed = onOk;
    _onHide = onHide;
    _primaryActionLabel = null;
    _secondaryActionLabel = null;
    _onPrimaryActionPressed = null;
    _onSecondaryActionPressed = null;
    notifyListeners();
    _callOnHideAfterTransition(previousOnHide);
  }

  /// Shows an error overlay.
  ///
  /// [message] - The error message to display.
  /// [onOk] - Optional callback when the OK button is pressed.
  void showError(String message, {VoidCallback? onOk}) {
    final previousOnHide = _onHide;
    _state = LoadingState.error;
    _message = message;
    _name = null;
    _imageUrl = null;
    _localImageFile = null;
    _onOkPressed = onOk;
    _onHide = null;
    _primaryActionLabel = null;
    _secondaryActionLabel = null;
    _onPrimaryActionPressed = null;
    _onSecondaryActionPressed = null;
    notifyListeners();
    _callOnHideAfterTransition(previousOnHide);
  }

  /// Shows a warning overlay with primary and secondary confirmation actions.
  ///
  /// [message] - The warning message to display.
  /// [primaryActionLabel] - Label for the primary action button.
  /// [secondaryActionLabel] - Label for the secondary action button.
  /// [onPrimaryAction] - Optional callback when the primary button is pressed.
  /// [onSecondaryAction] - Optional callback when the secondary button
  /// is pressed.
  void showWarning(
    String message, {
    required String primaryActionLabel,
    required String secondaryActionLabel,
    VoidCallback? onPrimaryAction,
    VoidCallback? onSecondaryAction,
  }) {
    final previousOnHide = _onHide;
    _state = LoadingState.warning;
    _message = message;
    _name = null;
    _imageUrl = null;
    _localImageFile = null;
    _onOkPressed = null;
    _onHide = null;
    _primaryActionLabel = primaryActionLabel;
    _secondaryActionLabel = secondaryActionLabel;
    _onPrimaryActionPressed = onPrimaryAction;
    _onSecondaryActionPressed = onSecondaryAction;
    notifyListeners();
    _callOnHideAfterTransition(previousOnHide);
  }

  void hide() {
    final previousOnHide = _onHide;
    _state = LoadingState.idle;
    _message = null;
    _name = null;
    _imageUrl = null;
    _localImageFile = null;
    _onOkPressed = null;
    _onHide = null;
    _primaryActionLabel = null;
    _secondaryActionLabel = null;
    _onPrimaryActionPressed = null;
    _onSecondaryActionPressed = null;
    notifyListeners();
    _callOnHideAfterTransition(previousOnHide);
  }

  void _callOnHideAfterTransition(VoidCallback? callback) {
    if (callback == null) return;
    Future<void>.delayed(_onHideCallbackDelay, callback);
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

  /// Hides the overlay and calls the primary action callback if one
  /// was provided.
  void primaryActionAndClear() {
    final callback = _onPrimaryActionPressed;
    hide();
    callback?.call();
  }

  /// Hides the overlay and calls the secondary action callback if one
  /// was provided.
  void secondaryActionAndClear() {
    final callback = _onSecondaryActionPressed;
    hide();
    callback?.call();
  }
}

import 'package:flutter/material.dart';
import 'package:wishing_well/components/button/app_button.dart';
import 'package:wishing_well/components/button/app_button_type.dart';
import 'package:wishing_well/components/spacer/app_spacer_size.dart';
import 'package:wishing_well/theme/app_border_radius.dart';
import 'package:wishing_well/theme/app_theme.dart';
import 'package:wishing_well/theme/extensions/color_scheme_extension.dart';

const double _dialogBorderRadius = AppBorderRadius.large;
const double _dialogPadding = AppSpacerSize.large;
const double _buttonSpacing = AppSpacerSize.small;
const double _messageTopSpacing = AppSpacerSize.small;
const double _actionsTopSpacing = AppSpacerSize.xlarge;

/// A flexible app-modal alert dialog supporting both single-action (1-button)
/// and confirmation (2-button) modes.
///
/// **1-button mode** — omit [cancelLabel]:
/// ```dart
/// showDialog(
///   context: context,
///   builder: (_) => AppAlert(
///     title: 'Something went wrong',
///     message: 'Please try again.',
///     confirmLabel: 'OK',
///     onConfirm: () => viewModel.clearError(),
///   ),
/// );
/// ```
///
/// **2-button mode** — provide [cancelLabel]:
/// ```dart
/// final confirmed = await AppAlert.show(
///   context: context,
///   title: 'Delete item?',
///   message: 'This cannot be undone.',
///   confirmLabel: 'Delete',
///   cancelLabel: 'Cancel',
///   isDestructive: true,
/// );
/// ```
class AppAlert extends StatelessWidget {
  const AppAlert({
    required this.title,
    required this.message,
    required this.confirmLabel,
    super.key,
    this.cancelLabel,
    this.isDestructive = false,
    this.onConfirm,
    this.onCancel,
  });

  final String title;
  final String message;
  final String confirmLabel;

  /// When provided, a cancel button is rendered (2-button mode).
  final String? cancelLabel;

  /// When true, the confirm button is rendered in the error/destructive colour.
  final bool isDestructive;

  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;

  /// Shows the alert as a modal dialog.
  ///
  /// Returns `true` when confirmed, `false` when cancelled, or `null` if
  /// dismissed via back-button or barrier tap.
  static Future<bool?> show({
    required BuildContext context,
    required String title,
    required String message,
    required String confirmLabel,
    String? cancelLabel,
    bool isDestructive = false,
  }) => showDialog<bool>(
    context: context,
    builder: (_) => AppAlert(
      title: title,
      message: message,
      confirmLabel: confirmLabel,
      cancelLabel: cancelLabel,
      isDestructive: isDestructive,
    ),
  );

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final theme = Theme.of(context);

    return Dialog(
      backgroundColor: colorScheme.surfaceGray,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(_dialogBorderRadius)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(_dialogPadding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Semantics(
              label: title,
              child: Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: _messageTopSpacing),
            Semantics(
              label: message,
              liveRegion: true,
              child: Text(
                message,
                style: theme.textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: _actionsTopSpacing),
            _Actions(
              confirmLabel: confirmLabel,
              cancelLabel: cancelLabel,
              isDestructive: isDestructive,
              colorScheme: colorScheme,
              onConfirmPressed: () {
                onConfirm?.call();
                Navigator.of(context).pop(true);
              },
              onCancelPressed: () {
                onCancel?.call();
                Navigator.of(context).pop(false);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _Actions extends StatelessWidget {
  const _Actions({
    required this.confirmLabel,
    required this.cancelLabel,
    required this.isDestructive,
    required this.colorScheme,
    required this.onConfirmPressed,
    required this.onCancelPressed,
  });

  final String confirmLabel;
  final String? cancelLabel;
  final bool isDestructive;
  final AppColorScheme colorScheme;
  final VoidCallback onConfirmPressed;
  final VoidCallback onCancelPressed;

  @override
  Widget build(BuildContext context) {
    final confirmButton = AppButton.label(
      label: confirmLabel,
      onPressed: onConfirmPressed,
      type: AppButtonType.secondary,
      color: isDestructive ? colorScheme.error : null,
    );

    if (cancelLabel == null) {
      return SizedBox(width: double.infinity, child: confirmButton);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        confirmButton,
        const SizedBox(height: _buttonSpacing),
        AppButton.label(
          label: cancelLabel!,
          onPressed: onCancelPressed,
          type: AppButtonType.tertiary,
        ),
      ],
    );
  }
}

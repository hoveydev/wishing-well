import 'package:flutter/material.dart';
import 'package:wishing_well/components/button/app_button.dart';
import 'package:wishing_well/components/button/app_button_type.dart';
import 'package:wishing_well/components/spacer/app_spacer_size.dart';
import 'package:wishing_well/theme/app_theme.dart';

/// A styled confirmation dialogue with cancel and confirm actions.
///
/// Use the static [show] helper to display it as a modal dialog and receive
/// the user's choice as a [Future<bool?>].
class AppConfirmationDialogue extends StatelessWidget {
  const AppConfirmationDialogue({
    required this.title,
    required this.message,
    required this.confirmLabel,
    required this.cancelLabel,
    super.key,
    this.isDestructive = false,
    this.onConfirm,
    this.onCancel,
  });

  final String title;
  final String message;
  final String confirmLabel;
  final String cancelLabel;

  /// When true, the confirm button is rendered in the error/destructive colour.
  final bool isDestructive;

  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;

  /// Shows the dialogue as a modal and returns `true` (confirmed) or
  /// `false` (cancelled). Returns `null` if the dialog is dismissed via
  /// back-button / barrier tap.
  static Future<bool?> show({
    required BuildContext context,
    required String title,
    required String message,
    required String confirmLabel,
    required String cancelLabel,
    bool isDestructive = false,
  }) => showDialog<bool>(
    context: context,
    builder: (_) => AppConfirmationDialogue(
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

    return AlertDialog(
      backgroundColor: colorScheme.surfaceGray,
      title: Semantics(
        label: title,
        child: Text(
          title,
          style: theme.textTheme.titleMedium,
          textAlign: TextAlign.center,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Semantics(
            label: message,
            liveRegion: true,
            child: Text(
              message,
              style: theme.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: AppSpacerSize.medium),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: AppButton.label(
                  label: cancelLabel,
                  onPressed: () {
                    onCancel?.call();
                    Navigator.of(context).pop(false);
                  },
                  type: AppButtonType.tertiary,
                  fontWeight: FontWeight.normal,
                ),
              ),
              const SizedBox(width: AppSpacerSize.small),
              Flexible(
                child: AppButton.label(
                  label: confirmLabel,
                  onPressed: () {
                    onConfirm?.call();
                    Navigator.of(context).pop(true);
                  },
                  type: AppButtonType.tertiary,
                  fontWeight: FontWeight.normal,
                  color: isDestructive ? colorScheme.error : null,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:wishing_well/components/app_alert/app_alert_type.dart';
import 'package:wishing_well/components/button/app_button.dart';
import 'package:wishing_well/components/button/app_button_type.dart';
import 'package:wishing_well/components/spacer/app_spacer.dart';
import 'package:wishing_well/theme/app_icon_size.dart';
import 'package:wishing_well/theme/app_theme.dart';
import 'package:wishing_well/theme/extensions/color_scheme_extension.dart';

class AppAlert extends StatelessWidget {
  const AppAlert({
    required this.title,
    required this.message,
    required this.confirmLabel,
    super.key,
    this.type = AppAlertType.error,
    this.onConfirm,
  });

  final String title;
  final String message;
  final String confirmLabel;
  final AppAlertType type;
  final VoidCallback? onConfirm;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final theme = Theme.of(context);

    return AlertDialog(
      backgroundColor: colorScheme.surfaceGray,
      title: Semantics(
        label: title,
        child: Row(
          children: [
            Icon(
              _getIcon(),
              color: _getColor(colorScheme),
              size: const AppIconSize().large,
              semanticLabel: _getSemanticLabel(),
            ),
            const AppSpacer.small(),
            Expanded(
              child: Text(
                title,
                style: theme.textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
      content: Semantics(
        label: message,
        liveRegion: true,
        child: Text(
          message,
          style: theme.textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        AppButton.label(
          label: confirmLabel,
          onPressed: () {
            onConfirm?.call();
            Navigator.of(context).pop();
          },
          type: AppButtonType.primary,
        ),
      ],
    );
  }

  String _getSemanticLabel() {
    switch (type) {
      case AppAlertType.error:
        return 'Error';
      case AppAlertType.warning:
        return 'Warning';
      case AppAlertType.success:
        return 'Success';
      case AppAlertType.info:
        return 'Information';
    }
  }

  IconData _getIcon() {
    switch (type) {
      case AppAlertType.error:
        return Icons.error_outline;
      case AppAlertType.warning:
        return Icons.warning_amber_outlined;
      case AppAlertType.success:
        return Icons.check_circle_outline;
      case AppAlertType.info:
        return Icons.info_outline;
    }
  }

  Color _getColor(AppColorScheme colorScheme) {
    switch (type) {
      case AppAlertType.error:
        return colorScheme.error!;
      case AppAlertType.warning:
        return colorScheme.warning!;
      case AppAlertType.success:
        return colorScheme.success!;
      case AppAlertType.info:
        return colorScheme.primary!;
    }
  }
}

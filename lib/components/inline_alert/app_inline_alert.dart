import 'package:flutter/material.dart';
import 'package:wishing_well/components/inline_alert/app_inline_alert_type.dart';
import 'package:wishing_well/theme/app_theme.dart';
import 'package:wishing_well/theme/extensions/color_scheme_extension.dart';

class AppInlineAlert extends StatelessWidget {
  const AppInlineAlert({required this.message, required this.type, super.key});
  final String message;
  final AppInlineAlertType type;

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme;
    final colorScheme = context.colorScheme;

    return Semantics(
      label: message,
      liveRegion: true,
      child: Row(
        children: [
          // Icon based on type
          Icon(_getIcon(), color: _getColor(colorScheme)),
          const SizedBox(width: 8),
          // Message text
          Expanded(
            child: Text(
              message,
              style: textStyle.bodyMedium?.copyWith(
                color: _getColor(colorScheme),
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getIcon() {
    switch (type) {
      case AppInlineAlertType.info:
        return Icons.info;
      case AppInlineAlertType.success:
        return Icons.check_circle;
      case AppInlineAlertType.warning:
        return Icons.warning;
      case AppInlineAlertType.error:
        return Icons.error;
    }
  }

  Color? _getColor(AppColorScheme colorScheme) {
    switch (type) {
      case AppInlineAlertType.info:
        return colorScheme.primary;
      case AppInlineAlertType.success:
        return colorScheme.success;
      case AppInlineAlertType.warning:
        return colorScheme.warning;
      case AppInlineAlertType.error:
        return colorScheme.error;
    }
  }
}

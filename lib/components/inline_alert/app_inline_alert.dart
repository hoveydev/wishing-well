import 'package:flutter/material.dart';
import 'package:wishing_well/components/inline_alert/app_inline_alert_type.dart';

class AppInlineAlert extends StatelessWidget {
  final String message;
  final AppInlineAlertType type;

  const AppInlineAlert({
    super.key,
    required this.message,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    
    final textStyle = Theme.of(context).textTheme;

    return Row(
      children: [
        // Icon based on type
        Icon(_getIcon(), color: _getColor()),
        SizedBox(width: 8),
        // Message text
        Expanded(
          child: Text(
            message,
            style: textStyle.bodyMedium?.copyWith(
              color: _getColor(),
            ),
          ),
        ),
      ],
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

  Color _getColor() {
    // TODO: Replace with theme colors
    switch (type) {
      case AppInlineAlertType.info:
        return Colors.blue;
      case AppInlineAlertType.success:
        return Colors.green;
      case AppInlineAlertType.warning:
        return Colors.orange;
      case AppInlineAlertType.error:
        return Colors.red;
    }
  }
}
import 'package:flutter/material.dart';
import 'package:wishing_well/theme/app_spacing.dart';
import 'package:wishing_well/theme/app_theme.dart';

class AppErrorCard extends StatelessWidget {
  const AppErrorCard({
    required this.onRetry,
    required this.title,
    required this.message,
    required this.retryText,
    this.icon = Icons.refresh,
    this.iconSize = 18,
    this.buttonSize = 36,
    this.titleFontSize,
    this.messageFontSize,
    this.retryTextFontSize,
    this.horizontalPadding = AppSpacing.screenPaddingStandard,
    this.innerPadding = 8,
    super.key,
  });

  final VoidCallback? onRetry;
  final String title;
  final String message;
  final String retryText;
  final IconData icon;
  final double iconSize;
  final double buttonSize;
  final double? titleFontSize;
  final double? messageFontSize;
  final double? retryTextFontSize;
  final double horizontalPadding;
  final double innerPadding;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: Container(
        padding: EdgeInsets.all(innerPadding),
        decoration: BoxDecoration(
          color: colorScheme.surfaceGray,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: colorScheme.error!.withValues(alpha: 0.3)),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.error,
                      fontWeight: FontWeight.w600,
                      fontSize: titleFontSize,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    message,
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.error!.withValues(alpha: 0.8),
                      fontSize: messageFontSize,
                    ),
                  ),
                ],
              ),
            ),
            if (onRetry != null) ...[
              const SizedBox(width: 8),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: buttonSize,
                    height: buttonSize,
                    child: IconButton(
                      onPressed: onRetry,
                      style: IconButton.styleFrom(
                        foregroundColor: colorScheme.error,
                        backgroundColor: colorScheme.error!.withValues(
                          alpha: 0.1,
                        ),
                        shape: const CircleBorder(),
                      ),
                      icon: Icon(icon, size: iconSize),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    retryText,
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.error,
                      fontWeight: FontWeight.w600,
                      fontSize: retryTextFontSize,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

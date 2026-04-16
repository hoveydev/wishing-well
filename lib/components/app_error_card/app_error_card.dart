import 'package:flutter/material.dart';
import 'package:wishing_well/theme/app_spacing.dart';
import 'package:wishing_well/theme/app_theme.dart';

const double _defaultAppErrorCardButtonSize = 36;
const double _defaultAppErrorCardHorizontalPadding =
    AppSpacing.screenPaddingStandard;
const double _defaultAppErrorCardInnerPadding = 8;
const double _defaultAppErrorCardColumnGap = 8;
const double _defaultAppErrorCardRowGap = 2;

class AppErrorCard extends StatelessWidget {
  const AppErrorCard({
    required this.onRetry,
    required this.title,
    required this.message,
    required this.retryText,
    this.icon = Icons.refresh,
    this.iconSize = 18,
    this.buttonSize = _defaultAppErrorCardButtonSize,
    this.titleFontSize,
    this.messageFontSize,
    this.retryTextFontSize,
    this.horizontalPadding = _defaultAppErrorCardHorizontalPadding,
    this.innerPadding = _defaultAppErrorCardInnerPadding,
    super.key,
  });

  static const double defaultButtonSize = _defaultAppErrorCardButtonSize;
  static const double defaultHorizontalPadding =
      _defaultAppErrorCardHorizontalPadding;
  static const double defaultInnerPadding = _defaultAppErrorCardInnerPadding;
  static const double defaultColumnGap = _defaultAppErrorCardColumnGap;
  static const double defaultRowGap = _defaultAppErrorCardRowGap;

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

  static TextStyle titleTextStyle(
    TextTheme textTheme, {
    Color? color,
    double? fontSize,
  }) => (textTheme.bodySmall ?? const TextStyle(fontSize: 12)).copyWith(
    color: color,
    fontWeight: FontWeight.w600,
    fontSize: fontSize,
  );

  static TextStyle messageTextStyle(
    TextTheme textTheme, {
    Color? color,
    double? fontSize,
  }) => (textTheme.bodySmall ?? const TextStyle(fontSize: 12)).copyWith(
    color: color,
    fontSize: fontSize,
  );

  static TextStyle retryTextStyle(
    TextTheme textTheme, {
    Color? color,
    double? fontSize,
  }) => (textTheme.bodySmall ?? const TextStyle(fontSize: 12)).copyWith(
    color: color,
    fontWeight: FontWeight.w600,
    fontSize: fontSize,
  );

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
                    style: titleTextStyle(
                      textTheme,
                      color: colorScheme.error,
                      fontSize: titleFontSize,
                    ),
                  ),
                  const SizedBox(height: defaultRowGap),
                  Text(
                    message,
                    style: messageTextStyle(
                      textTheme,
                      color: colorScheme.error!.withValues(alpha: 0.8),
                      fontSize: messageFontSize,
                    ),
                  ),
                ],
              ),
            ),
            if (onRetry != null) ...[
              const SizedBox(width: defaultColumnGap),
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
                  const SizedBox(height: defaultRowGap),
                  Text(
                    retryText,
                    style: retryTextStyle(
                      textTheme,
                      color: colorScheme.error,
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

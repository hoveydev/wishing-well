import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:wishing_well/components/app_error_card/app_error_card.dart';
import 'package:wishing_well/components/spacer/app_spacer.dart';
import 'package:wishing_well/components/wishers/add_wisher_item.dart';
import 'package:wishing_well/components/wishers/wisher_item.dart';
import 'package:wishing_well/components/wishers/wishers_list_skeleton.dart';
import 'package:wishing_well/data/models/wisher.dart';
import 'package:wishing_well/l10n/app_localizations.dart';
import 'package:wishing_well/theme/app_spacing.dart';

class WishersList extends StatefulWidget {
  const WishersList({
    required this.onAddWisherTap,
    required this.onWisherTap,
    required this.wishers,
    this.isLoading = false,
    this.hasError = false,
    this.onRetry,
    this.onViewAllTap,
    super.key,
  });

  final void Function() onAddWisherTap;
  final void Function(Wisher wisher) onWisherTap;
  final List<Wisher> wishers;
  final bool isLoading;
  final bool hasError;
  final VoidCallback? onRetry;
  final VoidCallback? onViewAllTap;

  @override
  State<WishersList> createState() => _WishersListState();
}

class _WishersListState extends State<WishersList> {
  _WishersErrorHeightCacheKey? _cachedErrorHeightKey;
  double? _cachedErrorHeight;

  Widget _buildItem(BuildContext context, int index) {
    if (index == 0) {
      return AddWisherItem(
        const EdgeInsets.only(right: AppSpacing.wisherSpacing),
        widget.onAddWisherTap,
      );
    }

    final wisherIndex = index - 1;
    final wisher = widget.wishers[wisherIndex];
    final padding = wisherIndex == widget.wishers.length - 1
        ? EdgeInsets.zero
        : const EdgeInsets.only(right: AppSpacing.wisherSpacing);
    return WisherItem(wisher, padding, onTap: () => widget.onWisherTap(wisher));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;

    return LayoutBuilder(
      builder: (context, constraints) {
        final errorTitle = l10n.wishersErrorTitle;
        final errorMessage = l10n.wishersErrorMessage;
        final retryText = l10n.tryAgain;
        final wisherHeight = AppSpacing.wisherListItemHeightFor(context);
        final showErrorCard = widget.hasError && !widget.isLoading;
        final widenedListWidth = constraints.maxWidth.isFinite
            ? constraints.maxWidth + (AppSpacing.screenPaddingStandard * 2)
            : MediaQuery.sizeOf(context).width +
                  (AppSpacing.screenPaddingStandard * 2);
        final itemHeight = showErrorCard
            ? _wisherRowHeightFor(
                context: context,
                wisherHeight: wisherHeight,
                availableWidth: widenedListWidth,
                errorTitle: errorTitle,
                errorMessage: errorMessage,
                retryText: retryText,
                textTheme: textTheme,
              )
            : wisherHeight;

        return Semantics(
          header: true,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(l10n.wishers, style: textTheme.titleLarge),
                  Flexible(
                    child: Semantics(
                      button: widget.onViewAllTap != null,
                      child: GestureDetector(
                        onTap: widget.onViewAllTap,
                        child: Text(
                          l10n.viewAll,
                          style: textTheme.bodySmall,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const AppSpacer.medium(),
              SizedBox(
                height: itemHeight,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Positioned(
                      left: -AppSpacing.screenPaddingStandard,
                      right: -AppSpacing.screenPaddingStandard,
                      child: SizedBox(
                        height: itemHeight,
                        child: widget.isLoading
                            ? const WishersListSkeleton()
                            : showErrorCard
                            ? AppErrorCard(
                                onRetry: widget.onRetry,
                                title: errorTitle,
                                message: errorMessage,
                                retryText: retryText,
                              )
                            : ListView.builder(
                                scrollDirection: Axis.horizontal,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: AppSpacing.screenPaddingStandard,
                                ),
                                itemCount: widget.wishers.length + 1,
                                itemBuilder: _buildItem,
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  double _wisherRowHeightFor({
    required BuildContext context,
    required double wisherHeight,
    required double availableWidth,
    required String errorTitle,
    required String errorMessage,
    required String retryText,
    required TextTheme textTheme,
  }) {
    final errorHeight = _errorCardHeightForMemoized(
      context: context,
      availableWidth: availableWidth,
      errorTitle: errorTitle,
      errorMessage: errorMessage,
      retryText: retryText,
      hasRetry: widget.onRetry != null,
      textTheme: textTheme,
    );

    return math.max(wisherHeight, errorHeight).ceilToDouble();
  }

  double _errorCardHeightForMemoized({
    required BuildContext context,
    required double availableWidth,
    required String errorTitle,
    required String errorMessage,
    required String retryText,
    required bool hasRetry,
    required TextTheme textTheme,
  }) {
    final bodySmallStyle = AppErrorCard.messageTextStyle(textTheme);
    final textScaler = MediaQuery.textScalerOf(context);
    final cacheKey = _WishersErrorHeightCacheKey(
      availableWidth: availableWidth,
      hasRetry: hasRetry,
      errorTitle: errorTitle,
      errorMessage: errorMessage,
      retryText: retryText,
      textDirection: Directionality.of(context),
      bodySmallStyle: bodySmallStyle,
      scaledBodySmallFontSize: textScaler.scale(bodySmallStyle.fontSize ?? 0.0),
    );

    if (_cachedErrorHeightKey == cacheKey && _cachedErrorHeight != null) {
      return _cachedErrorHeight!;
    }

    final titleStyle = AppErrorCard.titleTextStyle(textTheme);
    final messageStyle = AppErrorCard.messageTextStyle(textTheme);
    final retryStyle = AppErrorCard.retryTextStyle(textTheme);
    final calculatedHeight = _errorCardHeightFor(
      context: context,
      availableWidth: availableWidth,
      errorTitle: errorTitle,
      errorMessage: errorMessage,
      retryText: retryText,
      hasRetry: hasRetry,
      titleStyle: titleStyle,
      messageStyle: messageStyle,
      retryStyle: retryStyle,
    );

    _cachedErrorHeightKey = cacheKey;
    _cachedErrorHeight = calculatedHeight;
    return calculatedHeight;
  }

  double _errorCardHeightFor({
    required BuildContext context,
    required double availableWidth,
    required String errorTitle,
    required String errorMessage,
    required String retryText,
    required bool hasRetry,
    required TextStyle titleStyle,
    required TextStyle messageStyle,
    required TextStyle retryStyle,
  }) {
    const horizontalPadding = AppErrorCard.defaultHorizontalPadding;
    const innerPadding = AppErrorCard.defaultInnerPadding;
    const buttonSize = AppErrorCard.defaultButtonSize;
    const gapBetweenColumns = AppErrorCard.defaultColumnGap;
    const gapBetweenRows = AppErrorCard.defaultRowGap;
    const measurementSafetyBuffer = 2.0;

    final textScaler = MediaQuery.textScalerOf(context);
    final textDirection = Directionality.of(context);
    final cardWidth = math.max(0.0, availableWidth - (horizontalPadding * 2));
    final innerWidth = math.max(0.0, cardWidth - (innerPadding * 2));

    final retryColumnWidth = hasRetry
        ? math.max(
            buttonSize,
            _measureTextWidth(retryText, retryStyle, textScaler, textDirection),
          )
        : 0.0;
    final leftColumnWidth = hasRetry
        ? math.max(0.0, innerWidth - retryColumnWidth - gapBetweenColumns)
        : innerWidth;

    final titleHeight = _measureTextHeight(
      errorTitle,
      titleStyle,
      leftColumnWidth,
      textScaler,
      textDirection,
    );
    final messageHeight = _measureTextHeight(
      errorMessage,
      messageStyle,
      leftColumnWidth,
      textScaler,
      textDirection,
    );
    final retryHeight = hasRetry
        ? _measureTextHeight(
            retryText,
            retryStyle,
            retryColumnWidth,
            textScaler,
            textDirection,
          )
        : 0.0;

    final leftColumnHeight = titleHeight + gapBetweenRows + messageHeight;
    final rightColumnHeight = hasRetry
        ? buttonSize + gapBetweenRows + retryHeight
        : 0.0;

    return (innerPadding * 2) +
        math.max(leftColumnHeight, rightColumnHeight) +
        measurementSafetyBuffer;
  }

  double _measureTextHeight(
    String text,
    TextStyle style,
    double maxWidth,
    TextScaler textScaler,
    TextDirection textDirection,
  ) {
    final painter = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: textDirection,
      textScaler: textScaler,
    )..layout(maxWidth: maxWidth);

    return painter.height.ceilToDouble();
  }

  double _measureTextWidth(
    String text,
    TextStyle style,
    TextScaler textScaler,
    TextDirection textDirection,
  ) {
    final painter = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: textDirection,
      textScaler: textScaler,
    )..layout();

    return painter.width.ceilToDouble();
  }
}

class _WishersErrorHeightCacheKey {
  const _WishersErrorHeightCacheKey({
    required this.availableWidth,
    required this.hasRetry,
    required this.errorTitle,
    required this.errorMessage,
    required this.retryText,
    required this.textDirection,
    required this.bodySmallStyle,
    required this.scaledBodySmallFontSize,
  });

  final double availableWidth;
  final bool hasRetry;
  final String errorTitle;
  final String errorMessage;
  final String retryText;
  final TextDirection textDirection;
  final TextStyle bodySmallStyle;
  final double scaledBodySmallFontSize;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _WishersErrorHeightCacheKey &&
          runtimeType == other.runtimeType &&
          availableWidth == other.availableWidth &&
          hasRetry == other.hasRetry &&
          errorTitle == other.errorTitle &&
          errorMessage == other.errorMessage &&
          retryText == other.retryText &&
          textDirection == other.textDirection &&
          bodySmallStyle == other.bodySmallStyle &&
          scaledBodySmallFontSize == other.scaledBodySmallFontSize;

  @override
  int get hashCode => Object.hash(
    availableWidth,
    hasRetry,
    errorTitle,
    errorMessage,
    retryText,
    textDirection,
    bodySmallStyle,
    scaledBodySmallFontSize,
  );
}

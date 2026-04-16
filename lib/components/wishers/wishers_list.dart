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
import 'package:wishing_well/utils/app_logger.dart';

class WishersList extends StatelessWidget {
  const WishersList({
    required this.onAddWisherTap,
    required this.onWisherTap,
    required this.wishers,
    this.isLoading = false,
    this.hasError = false,
    this.onRetry,
    super.key,
  });

  final void Function() onAddWisherTap;
  final void Function(Wisher wisher) onWisherTap;
  final List<Wisher> wishers;
  final bool isLoading;
  final bool hasError;
  final VoidCallback? onRetry;

  Widget _buildItem(BuildContext context, int index) {
    if (index == 0) {
      return AddWisherItem(
        const EdgeInsets.only(right: AppSpacing.wisherSpacing),
        onAddWisherTap,
      );
    }

    final wisherIndex = index - 1;
    final wisher = wishers[wisherIndex];
    final padding = wisherIndex == wishers.length - 1
        ? EdgeInsets.zero
        : const EdgeInsets.only(right: AppSpacing.wisherSpacing);
    return WisherItem(wisher, padding, onTap: () => onWisherTap(wisher));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;

    return LayoutBuilder(
      builder: (context, constraints) {
        final wisherHeight = AppSpacing.wisherListItemHeightFor(context);
        final widenedListWidth = constraints.maxWidth.isFinite
            ? constraints.maxWidth + (AppSpacing.screenPaddingStandard * 2)
            : MediaQuery.sizeOf(context).width +
                  (AppSpacing.screenPaddingStandard * 2);
        final itemHeight = hasError
            ? _wisherRowHeightFor(
                context: context,
                wisherHeight: wisherHeight,
                availableWidth: widenedListWidth,
                l10n: l10n,
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
                    child: GestureDetector(
                      onTap: () => AppLogger.debug(
                        'View All tapped',
                        context: 'WishersList',
                      ),
                      child: Text(
                        l10n.viewAll,
                        style: textTheme.bodySmall,
                        overflow: TextOverflow.ellipsis,
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
                        child: isLoading
                            ? const WishersListSkeleton()
                            : hasError
                            ? AppErrorCard(
                                onRetry: onRetry,
                                title: l10n.wishersErrorTitle,
                                message: l10n.wishersErrorMessage,
                                retryText: l10n.tryAgain,
                              )
                            : ListView.builder(
                                scrollDirection: Axis.horizontal,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: AppSpacing.screenPaddingStandard,
                                ),
                                itemCount: wishers.length + 1,
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
    required AppLocalizations l10n,
    required TextTheme textTheme,
  }) {
    final errorHeight = _errorCardHeightFor(
      context: context,
      availableWidth: availableWidth,
      l10n: l10n,
      hasRetry: onRetry != null,
      textTheme: textTheme,
    );

    return math.max(wisherHeight, errorHeight).ceilToDouble();
  }

  double _errorCardHeightFor({
    required BuildContext context,
    required double availableWidth,
    required AppLocalizations l10n,
    required bool hasRetry,
    required TextTheme textTheme,
  }) {
    const horizontalPadding = AppSpacing.screenPaddingStandard;
    const innerPadding = 8.0;
    const buttonSize = 36.0;
    const gapBetweenColumns = 8.0;
    const gapBetweenRows = 2.0;

    final textScaler = MediaQuery.textScalerOf(context);
    final textDirection = Directionality.of(context);
    final cardWidth = math.max(0.0, availableWidth - (horizontalPadding * 2));
    final innerWidth = math.max(0.0, cardWidth - (innerPadding * 2));
    final leftColumnWidth = hasRetry
        ? math.max(0.0, innerWidth - buttonSize - gapBetweenColumns)
        : innerWidth;

    final bodyStyle = textTheme.bodySmall ?? const TextStyle(fontSize: 12);
    final titleStyle = bodyStyle.copyWith(fontWeight: FontWeight.w600);
    final messageStyle = bodyStyle.copyWith();
    final retryStyle = bodyStyle.copyWith(fontWeight: FontWeight.w600);

    final titleHeight = _measureTextHeight(
      l10n.wishersErrorTitle,
      titleStyle,
      leftColumnWidth,
      textScaler,
      textDirection,
    );
    final messageHeight = _measureTextHeight(
      l10n.wishersErrorMessage,
      messageStyle,
      leftColumnWidth,
      textScaler,
      textDirection,
    );
    final retryHeight = hasRetry
        ? _measureTextHeight(
            l10n.tryAgain,
            retryStyle,
            buttonSize,
            textScaler,
            textDirection,
          )
        : 0.0;

    final leftColumnHeight = titleHeight + gapBetweenRows + messageHeight;
    final rightColumnHeight = hasRetry
        ? buttonSize + gapBetweenRows + retryHeight
        : 0.0;

    return (innerPadding * 2) + math.max(leftColumnHeight, rightColumnHeight);
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

    return painter.height;
  }
}

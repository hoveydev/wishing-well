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
    required this.wishers,
    this.isLoading = false,
    this.hasError = false,
    this.onRetry,
    super.key,
  });

  final void Function() onAddWisherTap;
  final List<Wisher> wishers;
  final bool isLoading;
  final bool hasError;
  final VoidCallback? onRetry;

  Widget _buildItem(BuildContext context, int index) {
    // First item is the Add button
    if (index == 0) {
      return AddWisherItem(
        const EdgeInsets.only(right: AppSpacing.wisherSpacing),
        onAddWisherTap,
      );
    }

    // Regular wisher items
    final wisherIndex = index - 1; // Adjust for Add button
    final wisher = wishers[wisherIndex];
    final padding = wisherIndex == wishers.length - 1
        ? EdgeInsets.zero
        : const EdgeInsets.only(right: AppSpacing.wisherSpacing);
    return WisherItem(wisher, padding);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;

    return Semantics(
      header: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(l10n.wishers, style: textTheme.titleLarge),
              GestureDetector(
                onTap: () =>
                    AppLogger.debug('View All tapped', context: 'WishersList'),
                child: Text(l10n.viewAll, style: textTheme.bodySmall),
              ),
            ],
          ),
          const AppSpacer.medium(),
          SizedBox(
            height: 80,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  left: -AppSpacing.screenPaddingStandard,
                  right: -AppSpacing.screenPaddingStandard,
                  child: SizedBox(
                    height: 80,
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
                            itemCount: wishers.length + 1, // +1 for Add button
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
  }
}

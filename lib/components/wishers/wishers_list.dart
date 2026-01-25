import 'package:flutter/material.dart';
import 'package:wishing_well/components/spacer/app_spacer.dart';
import 'package:wishing_well/components/wishers/add_wisher_item.dart';
import 'package:wishing_well/components/wishers/wisher_item.dart';
import 'package:wishing_well/data/models/wisher.dart';
import 'package:wishing_well/l10n/app_localizations.dart';
import 'package:wishing_well/theme/app_spacing.dart';

class WishersList extends StatelessWidget {
  const WishersList({super.key});

  static const List<Wisher> _wishers = [
    Wisher('Alice'),
    Wisher('Bob'),
    Wisher('Charlie'),
    Wisher('Diana'),
    Wisher('Alice'),
    Wisher('Bob'),
    Wisher('Charlie'),
    Wisher('Diana'),
  ];

  Widget _buildItem(BuildContext context, int index) {
    // First item is the Add button
    if (index == 0) {
      return const AddWisherItem(
        EdgeInsets.only(right: AppSpacing.wisherSpacing),
      );
    }

    // Regular wisher items
    final wisherIndex = index - 1; // Adjust for Add button
    final wisher = _wishers[wisherIndex];
    final padding = wisherIndex == _wishers.length - 1
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
              Text(l10n.wishers, style: textTheme.titleMedium),
              GestureDetector(
                onTap: () => debugPrint('View All tapped'),
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
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.screenPaddingStandard,
                      ),
                      itemCount: _wishers.length + 1, // +1 for Add button
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

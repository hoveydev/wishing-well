import 'package:flutter/material.dart';
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
    final wisher = _wishers[index];
    final padding = index == _wishers.length - 1
        ? EdgeInsets.zero
        : const EdgeInsets.only(right: 16);
    return WisherItem(wisher, padding);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Semantics(
      header: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.wishers, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 16),
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
                      itemCount: _wishers.length,
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

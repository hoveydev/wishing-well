import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wishing_well/components/profile_image/profile_image.dart';
import 'package:wishing_well/components/spacer/app_spacer.dart';
import 'package:wishing_well/theme/app_spacer_size.dart';
import 'package:wishing_well/data/models/wisher.dart';
import 'package:wishing_well/data/models/wisher_field_options.dart';
import 'package:wishing_well/l10n/app_localizations.dart';

class WisherDetailsProfile extends StatelessWidget {
  const WisherDetailsProfile({required this.wisher, super.key});
  final Wisher wisher;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;
    final sectionHeaderStyle = textTheme.titleSmall?.copyWith(
      fontWeight: FontWeight.w600,
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ProfileAvatar(
          imageUrl: wisher.profilePicture,
          firstName: wisher.firstName,
          lastName: wisher.lastName,
          radius: 50,
        ),
        const AppSpacer.large(),
        Text(
          wisher.name,
          style: textTheme.headlineMedium,
          textAlign: TextAlign.center,
        ),
        if (wisher.birthday != null) ...[
          const SizedBox(height: AppSpacerSize.xsmall),
          Text(
            DateFormat.yMMMMd().format(wisher.birthday!),
            style: textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
        if (wisher.giftOccasions.isNotEmpty) ...[
          const SizedBox(height: AppSpacerSize.small),
          _GiftTagSection(
            title: l10n.giftOccasions,
            values: wisher.giftOccasions,
            chipLabel: (value) => _chipLabel(l10n, value),
            titleStyle: sectionHeaderStyle,
          ),
        ],
        if (wisher.giftInterests.isNotEmpty) ...[
          const SizedBox(height: AppSpacerSize.small),
          _GiftTagSection(
            title: l10n.giftInterests,
            values: wisher.giftInterests,
            chipLabel: (value) => _chipLabel(l10n, value),
            titleStyle: sectionHeaderStyle,
          ),
        ],
      ],
    );
  }

  String _chipLabel(AppLocalizations l10n, String value) => switch (value) {
    WisherGiftOccasions.christmas => l10n.occasionChristmas,
    WisherGiftOccasions.hanukkah => l10n.occasionHanukkah,
    WisherGiftOccasions.kwanzaa => l10n.occasionKwanzaa,
    WisherGiftOccasions.diwali => l10n.occasionDiwali,
    WisherGiftOccasions.eid => l10n.occasionEid,
    WisherGiftOccasions.valentinesDay => l10n.occasionValentinesDay,
    WisherGiftOccasions.mothersDay => l10n.occasionMothersDay,
    WisherGiftOccasions.fathersDay => l10n.occasionFathersDay,
    WisherGiftOccasions.easter => l10n.occasionEaster,
    WisherGiftOccasions.newYears => l10n.occasionNewYears,
    WisherGiftInterests.books => l10n.interestBooks,
    WisherGiftInterests.electronics => l10n.interestElectronics,
    WisherGiftInterests.clothing => l10n.interestClothing,
    WisherGiftInterests.jewelry => l10n.interestJewelry,
    WisherGiftInterests.art => l10n.interestArt,
    WisherGiftInterests.homeAndGarden => l10n.interestHomeAndGarden,
    WisherGiftInterests.sports => l10n.interestSports,
    WisherGiftInterests.beauty => l10n.interestBeauty,
    WisherGiftInterests.foodAndDrink => l10n.interestFoodAndDrink,
    WisherGiftInterests.travel => l10n.interestTravel,
    WisherGiftInterests.gamesAndToys => l10n.interestGamesAndToys,
    _ => value,
  };
}

class _GiftTagSection extends StatelessWidget {
  /// Reusable gift section for rendering a title and selected gift chips.
  const _GiftTagSection({
    required this.title,
    required this.values,
    required this.chipLabel,
    this.titleStyle,
  });

  /// Section header text.
  final String title;

  /// Gift values displayed as chips.
  final List<String> values;

  /// Maps a raw gift value to its localized chip label.
  final String Function(String value) chipLabel;
  final TextStyle? titleStyle;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      Text(
        title,
        style: titleStyle ?? Theme.of(context).textTheme.bodyMedium,
        textAlign: TextAlign.center,
      ),
      const SizedBox(height: AppSpacerSize.xsmall),
      Wrap(
        spacing: AppSpacerSize.xsmall,
        runSpacing: AppSpacerSize.xsmall,
        alignment: WrapAlignment.center,
        children: values
            .map((value) => Chip(label: Text(chipLabel(value))))
            .toList(growable: false),
      ),
    ],
  );
}

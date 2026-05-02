import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wishing_well/components/profile_image/profile_image.dart';
import 'package:wishing_well/components/spacer/app_spacer.dart';
import 'package:wishing_well/components/spacer/app_spacer_size.dart';
import 'package:wishing_well/data/models/wisher.dart';
import 'package:wishing_well/data/models/wisher_field_options.dart';
import 'package:wishing_well/l10n/app_localizations.dart';

class WisherDetailsProfile extends StatelessWidget {
  const WisherDetailsProfile({required this.wisher, super.key});
  final Wisher wisher;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final allChipValues = [...wisher.giftOccasions, ...wisher.giftInterests];

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ProfileAvatar(
          imageUrl: wisher.profilePicture,
          firstName: wisher.firstName,
          lastName: wisher.lastName,
          radius: 50,
        ),
        const AppSpacer.medium(),
        Text(
          wisher.name,
          style: Theme.of(context).textTheme.headlineMedium,
          textAlign: TextAlign.center,
        ),
        if (wisher.birthday != null) ...[
          const SizedBox(height: AppSpacerSize.xsmall),
          Text(
            DateFormat.yMMMMd().format(wisher.birthday!),
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
        if (allChipValues.isNotEmpty) ...[
          const SizedBox(height: AppSpacerSize.small),
          Wrap(
            spacing: AppSpacerSize.xsmall,
            runSpacing: AppSpacerSize.xsmall,
            alignment: WrapAlignment.center,
            children: allChipValues
                .map((v) => Chip(label: Text(_chipLabel(l10n, v))))
                .toList(growable: false),
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

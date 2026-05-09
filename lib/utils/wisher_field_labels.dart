import 'package:wishing_well/data/models/wisher_field_options.dart';
import 'package:wishing_well/l10n/app_localizations.dart';

String wisherOccasionLabel(AppLocalizations l10n, String occasion) =>
    switch (occasion) {
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
      _ => occasion,
    };

String wisherInterestLabel(AppLocalizations l10n, String interest) =>
    switch (interest) {
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
      _ => interest,
    };

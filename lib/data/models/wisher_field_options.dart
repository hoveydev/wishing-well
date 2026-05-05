/// Constants for gift occasion and gift interest options.
///
/// Values are stored as-is in Postgres TEXT[] columns.
class WisherGiftOccasions {
  WisherGiftOccasions._();

  static const christmas = 'christmas';
  static const hanukkah = 'hanukkah';
  static const kwanzaa = 'kwanzaa';
  static const diwali = 'diwali';
  static const eid = 'eid';
  static const valentinesDay = 'valentines_day';
  static const mothersDay = 'mothers_day';
  static const fathersDay = 'fathers_day';
  static const easter = 'easter';
  static const newYears = 'new_years';

  static const all = [
    christmas,
    hanukkah,
    kwanzaa,
    diwali,
    eid,
    valentinesDay,
    mothersDay,
    fathersDay,
    easter,
    newYears,
  ];
}

class WisherGiftInterests {
  WisherGiftInterests._();

  static const books = 'books';
  static const electronics = 'electronics';
  static const clothing = 'clothing';
  static const jewelry = 'jewelry';
  static const art = 'art';
  static const homeAndGarden = 'home_and_garden';
  static const sports = 'sports';
  static const beauty = 'beauty';
  static const foodAndDrink = 'food_and_drink';
  static const travel = 'travel';
  static const gamesAndToys = 'games_and_toys';

  static const all = [
    books,
    electronics,
    clothing,
    jewelry,
    art,
    homeAndGarden,
    sports,
    beauty,
    foodAndDrink,
    travel,
    gamesAndToys,
  ];
}

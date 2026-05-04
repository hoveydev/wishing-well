/// Holds the gift-related profile fields for a wisher.
///
/// Groups birthday, gift occasions, and gift interests into a single
/// value object so these three fields travel together through the
/// data and presentation layers.
class WisherGiftProfile {
  const WisherGiftProfile({
    this.birthday,
    this.giftOccasions = const [],
    this.giftInterests = const [],
  });

  static const _unset = Object();

  /// Optional birthday (date only, no time component).
  final DateTime? birthday;

  /// Gift-giving occasions this wisher celebrates.
  final List<String> giftOccasions;

  /// Gift interest categories for this wisher.
  final List<String> giftInterests;

  /// Creates a copy with updated fields.
  ///
  /// Use the sentinel pattern to explicitly clear [birthday] to null.
  /// If [birthday] is not provided, the original value is preserved.
  WisherGiftProfile copyWith({
    Object? birthday = _unset,
    List<String>? giftOccasions,
    List<String>? giftInterests,
  }) => WisherGiftProfile(
    birthday: identical(birthday, _unset)
        ? this.birthday
        : birthday as DateTime?,
    giftOccasions: giftOccasions ?? this.giftOccasions,
    giftInterests: giftInterests ?? this.giftInterests,
  );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! WisherGiftProfile) return false;
    if (birthday != other.birthday) return false;
    if (!_sortedListEquals(giftOccasions, other.giftOccasions)) return false;
    if (!_sortedListEquals(giftInterests, other.giftInterests)) return false;
    return true;
  }

  @override
  int get hashCode => Object.hash(
    birthday,
    Object.hashAll([...giftOccasions]..sort()),
    Object.hashAll([...giftInterests]..sort()),
  );

  static bool _sortedListEquals(List<String> a, List<String> b) {
    if (a.length != b.length) return false;
    final sortedA = [...a]..sort();
    final sortedB = [...b]..sort();
    for (var i = 0; i < sortedA.length; i++) {
      if (sortedA[i] != sortedB[i]) return false;
    }
    return true;
  }
}

class AppIconSize {
  const AppIconSize({this.sectionHeight});
  final double? sectionHeight;

  static const double _small = 10.0;
  static const double _medium = 14.0;
  static const double _large = 60.0;
  static const double _headerLargeRatio = 0.12;

  double get small => _small;
  double get medium => _medium;

  double get large {
    if (sectionHeight == null) return _large;
    return sectionHeight! * _headerLargeRatio;
  }
}

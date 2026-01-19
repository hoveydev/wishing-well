class AppIconSize {
  const AppIconSize({this.sectionHeight});
  final double? sectionHeight;

  static const double _xsmall = 10.0;
  static const double _small = 14.0;
  static const double _medium = 18.0;
  static const double _large = 24.0;
  static const double _xlarge = 60.0;
  static const double _headerLargeRatio = 0.12;

  double get xsmall => _xsmall;
  double get small => _small;
  double get medium => _medium;
  double get large => _large;

  double get xlarge {
    if (sectionHeight == null) return _xlarge;
    return sectionHeight! * _headerLargeRatio;
  }
}

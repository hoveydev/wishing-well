class AppIconSize {
  const AppIconSize({this.sectionHeight});
  final double? sectionHeight;

  static const double _large = 60.0;
  static const double _headerLargeRatio = 0.12;

  double get large {
    if (sectionHeight == null) return _large;
    return sectionHeight! * _headerLargeRatio;
  }
}

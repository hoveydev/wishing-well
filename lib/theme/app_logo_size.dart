class AppLogoSize {
  final double? sectionHeight;

  const AppLogoSize({this.sectionHeight});

  static const double _large = 60.0;
  static const double _headerLargeRatio = 0.15;

  double get large {
    if (sectionHeight != null) return _large;
    return sectionHeight! * _headerLargeRatio;
  }
}
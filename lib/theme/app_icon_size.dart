/// Provides consistent icon sizes across the application.
///
/// Usage:
/// ```dart
/// const iconSize = AppIconSize();
/// Icon(icon, size: iconSize.medium);
///
/// // For section-dependent sizes (e.g., hero images)
/// const iconSize = AppIconSize(sectionHeight: 1000);
/// Icon(icon, size: iconSize.xlarge); // 120.0
/// ```
class AppIconSize {
  const AppIconSize({this.sectionHeight});
  final double? sectionHeight;

  static const double _xsmall = 10.0;
  static const double _small = 14.0;
  static const double _medium = 18.0;
  static const double _large = 24.0;
  static const double _xlarge = 60.0;
  static const double _xxlarge = 64.0;
  static const double _successAvatar = 120.0;
  static const double _headerLargeRatio = 0.12;

  double get xsmall => _xsmall;
  double get small => _small;
  double get medium => _medium;
  double get large => _large;

  double get xlarge {
    if (sectionHeight == null) return _xlarge;
    return sectionHeight! * _headerLargeRatio;
  }

  double get xxlarge => _xxlarge;

  /// Icon size for success/confirm overlay avatars (120.0).
  ///
  /// Used in loading overlay to display user avatars after successful
  /// operations (e.g., "John has been added!").
  /// This size is independent of [sectionHeight].
  double get successAvatar => _successAvatar;
}

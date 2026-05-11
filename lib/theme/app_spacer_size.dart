/// Common spacing values for padding, margins, and gaps throughout the app.
///
/// These constants provide a consistent spacing scale used for all
/// spacing-related properties (padding, margin, width/height of SizedBox,
/// gaps, etc).
///
/// Usage:
/// ```dart
/// // Padding examples
/// padding: EdgeInsets.all(AppSpacerSize.medium),
/// padding: EdgeInsets.symmetric(
///   horizontal: AppSpacerSize.large,
///   vertical: AppSpacerSize.small,
/// ),
///
/// // Spacing with SizedBox
/// SizedBox(width: AppSpacerSize.small),
/// SizedBox(height: AppSpacerSize.medium),
/// ```
///
/// Scale:
/// - **xsmall (4)**: Minimal spacing, tight components
/// - **small (8)**: Compact spacing, icon + text pairs
/// - **medium (12)**: Default spacing between elements
/// - **large (16)**: Standard padding for screens and containers
/// - **xlarge (20)**: Generous spacing, section separators
/// - **xxlarge (24)**: Large spacing, major section breaks
/// - **xxxlarge (32)**: Extra-large spacing, between major sections
/// - **huge (48)**: Maximum spacing, hero sections
class AppSpacerSize {
  static const double xsmall = 4.0;
  static const double small = 8.0;
  static const double medium = 12.0;
  static const double large = 16.0;
  static const double xlarge = 20.0;
  static const double xxlarge = 24.0;
  static const double xxxlarge = 32.0;
  static const double huge = 48.0;
}

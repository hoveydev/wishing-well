# Design Constants - Quick Reference

## When Creating Components
Before writing any UI, check this quick reference:

### Spacing (most common)
```dart
// SizedBox and padding - use AppSpacerSize
SizedBox(width: AppSpacerSize.small),        // 8
SizedBox(height: AppSpacerSize.medium),      // 12
SizedBox(height: AppSpacerSize.large),       // 16

// EdgeInsets - use AppSpacerSize or AppSpacing
padding: EdgeInsets.all(AppSpacerSize.large),
padding: EdgeInsets.symmetric(
  horizontal: AppSpacing.screenPaddingStandard,  // 24
  vertical: AppSpacerSize.large,
),
```

### Borders
```dart
// Border radius
borderRadius: BorderRadius.circular(AppBorderRadius.small),   // 8
borderRadius: BorderRadius.circular(AppBorderRadius.medium),  // 14
borderRadius: BorderRadius.circular(AppBorderRadius.large),   // 24

// Border width
border: Border.all(width: AppBorderWeight.regular),  // 1.0
border: Border.all(width: AppBorderWeight.bold),     // 2.0
```

### Icons
```dart
Icon(Icons.star, size: const AppIconSize().small),    // 14
Icon(Icons.star, size: const AppIconSize().medium),   // 18
Icon(Icons.star, size: const AppIconSize().large),    // 24
Icon(Icons.check_circle, size: const AppIconSize().overlayIcon),  // 120
```

### Colors
```dart
// ALWAYS use AppColorScheme
final colorScheme = Theme.of(context).extension<AppColorScheme>();

Container(color: colorScheme?.primary);
Container(color: colorScheme?.error);
Container(color: colorScheme?.background);
Container(border: Border.all(color: colorScheme?.borderGray));

// Text with color override
Text(
  'Error',
  style: textTheme.bodyMedium?.copyWith(
    color: colorScheme?.error,
  ),
)
```

### Text
```dart
// ALWAYS use Theme.textTheme
final textTheme = Theme.of(context).textTheme;

Text('Title', style: textTheme.titleLarge);
Text('Body', style: textTheme.bodyMedium);
Text('Small', style: textTheme.bodySmall);
```

## DO NOT DO THIS ❌
```dart
SizedBox(width: 16);              // Use AppSpacerSize.large
EdgeInsets.all(8);                // Use AppSpacerSize.small
borderRadius: BorderRadius.circular(8);  // Use AppBorderRadius.small
Icon(Icons.star, size: 24);       // Use const AppIconSize().large
Color(0xFF3A8FB7);                // Use colorScheme.primary
TextStyle(fontSize: 14);          // Use textTheme.bodyMedium
```

## Quick Decision Tree

**"I need to add spacing"**
→ Use `AppSpacerSize` (xsmall, small, medium, large, xlarge, xxlarge, xxxlarge)

**"I need a special spacing value"**
→ Use `AppSpacing` (screenPaddingStandard, appBarHeight, wisherSpacing, wisherAvatarDiameter)

**"I need to make corners rounded"**
→ Use `AppBorderRadius` (small, medium, large)

**"I need a visible border"**
→ Use `AppBorderWeight` (light, regular, bold) for width

**"I need an icon"**
→ Use `AppIconSize` (xsmall, small, medium, large, xlarge, xxlarge, overlayIcon)

**"I need a color"**
→ Use `AppColorScheme` via `Theme.of(context).extension()`

**"I need text styling"**
→ Use `Theme.of(context).textTheme`

## Files to Import
```dart
import 'package:wishing_well/theme/app_spacer_size.dart';   // Spacing
import 'package:wishing_well/theme/app_spacing.dart';       // Semantic spacing
import 'package:wishing_well/theme/app_border_radius.dart'; // Border radius
import 'package:wishing_well/theme/app_border_weight.dart'; // Border width
import 'package:wishing_well/theme/app_icon_size.dart';     // Icon sizes
import 'package:wishing_well/theme/extensions/color_scheme_extension.dart';  // Colors
```

## Documentation
- **Full Guide**: `docs/DESIGN_CONSTANTS.md`
- **Agent Instructions**: `.github/copilot-instructions.md`
- **Linting**: Run `./scripts/lint_constants.sh` to find violations

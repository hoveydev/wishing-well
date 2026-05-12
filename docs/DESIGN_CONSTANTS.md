# Design Constants Reference Guide

This guide provides a comprehensive reference for all design constants used throughout the Wishing Well app. These constants ensure visual consistency and make it easier for developers and Copilot agents to create components that follow the design system.

## Table of Contents
1. [Spacing Constants](#spacing-constants)
2. [Border Radius Constants](#border-radius-constants)
3. [Border Weight Constants](#border-weight-constants)
4. [Icon Size Constants](#icon-size-constants)
5. [Color Constants](#color-constants)
6. [Best Practices](#best-practices)
7. [Anti-Patterns](#anti-patterns)

---

## Spacing Constants

**Files:** `lib/theme/app_spacer_size.dart`, `lib/theme/app_screen_layout.dart`,
`lib/theme/app_bar_sizing.dart`, `lib/components/wishers/wisher_sizing.dart`

### AppSpacerSize (Common Spacing)

Use `AppSpacerSize` for general spacing, padding, margins, and SizedBox dimensions.

| Constant | Value | Use Case |
|----------|-------|----------|
| `xsmall` | 4.0 | Minimal gaps, tight micro-interactions (rarely used) |
| `small` | 8.0 | Tight spacing between elements, icon+text pairs |
| `medium` | 12.0 | Default spacing between UI elements |
| `large` | 16.0 | Standard padding for screens, containers, and cards |
| `xlarge` | 20.0 | Generous spacing between elements |
| `xxlarge` | 24.0 | Large spacing, major section breaks |
| `xxxlarge` | 32.0 | Extra-large spacing between major sections |
| `huge` | 48.0 | Maximum spacing for hero/major sections |

#### Examples

```dart
// ✅ CORRECT - Padding
padding: EdgeInsets.all(AppSpacerSize.large);
padding: EdgeInsets.symmetric(
  horizontal: AppSpacerSize.large,
  vertical: AppSpacerSize.medium,
);

// ✅ CORRECT - SizedBox spacing
SizedBox(width: AppSpacerSize.small);
SizedBox(height: AppSpacerSize.xxlarge);
Spacer(flex: 1);  // For flexible space

// ✅ CORRECT - Row/Column gaps (Flutter 3.10+)
Row(
  spacing: AppSpacerSize.medium,
  children: [...],
)

// ❌ WRONG - Hardcoded values
padding: EdgeInsets.all(16);  // Use AppSpacerSize.large
SizedBox(width: 8);           // Use AppSpacerSize.small
```

### Semantic Spacing/Sizing Constants

Use semantic classes when the value has domain meaning.

| Constant | Value | Use Case |
|----------|-------|----------|
| `AppBarSizing.height` | 48.0 | Standard app bar height |
| `AppScreenLayout.screenPaddingStandard` | 24.0 | Standard horizontal screen padding |
| `WisherSizing.itemSpacing` | 16.0 | Spacing between wisher list items |
| `WisherSizing.avatarDiameter` | 60.0 | Wisher avatar circle diameter |
| `WisherSizing.listItemHeight` | 80.0 | Wisher list item minimum height |
| `WisherSizing.labelTopSpacing` | 4.0 | Top spacing for wisher label |

#### Examples

```dart
// ✅ CORRECT - App bar sizing
SizedBox(height: AppBarSizing.height);

// ✅ CORRECT - Screen padding
padding: EdgeInsets.symmetric(
  horizontal: AppScreenLayout.screenPaddingStandard,
),

// ✅ CORRECT - Avatar sizing
CircleAvatar(radius: WisherSizing.avatarDiameter / 2);

// ❌ WRONG - Duplicate constants
CircleAvatar(radius: 30);  // Should use WisherSizing.avatarDiameter
```

---

## Border Radius Constants

**File:** `lib/theme/app_border_radius.dart`

Use `AppBorderRadius` for all `borderRadius` values.

| Constant | Value | Use Case |
|----------|-------|----------|
| `small` | 8.0 | Slightly rounded corners (buttons, small cards) |
| `medium` | 14.0 | Standard rounded corners (input fields, chips) |
| `large` | 24.0 | Large rounded corners (modals, dialogs) |

#### Examples

```dart
// ✅ CORRECT - Border radius on containers
borderRadius: BorderRadius.circular(AppBorderRadius.small);
borderRadius: BorderRadius.only(
  topLeft: Radius.circular(AppBorderRadius.large),
  topRight: Radius.circular(AppBorderRadius.large),
);

// ✅ CORRECT - Clip rounded rectangles
ClipRRect(
  borderRadius: BorderRadius.circular(AppBorderRadius.medium),
  child: Image.network(url),
);

// ❌ WRONG - Hardcoded radii
borderRadius: BorderRadius.circular(8);  // Use AppBorderRadius.small
borderRadius: BorderRadius.circular(28); // Use AppBorderRadius.large or combine
```

---

## Border Weight Constants

**File:** `lib/theme/app_border_weight.dart`

Use `AppBorderWeight` for all stroke/border widths.

| Constant | Value | Use Case |
|----------|-------|----------|
| `light` | 0.5 | Fine, subtle borders (optional decoration) |
| `regular` | 1.0 | Standard borders (input fields, cards) |
| `medium` | 1.5 | Medium emphasis borders (inputs/buttons) |
| `bold` | 2.0 | Prominent borders (emphasis, focus states) |

#### Examples

```dart
// ✅ CORRECT - Border definition
border: Border.all(
  color: colorScheme.borderGray,
  width: AppBorderWeight.regular,
);

// ✅ CORRECT - Custom paint or divider
Paint()..strokeWidth = AppBorderWeight.bold;

// ❌ WRONG - Hardcoded stroke widths
width: 1.0;    // Use AppBorderWeight.regular
width: 2.0;    // Use AppBorderWeight.bold
width: 0.5;    // Use AppBorderWeight.light
```

---

## Icon Size Constants

**File:** `lib/theme/app_icon_size.dart`

Use `AppIconSize` for all icon sizes.

| Constant | Value | Use Case |
|----------|-------|----------|
| `xsmall` | 10.0 | Badges, decorative icons |
| `small` | 14.0 | Inline icons (next to text) |
| `medium` | 18.0 | Standard icons (toolbar buttons) |
| `large` | 24.0 | Primary action icons (FAB, app bar buttons) |
| `xlarge` | 60.0 | Hero images, large interactive icons |
| `xxlarge` | 64.0 | Avatar icons, large profile images |
| `overlayIcon` | 120.0 | Success/error icons in status overlays |

#### Examples

```dart
// ✅ CORRECT - Icon with constant size
Icon(Icons.star, size: const AppIconSize().large);
Icon(Icons.check_circle, size: const AppIconSize().overlayIcon);

// ✅ CORRECT - Section-dependent sizing
const iconSize = AppIconSize(sectionHeight: 300);
Icon(Icons.star, size: iconSize.xlarge);  // 300 * 0.12 = 36

// ❌ WRONG - Hardcoded icon sizes
Icon(Icons.star, size: 24);       // Use const AppIconSize().large
Icon(Icons.close, size: 14);      // Use const AppIconSize().small
```

---

## Color Constants

**File:** `lib/theme/app_colors.dart` & `lib/theme/extensions/color_scheme_extension.dart`

Use `AppColorScheme` (via `Theme.of(context).extension<AppColorScheme>()`) for all colors. DO NOT hardcode color values.

### Light Mode Colors

| Constant | Value | Use Case |
|----------|-------|----------|
| `primary` | `#3A8FB7` | Primary brand color, text, interactive elements |
| `onPrimary` | `#E8E8E8` | Text on primary background |
| `background` | `#FAFAFA` | Main app background |
| `surfaceGray` | `#F5F5F5` | Card and container backgrounds |
| `borderGray` | `#E0E0E0` | Border and divider colors |
| `success` | `#3FB984` | Success states, checkmarks |
| `warning` | `#F4A261` | Warning states, caution |
| `error` | `#B74A4A` | Error states, alerts |

### Dark Mode Colors

Same constants with "dark" prefix (e.g., `darkPrimary`, `darkBackground`, etc.).

#### Examples

```dart
// ✅ CORRECT - Access colors via extension
final colorScheme = Theme.of(context).extension<AppColorScheme>();
final primaryColor = colorScheme?.primary;
final errorColor = colorScheme?.error;

// ✅ CORRECT - Use in widgets
Container(
  color: colorScheme?.surfaceGray,
  border: Border.all(color: colorScheme?.borderGray ?? Colors.grey),
);

// ✅ CORRECT - Use in text styling
Text(
  'Error message',
  style: textTheme.bodyMedium?.copyWith(
    color: colorScheme?.error,
  ),
);

// ❌ WRONG - Hardcoded colors
Color(0xFF3A8FB7);                              // Use colorScheme.primary
Colors.red;                                     // Use colorScheme.error
Container(color: Color(0xFFF5F5F5));           // Use colorScheme.surfaceGray
```

---

## Text/Font Constants

**File:** `lib/theme/app_theme.dart`

Use `Theme.of(context).textTheme` for all text styling. NO hardcoded font sizes.

### Available Text Styles

| Style | Typical Size | Use Case |
|-------|------|----------|
| `displayLarge` | 57 | Large display headings (rarely used) |
| `displayMedium` | 45 | Medium display headings (rarely used) |
| `displaySmall` | 36 | Small display headings (rarely used) |
| `headlineLarge` | 32 | Large section headers |
| `headlineMedium` | 28 | Medium section headers |
| `headlineSmall` | 24 | Small section headers |
| `titleLarge` | 22 | Large titles, card titles |
| `titleMedium` | 16 | Medium titles, feature headers |
| `titleSmall` | 14 | Small titles, labels |
| `bodyLarge` | 16 | Large body text, main content |
| `bodyMedium` | 14 | Standard body text |
| `bodySmall` | 12 | Small body text, annotations |
| `labelLarge` | 14 | Large labels, button text |
| `labelMedium` | 12 | Medium labels |
| `labelSmall` | 11 | Small labels |

#### Examples

```dart
// ✅ CORRECT - Apply text theme
final textTheme = Theme.of(context).textTheme;
Text('Title', style: textTheme.titleLarge);
Text('Body', style: textTheme.bodyMedium);

// ✅ CORRECT - Override color only
Text(
  'Error',
  style: textTheme.bodyMedium?.copyWith(
    color: colorScheme?.error,
  ),
);

// ❌ WRONG - Hardcoded font sizes
Text('Title', style: TextStyle(fontSize: 22));  // Use textTheme.titleLarge
Text('Body', style: TextStyle(fontSize: 14));   // Use textTheme.bodyMedium
```

---

## Best Practices

### 1. Always Use Constants, Never Hardcode

```dart
// ✅ GOOD
padding: EdgeInsets.all(AppSpacerSize.large),
icon: Icon(Icons.star, size: const AppIconSize().medium),
borderRadius: BorderRadius.circular(AppBorderRadius.small),

// ❌ BAD
padding: EdgeInsets.all(16),
icon: Icon(Icons.star, size: 18),
borderRadius: BorderRadius.circular(8),
```

### 2. Prefer AppSpacerSize Over Arbitrary Values

AppSpacerSize provides a consistent scale for spacing:

```dart
// ✅ GOOD - Intentional spacing scale
mainAxisAlignment: MainAxisAlignment.spaceEvenly,
children: [
  SizedBox(height: AppSpacerSize.small),  // 8
  SizedBox(height: AppSpacerSize.medium), // 12
  SizedBox(height: AppSpacerSize.large),  // 16
];

// ❌ BAD - Arbitrary spacing
children: [
  SizedBox(height: 5),
  SizedBox(height: 10),
  SizedBox(height: 15),
];
```

### 3. Use Semantic Names When Available

If a value has domain meaning (like avatar diameter), use the semantic
constant:

```dart
// ✅ GOOD - Semantic name
CircleAvatar(radius: WisherSizing.avatarDiameter / 2);

// ❌ BAD - Generic spacing constant
CircleAvatar(radius: AppSpacerSize.xxxlarge / 2);
```

### 4. Compose Constants for Complex Values

```dart
// ✅ GOOD - Compose from constants
padding: EdgeInsets.symmetric(
  horizontal: AppScreenLayout.screenPaddingStandard,
  vertical: AppSpacerSize.large,
);

// ❌ BAD - Mix hardcoded and constants
padding: EdgeInsets.only(
  left: 24,
  right: 24,
  top: AppSpacerSize.large,
  bottom: 16,
);
```

### 5. Extract Color Scheme Once Per Build

```dart
// ✅ GOOD - Extract once
@override
Widget build(BuildContext context) {
  final colorScheme = Theme.of(context).extension<AppColorScheme>();
  final textTheme = Theme.of(context).textTheme;
  
  return Container(
    color: colorScheme?.background,
    child: Text('Hello', style: textTheme.bodyMedium),
  );
}

// ⚠️ LESS EFFICIENT - Extract multiple times
@override
Widget build(BuildContext context) {
  return Container(
    color: Theme.of(context).extension<AppColorScheme>()?.background,
    child: Text(
      'Hello',
      style: Theme.of(context).textTheme.bodyMedium,
    ),
  );
}
```

---

## Anti-Patterns

### ❌ Anti-Pattern 1: Hardcoded Magic Numbers

```dart
// DON'T DO THIS
SizedBox(width: 16),
padding: EdgeInsets.all(24),
borderRadius: BorderRadius.circular(8),
Icon(Icons.star, size: 24),

// USE INSTEAD
SizedBox(width: AppSpacerSize.large),
padding: EdgeInsets.all(AppSpacerSize.xxlarge),
borderRadius: BorderRadius.circular(AppBorderRadius.small),
Icon(Icons.star, size: const AppIconSize().large),
```

### ❌ Anti-Pattern 2: Inconsistent Spacing Scale

```dart
// DON'T DO THIS - No scale, inconsistent
children: [
  SizedBox(height: 5),
  SizedBox(height: 10),
  SizedBox(height: 7),
  SizedBox(height: 20),
];

// USE INSTEAD - Consistent scale
children: [
  SizedBox(height: AppSpacerSize.small),
  SizedBox(height: AppSpacerSize.medium),
  SizedBox(height: AppSpacerSize.small),
  SizedBox(height: AppSpacerSize.large),
];
```

### ❌ Anti-Pattern 3: Hardcoded Colors

```dart
// DON'T DO THIS
Container(
  color: Color(0xFF3A8FB7),  // Hardcoded primary
  child: Text(
    'Error',
    style: TextStyle(
      color: Color(0xFFB74A4A),  // Hardcoded error
      fontSize: 14,              // Hardcoded size
    ),
  ),
);

// USE INSTEAD
final colorScheme = Theme.of(context).extension<AppColorScheme>();
final textTheme = Theme.of(context).textTheme;

Container(
  color: colorScheme?.primary,
  child: Text(
    'Error',
    style: textTheme.bodyMedium?.copyWith(
      color: colorScheme?.error,
    ),
  ),
);
```

### ❌ Anti-Pattern 4: Mixing Semantic and Generic Constants

```dart
// DON'T DO THIS - Confusing mix
padding: EdgeInsets.symmetric(
  horizontal: AppScreenLayout.screenPaddingStandard,  // Semantic
  vertical: 16,                                   // Hardcoded
),

// USE INSTEAD - Consistent approach
padding: EdgeInsets.symmetric(
  horizontal: AppScreenLayout.screenPaddingStandard,
  vertical: AppSpacerSize.large,  // Both semantic
),
```

### ❌ Anti-Pattern 5: Creating New Constants for Single Use

```dart
// DON'T DO THIS
class MyComponent {
  static const double customPadding = 15.0;  // Not in scale!
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(customPadding),
      child: ...,
    );
  }
}

// USE INSTEAD - Nearest matching constant
return Padding(
  padding: EdgeInsets.all(AppSpacerSize.large),  // 16, close enough
  child: ...,
);
```

---

## Quick Reference Checklist

When creating or updating components, verify:

- [ ] All spacing uses `AppSpacerSize` or semantic sizing constants
- [ ] All border radii use `AppBorderRadius` constants
- [ ] All border widths use `AppBorderWeight` constants
- [ ] All icon sizes use `AppIconSize` constants
- [ ] All colors use `AppColorScheme` via `Theme.of(context).extension()`
- [ ] All text styling uses `Theme.of(context).textTheme`
- [ ] No Color() values hardcoded anywhere
- [ ] No magic numbers for sizing/spacing
- [ ] No raw `Colors.*` utilities (use `AppColorScheme` instead)

---

## Related Files

- **Spacing:** `lib/theme/app_spacer_size.dart`,
  `lib/theme/app_screen_layout.dart`,
  `lib/theme/app_bar_sizing.dart`,
  `lib/components/wishers/wisher_sizing.dart`
- **Borders:** `lib/theme/app_border_radius.dart`, `lib/theme/app_border_weight.dart`
- **Icons:** `lib/theme/app_icon_size.dart`
- **Colors:** `lib/theme/app_colors.dart`, `lib/theme/extensions/color_scheme_extension.dart`
- **Theme Setup:** `lib/theme/app_theme.dart`
- **Copilot Instructions:** `.github/copilot-instructions.md`

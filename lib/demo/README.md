# Component Demo App

## 🚨 DEVELOPER ONLY - DO NOT SHIP TO PRODUCTION 🚨

This demo app is for development and testing purposes only. It will never be included in production builds.

## How to Run

```bash
# Run the demo app
flutter run --target lib/demo/main.dart

# Run the production app
flutter run --target lib/main.dart
```

## Component Coverage

✅ **Buttons** - All variants (Primary, Secondary, Tertiary) with states, icons, and loading indicators
✅ **Inputs** - All types (text, email, password, phone) with icons and autofill
✅ **Wishers** - Full wishers list with add functionality and touch feedback
✅ **Checklist** - Interactive checklist with satisfied/unsatisfied states
✅ **Inline Alerts** - All types (Info, Success, Warning, Error) for inline messaging
✅ **Spacers** - All sizes (XSmall, Small, Medium, Large, XLarge) with visual comparison
✅ **Throbbers** - All sizes (XSmall, Small, Medium, Large, XLarge) with smooth animation
✅ **App Bar** - All types (Main, Close, Dismiss) with interactive examples
✅ **Logo** - All sizes with visual comparison and use cases
✅ **Screen** - Full screen component with app bar integration and layout variations
✅ **Touch Feedback** - Opacity-based feedback with customizable animations

## Features

- **Interactive Controls** - Test component states in real-time
- **Comprehensive Examples** - See all component variants
- **Production Safe** - Completely isolated from production builds
- **Easy Navigation** - Organized by component category
- **Visual Comparisons** - Side-by-side component comparisons
- **Use Case Examples** - Real-world implementation examples

## Architecture

```
lib/
├── main.dart (production app - unchanged)
└── demo/ (entire demo folder - production-excluded)
    ├── main.dart (demo entry point)
    ├── demo_app.dart
    ├── demo_home.dart
    ├── components/ (individual component demos)
    └── widgets/ (reusable demo widgets)
```

## Safety Measures

- Demo code never imports into production files
- Entire `demo/` folder excluded from production builds
- Clear visual indicators this is developer-only
- Separate entry point prevents accidental production usage

## Component Details

### Buttons
- Primary, Secondary, and Tertiary variants
- Loading states with throbber
- Icon support
- Disabled states
- Touch feedback

### Inputs
- Text, Email, Password, and Phone types
- Type-specific icons
- Autofill hints
- Accessibility labels
- Consistent styling

### Wishers
- Horizontal scrolling list
- Add new wisher button
- Touch feedback
- Circle avatars with initials
- View All and Add navigation

### Checklist
- Satisfied/unsatisfied states
- Checkmark icons
- Color-coded backgrounds
- Font weight changes
- Accessibility labels

### Inline Alerts
- Info, Success, Warning, and Error types
- Compact inline design
- Semantic colors
- Live region announcements

### Spacers
- Five predefined sizes
- Visual comparison
- Use case examples
- Reduces magic numbers

### Throbbers
- Five predefined sizes
- Smooth continuous animation
- Theme colors
- Lightweight custom painting

### App Bar
- Main, Close, and Dismiss types
- Logo integration
- Action buttons
- Semantic labels
- Consistent styling

### Logo
- Customizable size
- High-quality rendering
- Aspect ratio maintenance
- Visual size comparison

### Screen
- Automatic safe area handling
- Built-in scrolling
- Optional app bar integration
- Customizable padding
- Flexible layout control

### Touch Feedback
- Opacity-based feedback
- Customizable durations
- Adjustable opacity values
- Works with any widget
- Accessibility-friendly

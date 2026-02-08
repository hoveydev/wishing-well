# Component Demo App

## 🚨 DEVELOPER ONLY - DO NOT SHIP TO PRODUCTION 🚨

This demo app is for development and testing purposes only. It will never be included in production builds.

## How to Run

### Option 1: Using the Script (Recommended)

```bash
# Run the component demo app
./scripts/run_component_demo.sh

# Run the production app
flutter run --target lib/main.dart
```

### Option 2: Direct Flutter Command

```bash
# Run the component demo app
flutter run --target lib/components/demo/main.dart
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
└── components/ (component library)
    ├── app_alert/
    ├── app_bar/
    ├── button/
    ├── checklist/
    ├── inline_alert/
    ├── input/
    ├── logo/
    ├── screen/
    ├── spacer/
    ├── throbber/
    ├── touch_feedback/
    ├── wishers/
    └── demo/ (component demo app - production-excluded)
        ├── main.dart (demo entry point)
        ├── demo_app.dart
        ├── demo_home.dart
        ├── README.md
        └── demos/ (individual component demos)
            ├── button_demo.dart
            ├── input_demo.dart
            ├── wishers_demo.dart
            ├── checklist_demo.dart
            ├── inline_alert_demo.dart
            ├── spacer_demo.dart
            ├── throbber_demo.dart
            ├── app_bar_demo.dart
            ├── logo_demo.dart
            ├── screen_demo.dart
            └── touch_feedback_demo.dart
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

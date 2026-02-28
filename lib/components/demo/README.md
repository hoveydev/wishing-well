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
✅ **Throbbers** - All sizes (XSmall, Small, Medium, Large, XLarge) with smooth animation, plus skeleton loaders for loading states
✅ **App Bar** - All types (Main, Close, Dismiss) with interactive examples
✅ **Logo** - All sizes with visual comparison and use cases
✅ **Screen** - Full screen component with app bar integration and layout variations
✅ **Touch Feedback** - Opacity-based feedback with customizable animations
✅ **Image Picker Circle** - Generic circular image picker with local/remote support, configurable size, and optional edit overlay
✅ **Image Picker Overlay** - Animated loading overlay with pulsing icon for image picker operations

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
    ├── image_picker_circle/
    ├── image_picker_overlay/
    └── demo/ (component demo app - production-excluded)
        ├── main.dart (demo entry point)
        ├── demo_app.dart
        ├── demo_home.dart
        ├── component_registry.dart (registry system)
        ├── component_registrations.dart (all component registrations)
        ├── README.md
        └── demos/ (individual component demos)
            ├── app_alert_demo.dart
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
            ├── touch_feedback_demo.dart
            ├── image_picker_circle_demo.dart
            └── image_picker_overlay_demo.dart
```

## 📝 Adding a New Component Demo

### Prerequisite: Create the Component

First, ensure you have created your component in the appropriate folder:
```
lib/components/your_component/
└── your_widget.dart
```

### Step 1: Create the Demo File

Create a new demo file in the `demos` folder:
```
lib/components/demo/demos/your_component_demo.dart
```

**Template for a demo file:**
```dart
import 'package:flutter/material.dart';
import 'package:wishing_well/components/your_component/your_widget.dart';

class YourComponentDemo extends StatefulWidget {
  const YourComponentDemo({super.key});

  @override
  State<YourComponentDemo> createState() => _YourComponentDemoState();
}

class _YourComponentDemoState extends State<YourComponentDemo> {
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Your Component'),
      backgroundColor: Colors.blue.withValues(alpha: 0.1),
    ),
    body: SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Add your demo examples here
          _buildSection('Section Title', [
            // Example implementations
          ]),
        ],
      ),
    ),
  );

  Widget _buildSection(String title, List<Widget> children) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        title,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 12),
      ...children,
      const SizedBox(height: 24),
    ],
  );
}
```

### Step 2: Register the Component

Edit `lib/components/demo/component_registrations.dart`:

1. **Add the import** at the top of the file:
```dart
import 'package:wishing_well/components/demo/demos/your_component_demo.dart';
```

2. **Add the registration** in the `registerAllDemos()` function (in alphabetical order):
```dart
ComponentDemoRegistry.register(
  componentName: 'your_component',  // Must match folder name
  title: 'Your Component',          // Display title in demo app
  icon: Icons.widget,                // Material Icon
  demoBuilder: (_) => const YourComponentDemo(),
  description: 'Brief description of what the component does',
);
```

3. **Add to required components list** (at the bottom of the file):
```dart
const requiredComponents = [
  'app_alert',
  'app_bar',
  'button',
  // ...
  'your_component',  // Add here in alphabetical order
];
```

### Step 3: Verify It Works

Run the demo app:
```bash
flutter run --target lib/components/demo/main.dart
```

Your new component should appear in the demo list!

### Step 4: Run Tests

Ensure all tests pass:
```bash
flutter test test/component_registry_test.dart
```

## ⚠️ Registry System

The demo app uses a **registry pattern** to ensure every component has a corresponding demo.

### How It Works

1. **Registration**: Each component demo is registered in `component_registrations.dart`
2. **Verification**: When the demo app starts, it verifies all expected components have demos
3. **Failure**: If a component is missing a demo, the app crashes with a clear error message

### Benefits

- ✅ **Explicit**: All components are explicitly registered, making the relationship clear
- ✅ **Metadata**: Each demo can include title, icon, and description
- ✅ **Validation**: Fails early if components are missing demos
- ✅ **Type Safe**: IDE provides autocomplete and refactoring support
- ✅ **Flexible**: Can easily add metadata like categories, tags, or versions

### Finding Icons

See the [Material Icons documentation](https://api.flutter.dev/flutter/material/Icons-class.html) for available icons. Choose an icon that represents your component well.

### Error Messages

If a component is missing a demo, you'll see an error like:
```
╔════════════════════════════════════════════════════════════════╗
║  ⚠️  COMPONENT DEMO REGISTRY VALIDATION FAILED                 ║
╠════════════════════════════════════════════════════════════════╣
║  The following components are missing from the registry:       ║
║                                                                ║
║    • your_component                                            ║
║                                                                ║
║  Please register these components using:                       ║
║  ComponentDemoRegistry.register(                               ║
║    componentName: 'your_component',                            ║
║    title: 'Display Title',                                     ║
║    icon: Icons.some_icon,                                      ║
║    demoBuilder: (_) => const YourComponentDemo(),              ║
║  );                                                            ║
╚════════════════════════════════════════════════════════════════╝
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
- **Throbber (Circular)**: Five predefined sizes with smooth continuous animation, theme colors, lightweight custom painting
- **Skeleton Loader**: Shimmer animation for loading states, circle and rounded rectangle shapes, configurable dimensions and border radius, gradient-based highlight effect

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

### Image Picker Circle
- Generic circular image picker component
- Supports local file (File) or remote URL (String)
- Configurable radius for different sizes
- Optional edit icon overlay
- Optional label text
- Placeholder with camera icon when empty
- Dotted border styling matching app theme
- Integrates with TouchFeedbackOpacity for tap interactions

### Image Picker Overlay
- Animated loading overlay for image picker operations
- Smooth pulsing icon animation with fade-in effect
- Semi-transparent backdrop for focus
- Customizable messages (gallery/camera)
- Cross-fades with dismissing bottom sheets
- Configurable via constants:
  - `ImagePickerOverlaySize` - icon container and icon sizes
  - `ImagePickerOverlayAnimation` - animation durations and intervals
  - `ImagePickerOverlayVisuals` - colors, opacities, text styling
  - `ImagePickerOverlayMessage` - default messages
  - `ImagePickerOverlayIcon` - icon constant
- Fully themed using app color scheme

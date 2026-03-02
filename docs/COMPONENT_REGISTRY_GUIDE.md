# Component Demo Registry System

## 📋 Overview

The component demo registry system ensures that every new component added to `lib/components/` has a corresponding demo in the demo app. This is enforced through a registry pattern that validates completeness at runtime.

## 🏗️ Architecture

```
lib/components/demo/
├── component_registry.dart           # Core registry class
├── component_registrations.dart      # All component registrations
├── demo_home.dart                  # Updated to use registry
├── demo_app.dart                   # Main demo app
├── main.dart                       # Demo entry point
└── demos/                          # Individual component demos
    ├── app_alert_demo.dart          # ← NEW: Added
    ├── button_demo.dart
    ├── input_demo.dart
    └── ... (other demo files)
```

## 🔧 Core Components

### 1. ComponentDemoRegistry (`component_registry.dart`)

The core registry class that manages all component demos.

**Key Methods:**
- `register()` - Register a new component demo
- `getDemo()` - Get a specific demo by component name
- `getAllDemos()` - Get all registered demos
- `getRegisteredComponentNames()` - Get all registered component names
- `verifyCompleteness()` - Verify all required components are registered
- `clear()` - Clear all registrations (for testing)

**Usage:**
```dart
ComponentDemoRegistry.register(
  componentName: 'button',
  title: 'Buttons',
  icon: Icons.touch_app,
  demoBuilder: (_) => const ButtonDemo(),
  description: 'Primary, secondary, and tertiary buttons',
);
```

### 2. ComponentRegistrations (`component_registrations.dart`)

Contains all component registrations and completeness verification.

**Key Function:**
```dart
void registerAllDemos() {
  // Register each component
  ComponentDemoRegistry.register(...);

  // Verify all components are registered
  const requiredComponents = [
    'app_alert', 'app_bar', 'button', ...
  ];

  ComponentDemoRegistry.verifyCompleteness(requiredComponents);
}
```

## 📝 Adding a New Component Demo

### Step-by-Step Guide

#### 1. Create the Demo File

```bash
# Create demo file
touch lib/components/demo/demos/your_component_demo.dart
```

**Template:**
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
          _buildSection('Example Section', [
            // Add your demo examples here
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

#### 2. Register the Component

Edit `lib/components/demo/component_registrations.dart`:

**Add import:**
```dart
import 'package:wishing_well/components/demo/demos/your_component_demo.dart';
```

**Add registration (in alphabetical order):**
```dart
ComponentDemoRegistry.register(
  componentName: 'your_component',
  title: 'Your Component',
  icon: Icons.widget,
  demoBuilder: (_) => const YourComponentDemo(),
  description: 'Brief description',
);
```

**Add to required components list:**
```dart
const requiredComponents = [
  'app_alert',
  'app_bar',
  'button',
  // ...
  'your_component',  // Add here alphabetically
];
```

#### 3. Run and Verify

```bash
# Run the demo app
flutter run --target lib/components/demo/main.dart

# Run tests
flutter test lib/testing/component_registry_test.dart
```

## 🧪 Testing

### Registry Tests

Comprehensive tests ensure the registry works correctly:

```bash
flutter test lib/testing/component_registry_test.dart
```

**Test Coverage:**
- ✅ Registration and retrieval
- ✅ Duplicate detection
- ✅ Completeness verification
- ✅ Metadata handling
- ✅ All component registrations

## ⚠️ Error Handling

If a component is missing from the registry, you'll see a detailed error:

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

## ✅ Benefits

| Benefit | Description |
|---------|-------------|
| **Explicit** | All components are explicitly registered, making relationships clear |
| **Type Safe** | IDE provides autocomplete and refactoring support |
| **Validated** | Fails early if components are missing demos |
| **Metadata** | Each demo can include title, icon, and description |
| **Flexible** | Can easily add metadata like categories, tags, or versions |
| **Tested** | Comprehensive test coverage ensures reliability |

## 📚 Current Registered Components

As of this implementation, the following components are registered:

| Component | Demo File | Title | Icon |
|-----------|-----------|-------|------|
| app_alert | app_alert_demo.dart | App Alert | Icons.error_outline |
| app_bar | app_bar_demo.dart | App Bar | Icons.menu |
| button | button_demo.dart | Buttons | Icons.touch_app |
| checklist | checklist_demo.dart | Checklist | Icons.checklist |
| inline_alert | inline_alert_demo.dart | Inline Alerts | Icons.info_outline |
| input | input_demo.dart | Inputs | Icons.text_fields |
| logo | logo_demo.dart | Logo | Icons.image |
| screen | screen_demo.dart | Screen | Icons.phone_android |
| spacer | spacer_demo.dart | Spacers | Icons.space_bar |
| throbber | throbber_demo.dart | Throbbers | Icons.hourglass_empty |
| touch_feedback | touch_feedback_demo.dart | Touch Feedback | Icons.pan_tool |
| wishers | wishers_demo.dart | Wishers | Icons.people |

## 🔍 Finding Icons

Choose appropriate icons from [Material Icons](https://api.flutter.dev/flutter/material/Icons-class.html):

| Category | Icon Examples |
|----------|---------------|
| Actions | Icons.touch_app, Icons.pan_tool, Icons.checklist |
| Social | Icons.people, Icons.person, Icons.group |
| UI | Icons.menu, Icons.image, Icons.phone_android |
| Communication | Icons.info_outline, Icons.error_outline |
| Content | Icons.text_fields, Icons.widgets |

## 🚀 Future Enhancements

Potential improvements to consider:

1. **Categories/Tags**: Add category metadata for grouping
2. **Search**: Implement search functionality in demo app
3. **Favorites**: Allow marking demos as favorites
4. **Versioning**: Track component versions in registry
5. **Auto-discovery**: Use build_runner for automatic component discovery
6. **Documentation**: Link component docs from registry

## 📞 Getting Help

For questions or issues:

1. Check this README for setup instructions
2. Review test cases in `lib/testing/component_registry_test.dart`
3. Examine existing demo implementations in `lib/components/demo/demos/`
4. Consult the component registry code in `component_registry.dart`

## 📄 Related Files

- `lib/components/demo/README.md` - Full demo app documentation
- `lib/components/demo/component_registry.dart` - Registry implementation
- `lib/components/demo/component_registrations.dart` - All registrations
- `lib/testing/component_registry_test.dart` - Registry tests

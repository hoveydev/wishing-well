/// Registration file for all component demos.
///
/// This file contains the registration of all component demos with the
/// ComponentDemoRegistry. When you add a new component, you must register
/// its demo here.
///
/// ## How to add a new component demo
///
/// 1. Create your demo file: `lib/components/demo/demos/{component_name}_demo.dart`
/// 2. Define your demo widget class:
///    ```dart
///    class YourComponentDemo extends StatelessWidget {
///      const YourComponentDemo({super.key});
///
///      @override
///      Widget build(BuildContext context) {
///        // ... demo implementation
///      }
///    }
///    ```
/// 3. Import the demo file in this file
/// 4. Add a registration call below in the `registerAllDemos()` function
/// 5. Add the component name to the
///  `requiredComponents` list in `registerAllDemos()`
///
/// ## Finding appropriate icons
///
/// See the [Material Icons documentation](https://api.flutter.dev/flutter/material/Icons-class.html)
/// for available icons. Choose an icon that represents your component well.
library;

import 'package:flutter/material.dart';
import 'package:wishing_well/components/demo/component_registry.dart';
import 'package:wishing_well/components/demo/demos/app_alert_demo.dart';
import 'package:wishing_well/components/demo/demos/app_bar_demo.dart';
import 'package:wishing_well/components/demo/demos/button_demo.dart';
import 'package:wishing_well/components/demo/demos/checklist_demo.dart';
import 'package:wishing_well/components/demo/demos/input_demo.dart';
import 'package:wishing_well/components/demo/demos/inline_alert_demo.dart';
import 'package:wishing_well/components/demo/demos/logo_demo.dart';
import 'package:wishing_well/components/demo/demos/screen_demo.dart';
import 'package:wishing_well/components/demo/demos/spacer_demo.dart';
import 'package:wishing_well/components/demo/demos/throbber_demo.dart';
import 'package:wishing_well/components/demo/demos/touch_feedback_demo.dart';
import 'package:wishing_well/components/demo/demos/wishers_demo.dart';

/// Registers all component demos with the registry.
///
/// This function should be called once during app initialization.
/// It registers all known component demos and then verifies that
/// all expected components have been registered.
///
/// Throws a [StateError] if any required component is missing.
void registerAllDemos() {
  // ═══════════════════════════════════════════════════════════════════
  // COMPONENT REGISTRATIONS
  //
  // When adding a new component, register it here following the pattern:
  // ComponentDemoRegistry.register(
  //   componentName: 'component_folder_name',
  //   title: 'Display Title',
  //   icon: Icons.some_icon,
  //   demoBuilder: (_) => const ComponentNameDemo(),
  // );
  // ═══════════════════════════════════════════════════════════════════

  ComponentDemoRegistry.register(
    componentName: 'app_alert',
    title: 'App Alert',
    icon: Icons.error_outline,
    demoBuilder: (_) => const AppAlertDialog(),
    description: 'Dialog alerts with error, warning, success, and info types',
  );

  ComponentDemoRegistry.register(
    componentName: 'app_bar',
    title: 'App Bar',
    icon: Icons.menu,
    demoBuilder: (_) => const AppBarDemo(),
    description: 'Application menu bar with navigation options',
  );

  ComponentDemoRegistry.register(
    componentName: 'button',
    title: 'Buttons',
    icon: Icons.touch_app,
    demoBuilder: (_) => const ButtonDemo(),
    description: 'Primary, secondary, and tertiary buttons with loading states',
  );

  ComponentDemoRegistry.register(
    componentName: 'checklist',
    title: 'Checklist',
    icon: Icons.checklist,
    demoBuilder: (_) => const ChecklistDemo(),
    description: 'Checklist items with icons and selection states',
  );

  ComponentDemoRegistry.register(
    componentName: 'inline_alert',
    title: 'Inline Alerts',
    icon: Icons.info_outline,
    demoBuilder: (_) => const InlineAlertDemo(),
    description: 'Inline alert messages with different severity levels',
  );

  ComponentDemoRegistry.register(
    componentName: 'input',
    title: 'Inputs',
    icon: Icons.text_fields,
    demoBuilder: (_) => const InputDemo(),
    description: 'Text, email, password, and phone input fields',
  );

  ComponentDemoRegistry.register(
    componentName: 'logo',
    title: 'Logo',
    icon: Icons.image,
    demoBuilder: (_) => const LogoDemo(),
    description: 'Application logo component',
  );

  ComponentDemoRegistry.register(
    componentName: 'screen',
    title: 'Screen',
    icon: Icons.phone_android,
    demoBuilder: (_) => const ScreenDemo(),
    description: 'Screen layout wrapper component',
  );

  ComponentDemoRegistry.register(
    componentName: 'spacer',
    title: 'Spacers',
    icon: Icons.space_bar,
    demoBuilder: (_) => const SpacerDemo(),
    description: 'Spacing components with predefined sizes',
  );

  ComponentDemoRegistry.register(
    componentName: 'throbber',
    title: 'Throbbers',
    icon: Icons.hourglass_empty,
    demoBuilder: (_) => const ThrobberDemo(),
    description: 'Loading indicator components with different sizes',
  );

  ComponentDemoRegistry.register(
    componentName: 'touch_feedback',
    title: 'Touch Feedback',
    icon: Icons.pan_tool,
    demoBuilder: (_) => const TouchFeedbackDemo(),
    description: 'Touch feedback with opacity effects',
  );

  ComponentDemoRegistry.register(
    componentName: 'wishers',
    title: 'Wishers',
    icon: Icons.people,
    demoBuilder: (_) => const WishersDemo(),
    description: 'List of wishers with add/remove functionality',
  );

  // NEW COMPONENT REGISTRATION HERE - DO NOT DELETE

  // ═══════════════════════════════════════════════════════════════════
  // COMPLETENESS VERIFICATION
  //
  // This list must contain ALL component folders in lib/components/
  // (excluding the 'demo' folder itself)
  //
  // When adding a new component folder, add its name to this list:
  // ═══════════════════════════════════════════════════════════════════

  const requiredComponents = [
    'app_alert', // Alert component
    'app_bar', // App bar component
    'button', // Button components
    'checklist', // Checklist component
    'inline_alert', // Inline alert component
    'input', // Input fields
    'logo', // Logo component
    'screen', // Screen wrapper
    'spacer', // Spacing components
    'throbber', // Loading indicators
    'touch_feedback', // Touch feedback component
    'wishers', // Wisher list component
  ];

  // Verify that all required components have been registered
  // This will throw an error if any component is missing
  ComponentDemoRegistry.verifyCompleteness(requiredComponents);
}

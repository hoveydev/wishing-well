/// Registry for managing component demos.
///
/// This registry provides a centralized way to manage all component demos,
/// including metadata like titles, icons, and demo builders.
///
/// ## Usage
///
/// 1. Register each component demo using the static `register` method:
/// ```dart
/// ComponentDemoRegistry.register(
///   componentName: 'button',
///   title: 'Buttons',
///   icon: Icons.touch_app,
///   demoBuilder: (_) => const ButtonDemo(),
/// );
/// ```
///
/// 2. Verify all components are registered using `verifyCompleteness`:
/// ```dart
/// ComponentDemoRegistry.verifyCompleteness([
///   'button', 'input', 'checklist', ...
/// ]);
/// ```
///
/// 3. Get all registered demos using `getAllDemos`:
/// ```dart
/// final demos = ComponentDemoRegistry.getAllDemos();
/// ```
library;

import 'package:flutter/material.dart';

/// Metadata for a component demo.
class DemoMetadata {
  const DemoMetadata({
    required this.title,
    required this.icon,
    required this.builder,
    this.description,
  });

  /// The display title for the demo.
  final String title;

  /// The icon to display for the demo.
  final IconData icon;

  /// Builder function to create the demo widget.
  final WidgetBuilder builder;

  /// Optional description of the component.
  final String? description;
}

/// Registry for component demos.
///
/// This class manages the registration and retrieval of component demos.
/// It provides validation to ensure all expected components have demos.
class ComponentDemoRegistry {
  static final Map<String, DemoMetadata> _registry = {};
  static bool _initialized = false;

  /// Registers a component demo with the given metadata.
  ///
  /// The [componentName] should match the component folder name in
  /// `lib/components/`. For example, a component in `lib/components/button/`
  /// should use `componentName: 'button'`.
  static void register({
    required String componentName,
    required String title,
    required IconData icon,
    required WidgetBuilder demoBuilder,
    String? description,
  }) {
    if (_registry.containsKey(componentName)) {
      throw ArgumentError(
        'Component "$componentName" is already registered. '
        'Duplicate registrations are not allowed.',
      );
    }

    _registry[componentName] = DemoMetadata(
      title: title,
      icon: icon,
      builder: demoBuilder,
      description: description,
    );
  }

  /// Retrieves a specific demo metadata by component name.
  ///
  /// Returns `null` if the component is not registered.
  static DemoMetadata? getDemo(String componentName) =>
      _registry[componentName];

  /// Returns all registered demos as a list.
  ///
  /// The list is unmodifiable to prevent external modifications.
  static List<DemoMetadata> getAllDemos() {
    _initialized = true;
    return List.unmodifiable(_registry.values.toList());
  }

  /// Returns all registered component names.
  ///
  /// The set is unmodifiable to prevent external modifications.
  static Set<String> getRegisteredComponentNames() =>
      Set.unmodifiable(_registry.keys);

  /// Verifies that all required components have registered demos.
  ///
  /// Throws a [StateError] if any required components are missing.
  /// This should be called after all registrations are complete to ensure
  /// completeness.
  ///
  /// Example:
  /// ```dart
  /// ComponentDemoRegistry.register(...);
  /// ComponentDemoRegistry.register(...);
  ///
  /// // Verify all expected components are registered
  /// ComponentDemoRegistry.verifyCompleteness([
  ///   'button',
  ///   'input',
  ///   'checklist',
  ///   // ... all component names
  /// ]);
  /// ```
  static void verifyCompleteness(List<String> requiredComponents) {
    final registered = _registry.keys.toSet();
    final missing = requiredComponents.where((c) => !registered.contains(c));

    if (missing.isNotEmpty) {
      final missingList = missing.toList()..sort();
      throw StateError(_buildValidationError(missingList));
    }
  }

  /// Clears all registered demos.
  ///
  /// This is primarily useful for testing purposes.
  static void clear() {
    _registry.clear();
    _initialized = false;
  }

  /// Checks if the registry has been initialized.
  static bool get isInitialized => _initialized;

  /// Returns the number of registered components.
  static int get count => _registry.length;

  static String _buildValidationError(List<String> missingComponents) {
    final buffer = StringBuffer();
    buffer.writeln(
      '╔════════════════════════════════════════════════════════════════╗',
    );
    buffer.writeln(
      '║  ⚠️  COMPONENT DEMO REGISTRY VALIDATION FAILED                 ║',
    );
    buffer.writeln(
      '╠════════════════════════════════════════════════════════════════╣',
    );
    buffer.writeln(
      '║  The following components are missing from the registry:       ║',
    );
    buffer.writeln(
      '║                                                                ║',
    );

    for (final component in missingComponents) {
      final padded = component.padRight(63);
      buffer.writeln('║    • $padded ║');
    }

    buffer.writeln(
      '║                                                                ║',
    );
    buffer.writeln(
      '║  Please register these components using:                       ║',
    );
    buffer.writeln(
      '║  ComponentDemoRegistry.register(                               ║',
    );
    buffer.writeln(
      '║    componentName: \'your_component\',                          ║',
    );
    buffer.writeln(
      '║    title: \'Display Title\',                                   ║',
    );
    buffer.writeln(
      '║    icon: Icons.some_icon,                                      ║',
    );
    buffer.writeln(
      '║    demoBuilder: (_) => const YourComponentDemo(),              ║',
    );
    buffer.writeln(
      '║  );                                                            ║',
    );
    buffer.writeln(
      '╚════════════════════════════════════════════════════════════════╝',
    );

    return buffer.toString();
  }
}

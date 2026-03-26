import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Common finder patterns for integration tests.
///
/// Provides reusable finders for frequently used widgets across the app.
class IntegrationFinders {
  // ===========================================================================
  // Text Finders
  // ===========================================================================

  /// Find a widget with exact text
  static Finder text(String text) => find.text(text);

  /// Find widgets containing text (partial match)
  static Finder textContaining(String text) => find.textContaining(text);

  // ===========================================================================
  // Type Finders
  // ===========================================================================

  /// Find a widget by type
  static Finder widgetByType(Type type) => find.byType(type);

  /// Find widgets that are instances of a type
  static Finder widgetsByType(Type type) => find.byType(type);

  // ===========================================================================
  // Key Finders
  // ===========================================================================

  /// Find a widget by key
  static Finder byKey(String key) => find.byKey(Key(key));

  // ===========================================================================
  // Semantic Finders
  // ===========================================================================

  /// Find a widget by tooltip
  static Finder byTooltip(String message) => find.byTooltip(message);

  // ===========================================================================
  // Icon Finders
  // ===========================================================================

  /// Find an icon by icon data
  static Finder byIcon(IconData iconData) => find.byIcon(iconData);

  // ===========================================================================
  // Widget State Finders
  // ===========================================================================

  /// Find widgets that are currently loading
  /// (CircularProgressIndicator or LinearProgressIndicator)
  static Finder loadingWidget() => find.byWidgetPredicate(
    (widget) =>
        widget is CircularProgressIndicator ||
        widget is LinearProgressIndicator,
  );
}

/// Common assertion helpers for integration tests
class IntegrationAssertions {
  /// Assert that exactly one widget with the given text exists
  static void expectTextOnce(WidgetTester tester, String text) {
    expect(find.text(text), findsOneWidget);
  }

  /// Assert that no widgets with the given text exist
  static void expectTextNotPresent(WidgetTester tester, String text) {
    expect(find.text(text), findsNothing);
  }

  /// Assert that a widget with key exists
  static void expectKeyExists(WidgetTester tester, String key) {
    expect(find.byKey(Key(key)), findsOneWidget);
  }

  /// Assert that a widget type exists exactly once
  static void expectWidgetOnce(WidgetTester tester, Type type) {
    expect(find.byType(type), findsOneWidget);
  }

  /// Assert that multiple widgets of a type exist
  static void expectWidgetsExist(WidgetTester tester, Type type, int count) {
    expect(find.byType(type), findsNWidgets(count));
  }
}

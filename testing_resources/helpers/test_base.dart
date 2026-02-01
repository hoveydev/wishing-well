import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'test_helpers.dart';

/// Base class for component tests to ensure consistency
abstract class ComponentTestBase {
  /// Get the widget to be tested
  Widget getWidgetUnderTest();

  /// Standard rendering test that all components should have
  void renderingTest(WidgetTester tester) async {
    await tester.pumpWidget(createComponentTestWidget(getWidgetUnderTest()));
    await TestHelpers.pumpAndSettle(tester);

    // Basic sanity check - widget should render without errors
    expect(tester.takeException(), isNull);
  }
}

/// Base class for screen tests to ensure consistency
abstract class ScreenTestBase {
  /// Get the screen widget to be tested with all required dependencies
  Widget getScreenUnderTest();

  /// Standard screen rendering test
  void renderingTest(WidgetTester tester) async {
    await tester.pumpWidget(
      createScreenTestWidget(child: getScreenUnderTest()),
    );
    await TestHelpers.pumpAndSettle(tester);

    // Basic sanity check
    expect(tester.takeException(), isNull);
  }

  /// Standard screen interaction test
  Future<void> interactionTest(
    WidgetTester tester, {
    required Finder interactionTarget,
    required Future<void> Function(WidgetTester) performInteraction,
    required void Function() verifyResult,
  }) async {
    await tester.pumpWidget(
      createScreenTestWidget(child: getScreenUnderTest()),
    );
    await TestHelpers.pumpAndSettle(tester);

    await performInteraction(tester);
    await TestHelpers.pumpAndSettle(tester);

    verifyResult();
  }
}

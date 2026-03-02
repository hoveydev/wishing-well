import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wishing_well/components/demo/component_registry.dart';
import 'package:wishing_well/components/demo/component_registrations.dart';

void main() {
  group('ComponentDemoRegistry', () {
    tearDown(() {
      ComponentDemoRegistry.clear();
    });

    test('should register a demo successfully', () {
      ComponentDemoRegistry.register(
        componentName: 'test_component',
        title: 'Test Component',
        icon: Icons.abc,
        demoBuilder: (_) => const SizedBox(),
      );

      final demo = ComponentDemoRegistry.getDemo('test_component');
      expect(demo, isNotNull);
      expect(demo!.title, equals('Test Component'));
      expect(demo.icon, equals(Icons.abc));
    });

    test('should throw on duplicate registration', () {
      ComponentDemoRegistry.register(
        componentName: 'test_component',
        title: 'Test Component',
        icon: Icons.abc,
        demoBuilder: (_) => const SizedBox(),
      );

      expect(
        () => ComponentDemoRegistry.register(
          componentName: 'test_component',
          title: 'Test Component 2',
          icon: Icons.abc,
          demoBuilder: (_) => const SizedBox(),
        ),
        throwsArgumentError,
      );
    });

    test('should return null for unregistered component', () {
      final demo = ComponentDemoRegistry.getDemo('non_existent');
      expect(demo, isNull);
    });

    test('should return all registered demos', () {
      ComponentDemoRegistry.register(
        componentName: 'component1',
        title: 'Component 1',
        icon: Icons.abc,
        demoBuilder: (_) => const SizedBox(),
      );

      ComponentDemoRegistry.register(
        componentName: 'component2',
        title: 'Component 2',
        icon: Icons.abc,
        demoBuilder: (_) => const SizedBox(),
      );

      final demos = ComponentDemoRegistry.getAllDemos();
      expect(demos.length, equals(2));
      expect(demos.any((d) => d.title == 'Component 1'), isTrue);
      expect(demos.any((d) => d.title == 'Component 2'), isTrue);
    });

    test('should return registered component names', () {
      ComponentDemoRegistry.register(
        componentName: 'component1',
        title: 'Component 1',
        icon: Icons.abc,
        demoBuilder: (_) => const SizedBox(),
      );

      ComponentDemoRegistry.register(
        componentName: 'component2',
        title: 'Component 2',
        icon: Icons.abc,
        demoBuilder: (_) => const SizedBox(),
      );

      final names = ComponentDemoRegistry.getRegisteredComponentNames();
      expect(names.length, equals(2));
      expect(names, contains('component1'));
      expect(names, contains('component2'));
    });

    test('should verify completeness successfully', () {
      ComponentDemoRegistry.register(
        componentName: 'component1',
        title: 'Component 1',
        icon: Icons.abc,
        demoBuilder: (_) => const SizedBox(),
      );

      ComponentDemoRegistry.register(
        componentName: 'component2',
        title: 'Component 2',
        icon: Icons.abc,
        demoBuilder: (_) => const SizedBox(),
      );

      expect(
        () => ComponentDemoRegistry.verifyCompleteness([
          'component1',
          'component2',
        ]),
        returnsNormally,
      );
    });

    test('should throw on incomplete verification', () {
      ComponentDemoRegistry.register(
        componentName: 'component1',
        title: 'Component 1',
        icon: Icons.abc,
        demoBuilder: (_) => const SizedBox(),
      );

      expect(
        () => ComponentDemoRegistry.verifyCompleteness([
          'component1',
          'component2',
          'component3',
        ]),
        throwsStateError,
      );
    });

    test('should track initialization state', () {
      expect(ComponentDemoRegistry.isInitialized, isFalse);
      ComponentDemoRegistry.getAllDemos();
      expect(ComponentDemoRegistry.isInitialized, isTrue);
    });

    test('should count registered components', () {
      expect(ComponentDemoRegistry.count, equals(0));

      ComponentDemoRegistry.register(
        componentName: 'component1',
        title: 'Component 1',
        icon: Icons.abc,
        demoBuilder: (_) => const SizedBox(),
      );

      expect(ComponentDemoRegistry.count, equals(1));

      ComponentDemoRegistry.register(
        componentName: 'component2',
        title: 'Component 2',
        icon: Icons.abc,
        demoBuilder: (_) => const SizedBox(),
      );

      expect(ComponentDemoRegistry.count, equals(2));
    });

    test('should clear all registrations', () {
      ComponentDemoRegistry.register(
        componentName: 'component1',
        title: 'Component 1',
        icon: Icons.abc,
        demoBuilder: (_) => const SizedBox(),
      );

      ComponentDemoRegistry.register(
        componentName: 'component2',
        title: 'Component 2',
        icon: Icons.abc,
        demoBuilder: (_) => const SizedBox(),
      );

      expect(ComponentDemoRegistry.count, equals(2));

      ComponentDemoRegistry.clear();

      expect(ComponentDemoRegistry.count, equals(0));
      expect(ComponentDemoRegistry.isInitialized, isFalse);
    });
  });

  group('ComponentRegistrations', () {
    setUp(() {
      // Ensure fresh state before each test
      ComponentDemoRegistry.clear();
    });

    test('should register all expected components', () {
      registerAllDemos();

      final count = ComponentDemoRegistry.count;
      // We expect 12 components: app_alert, app_bar, button, checklist,
      // inline_alert, input, logo, screen, spacer,
      // throbber, touch_feedback, wishers
      expect(count, greaterThan(0));

      // Verify specific components exist
      expect(ComponentDemoRegistry.getDemo('button'), isNotNull);
      expect(ComponentDemoRegistry.getDemo('input'), isNotNull);
      expect(ComponentDemoRegistry.getDemo('checklist'), isNotNull);
      expect(ComponentDemoRegistry.getDemo('inline_alert'), isNotNull);
      expect(ComponentDemoRegistry.getDemo('spacer'), isNotNull);
      expect(ComponentDemoRegistry.getDemo('throbber'), isNotNull);
      expect(ComponentDemoRegistry.getDemo('app_bar'), isNotNull);
      expect(ComponentDemoRegistry.getDemo('logo'), isNotNull);
      expect(ComponentDemoRegistry.getDemo('screen'), isNotNull);
      expect(ComponentDemoRegistry.getDemo('touch_feedback'), isNotNull);
      expect(ComponentDemoRegistry.getDemo('wishers'), isNotNull);
      expect(ComponentDemoRegistry.getDemo('app_alert'), isNotNull);
    });

    test('should verify completeness without errors', () {
      expect(() => registerAllDemos(), returnsNormally);
    });

    test('should provide metadata for all demos', () {
      registerAllDemos();

      final demos = ComponentDemoRegistry.getAllDemos();

      for (final demo in demos) {
        expect(demo.title, isNotEmpty);
        expect(demo.builder, isNotNull);
      }
    });

    test('should be initialized after calling getAllDemos', () {
      expect(ComponentDemoRegistry.isInitialized, isFalse);
      registerAllDemos();
      // registerAllDemos() doesn't set initialized - getAllDemos() does
      expect(ComponentDemoRegistry.isInitialized, isFalse);
      final demos = ComponentDemoRegistry.getAllDemos();
      expect(ComponentDemoRegistry.isInitialized, isTrue);
      expect(demos.isNotEmpty, isTrue);
    });
  });

  group('DemoMetadata', () {
    test('should store all properties', () {
      final metadata = DemoMetadata(
        title: 'Test Demo',
        icon: Icons.abc,
        builder: (_) => const SizedBox(),
        description: 'Test description',
      );

      expect(metadata.title, equals('Test Demo'));
      expect(metadata.icon, equals(Icons.abc));
      expect(metadata.description, equals('Test description'));
    });

    test('should handle null description', () {
      final metadata = DemoMetadata(
        title: 'Test Demo',
        icon: Icons.abc,
        builder: (_) => const SizedBox(),
      );

      expect(metadata.description, isNull);
    });
  });
}

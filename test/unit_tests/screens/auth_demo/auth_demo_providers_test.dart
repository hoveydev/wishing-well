import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart' show ChangeNotifierProvider;
import 'package:provider/single_child_widget.dart';
import 'package:wishing_well/data/repositories/auth/auth_repository.dart';
import 'package:wishing_well/features/auth/demo/auth_demo_providers.dart';

void main() {
  group('AuthDemoProviders', () {
    group('success scenario', () {
      late List<SingleChildWidget> providers;

      setUp(() {
        providers = getAuthDemoProviders(scenario: AuthDemoScenario.success);
      });

      test('provides ChangeNotifierProvider for AuthRepository', () {
        expect(providers.length, 1);
        expect(providers.first, isA<ChangeNotifierProvider<AuthRepository>>());
      });
    });

    group('failure scenario', () {
      late List<SingleChildWidget> providers;

      setUp(() {
        providers = getAuthDemoProviders(scenario: AuthDemoScenario.failure);
      });

      test('provides ChangeNotifierProvider for AuthRepository', () {
        expect(providers.length, 1);
        expect(providers.first, isA<ChangeNotifierProvider<AuthRepository>>());
      });
    });

    group('loading scenario', () {
      late List<SingleChildWidget> providers;

      setUp(() {
        providers = getAuthDemoProviders(scenario: AuthDemoScenario.loading);
      });

      test('provides ChangeNotifierProvider for AuthRepository', () {
        expect(providers.length, 1);
        expect(providers.first, isA<ChangeNotifierProvider<AuthRepository>>());
      });
    });
  });

  group('AuthDemoScenario enum', () {
    test('has all expected values', () {
      expect(AuthDemoScenario.values, contains(AuthDemoScenario.success));
      expect(AuthDemoScenario.values, contains(AuthDemoScenario.failure));
      expect(AuthDemoScenario.values, contains(AuthDemoScenario.loading));
      expect(AuthDemoScenario.values.length, 3);
    });

    test('has descriptive names', () {
      expect(AuthDemoScenario.success.name, 'success');
      expect(AuthDemoScenario.failure.name, 'failure');
      expect(AuthDemoScenario.loading.name, 'loading');
    });
  });
}

// Integration Test Framework
//
// This directory contains the integration test framework for the Wishing
// Well app. Integration tests run on a real device or emulator and test
// complete user flows.
//
// ## Structure
//
// - [base/] - Base classes for integration tests
// - [helpers/] - Test utilities and helpers
// - [mocks/] - Mock implementations for repositories
// - [providers/] - Provider configurations for tests
//
// ## Quick Start
//
// To create a new integration test:
//
// 1. Create a new file in this directory (e.g., `my_feature_test.dart`)
//
// 2. Import the integration test package and framework:
//
//    ```dart
//    import 'package:integration_test/integration_test.dart';
//    import 'package:flutter_test/flutter_test.dart';
//    import 'package:wishing_well/integration_test/base/base.dart';
//    import 'package:wishing_well/integration_test/helpers/helpers.dart';
//    import 'package:wishing_well/integration_test/providers/providers.dart';
//    import 'package:wishing_well/integration_test/mocks/mocks.dart';
//    ```
//
// 3. Extend IntegrationTestBase or use the helpers directly:
//
//    ```dart
//    void main() {
//      IntegrationTestWidgetsFlutterBinding.ensureInitialized();
//
//      group('My Feature', () {
//        testWidgets('user can perform action', (WidgetTester tester) async {
//          // Set up the app with optional custom providers
//          final authMock = quickAuthMock();
//          final providers = withMockedAuth(authRepository: authMock);
//
//          await tester.pumpWidget(
//            MaterialApp(
//              home: MyTestWidget(),
//              providers: providers,
//            ),
//          );
//          await tester.pumpAndSettle();
//
//          // Test logic here
//        });
//      });
//    }
//    ```
//
// ## Running Integration Tests
//
// To run integration tests, use:
//
// ```bash
// flutter test integration_test/
// ```
//
// For specific tests:
//
// ```bash
// flutter test integration_test/my_feature_test.dart
// ```
//
// ## Best Practices
//
// - Use the Page Object Pattern for complex screens
// - Create reusable flow helpers in the flows/ directory
// - Group tests using the IntegrationTestGroups constants
// - Use the mock repositories for predictable test data
// - Clean up state between tests using resetState() methods
export 'base/base.dart';
export 'helpers/helpers.dart';
export 'mocks/mocks.dart';
export 'providers/providers.dart';

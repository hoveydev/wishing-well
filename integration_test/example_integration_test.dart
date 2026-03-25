// Example Integration Test
//
// This file demonstrates how to write integration tests using the framework.
// Delete or modify this file when you add real integration tests.
//
// ## Using the Base Class
//
// ```dart
// import 'package:integration_test/integration_test.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:provider/provider.dart';
// import 'package:flutter/material.dart';
// import 'package:wishing_well/integration_test/base/base.dart';
// import 'package:wishing_well/integration_test/helpers/helpers.dart';
// import 'package:wishing_well/integration_test/mocks/mocks.dart';
// import 'package:wishing_well/integration_test/providers/providers.dart';
// import 'package:wishing_well/data/repositories/auth/auth_repository.dart';
// import 'package:wishing_well/data/repositories/wisher/wisher_repository.dart';
//
// // Example: Using the base class approach
// class ExampleIntegrationTest extends IntegrationTestBase {
//   late IntegrationMockAuthRepository _authMock;
//   late IntegrationMockWisherRepository _wisherMock;
//
//   @override
//   List<SingleChildWidget>? get customProviders => [
//     ChangeNotifierProvider<AuthRepository>.value(value: _authMock),
//     ChangeNotifierProvider<WisherRepository>.value(value: _wisherMock),
//   ];
//
//   @override
//   Future<void> setUp(WidgetTester tester) async {
//     _authMock = IntegrationMockAuthRepository();
//     _wisherMock = IntegrationMockWisherRepository();
//     await super.setUp(tester);
//   }
//
//   testWidgets('example test', (WidgetTester tester) async {
//     await setUp(tester);
//
//     // Your test logic here
//
//     await tearDown(tester);
//   });
// }
// ```
//
// ## Using the Helper Functions Directly
//
// ```dart
// import 'package:integration_test/integration_test.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:wishing_well/integration_test/helpers/helpers.dart';
// import 'package:wishing_well/integration_test/mocks/mocks.dart';
// import 'package:wishing_well/integration_test/providers/providers.dart';
// import 'package:wishing_well/data/repositories/auth/auth_repository.dart';
// import 'package:wishing_well/data/repositories/wisher/wisher_repository.dart';
//
// void main() {
//   IntegrationTestWidgetsFlutterBinding.ensureInitialized();
//
//   group('Example Feature', () {
//     testWidgets('user can perform action', (WidgetTester tester) async {
//       // Set up mocks
//       final authMock = quickAuthMock(userId: 'test-user-123');
//       final wisherMock = quickWisherMock();
//
//       // Create providers
//       final providers = withMockedRepositories(
//         authRepository: authMock,
//         wisherRepository: wisherMock,
//       );
//
//       // Build the app with providers
//       await tester.pumpWidget(
//         MultiProvider(
//           providers: providers,
//           child: MaterialApp(
//             home: const MyTestScreen(),
//           ),
//         ),
//       );
//       await tester.pumpAndSettle();
//
//       // Test assertions
//       expect(find.text('Welcome'), findsOneWidget);
//     });
//   });
// }
// ```
//
// ## Using the AppTestWrapper
//
// ```dart
// import 'package:integration_test/integration_test.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:wishing_well/integration_test/helpers/helpers.dart';
// import 'package:wishing_well/integration_test/mocks/mocks.dart';
// import 'package:wishing_well/integration_test/providers/providers.dart';
//
// void main() {
//   IntegrationTestWidgetsFlutterBinding.ensureInitialized();
//
//   group('Example with AppTestWrapper', () {
//     testWidgets('test using wrapper', (WidgetTester tester) async {
//       // Create wrapper with custom providers
//       final authMock = quickAuthMock();
//       final providers = withMockedAuth(authRepository: authMock);
//
//       final wrapper = AppTestWrapper(customProviders: providers);
//       await wrapper.setUp();
//       wrapper.launch();
//
//       await tester.pumpAndSettle();
//
//       // Your test logic
//     });
//   });
// }
// ```
//
// ## Group Organization
//
// Use IntegrationTestGroups to organize your tests:
//
// ```dart
// group(IntegrationTestGroups.authentication, () { ... });
// group(IntegrationTestGroups.navigation, () { ... });
// group(IntegrationTestGroups.userJourneys, () { ... });
// ```
//
// ## Finding Widgets
//
// Use IntegrationFinders for common widget finding patterns:
//
// ```dart
// // Find by text
// IntegrationFinders.text('Submit');
//
// // Find by key
// IntegrationFinders.byKey('email-input');
//
// // Find loading indicators
// IntegrationFinders.loadingWidget();
// ```
//
// ## Assertions
//
// Use IntegrationAssertions for common assertions:
//
// ```dart
// IntegrationAssertions.expectTextOnce(tester, 'Welcome');
// IntegrationAssertions.expectKeyExists(tester, 'submit-button');
// IntegrationAssertions.expectWidgetOnce(tester, ElevatedButton);
// ```

// This is a placeholder file to demonstrate the framework.
// Add your actual integration tests in this directory.
void main() {
  // This file is for documentation purposes only.
  // See usage examples above in this file.
  // Run: flutter test integration_test/
}

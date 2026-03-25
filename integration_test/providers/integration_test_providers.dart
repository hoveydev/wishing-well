import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:wishing_well/data/repositories/auth/auth_repository.dart';
import 'package:wishing_well/data/repositories/wisher/wisher_repository.dart';
import 'package:wishing_well/utils/result.dart';

import '../mocks/mocks.dart';

/// Provider configurations for integration tests.
///
/// Use these to quickly set up common test scenarios with mocked repositories.
class IntegrationTestProviders {
  /// Creates providers with both auth and wisher repositories mocked.
  ///
  /// Use this for tests that need to control both repositories.
  static List<SingleChildWidget> withMockedRepositories({
    required IntegrationMockAuthRepository authRepository,
    required IntegrationMockWisherRepository wisherRepository,
  }) => [
    ChangeNotifierProvider<AuthRepository>.value(value: authRepository),
    ChangeNotifierProvider<WisherRepository>.value(value: wisherRepository),
  ];

  /// Creates providers with mocked auth repository only.
  ///
  /// Use this when you only need to mock authentication.
  static List<SingleChildWidget> withMockedAuth({
    required IntegrationMockAuthRepository authRepository,
  }) => [ChangeNotifierProvider<AuthRepository>.value(value: authRepository)];

  /// Creates providers with mocked wisher repository only.
  ///
  /// Use this when you only need to mock wisher data.
  static List<SingleChildWidget> withMockedWisher({
    required IntegrationMockWisherRepository wisherRepository,
  }) => [
    ChangeNotifierProvider<WisherRepository>.value(value: wisherRepository),
  ];

  /// Creates a quick auth repository for testing.
  ///
  /// Returns a pre-configured mock that succeeds immediately.
  static IntegrationMockAuthRepository quickAuthMock({
    String? userId,
    String? firstName,
  }) {
    final mock = IntegrationMockAuthRepository();
    mock.simulateLoginSuccess(userId: userId, firstName: firstName);
    return mock;
  }

  /// Creates a quick wisher repository with default test data.
  ///
  /// Returns a pre-configured mock with sample wishers.
  static IntegrationMockWisherRepository quickWisherMock() =>
      IntegrationMockWisherRepository();

  /// Creates a failing auth mock for error testing.
  ///
  /// Returns a mock configured to fail on login attempts.
  static IntegrationMockAuthRepository failingAuthMock(Exception error) =>
      IntegrationMockAuthRepository(loginResult: Result.error(error));
}

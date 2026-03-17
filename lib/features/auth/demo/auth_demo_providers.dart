import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:wishing_well/data/repositories/auth/auth_repository.dart';
import 'package:wishing_well/test_helpers/mocks/repositories/mock_auth_repository.dart';
import 'package:wishing_well/utils/result.dart';

enum AuthDemoScenario { success, failure, loading }

List<SingleChildWidget> getAuthDemoProviders({
  required AuthDemoScenario scenario,
}) {
  // Configure mock repositories based on scenario
  final Result<void> loginResult;
  final Result<void> createAccountResult;
  final Duration? loginDelay;
  final Duration? createAccountDelay;

  switch (scenario) {
    case AuthDemoScenario.success:
      loginResult = const Result.ok(null);
      createAccountResult = const Result.ok(null);
      // Add 2 second delay to show loading spinner
      loginDelay = const Duration(seconds: 2);
      createAccountDelay = const Duration(seconds: 2);
    case AuthDemoScenario.failure:
      loginResult = Result.error(Exception('Invalid email or password'));
      createAccountResult = Result.error(Exception('Email already in use'));
      loginDelay = const Duration(seconds: 2);
      createAccountDelay = const Duration(seconds: 2);
    case AuthDemoScenario.loading:
      // For loading, we use a result that never completes
      // The mock repository will handle this by not returning
      loginResult = const Result.ok(null);
      createAccountResult = const Result.ok(null);
      // Long delay to simulate indefinite loading
      loginDelay = const Duration(hours: 1);
      createAccountDelay = const Duration(hours: 1);
  }

  return [
    ChangeNotifierProvider<AuthRepository>(
      create: (_) => MockAuthRepository(
        loginResult: loginResult,
        createAccountResult: createAccountResult,
        userId: 'demo-user',
        loginDelay: loginDelay,
        createAccountDelay: createAccountDelay,
      ),
    ),
  ];
}

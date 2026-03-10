import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:wishing_well/data/models/wisher.dart';
import 'package:wishing_well/data/repositories/auth/auth_repository.dart';
import 'package:wishing_well/data/repositories/wisher/wisher_repository.dart';
import 'package:wishing_well/test_helpers/mocks/repositories/mock_auth_repository.dart';
import 'package:wishing_well/test_helpers/mocks/repositories/mock_wisher_repository.dart';
import 'package:wishing_well/utils/result.dart';

enum HomeDemoScenario {
  noWishers,
  fewWishers,
  defaultWishers,
  manyWishers,
  failure,
}

List<SingleChildWidget> getHomeDemoProviders({
  required HomeDemoScenario scenario,
}) {
  // Configure mock repositories based on scenario
  final List<Wisher> initialWishers;
  final Result<void>? fetchWishersResult;

  switch (scenario) {
    case HomeDemoScenario.noWishers:
      initialWishers = [];
      fetchWishersResult = null;
      break;
    case HomeDemoScenario.fewWishers:
      initialWishers = [
        Wisher(
          id: '1',
          userId: 'test-user',
          firstName: 'Alice',
          lastName: 'Test',
          createdAt: DateTime(2024),
          updatedAt: DateTime(2024),
        ),
        Wisher(
          id: '2',
          userId: 'test-user',
          firstName: 'Bob',
          lastName: 'Test',
          createdAt: DateTime(2024, 1, 2),
          updatedAt: DateTime(2024, 1, 2),
        ),
      ];
      fetchWishersResult = null;
      break;
    case HomeDemoScenario.defaultWishers:
      initialWishers = [
        Wisher(
          id: '1',
          userId: 'test-user',
          firstName: 'Alice',
          lastName: 'Test',
          createdAt: DateTime(2024),
          updatedAt: DateTime(2024),
        ),
        Wisher(
          id: '2',
          userId: 'test-user',
          firstName: 'Bob',
          lastName: 'Test',
          createdAt: DateTime(2024, 1, 2),
          updatedAt: DateTime(2024, 1, 2),
        ),
        Wisher(
          id: '3',
          userId: 'test-user',
          firstName: 'Charlie',
          lastName: 'Test',
          createdAt: DateTime(2024, 1, 3),
          updatedAt: DateTime(2024, 1, 3),
        ),
        Wisher(
          id: '4',
          userId: 'test-user',
          firstName: 'Diana',
          lastName: 'Test',
          createdAt: DateTime(2024, 1, 4),
          updatedAt: DateTime(2024, 1, 4),
        ),
        Wisher(
          id: '5',
          userId: 'test-user',
          firstName: 'Eve',
          lastName: 'Test',
          createdAt: DateTime(2024, 1, 5),
          updatedAt: DateTime(2024, 1, 5),
        ),
      ];
      fetchWishersResult = null;
      break;
    case HomeDemoScenario.manyWishers:
      // Generate 50 wishers for scroll testing
      initialWishers = List.generate(
        50,
        (i) => Wisher(
          id: '${i + 1}',
          userId: 'test-user',
          firstName: 'Wisher ${i + 1}',
          lastName: 'Test',
          createdAt: DateTime(2024, 1, (i % 28) + 1),
          updatedAt: DateTime(2024, 1, (i % 28) + 1),
        ),
      );
      fetchWishersResult = null;
      break;
    case HomeDemoScenario.failure:
      initialWishers = [];
      fetchWishersResult = Result.error(Exception('Failed to fetch wishers'));
      break;
  }

  return [
    ChangeNotifierProvider<AuthRepository>(
      create: (_) =>
          MockAuthRepository(userId: 'demo-user')
            ..login(email: 'demo@test.com', password: 'demo'),
    ),
    ChangeNotifierProvider<WisherRepository>(
      create: (_) => MockWisherRepository(
        initialWishers: initialWishers,
        fetchWishersResult: fetchWishersResult,
      ),
    ),
  ];
}

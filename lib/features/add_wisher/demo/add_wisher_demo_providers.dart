import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:wishing_well/data/models/wisher.dart';
import 'package:wishing_well/data/repositories/auth/auth_repository.dart';
import 'package:wishing_well/data/repositories/wisher/wisher_repository.dart';
import 'package:wishing_well/test_helpers/mocks/repositories/mock_auth_repository.dart';
import 'package:wishing_well/test_helpers/mocks/repositories/mock_wisher_repository.dart';
import 'package:wishing_well/utils/result.dart';

enum AddWisherDemoScenario { success, failure, loading }

List<SingleChildWidget> getAddWisherDemoProviders({
  required AddWisherDemoScenario scenario,
}) {
  Result<Wisher>? createResult;

  switch (scenario) {
    case AddWisherDemoScenario.success:
      createResult = Result.ok(
        Wisher(
          id: 'new-1',
          userId: 'demo-user',
          firstName: 'New',
          lastName: 'Wisher',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      );
    case AddWisherDemoScenario.failure:
      createResult = Result.error(Exception('Failed to save wisher'));
    case AddWisherDemoScenario.loading:
      createResult = null;
  }

  return [
    ChangeNotifierProvider<AuthRepository>(
      create: (_) =>
          MockAuthRepository()..login(email: 'demo@test.com', password: 'demo'),
    ),
    ChangeNotifierProvider<WisherRepository>(
      create: (_) => MockWisherRepository(createWisherResult: createResult),
    ),
  ];
}

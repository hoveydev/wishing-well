import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:wishing_well/test_helpers/mocks/repositories/mock_auth_repository.dart';
import 'package:wishing_well/test_helpers/mocks/repositories/mock_wisher_repository.dart';

enum LoadingDemoScenario { success, error }

List<SingleChildWidget> getLoadingDemoProviders({
  required LoadingDemoScenario scenario,
}) => [
  ChangeNotifierProvider<MockAuthRepository>(
    create: (_) =>
        MockAuthRepository(userId: 'demo-user')
          ..login(email: 'demo@test.com', password: 'demo'),
  ),
  ChangeNotifierProvider<MockWisherRepository>(
    create: (_) => MockWisherRepository(),
  ),
];

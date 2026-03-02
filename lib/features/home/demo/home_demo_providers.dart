import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:wishing_well/data/repositories/auth/auth_repository.dart';
import 'package:wishing_well/data/repositories/wisher/wisher_repository.dart';
import 'package:wishing_well/test_helpers/mocks/repositories/mock_auth_repository.dart';
import 'package:wishing_well/test_helpers/mocks/repositories/mock_wisher_repository.dart';

enum HomeDemoScenario { success, failure }

List<SingleChildWidget> getHomeDemoProviders({
  required HomeDemoScenario scenario,
}) {
  return [
    ChangeNotifierProvider<AuthRepository>(
      create: (_) =>
          MockAuthRepository()..login(email: 'demo@test.com', password: 'demo'),
    ),
    ChangeNotifierProvider<WisherRepository>(
      create: (_) => MockWisherRepository(),
    ),
  ];
}

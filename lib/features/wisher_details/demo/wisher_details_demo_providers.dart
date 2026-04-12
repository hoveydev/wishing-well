import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:wishing_well/data/models/wisher.dart';
import 'package:wishing_well/data/repositories/auth/auth_repository.dart';
import 'package:wishing_well/data/repositories/image/image_repository.dart';
import 'package:wishing_well/data/repositories/wisher/wisher_repository.dart';
import 'package:wishing_well/test_helpers/mocks/repositories/mock_auth_repository.dart';
import 'package:wishing_well/test_helpers/mocks/repositories/mock_image_repository.dart';
import 'package:wishing_well/test_helpers/mocks/repositories/mock_wisher_repository.dart';

enum WisherDetailsDemoScenario { defaultWisher, wisherWithoutImage, notFound }

/// Sample profile picture URLs for demo wisher (using picsum.photos)
const _sampleProfilePicture = 'https://picsum.photos/id/64/200';

List<SingleChildWidget> getWisherDetailsDemoProviders({
  required WisherDetailsDemoScenario scenario,
}) {
  // Configure mock repositories based on scenario
  final List<Wisher> initialWishers;

  switch (scenario) {
    case WisherDetailsDemoScenario.defaultWisher:
      initialWishers = [
        Wisher(
          id: '1',
          userId: 'test-user',
          firstName: 'Alice',
          lastName: 'Johnson',
          profilePicture: _sampleProfilePicture,
          createdAt: DateTime(2024),
          updatedAt: DateTime(2024),
        ),
      ];

    case WisherDetailsDemoScenario.wisherWithoutImage:
      initialWishers = [
        Wisher(
          id: '1',
          userId: 'test-user',
          firstName: 'Bob',
          lastName: 'Smith',
          // No image - will show initial
          createdAt: DateTime(2024, 1, 2),
          updatedAt: DateTime(2024, 1, 2),
        ),
      ];

    case WisherDetailsDemoScenario.notFound:
      // Empty wishers list - navigating to wisher 1 will not find it
      initialWishers = [];
  }

  return [
    ChangeNotifierProvider<AuthRepository>(
      create: (_) =>
          MockAuthRepository(userId: 'demo-user')
            ..login(email: 'demo@test.com', password: 'demo'),
    ),
    ChangeNotifierProvider<WisherRepository>(
      create: (_) => MockWisherRepository(initialWishers: initialWishers),
    ),
    ChangeNotifierProvider<ImageRepository>(
      create: (_) => MockImageRepository(),
    ),
  ];
}
